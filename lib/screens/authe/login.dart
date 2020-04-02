import 'package:flutter/material.dart';
import 'package:getflutter/colors/gf_color.dart';
import 'package:getflutter/components/appbar/gf_appbar.dart';
import 'package:getflutter/components/button/gf_button.dart';
import 'package:getflutter/components/typography/gf_typography.dart';
import 'package:getflutter/getflutter.dart';
import 'package:getflutter/size/gf_size.dart';
import 'package:grocery_pro/screens/authe/forgotpassword.dart';
import 'package:grocery_pro/screens/authe/signup.dart';
import 'package:grocery_pro/screens/home/home.dart';
import 'package:grocery_pro/service/common.dart';
import 'package:grocery_pro/style/style.dart';
import 'package:grocery_pro/service/sentry-service.dart';
import 'package:grocery_pro/service/auth-service.dart';

SentryError sentryError = new SentryError();

class Login extends StatefulWidget {
  const Login(
      {Key key,
      this.isProfile,
      this.isCart,
      this.isStore,
      this.isProductDetails})
      : super(key: key);
  final bool isProfile;
  final bool isCart;
  final bool isStore;
  final bool isProductDetails;
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKeyForLogin = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isUserLoaginLoading = false;
  bool registerationLoading = false;
  bool value = false;
  String email, password;

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
      Map<String, dynamic> body = {
        "email": email.toLowerCase(),
        "password": password
      };
      await LoginService.signIn(body).then((onValue) {
        try {
          if (mounted) {
            setState(() {
              isUserLoaginLoading = false;
            });
          }
          if (onValue['response_code'] == 200) {
            Common.setToken(onValue['response_data']['token']);
            showDialog<Null>(
              context: context,
              barrierDismissible: false, // user must tap button!
              builder: (BuildContext context) {
                return new AlertDialog(
                  content: new SingleChildScrollView(
                    child: new ListBody(
                      children: <Widget>[
                        new Text('Login successfully'),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    new FlatButton(
                      child: new Text('OK'),
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) => Home(
                                currentIndex: 2,
                              ),
                            ),
                            (Route<dynamic> route) => false);
                      },
                    ),
                  ],
                );
              },
            );
          } else if (onValue['response_code'] == 401) {
            showSnackbar(onValue['response_data']);
          } else {
            showSnackbar(onValue['response_data']);
          }
        } catch (error, stackTrace) {
          sentryError.reportError(error, stackTrace);
        }
      }).catchError((error) {
        sentryError.reportError(error, null);
      });
    } else {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: GFAppBar(
        automaticallyImplyLeading: false,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20))),
        title: Text(
          'Login',
          style: textbarlowSemiBoldBlack(),
        ),
        centerTitle: true,
        backgroundColor: primary,
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
          "Let's get started !",
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
              TextSpan(text: "Email", style: textbarlowRegularBlack()),
              TextSpan(
                text: ' *',
                style: TextStyle(color: Colors.red),
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
          initialValue: "user@ionicfirebaseapp.com",
          onSaved: (String value) {
            email = value;
          },
          validator: (String value) {
            if (value.isEmpty ||
                !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                    .hasMatch(value)) {
              return "Please Enter a Valid Email";
            } else
              return null;
          },
          style: textBarlowRegularBlack(),
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
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
            TextSpan(text: "Password", style: textbarlowRegularBlack()),
            TextSpan(
              text: ' *',
              style: TextStyle(color: Colors.red),
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
        initialValue: "123456",
        style: textBarlowRegularBlack(),
        keyboardType: TextInputType.text,
        onSaved: (String value) {
          password = value;
        },
        validator: (String value) {
          if (value.isEmpty || value.length < 6) {
            return "please Enter Valid Password";
          } else
            return null;
        },
        decoration: InputDecoration(
          fillColor: Colors.black,
          focusColor: Colors.black,
          contentPadding: EdgeInsets.only(
            left: 15.0,
            right: 15.0,
            top: 10.0,
            bottom: 10.0,
          ),
          suffixIcon: Icon(
            Icons.remove_red_eye,
            color: Colors.grey,
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey, width: 0.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: primary),
          ),
        ),
        obscureText: true,
      ),
    );
  }

  Widget buildLoginButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, bottom: 15.0),
      child: GFButton(
        size: GFSize.LARGE,
        color: GFColors.WARNING,
        blockButton: true,
        onPressed: userLogin,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Login",
              style: textBarlowRegularrBlack(),
            ),
            isUserLoaginLoading
                ? Image.asset(
                    'lib/assets/images/spinner.gif',
                    width: 15.0,
                    height: 15.0,
                    color: Colors.black,
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
          MaterialPageRoute(builder: (context) => ForgotPassword()),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: RichText(
          text: TextSpan(
            children: <TextSpan>[
              TextSpan(
                  text: "Forgot Password?", style: textbarlowRegularBlack()),
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
      'OR',
      textAlign: TextAlign.center,
      style: textbarlowRegularBlack(),
    );
  }

  Widget buildsignuplink() {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Signup()),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: RichText(
          text: TextSpan(
            children: <TextSpan>[
              TextSpan(text: "Register?", style: textbarlowRegularBlack()),
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
                style: TextStyle(fontSize: 20.0),
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
