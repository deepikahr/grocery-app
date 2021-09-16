import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:readymadeGroceryApp/screens/authe/forgotpassword.dart';
import 'package:readymadeGroceryApp/screens/authe/otp.dart';
import 'package:readymadeGroceryApp/screens/authe/signup.dart';
import 'package:readymadeGroceryApp/screens/home/home.dart';
import 'package:readymadeGroceryApp/service/common.dart';
import 'package:readymadeGroceryApp/service/localizations.dart';
import 'package:readymadeGroceryApp/service/otp-service.dart';
import 'package:readymadeGroceryApp/style/style.dart';
import 'package:readymadeGroceryApp/service/sentry-service.dart';
import 'package:readymadeGroceryApp/widgets/appBar.dart';
import 'package:readymadeGroceryApp/widgets/button.dart';
import 'package:readymadeGroceryApp/widgets/normalText.dart';

import '../../service/constants.dart';

SentryError sentryError = new SentryError();

class Login extends StatefulWidget {
  const Login(
      {Key? key,
      this.isProfile,
      this.isCart,
      this.isSaveItem,
      this.isProductDetails,
      this.locale,
      this.localizedValues,
      this.isBottomSheet})
      : super(key: key);
  final bool? isProfile, isCart, isSaveItem, isProductDetails, isBottomSheet;
  final Map? localizedValues;
  final String? locale;

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKeyForLogin = GlobalKey<FormState>();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isUserLoaginLoading = false,
      registerationLoading = false,
      value = false,
      passwordVisible = true,
      _obscureText = true;
  String? password, userName;

