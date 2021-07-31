import 'package:bulb/Models/comment_model.dart';
import 'package:bulb/Services/authentication_service.dart';
import 'package:bulb/Services/firestore_service.dart';
import 'package:bulb/Services/toast_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class Comment extends StatefulWidget {
  final String storeId;

  Comment({Key key, this.storeId}) : super(key: key);

  @override
  _CommentState createState() => _CommentState();
}

class _CommentState extends State<Comment> {
  final TextEditingController _reportTitle = TextEditingController();
  final TextEditingController _reportDesc = TextEditingController();
  GlobalKey<FormState> formKeyComment = GlobalKey<FormState>();
  bool _isLoading = false;

  String _validateComTitle(String value) {
    if (value.isEmpty) {
      return '* Dilek & Şikayet başlığı boş olmamalıdır !';
    }
    if (value.contains(RegExp(r'[a-zA-ZğüşöçİĞÜŞÖÇ]')) != true) {
      return '* Harf içermelidir !';
    }

    return null;
  }

  String _validateComDesc(String value) {
    if (value.isEmpty) {
      return '* Dilek & Şikayet açıklaması boş olmamalıdır !';
    }

    if (value.contains(RegExp(r'[a-zA-ZğüşöçİĞÜŞÖÇ]')) != true) {
      return '* Harf içermelidir !';
    }

    return null;
  }

  saveComment() {
    if (formKeyComment.currentState.validate()) {
      setState(() {
        _isLoading = true;
      });

      CommentModel newComment = CommentModel(
          reportId: Uuid().v4(),
          reportTitle: _reportTitle.text,
          reportDesc: _reportDesc.text,
          reportUser: AuthService(FirebaseAuth.instance).getUserId(),
          createdAt: Timestamp.now());

      FirestoreService()
          .saveComment(widget.storeId, newComment)
          .then((value) => ToastService().showSuccess(value, context))
          .onError(
              (error, stackTrace) => ToastService().showError(error, context))
          .whenComplete(() => setState(() {
                _isLoading = false;
              }));
      setState(() {
        _reportTitle.text = '';
        _reportDesc.text = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            Theme.of(context).accentColor,
            Theme.of(context).primaryColor
          ], begin: Alignment.centerRight, end: Alignment.centerLeft)),
        ),
        elevation: 0,
        centerTitle: true,
        title: Text('bulb',
            style: TextStyle(
                fontSize: 45.0,
                color: Colors.white,
                fontFamily: 'Armatic',
                fontWeight: FontWeight.bold)),
      ),
      body: (_isLoading == false)
          ? Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                Theme.of(context).accentColor,
                Theme.of(context).primaryColor
              ], begin: Alignment.centerRight, end: Alignment.centerLeft)),
              child: Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50.0),
                          topRight: Radius.circular(50.0))),
                  child: Column(
                    children: [
                      SingleChildScrollView(
                        child: Form(
                          key: formKeyComment,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 40.0),
                                  child: Text(
                                    " * Dilek & Şikayet başlığı kısaca konunun ne olduğunu anlatmanız içindir.",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontFamily: 'Roboto',
                                        fontSize: 16.0),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: TextFormField(
                                    controller: _reportTitle,
                                    maxLength: 50,
                                    validator: _validateComTitle,
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                        labelText: 'Dilek & Şikayet Başlığı',
                                        border: OutlineInputBorder()),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 40.0),
                                  child: Text(
                                    " * Dilek & Şikayet açıklamasını elinizden geldiği kadar açık ve net yazmanız işletme için çok önemlidir.",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontFamily: 'Roboto',
                                        fontSize: 16.0),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: TextFormField(
                                    validator: _validateComDesc,
                                    controller: _reportDesc,
                                    maxLength: 255,
                                    maxLines: 3,
                                    decoration: InputDecoration(
                                        labelText: 'Dilek & Şikayet Açıklaması',
                                        border: OutlineInputBorder()),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 20.0, bottom: 60.0),
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.7,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(50.0),
                                        gradient: LinearGradient(
                                            colors: [
                                              Theme.of(context).accentColor,
                                              Theme.of(context).primaryColor
                                            ],
                                            begin: Alignment.centerRight,
                                            end: Alignment.centerLeft)),
                                    child: TextButton(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 10.0),
                                              child: Icon(
                                                Icons.save,
                                                color: Colors.white,
                                              ),
                                            ),
                                            Text(
                                                "Dilek & Şikayet Oluştur"
                                                    .toUpperCase(),
                                                style: TextStyle(
                                                    fontSize: 17,
                                                    color: Colors.white,
                                                    fontFamily: 'Bebas')),
                                          ],
                                        ),
                                        onPressed: () {
                                          saveComment();
                                        }),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          : Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
    );
  }
}
