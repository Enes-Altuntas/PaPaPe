import 'package:bulovva/Models/user_model.dart';
import 'package:bulovva/services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth;
  final FirestoreService firestoreService = FirestoreService();
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  AuthService(this._firebaseAuth);

  Stream<User> get authStateChanges => _firebaseAuth.authStateChanges();

  getUserId() {
    return _firebaseAuth.currentUser.uid;
  }

  getInstance() {
    return _firebaseAuth;
  }

  Future<UserModel> get userInformation async {
    return await _db
        .collection('users')
        .doc(_firebaseAuth.currentUser.uid)
        .get()
        .then((value) {
      return UserModel.fromFirestore(value.data());
    }).onError((error, stackTrace) => null);
  }

  // *************************************************************************** Giriş İşlemleri
  // *************************************************************************** Giriş İşlemleri
  // *************************************************************************** Giriş İşlemleri

  Future<String> signIn({String email, String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);

      if (_firebaseAuth.currentUser.emailVerified == false) {
        await _firebaseAuth.signOut();
        return 'Hesabınız henüz aktifleştirilmedi ! Mail kutunuzu kontrol ediniz !';
      }
      return 'Hoşgeldiniz !';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password' || e.code == 'user-not-found') {
        throw 'Geçersiz kullanıcı adı veya şifre !';
      } else {
        throw 'Sistemde bir hata meydana geldi !';
      }
    }
  }

  Future googleLogin() async {
    GoogleSignInAccount user = await _googleSignIn.signIn();
    if (user == null) {
      return;
    } else {
      final googleAuth = await user.authentication;

      final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

      await _firebaseAuth.signInWithCredential(credential);

      String role = "basic";
      await saveUser(_firebaseAuth.currentUser.displayName, role)
          .onError((error, stackTrace) {
        throw error;
      });
    }
  }

  // *************************************************************************** Kayıt İşlemleri
  // *************************************************************************** Kayıt İşlemleri
  // *************************************************************************** Kayıt İşlemleri

  Future<String> signUp({String name, String email, String password}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);

      await _firebaseAuth.currentUser.sendEmailVerification();

      String role = "basic";
      await saveUser(name, role);

      await _firebaseAuth.signOut();

      return "Kullancı kaydınız oluşturulmuştur. E-mail'inize girip hesabınızı aktifleştirebilirsiniz !";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'ınvalıd-emaıl') {
        throw 'Kayıt olmak için geçersiz bir e-mail adresi girdiniz !';
      } else if (e.code == 'emaıl-already-ın-use') {
        throw 'Sistemde kayıtlı olan bir e-mail adresi girdiniz, eğer size ait ise "Şifremi Unuttum" seçeneğini deneyebilirsiniz !';
      } else if (e.code == 'weak-password') {
        throw 'Daha güçlü bir şifre girmelisiniz ! ';
      } else {
        throw 'Sistemde bir hata meydana geldi !';
      }
    }
  }

  Future verifyCodeAndUser({String code, String verification}) async {
    PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: verification, smsCode: code);

    await _firebaseAuth
        .signInWithCredential(phoneAuthCredential)
        .onError((error, stackTrace) {
      throw "Kullanıcı giriş işlemi sırasında bir hata meydana geldi!";
    });

    await _db
        .collection('users')
        .doc(_firebaseAuth.currentUser.uid)
        .get()
        .then((value) {
      return UserModel.fromFirestore(value.data());
    }).onError((error, stackTrace) async {
      await _firebaseAuth.signOut();
      throw "Henüz bu telefon ile yapılmış olan bir kayıt bulunamamaktadır. Eğer kayıt olmadıysanız ilk önce kayıt olmanız gerekmektedir!";
    }).then((value) {
      if (!value.roles.contains("basic")) {
        throw "Henüz bu telefon ile yapılmış olan bir kayıt bulunamamaktadır. Eğer kayıt olmadıysanız ilk önce kayıt olmanız gerekmektedir!";
      }
    });
  }

  Future verifyCodeAndSaveUser(
      {String name, String code, String verification}) async {
    PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: verification, smsCode: code);

    await _firebaseAuth
        .signInWithCredential(phoneAuthCredential)
        .onError((error, stackTrace) {
      throw "Telefon ile giriş işlemi sırasında bir hata meydana geldi!";
    });

    String role = "basic";
    await saveUser(name, role);
  }

  // *************************************************************************** Parola İşlemleri
  // *************************************************************************** Parola İşlemleri
  // *************************************************************************** Parola İşlemleri

  Future<String> rememberPass({String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return 'Şifrenizi yenilemeniz için link mail adresinize gönderilmiştir !';
    } catch (e) {
      throw 'Sistemde bir hata meydana geldi !';
    }
  }

  // *************************************************************************** Çıkış İşlemleri
  // *************************************************************************** Çıkış İşlemleri
  // *************************************************************************** Çıkış İşlemleri

  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
      if (_googleSignIn.currentUser != null) {
        await _googleSignIn.disconnect();
      }
    } catch (e) {
      return e.message;
    }
  }

  // *************************************************************************** Kullanıcı İşlemleri
  // *************************************************************************** Kullanıcı İşlemleri
  // *************************************************************************** Kullanıcı İşlemleri

  Future<void> saveUser(String name, String role) async {
    UserModel user = await _db
        .collection('users')
        .doc(_firebaseAuth.currentUser.uid)
        .get()
        .then((value) {
      return UserModel.fromFirestore(value.data());
    }).onError((error, stackTrace) => null);

    if (user == null) {
      UserModel newUser = UserModel(
          name: name,
          token: await FirebaseMessaging.instance.getToken(),
          iToken: null,
          userId: _firebaseAuth.currentUser.uid,
          favorites: [],
          storeId: null,
          campaignCodes: [],
          roles: []);

      newUser.roles.add(role);

      await _db
          .collection('users')
          .doc(_firebaseAuth.currentUser.uid)
          .set(newUser.toMap());
    } else {
      if (user.roles.contains("basic")) {
        return;
      } else {
        user.roles.add("basic");

        String token = await FirebaseMessaging.instance.getToken();

        await _db
            .collection('users')
            .doc(_firebaseAuth.currentUser.uid)
            .update({'roles': user.roles, 'token': token});
      }
    }
  }
}
