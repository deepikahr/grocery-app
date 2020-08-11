import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/components/appbar/gf_appbar.dart';
import 'package:getflutter/components/button/gf_button.dart';
import 'package:getflutter/components/loader/gf_loader.dart';
import 'package:getflutter/components/typography/gf_typography.dart';
import 'package:getflutter/getflutter.dart';
import 'package:readymadeGroceryApp/screens/authe/login.dart';
import 'package:readymadeGroceryApp/screens/home/home.dart';
import 'package:readymadeGroceryApp/service/auth-service.dart';
import 'package:readymadeGroceryApp/service/common.dart';
import 'package:readymadeGroceryApp/service/localizations.dart';
import 'package:readymadeGroceryApp/service/sentry-service.dart';
import 'package:readymadeGroceryApp/style/style.dart';

SentryError sentryError = new SentryError();

class ChangePassword extends StatefulWidget {
  final String token, locale;
  final Map localizedValues;
  ChangePassword({Key key, this.token, this.localizedValues, this.locale})
      : super(key: key);

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _passwordTextController = TextEditingController();

  String oldPassword, newPassword, confirmPassword;
  bool oldPasswordVisible = true,
      newPasswordVisible = true,
      confirmPasswordVisible = true;

  bool isChangePasswordLoading = false;