  // Toggles the password
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  userLoginwithMobile() async {
    final form = _formKeyForLogin.currentState!;
    if (form.validate()) {
      form.save();
      if (mounted) {
        setState(() {
          isUserLoaginLoading = true;
        });
      }
      await Common.getPlayerID().then((playerID) async {
        Map<String, dynamic> body = {
          "userName": userName,
          "password": password,
          "playerId": playerID
        };
        await OtpService.signInWithNumber(body).then((onValue) async {
          if (mounted) {
            setState(() {
              isUserLoaginLoading = false;
            });
          }
          if (onValue['response_code'] == 205) {
            showAlert(onValue['response_data'], userName);
          } else {
            if (onValue['response_data']['role'] == 'USER') {
              await Common.setToken(onValue['response_data']['token']);

              if (widget.isCart == true) {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => Home(
                          locale: widget.locale,
                          localizedValues: widget.localizedValues,
                          currentIndex: 2),
                    ),
                    (Route<dynamic> route) => false);
              } else if (widget.isProfile == true) {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => Home(
                          locale: widget.locale,
                          localizedValues: widget.localizedValues,
                          currentIndex: 3),
                    ),
                    (Route<dynamic> route) => false);
              } else if (widget.isSaveItem == true) {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => Home(
                          locale: widget.locale,
                          localizedValues: widget.localizedValues,
                          currentIndex: 1),
                    ),
                    (Route<dynamic> route) => false);
              } else if (widget.isProductDetails == true) {
                Navigator.pop(context);
              } else {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => Home(
                          locale: widget.locale,
                          localizedValues: widget.localizedValues,
                          currentIndex: 0),
                    ),
                    (Route<dynamic> route) => false);
              }
            } else {
              showSnackbar(MyLocalizations.of(context)!
                  .getLocalizations("INVAILD_USER"));
            }
          }
        }).catchError((error) {
          if (mounted) {
            setState(() {
              isUserLoaginLoading = false;
            });
          }
          sentryError.reportError(error, null);
        });
      });
    } else {
      if (mounted) {
        setState(() {
          isUserLoaginLoading = false;
        });
      }
      return;
    }
  }

  showAlert(message, mobileNumber) {
    return showDialog<Null>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text(
            message,
            style: hintSfMediumredsmall(context),
          ),
          actions: <Widget>[
            GFButton(
              color: Colors.transparent,
              child: new Text(
                MyLocalizations.of(context)!.getLocalizations("CANCEL"),
                style: textbarlowRegularaprimary(context),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            GFButton(
              color: Colors.transparent,
              child: new Text(
                MyLocalizations.of(context)!.getLocalizations("SEND_OTP"),
                style: textbarlowRegularaprimary(context),
              ),
              onPressed: () {
                OtpService.resendOtpWithNumber(mobileNumber).then((response) {
                  showSnackbar(response['response_data']);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => Otp(
                        locale: widget.locale,
                        localizedValues: widget.localizedValues,
                        signUpTime: true,
                        mobileNumber: mobileNumber,
                        sId: response['sId'],
                      ),
                    ),
                  );
                });
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg(context),
      key: _scaffoldKey,
      appBar: appBarPrimary(context, "LOGIN") as PreferredSizeWidget?,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            buildLoginPageForm(),
          ],
        ),
      ),
    );
  }

  Widget buildLoginPageForm() {
    return Form(
      key: _formKeyForLogin,
      child: Theme(
        data: ThemeData(
          brightness: Brightness.dark,
        ),
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              buildwelcometext(),
              buildEmailOrMobileNumberText(),
              buildEmailOrMobileNumberTextField(),
              buildPasswordText(),
              buildPasswordTextField(),
              buildLoginButton(),
              buildForgotPasswordLink(),
              buildcontinuetext(),
              SizedBox(height: 10),
              buildsignuplink(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildwelcometext() {
    return Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: buildBoldText(context, "WELCOME_BACK"));
  }

  Widget buildEmailOrMobileNumberText() {
    return buildGFTypography(context, "EMAIL_OR_MOBILE_NUMBER", true, true);
  }

  Widget buildEmailOrMobileNumberTextField() {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0, bottom: 10.0),
      child: Container(
        child: TextFormField(
          onSaved: (String? value) {
            userName = value;
          },
          initialValue: Constants.predefined == "true"
              ? "user@ionicfirebaseapp.com"
              : null,
          validator: (String? value) {
            if (value!.isEmpty) {
              return MyLocalizations.of(context)!
                  .getLocalizations("ENTER_YOUR_EMAIL_OR_MOBILE_NUMBER");
            } else
              return null;
          },
          style: textBarlowRegularBlack(context),
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            errorBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 0, color: Color(0xFFF44242))),
            errorStyle: TextStyle(color: Color(0xFFF44242)),
            contentPadding: EdgeInsets.all(10),
            enabledBorder: const OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.grey, width: 0.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: primary(context)),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildPasswordText() {
    return buildGFTypography(context, "PASSWORD", true, true);
  }

  Widget buildPasswordTextField() {
    return Container(
      margin: EdgeInsets.only(top: 5.0, bottom: 10.0),
      child: TextFormField(
        style: textBarlowRegularBlack(context),
        keyboardType: TextInputType.text,
        onSaved: (String? value) {
          password = value;
        },
        initialValue: Constants.predefined == "true" ? "123456" : null,
        validator: (String? value) {
          if (value!.isEmpty) {
            return MyLocalizations.of(context)!
                .getLocalizations("ENTER_PASSWORD");
          } else if (value.length < 6) {
            return MyLocalizations.of(context)!.getLocalizations("ERROR_PASS");
          } else
            return null;
        },
        decoration: InputDecoration(
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 0,
              color: Color(0xFFF44242),
            ),
          ),
          errorStyle: TextStyle(color: Color(0xFFF44242)),
          fillColor: dark(context),
          focusColor: dark(context),
          contentPadding: EdgeInsets.only(
            left: 15.0,
            right: 15.0,
            top: 10.0,
            bottom: 10.0,
          ),
          suffixIcon: InkWell(
              onTap: _toggle,
              child: Icon(Icons.remove_red_eye,
                  color: _obscureText
                      ? Theme.of(context).brightness == Brightness.dark
                          ? Colors.white54
                          : Colors.black54
                      : Theme.of(context).brightness == Brightness.dark
                          ? Colors.white24
                          : Colors.black26)),
          enabledBorder: const OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey, width: 0.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: primary(context)),
          ),
        ),
        obscureText: _obscureText,
      ),
    );
  }

  Widget buildLoginButton() {
    return InkWell(
        onTap: userLoginwithMobile,
        child: buttonprimary(context, "LOGIN", isUserLoaginLoading));
  }

  Widget buildForgotPasswordLink() {
    return InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ForgotPassword(
                locale: widget.locale,
                localizedValues: widget.localizedValues,
              ),
            ),
          );
        },
        child: buildGFTypographyFogotPass(context, "FORGET_PASSWORD", false));
  }

  Widget buildcontinuetext() {
    return normalTextWithOutRow(context, "OR", true);
  }

  Widget buildsignuplink() {
    return InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Signup(
                      locale: widget.locale,
                      localizedValues: widget.localizedValues,
                    )),
          );
        },
        child: buildGFTypographyFogotPass(context, "REGISTER", true));
  }

  void showSnackbar(message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(milliseconds: 3000),
      ),
    );
  }
}
