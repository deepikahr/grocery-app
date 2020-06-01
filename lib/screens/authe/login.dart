import 'package:flutter/material.dart';
import 'package:getflutter/components/appbar/gf_appbar.dart';
import 'package:getflutter/components/button/gf_button.dart';
import 'package:getflutter/components/typography/gf_typography.dart';
import 'package:getflutter/getflutter.dart';
import 'package:getflutter/size/gf_size.dart';
import 'package:readymadeGroceryApp/screens/authe/forgotpassword.dart';
import 'package:readymadeGroceryApp/screens/authe/signup.dart';
import 'package:readymadeGroceryApp/screens/home/home.dart';
import 'package:readymadeGroceryApp/service/common.dart';
import 'package:readymadeGroceryApp/service/constants.dart';
import 'package:readymadeGroceryApp/service/localizations.dart';
import 'package:readymadeGroceryApp/style/style.dart';
import 'package:readymadeGroceryApp/service/sentry-service.dart';
import 'package:readymadeGroceryApp/service/auth-service.dart';

SentryError sentryError = new SentryError();

class Login extends StatefulWidget {
  const Login(
      {Key key,
      this.isProfile,
      this.isCart,
      this.isSaveItem,
      this.isProductDetails,
      this.locale,
      this.localizedValues,
      this.isBottomSheet})
      : super(key: key);
  final bool isProfile, isCart, isSaveItem, isProductDetails, isBottomSheet;
  final Map localizedValues;
  final String locale;

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKeyForLogin = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isUserLoaginLoading = false,
      registerationLoading = false,
      value = false,
      passwordVisible = true;
  String email, password;
  bool _obscureText = true;

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

