import 'package:bulovva/Components/gradient_button.dart';
import 'package:bulovva/Components/progress.dart';
import 'package:bulovva/Components/wrapper.dart';
import 'package:bulovva/Constants/colors_constants.dart';
import 'package:bulovva/services/authentication_service.dart';
import 'package:bulovva/services/toast_service.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class Sign extends StatefulWidget {
  const Sign({Key key}) : super(key: key);

  @override
  _SignState createState() => _SignState();
}

class _SignState extends State<Sign> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordVerifyController =
      TextEditingController();
  final TextEditingController codeController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  bool isLoading = false;
  bool isVisible = false;
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
            .signInWithPhone(
                name: nameController.text.trim(),
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
      setState(() {
        isLoading = true;
      });
      FirebaseAuth firebaseAuth = context.read<AuthService>().getInstance();
      await firebaseAuth
          .verifyPhoneNumber(
              phoneNumber: '+90${phoneController.text.trim()}',
              verificationCompleted: (PhoneAuthCredential credential) async {},
              verificationFailed: (FirebaseAuthException exception) {
                if (exception.code == 'too-many-requests') {
                  ToastService().showError(
                      'İşleminiz, çok fazla denemeniz doğrultusunda engellendi tekrar deneyebilmek için lütfen bekleyiniz yada diğer giriş yöntemlerini deneyebilirsiniz.',
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

  void signUp() {
    if (passwordController.text != passwordVerifyController.text) {
      ToastService().showError(
          'Girdiğiniz şifreler eşleşmemektedir ! Lütfen girdiğiniz şifreleri tekrar kontrol ediniz.',
          context);
      return;
    }
    if (formkey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });
      context
          .read<AuthService>()
          .signin(
              name: nameController.text.trim(),
              email: emailController.text.trim(),
              password: passwordController.text.trim())
          .then((value) {
        CoolAlert.show(
            context: context,
            type: CoolAlertType.warning,
            title: '',
            text: value,
            showCancelBtn: false,
            backgroundColor: ColorConstants.instance.primaryColor,
            confirmBtnColor: ColorConstants.instance.primaryColor,
            onConfirmBtnTap: () {
              Navigator.of(context).pop();
            },
            barrierDismissible: false,
            confirmBtnText: 'Evet');
      }).onError((error, stackTrace) {
        ToastService().showError(error, context);
      });
      setState(() {
        isLoading = false;
      });
    }
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

  String validatePassAgain(value) {
    if (value.isEmpty) {
      return "* Şifre(Tekrar) zorunludur !";
    } else {
      return null;
    }
  }

  String validateName(value) {
    if (value.isEmpty) {
      return "* İsim-Soyisim zorunludur !";
    } else {
      return null;
    }
  }

  String validatePhone(value) {
    if (value.isEmpty) {
      return "* Telefon Numarası zorunludur !";
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
        appBar: AppBar(
          backgroundColor: ColorConstants.instance.whiteContainer,
          iconTheme: IconThemeData(color: ColorConstants.instance.primaryColor),
          elevation: 0,
        ),
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
                        right: 30.0, left: 30.0, bottom: 20.0),
                    child: Form(
                      key: formkey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Image.asset('assets/images/login_logo.png',
                              height: MediaQuery.of(context).size.height / 5),
                          Visibility(
                            visible: !codeSent,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 40.0),
                              child: TextFormField(
                                  controller: nameController,
                                  keyboardType: TextInputType.text,
                                  style: const TextStyle(fontSize: 12.0),
                                  decoration: const InputDecoration(
                                      icon: Icon(Icons.account_circle_outlined),
                                      labelText: 'İsim-Soyisim'),
                                  validator: validateName),
                            ),
                          ),
                          Visibility(
                            visible: loginWithPhone && !codeSent,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: TextFormField(
                                  controller: phoneController,
                                  keyboardType: TextInputType.phone,
                                  maxLength: 10,
                                  style: const TextStyle(fontSize: 12.0),
                                  decoration: const InputDecoration(
                                      prefix: Text('+90'),
                                      icon: Icon(Icons.phone),
                                      labelText: 'Telefon Numarası'),
                                  validator: validatePhone),
                            ),
                          ),
                          Visibility(
                            visible: codeSent,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 40.0),
                              child: PinPut(
                                fieldsCount: 6,
                                controller: codeController,
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
                              padding: const EdgeInsets.only(top: 10.0),
                              child: TextFormField(
                                  controller: emailController,
                                  style: const TextStyle(fontSize: 12.0),
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: const InputDecoration(
                                      icon: Icon(Icons.mail),
                                      labelText: 'E-Posta'),
                                  validator: validateMail),
                            ),
                          ),
                          Visibility(
                            visible: !loginWithPhone,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: TextFormField(
                                obscureText:
                                    (isVisible == false) ? true : false,
                                controller: passwordController,
                                style: const TextStyle(fontSize: 12.0),
                                decoration: InputDecoration(
                                    icon: const Icon(Icons.vpn_key_outlined),
                                    labelText: 'Yeni Parola',
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
                          Visibility(
                            visible: !loginWithPhone,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: TextFormField(
                                obscureText:
                                    (isVisible == false) ? true : false,
                                controller: passwordVerifyController,
                                style: const TextStyle(fontSize: 12.0),
                                decoration: InputDecoration(
                                    icon: const Icon(Icons.vpn_key_outlined),
                                    labelText: 'Yeni Parola (Tekrar)',
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
                                validator: validatePassAgain,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 25.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
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
                                        ? 'Telefon ile Kayıt Ol'
                                        : 'E-Mail ile Kayıt Ol',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12.0,
                                      color:
                                          ColorConstants.instance.primaryColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              Padding(
                                  padding: const EdgeInsets.only(top: 30.0),
                                  child: GradientButton(
                                    start: ColorConstants.instance.primaryColor,
                                    end: ColorConstants.instance.secondaryColor,
                                    buttonText: (loginWithPhone)
                                        ? (codeSent)
                                            ? 'Kodu Doğrula'
                                            : 'Doğrulama Kodu Al'
                                        : 'Kayıt Ol',
                                    fontSize: 15,
                                    onPressed: (loginWithPhone)
                                        ? (codeSent)
                                            ? verifyCode
                                            : verifyPhone
                                        : signUp,
                                    icon: FontAwesomeIcons.signInAlt,
                                    widthMultiplier: 0.9,
                                  )),
                              Visibility(
                                visible: codeSent,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 20.0),
                                  child: GestureDetector(
                                    onTap: verifyCode,
                                    child: Text(
                                      'Tekrar SMS ile kod al!',
                                      style: TextStyle(
                                        fontSize: 13.0,
                                        fontWeight: FontWeight.bold,
                                        color:
                                            ColorConstants.instance.hintColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
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
