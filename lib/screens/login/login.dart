import 'package:flutter/material.dart';
import 'package:getflutter/colors/gf_color.dart';
import 'package:getflutter/components/appbar/gf_appbar.dart';
import 'package:getflutter/components/button/gf_button.dart';
import 'package:getflutter/components/typography/gf_typography.dart';
import 'package:getflutter/getflutter.dart';
import 'package:getflutter/size/gf_size.dart';
import 'package:grocery_pro/screens/forgetpassword/forgotpassword.dart';
// import 'package:grocery_pro/screens/verification/otp.dart';
import 'package:grocery_pro/service/common.dart';
import 'package:grocery_pro/style/style.dart';
import 'package:grocery_pro/service/sentry-service.dart';
import 'package:grocery_pro/service/auth-service.dart';
import 'package:grocery_pro/translator/localizations.dart';
import 'package:grocery_pro/screens/login/signup.dart';
import 'package:grocery_pro/screens/cart/mycart.dart';
import 'package:grocery_pro/screens/home/home.dart';

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

  bool isLoading = false;
  bool registerationLoading = false;
  bool value = false;
  String email, password;

  @override
  void initState() {
    super.initState();
    getToken();
  }

  getToken() async {
    await Common.getToken().then((onValue) {
      // print("Value of the Token");
      // print(onValue);
    });
  }

  // returnPage() {
  //   // final pageToken = ;

  // }

  userLogin() async {
    final form = _formKeyForLogin.currentState;
    if (form.validate()) {
      form.save();
      if (mounted) {
        setState(() {
          isLoading = true;
        });
      }
      Map<String, dynamic> body = {
        "email": email.toLowerCase(),
        "password": password
      };
      // print('I am here 2');
      // print(body);
      await LoginService.signIn(body).then((onValue) {
        // print('onvalue of login');
        // print(onValue);
        try {
          if (mounted) {
            setState(() {
              isLoading = false;
            });
          }
          if (onValue['response_code'] == 200) {
            Common.setToken(onValue['response_data']['token']);
            showDialog(
              context: context,
              builder: (BuildContext context) {
                // return object of type Dialog
                return AlertDialog(
                  contentPadding: EdgeInsets.only(
                    top: 10.0,
                  ),
                  title: new Text(
                    'Thank you',
                    // MyLocalizations.of(context).thankYou + "...",
                    style: hintSfsemiboldb(),
                    textAlign: TextAlign.center,
                  ),
                  content: Container(
                    height: 100.0,
                    child: Column(
                      children: <Widget>[
                        new Text(
                          'Login Successful',
                          // MyLocalizations.of(context).loginSuccessful,
                          style: hintSfLightsm(),
                          textAlign: TextAlign.center,
                        ),
                        Padding(padding: EdgeInsets.only(top: 20.0)),
                        Divider(),
                        IntrinsicHeight(
                            child: new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            VerticalDivider(),
                            Expanded(
                                child: GestureDetector(
                              // onTap: returnPage,
                              onTap: () {
                                if (widget.isProfile == true) {
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              Home()),
                                      (Route<dynamic> route) => false);
                                } else if (widget.isStore == true) {
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              Home()),
                                      (Route<dynamic> route) => false);
                                } else {
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              MyCart()),
                                      (Route<dynamic> route) => false);
                                }
                              },
                              child: Container(
                                alignment: Alignment.center,
//                            margin: EdgeInsets.only(top:15.0),
//                                height: 29.0,
                                decoration: BoxDecoration(
//                                border: Border.all(color: Colors.black12)
                                    ),
                                child: Text(
                                  'OK',
                                  style: hintSfLightbig(),
                                ),
                              ),
                            ))
                          ],
                        ))
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (onValue['response_code'] == 401) {
            showAlert('${onValue['response_data']}');
          } else {}
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

  showAlert(message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          contentPadding: EdgeInsets.only(
            top: 10.0,
          ),
          title: new Text(
            MyLocalizations.of(context).error,
            style: hintSfsemiboldb(),
            textAlign: TextAlign.center,
          ),
          content: Container(
            height: 100.0,
            child: Column(
              children: <Widget>[
                new Text(
                  "$message",
                  style: hintSfLightsm(),
                  textAlign: TextAlign.center,
                ),
                Padding(padding: EdgeInsets.only(top: 20.0)),
                Divider(),
                IntrinsicHeight(
                    child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    VerticalDivider(),
                    Expanded(
                        child: GestureDetector(
//                              onTap: (){},
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        alignment: Alignment.center,
//                            margin: EdgeInsets.only(top:15.0),
//                                height: 29.0,
                        decoration: BoxDecoration(
//                                border: Border.all(color: Colors.black12)
                            ),
                        child: Text(
                          'OK',
                          style: hintSfLightbig(),
                        ),
                      ),
                    ))
                  ],
                ))
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: GFAppBar(
          automaticallyImplyLeading: false,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20))),
          title: Text(
            'Log In',
            style: TextStyle(color: Colors.black, fontSize: 20.0),
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
        ));
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
              // buildusername(),
              // buildEmailTextField(),
              buildEmailText(),
              buildEmailTextField(),
              buildPasswordText(),
              buildPasswordTextField(),
              buildLoginButton(),
              buildForgotPasswordLink(),
              buildcontinuetext(),
              buildsignuplink(),
              buildcontinuetext(),
              buildsocialbuttons(),
              // buildForgotPasswordButton(),
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
        // color: Colors.blue,
        showDivider: false,
        child: Text(
          "Let's get started !",
          style: authHeader(),
        ),
      ),
    );
  }

  Widget buildEmailText() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: GFTypography(
        // color: Colors.blue,
        showDivider: false,
        child: RichText(
          text: TextSpan(
            children: <TextSpan>[
              TextSpan(text: "Email", style: emailTextNormal()),
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
        // color: Colors.blue,
        child: TextFormField(
          // initialValue: "user@demo.com",
          onSaved: (String value) {
            email = value;
          },
          validator: (String value) {
            if (value.isEmpty ||
                !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                    .hasMatch(value)) {
              return "Please Enter a Valid Email";
              // MyLocalizations.of(context).pleaseEnterValidEmail;
            } else
              return null;
          },
          style: labelStyle(),
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.all(10),
              enabledBorder: const OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.grey, width: 0.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: primary),
              )),
          // style: textBlackOSR(),
        ),
      ),
    );
  }

  Widget buildPasswordText() {
    return GFTypography(
      // color: Colors.blue,
      showDivider: false,
      child: RichText(
        text: TextSpan(
          children: <TextSpan>[
            TextSpan(text: "Password", style: emailTextNormal()),
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
      // color: Colors.blue,
      child: TextFormField(
        // initialValue: "123456",
        style: labelStyle(),
        keyboardType: TextInputType.text,
        onSaved: (String value) {
          password = value;
        },
        validator: (String value) {
          if (value.isEmpty || value.length < 8) {
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
            )),
        // style: textBlackOSR(),
        obscureText: true,
      ),
    );
  }

  Widget buildLoginButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, bottom: 15.0),
      child: GFButton(
        // color: primary,
        size: GFSize.large,
        color: GFColor.warning,
        blockButton: true,
        onPressed: userLogin,

        // onPressed: () {
        //   Navigator.push(
        //     context,
        //     MaterialPageRoute(builder: (context) => Otp()),
        //   );
        // },
        text: 'Log In',
        textStyle: TextStyle(fontSize: 17.0, color: Colors.black),
      ),
    );
    //     )
    //   ],
    // );
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
          padding: const EdgeInsets.only(bottom: 20.0),
          child: RichText(
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(text: "Forgot Password?", style: emailTextNormal()),
                TextSpan(
                  text: '',
                  style: TextStyle(color: primary),
                ),
              ],
            ),
          ),
        ));
  }

  Widget buildcontinuetext() {
    return Text(
      'OR',
      textAlign: TextAlign.center,
      style: emailTextNormal(),
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
                TextSpan(text: "Register?", style: emailTextNormal()),
                TextSpan(
                  text: '',
                  style: TextStyle(color: primary),
                ),
              ],
            ),
          ),
        ));
  }

  Widget buildsocialbuttons() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 10.0, left: 0.0, right: 0.0),
            child: GFButton(
              size: GFSize.large,
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
        // ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