  changePassword() async {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      if (newPassword == oldPassword) {
        showSnackbar(MyLocalizations.of(context)
            .getLocalizations("DO_NOT_ENTER_SAME_PASS"));
      } else {
        if (mounted) {
          setState(() {
            isChangePasswordLoading = true;
          });
        }
        Map<String, dynamic> body = {
          "currentPassword": oldPassword,
          "newPassword": newPassword,
          "confirmPassword": confirmPassword
        };
        await LoginService.changePassword(body).then((onValue) {
          print(onValue);
          if (mounted) {
            setState(() {
              isChangePasswordLoading = false;
            });
          }
          showSnackbar(onValue['response_data']);
          Common.getSelectedLanguage().then((selectedLocale) async {
            Map body = {"language": selectedLocale, "playerId": null};
            LoginService.updateUserInfo(body).then((value) async {
              await Common.setToken(null);
              await Common.setUserID(null);
              var result = Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => Login(
                    locale: widget.locale,
                    localizedValues: widget.localizedValues,
                  ),
                ),
              );
              result.then((value) {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => Home(
                        locale: widget.locale,
                        localizedValues: widget.localizedValues,
                        currentIndex: 0,
                      ),
                    ),
                    (Route<dynamic> route) => false);
              });
            });
          });
        }).catchError((error) {
          if (mounted) {
            setState(() {
              isChangePasswordLoading = false;
            });
          }
          sentryError.reportError(error, null);
        });
      }
    } else {
      if (mounted) {
        setState(() {
          isChangePasswordLoading = false;
        });
      }
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: GFAppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        title: Text(
          MyLocalizations.of(context).getLocalizations("CHANGE_PASSWORD"),
          style: textbarlowSemiBoldBlack(),
        ),
        centerTitle: true,
        backgroundColor: primary,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Form(
        key: _formKey,
        child: Container(
          child: ListView(
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.only(left: 20.0, bottom: 5.0, right: 20.0),
                child: GFTypography(
                  showDivider: false,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20.0, bottom: 2.0),
                    child: RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                              text: MyLocalizations.of(context)
                                  .getLocalizations("ENTER_OLD_PASSWORD", true),
                              style: textBarlowRegularBlack()),
                          TextSpan(
                            text: ' ',
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 20.0, right: 20.0, bottom: 20.0),
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      errorBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 0, color: Color(0xFFF44242))),
                      errorStyle: TextStyle(color: Color(0xFFF44242)),
                      contentPadding: EdgeInsets.all(10),
                      enabledBorder: const OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.grey, width: 0.0),
                      ),
                      suffixIcon: InkWell(
                        onTap: () {
                          if (mounted) {
                            setState(() {
                              oldPasswordVisible = !oldPasswordVisible;
                            });
                          }
                        },
                        child: Icon(
                          Icons.remove_red_eye,
                          color: Colors.grey,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: primary),
                      ),
                    ),
                    validator: (String value) {
                      if (value.isEmpty) {
                        return MyLocalizations.of(context)
                            .getLocalizations("ENTER_OLD_PASSWORD");
                      } else if (value.length < 6) {
                        return MyLocalizations.of(context)
                            .getLocalizations("ERROR_PASS");
                      } else
                        return null;
                    },
                    onSaved: (String value) {
                      oldPassword = value;
                    },
                    obscureText: oldPasswordVisible,
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 20.0, bottom: 5.0, right: 20.0),
                child: GFTypography(
                  showDivider: false,
                  child: RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                            text: MyLocalizations.of(context)
                                .getLocalizations("ENTER_NEW_PASSWORD", true),
                            style: textBarlowRegularBlack()),
                        TextSpan(
                          text: ' ',
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 20.0, right: 20.0, bottom: 20.0),
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      errorBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 0, color: Color(0xFFF44242))),
                      errorStyle: TextStyle(color: Color(0xFFF44242)),
                      contentPadding: EdgeInsets.all(10),
                      enabledBorder: const OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.grey, width: 0.0),
                      ),
                      suffixIcon: InkWell(
                        onTap: () {
                          if (mounted) {
                            setState(() {
                              newPasswordVisible = !newPasswordVisible;
                            });
                          }
                        },
                        child: Icon(
                          Icons.remove_red_eye,
                          color: Colors.grey,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: primary),
                      ),
                    ),
                    validator: (String value) {
                      if (value.isEmpty) {
                        return MyLocalizations.of(context)
                            .getLocalizations("ENTER_NEW_PASSWORD");
                      } else if (value.length < 6) {
                        return MyLocalizations.of(context)
                            .getLocalizations("ERROR_PASS");
                      } else
                        return null;
                    },
                    controller: _passwordTextController,
                    onSaved: (String value) {
                      newPassword = value;
                    },
                    obscureText: newPasswordVisible,
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 20.0, bottom: 5.0, right: 20.0),
                child: GFTypography(
                  showDivider: false,
                  child: RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                            text: MyLocalizations.of(context).getLocalizations(
                                "ENTER_CONFIRM_PASSWORD", true),
                            style: textBarlowRegularBlack()),
                        TextSpan(
                          text: ' ',
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 0,
                          color: Color(0xFFF44242),
                        ),
                      ),
                      errorStyle: TextStyle(color: Color(0xFFF44242)),
                      contentPadding: EdgeInsets.all(10),
                      enabledBorder: const OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.grey, width: 0.0),
                      ),
                      suffixIcon: InkWell(
                        onTap: () {
                          if (mounted) {
                            setState(() {
                              confirmPasswordVisible = !confirmPasswordVisible;
                            });
                          }
                        },
                        child: Icon(
                          Icons.remove_red_eye,
                          color: Colors.grey,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: primary),
                      ),
                    ),
                    validator: (String value) {
                      if (value.isEmpty) {
                        return MyLocalizations.of(context)
                            .getLocalizations("ENTER_CONFIRM_PASSWORD");
                      } else if (value.length < 6) {
                        return MyLocalizations.of(context)
                            .getLocalizations("ERROR_PASS");
                      } else if (_passwordTextController.text != value) {
                        return MyLocalizations.of(context)
                            .getLocalizations("PASS_NOT_MATCH");
                      } else
                        return null;
                    },
                    onSaved: (String value) {
                      confirmPassword = value;
                    },
                    obscureText: confirmPasswordVisible,
                  ),
                ),
              ),
              Container(
                height: 55,
                margin:
                    EdgeInsets.only(top: 30, bottom: 20, right: 20, left: 20),
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.29), blurRadius: 5)
                ]),
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 0.0,
                    right: 0.0,
                  ),
                  child: GFButton(
                    color: primary,
                    blockButton: true,
                    onPressed: changePassword,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          MyLocalizations.of(context)
                              .getLocalizations("SUBMIT"),
                          style: textbarlowMediumBlack(),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        isChangePasswordLoading
                            ? GFLoader(
                                type: GFLoaderType.ios,
                              )
                            : Text("")
                      ],
                    ),
                    textStyle: textBarlowRegularrBlack(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showSnackbar(message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: Duration(milliseconds: 3000),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
}
