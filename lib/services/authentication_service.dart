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

  // *************************************************************************** Giriş İşlemleri
  // *************************************************************************** Giriş İşlemleri
  // *************************************************************************** Giriş İşlemleri

  Future login({String email, String password}) async {
    await _firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password)
        .onError((FirebaseAuthException error, stackTrace) {
      if (error.code == 'wrong-password' || error.code == 'user-not-found') {
        throw 'Geçersiz kullanıcı adı veya şifre !';
      } else {
        throw 'Sistemde bir hata meydana geldi !';
      }
    });

    if (_firebaseAuth.currentUser.emailVerified == false) {
      await _firebaseAuth.currentUser.sendEmailVerification();
      await _firebaseAuth.signOut();
      return 'Hesabınız henüz aktifleştirilmedi ! Mail kutunuzu kontrol ediniz !';
    } else {
      return;
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

      await _firebaseAuth
          .signInWithCredential(credential)
          .onError((error, stackTrace) {
        throw 'Google ile giriş yaparken bir hata ile karşılaşıldı!';
      });

      await saveUser(_firebaseAuth.currentUser.displayName, "basic")
          .onError((error, stackTrace) {
        throw 'Kullanıcı kaydı gerçekleştirilirken bir hata ile karşılaşıldı';
      });
    }
  }

  // *************************************************************************** Kayıt İşlemleri
  // *************************************************************************** Kayıt İşlemleri
  // *************************************************************************** Kayıt İşlemleri

  Future<String> signin({String name, String email, String password}) async {
    await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password)
        .onError((FirebaseAuthException error, stackTrace) {
      if (error.code == 'ınvalıd-emaıl') {
        throw 'Kayıt olmak için geçersiz bir e-mail adresi girdiniz !';
      } else if (error.code == 'emaıl-already-ın-use') {
        throw 'Sistemde kayıtlı olan bir e-mail adresi girdiniz, eğer size ait ise "Şifremi Unuttum" seçeneğini deneyebilirsiniz !';
      } else if (error.code == 'weak-password') {
        throw 'Daha güçlü bir şifre girmelisiniz ! ';
      } else {
        throw 'Sistemde bir hata meydana geldi !';
      }
    });

    await _firebaseAuth.signOut();

    await saveUser(name, "basic").onError((error, stackTrace) {
      throw 'Kullanıcı kaydı gerçekleştirilirken bir hata ile karşılaşıldı';
    });

    return "Kullancı kaydınız oluşturulmuştur. E-mail'inize girip hesabınızı aktifleştirebilirsiniz !";
  }

  // *************************************************************************** Telefon İşlemleri
  // *************************************************************************** Telefon İşlemleri
  // *************************************************************************** Telefon İşlemleri

  Future logInWithPhone({String code, String verification}) async {
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
      throw "Henüz bu telefon ile yapılmış olan bir kayıt bulunamamaktadır. Eğer kayıt olmadıysanız ilk önce kayıt olmanız gerekmektedir!";
    }).then((value) {
      if (!value.roles.contains("basic")) {
        throw "Henüz bu telefon ile yapılmış olan bir kayıt bulunamamaktadır. Eğer kayıt olmadıysanız ilk önce kayıt olmanız gerekmektedir!";
      } else {
        return;
      }
    });
  }

  Future signInWithPhone(
      {String name, String code, String verification}) async {
    PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: verification, smsCode: code);

    await _firebaseAuth
        .signInWithCredential(phoneAuthCredential)
        .onError((error, stackTrace) {
      throw "Telefon ile giriş işlemi sırasında bir hata meydana geldi!";
    });

    await saveUser(name, "basic").onError((error, stackTrace) {
      throw 'Kullanıcı kaydı gerçekleştirilirken bir hata ile karşılaşıldı';
    });
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
