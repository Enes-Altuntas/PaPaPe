import 'package:bulovva/Components/gradient_button.dart';
import 'package:bulovva/Components/progress.dart';
import 'package:bulovva/Components/wrapper.dart';
import 'package:bulovva/Constants/colors_constants.dart';
import 'package:bulovva/Login/sign.dart';
import 'package:bulovva/services/authentication_service.dart';
import 'package:bulovva/services/toast_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController codeController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  bool isVisible = false;
  bool isLoading = false;
  bool loginWithPhone = false;
  bool codeSent = false;
  String verificationCode;

  void verifyCode() async {
    if (codeController.text.isNotEmpty) {
      if (verificationCode.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        context
            .read<AuthService>()
            .logInWithPhone(
                code: codeController.text.trim(),
                verification: verificationCode)
            .then((value) {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const AuthWrapper()));
        }).onError((error, stackTrace) {
          ToastService().showError(error, context);
        });
        setState(() {
          isLoading = false;
        });
      } else {
        ToastService()
            .showWarning('Telefonunuza tekrar kod istemelisiniz!', context);
      }
    } else {
      ToastService().showWarning('Doğrulama kodu boş olamaz!', context);
    }
  }

  void verifyPhone() async {
    if (formkey.currentState.validate()) {
      FirebaseAuth firebaseAuth = context.read<AuthService>().getInstance();
      setState(() {
        isLoading = true;
      });
      await firebaseAuth
          .verifyPhoneNumber(
              phoneNumber: '+90${phoneController.text.trim()}',
              verificationCompleted: (PhoneAuthCredential credential) async {},
              verificationFailed: (FirebaseAuthException exception) {
                if (exception.code == 'too-many-requests') {
                  ToastService().showError(
                      'İşleminiz, çok fazla denemeniz doğrultusunda engellendi tekrar deneyebilmek için lütfen bekleyiniz yada diğer giriş yöntemlerini deneyebilirsiniz.',
                      context);
                } else if (exception.code == "invalid-phone-number") {
                  ToastService().showError(
                      'Hatalı bir cep telefonu girdiniz, düzeltip tekrar deneyebilir yada diğer giriş yöntemlerini deneyebilirsiniz.',
                      context);
                } else {
                  ToastService().showError(
                      'SMS gönderilmesi sırasında bir hata oluştu! Girdiğiniz telefon numarasını kontrol edebilir yada diğer giriş yöntemlerini deneyebilirsiniz.',
                      context);
                }
              },
              codeSent: (String verificationId, [int forceResendingToken]) {
                setState(() {
                  verificationCode = verificationId;
                  codeSent = true;
                });
              },
              codeAutoRetrievalTimeout: (String verificationId) {})
          .timeout(const Duration(seconds: 60));
      setState(() {
        isLoading = false;
      });
    }
  }

  void signIn() {
    if (formkey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });
      context
          .read<AuthService>()
          .login(
              email: emailController.text.trim(),
              password: passwordController.text.trim())
          .then((value) {
        if (FirebaseAuth.instance.currentUser != null &&
            FirebaseAuth.instance.currentUser.emailVerified) {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const AuthWrapper()));
        } else {
          ToastService().showError(value, context);
        }
      }).onError((error, stackTrace) {
        ToastService().showError(error, context);
      });
      setState(() {
        isLoading = false;
      });
    }
  }

  void rememberPass() {
    if (emailController.text.isEmpty != true) {
      context
          .read<AuthService>()
          .rememberPass(email: emailController.text.trim())
          .then((value) => ToastService().showSuccess(value, context))
          .onError(
              (error, stackTrace) => ToastService().showError(error, context));
    } else {
      ToastService().showWarning('Lütfen e-mail hesabınızı giriniz !', context);
    }
  }

  void signUp() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const Sign()));
  }

  void googleSignIn() {
    setState(() {
      isLoading = true;
    });
    context.read<AuthService>().googleLogin().then((value) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const AuthWrapper()));
    }).onError((error, stackTrace) => ToastService().showError(error, context));
    setState(() {
      isLoading = false;
    });
  }

  String validateMail(value) {
    if (value.isEmpty) {
      return "* E-mail zorunludur !";
    } else {
      return null;
    }
  }

  String validatePass(value) {
    if (value.isEmpty) {
      return "* Şifre zorunludur !";
    } else {
      return null;
    }
  }

  String validatePhone(value) {
    if (value.isEmpty) {
      return "* Telefon numarası zorunludur !";
    }
    if (value.contains(RegExp(r'[^\d]')) == true) {
      return "* Geçersiz telefon numarası !";
    }
    if (value.length != 10) {
      return "* 10 karakter içermelidir !";
    }

    return null;
  }

  String validateCode(value) {
    if (value.isEmpty) {
      return "* Doğrulama kodu zorunludur !";
    } else {
      return null;
    }
  }

  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
      border: Border.all(color: ColorConstants.instance.primaryColor),
      borderRadius: BorderRadius.circular(15.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: (!isLoading)
            ? SingleChildScrollView(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    color: ColorConstants.instance.whiteContainer,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        right: 30.0, left: 30.0, top: 40.0),
                    child: Form(
                      key: formkey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/login_logo.png',
                            height: MediaQuery.of(context).size.height / 5,
                          ),
                          Visibility(
                            visible: loginWithPhone && !codeSent,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 40.0),
                              child: TextFormField(
                                  controller: phoneController,
                                  style: const TextStyle(fontSize: 12.0),
                                  keyboardType: TextInputType.phone,
                                  maxLength: 10,
                                  decoration: const InputDecoration(
                                      prefix: Text("+90"),
                                      prefixIcon: Icon(Icons.phone),
                                      labelText: 'Telefon Numarası'),
                                  validator: validatePhone),
                            ),
                          ),
                          Visibility(
                            visible: loginWithPhone && codeSent,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: PinPut(
                                fieldsCount: 6,
                                controller: codeController,
                                validator: validateCode,
                                submittedFieldDecoration:
                                    _pinPutDecoration.copyWith(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                selectedFieldDecoration: _pinPutDecoration,
                                followingFieldDecoration:
                                    _pinPutDecoration.copyWith(
                                  borderRadius: BorderRadius.circular(5.0),
                                  border: Border.all(
                                    color: ColorConstants.instance.textGold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: !loginWithPhone,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 40.0),
                              child: TextFormField(
                                  style: const TextStyle(fontSize: 12.0),
                                  controller: emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: const InputDecoration(
                                      prefixIcon:
                                          Icon(Icons.account_circle_outlined),
                                      labelText: 'E-posta'),
                                  validator: validateMail),
                            ),
                          ),
                          Visibility(
                            visible: !loginWithPhone,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: TextFormField(
                                style: const TextStyle(fontSize: 12.0),
                                obscureText:
                                    (isVisible == false) ? true : false,
                                controller: passwordController,
                                decoration: InputDecoration(
                                    prefixIcon:
                                        const Icon(Icons.vpn_key_outlined),
                                    labelText: 'Parola',
                                    suffixIcon: IconButton(
                                      icon: (isVisible == false)
                                          ? const Icon(Icons.visibility_off)
                                          : const Icon(Icons.visibility),
                                      onPressed: () {
                                        if (isVisible == true) {
                                          setState(() {
                                            isVisible = false;
                                          });
                                        } else {
                                          setState(() {
                                            isVisible = true;
                                          });
                                        }
                                      },
                                    )),
                                validator: validatePass,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 25.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      loginWithPhone = !loginWithPhone;
                                      codeSent = false;
                                      verificationCode = "";
                                    });
                                  },
                                  child: Text(
                                    (!loginWithPhone)
                                        ? 'Telefon ile Giriş Yap'
                                        : 'E-Mail ile Giriş Yap',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12.0,
                                      color:
                                          ColorConstants.instance.primaryColor,
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: !loginWithPhone,
                                  child: GestureDetector(
                                    onTap: rememberPass,
                                    child: Text(
                                      'Parolamı Unuttum !',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12.0,
                                        color:
                                            ColorConstants.instance.hintColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 30.0),
                            child: GradientButton(
                              buttonText: (loginWithPhone)
                                  ? (codeSent)
                                      ? 'Kodu Doğrula'
                                      : 'Doğrulama Kodu Al'
                                  : 'Giriş Yap',
                              start: ColorConstants.instance.primaryColor,
                              end: ColorConstants.instance.secondaryColor,
                              icon: FontAwesomeIcons.signInAlt,
                              onPressed: (loginWithPhone)
                                  ? (codeSent)
                                      ? verifyCode
                                      : verifyPhone
                                  : signIn,
                              fontSize: 15,
                              widthMultiplier: 0.9,
                            ),
                          ),
                          Visibility(
                            visible: !loginWithPhone,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: GradientButton(
                                buttonText: 'Google İle Giriş Yap',
                                start: ColorConstants.instance.buttonDarkGold,
                                end: ColorConstants.instance.buttonLightColor,
                                icon: FontAwesomeIcons.google,
                                onPressed: googleSignIn,
                                fontSize: 15,
                                widthMultiplier: 0.9,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 30.0),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 20.0),
                                  child: Visibility(
                                    visible: codeSent,
                                    child: GestureDetector(
                                      onTap: verifyCode,
                                      child: Text(
                                        'Tekrar SMS ile kod al!',
                                        style: TextStyle(
                                          fontSize: 13.0,
                                          fontWeight: FontWeight.bold,
                                          color: ColorConstants
                                              .instance.primaryColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const Sign()));
                                  },
                                  child: RichText(
                                    text: TextSpan(
                                        style: TextStyle(
                                          color:
                                              ColorConstants.instance.hintColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        children: [
                                          const TextSpan(
                                              text: 'Hesabınız yok mu? '),
                                          TextSpan(
                                              text: 'Kayıt Olun!',
                                              style: TextStyle(
                                                color: ColorConstants
                                                    .instance.primaryColor,
                                              ))
                                        ]),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            : const ProgressWidget());
  }
}