  userLogin() async {
    final form = _formKeyForLogin.currentState;
    if (form.validate()) {
      form.save();
      if (mounted) {
        setState(() {
          isUserLoaginLoading = true;
        });
      }
      await Common.getPlayerID().then((playerID) async {
        Map<String, dynamic> body = {
          "email": email.toLowerCase(),
          "password": password,
          "playerId": playerID
        };
        await LoginService.signIn(body).then((onValue) async {
          try {
            if (mounted) {
              setState(() {
                isUserLoaginLoading = false;
              });
            }
            if (onValue['response_code'] == 200) {
              if (onValue['response_data']['role'] == 'User') {
                await Common.setToken(onValue['response_data']['token']);
                await Common.setUserID(onValue['response_data']['_id']);
                await LoginService.setLanguageCodeToProfile();
                if (widget.isCart == true) {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => Home(
                          locale: widget.locale,
                          localizedValues: widget.localizedValues,
                          currentIndex: 2,
                        ),
                      ),
                      (Route<dynamic> route) => false);
                } else if (widget.isProfile == true) {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => Home(
                          locale: widget.locale,
                          localizedValues: widget.localizedValues,
                          currentIndex: 3,
                        ),
                      ),
                      (Route<dynamic> route) => false);
                } else if (widget.isSaveItem == true) {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => Home(
                          locale: widget.locale,
                          localizedValues: widget.localizedValues,
                          currentIndex: 1,
                        ),
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
                          currentIndex: 0,
                        ),
                      ),
                      (Route<dynamic> route) => false);
                }
              } else {
                showSnackbar(MyLocalizations.of(context).invalidUser);
              }
            } else if (onValue['response_code'] == 401) {
              showSnackbar(onValue['response_data']);
            } else {
              showSnackbar(onValue['response_data']);
            }
          } catch (error, stackTrace) {
            if (mounted) {
              setState(() {
                isUserLoaginLoading = false;
              });
            }
            sentryError.reportError(error, stackTrace);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: GFAppBar(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20))),
        title: Text(
          MyLocalizations.of(context).login,
          style: textbarlowSemiBoldBlack(),
        ),
        centerTitle: true,
        backgroundColor: primary,
        iconTheme: IconThemeData(color: Colors.black),
      ),
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
              buildEmailText(),
              buildEmailTextField(),
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
      child: GFTypography(
        showDivider: false,
        child: Text(
          MyLocalizations.of(context).welcomeBack,
          style: textbarlowMediumBlack(),
        ),
      ),
    );
  }

  Widget buildEmailText() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: GFTypography(
        showDivider: false,
        child: RichText(
          text: TextSpan(
            children: <TextSpan>[
              TextSpan(
                text: MyLocalizations.of(context).email,
                style: textbarlowRegularBlackdull(),
              ),
              TextSpan(
                text: ' *',
                style: TextStyle(color: Color(0xFFF44242)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildEmailTextField() {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0, bottom: 10.0),
      child: Container(
        child: TextFormField(
          initialValue: Constants.APP_NAME.contains('Readymade')
              ? "user@ionicfirebaseapp.com"
              : null,
          onSaved: (String value) {
            email = value;
          },
          validator: (String value) {
            if (value.isEmpty) {
              return MyLocalizations.of(context).enterYourEmail;
            } else if (!RegExp(
                    r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                .hasMatch(value)) {
              return MyLocalizations.of(context).pleaseEnterValidEmail;
            } else
              return null;
          },
          style: textBarlowRegularBlack(),
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            errorBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 0, color: Color(0xFFF44242))),
            errorStyle: TextStyle(color: Color(0xFFF44242)),
            contentPadding: EdgeInsets.all(10),
            enabledBorder: const OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.grey, width: 0.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: primary),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildPasswordText() {
    return GFTypography(
      showDivider: false,
      child: RichText(
        text: TextSpan(
          children: <TextSpan>[
            TextSpan(
                text: MyLocalizations.of(context).password,
                style: textbarlowRegularBlackdull()),
            TextSpan(
              text: ' *',
              style: TextStyle(color: Color(0xFFF44242)),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPasswordTextField() {
    return Container(
      margin: EdgeInsets.only(top: 5.0, bottom: 10.0),
      child: TextFormField(
        initialValue:
            Constants.APP_NAME.contains('Readymade') ? "123456" : null,
        style: textBarlowRegularBlack(),
        keyboardType: TextInputType.text,
        onSaved: (String value) {
          password = value;
        },
        validator: (String value) {
          if (value.isEmpty) {
            return MyLocalizations.of(context).enterPassword;
          } else if (value.length < 6) {
            return MyLocalizations.of(context).pleaseEnterMin6DigitPassword;
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
          fillColor: Colors.black,
          focusColor: Colors.black,
          contentPadding: EdgeInsets.only(
            left: 15.0,
            right: 15.0,
            top: 10.0,
            bottom: 10.0,
          ),
          suffixIcon: InkWell(
            onTap: _toggle,
            child: _obscureText
                ? Icon(Icons.remove_red_eye, color: Colors.black54)
                : Icon(Icons.remove_red_eye, color: Colors.black26),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey, width: 0.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: primary),
          ),
        ),
        obscureText: _obscureText,
      ),
    );
  }

  Widget buildLoginButton() {
    return Container(
      height: 55,
      margin: EdgeInsets.only(top: 30, bottom: 20),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(color: Colors.black.withOpacity(0.29), blurRadius: 5)
      ]),
      child: GFButton(
        size: GFSize.LARGE,
        color: primary,
        blockButton: true,
        onPressed: userLogin,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              MyLocalizations.of(context).login,
              style: textBarlowRegularrBlack(),
            ),
            SizedBox(
              height: 10,
            ),
            isUserLoaginLoading
                ? GFLoader(
                    type: GFLoaderType.ios,
                  )
                : Text("")
          ],
        ),
      ),
    );
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
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: RichText(
          text: TextSpan(
            children: <TextSpan>[
              TextSpan(
                  text: MyLocalizations.of(context).forgotPasswordWithQuasMarks,
                  style: textbarlowRegularBlackd()),
              TextSpan(
                text: '',
                style: TextStyle(color: primary),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildcontinuetext() {
    return Text(
      MyLocalizations.of(context).or,
      textAlign: TextAlign.center,
      style: textBarlowRegularBlack(),
    );
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
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: RichText(
          text: TextSpan(
            children: <TextSpan>[
              TextSpan(
                text: MyLocalizations.of(context).registerWithQuasMarks,
                style: textbarlowRegularaPrimary(),
              ),
              TextSpan(
                text: '',
                style: TextStyle(color: primary),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildsocialbuttons() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 10.0, left: 0.0, right: 0.0),
            child: GFButton(
              size: GFSize.LARGE,
              icon: Icon(
                IconData(
                  0xe906,
                  fontFamily: 'icomoon',
                ),
                color: Colors.white,
              ),
              buttonBoxShadow: true,
              color: Color(0xFF3B5998),
              onPressed: () {},
              child: Text(
                "Log in with Facebook",
                style: textBarlowRegularrWhite(),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
      ],
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
