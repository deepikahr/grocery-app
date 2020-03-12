import 'package:flutter/material.dart';
import 'package:getflutter/colors/gf_color.dart';
import 'package:getflutter/components/appbar/gf_appbar.dart';
import 'package:getflutter/components/button/gf_button.dart';
import 'package:getflutter/components/typography/gf_typography.dart';
import 'package:getflutter/getflutter.dart';
import 'package:getflutter/size/gf_size.dart';
import 'package:grocery_pro/service/auth-service.dart';
import 'package:grocery_pro/style/style.dart';
import 'package:grocery_pro/screens/login/login.dart';
import 'package:grocery_pro/service/sentry-service.dart';

SentryError sentryError = new SentryError();

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isLoading = false;
  bool registerationLoading = false;
  bool rememberMe = false;
  bool value = false;
  String userName, email, password;

  @override
  void initState() {
    super.initState();
  }

  userSignup() async {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      if (mounted) {
        setState(() {
          registerationLoading = true;
        });
      }
      Map<String, dynamic> body = {
        "firstName": userName,
        "email": email.toLowerCase(),
        "password": password,
        "role": "User"
      };
      // print('Value on login');
      // print(body);
      await LoginService.signUp(body).then((onValue) {
        try {
          if (mounted) {
            setState(() {
              // print('I am here too');
              registerationLoading = false;
            });
          }
          // print('I am here');
          // print(body);
          if (onValue['response_code'] == 201) {
            // showAlert('${onValue['response_data']}');
            showDialog(
              context: context,
              builder: (BuildContext context) {
                // return object of type Dialog
                return AlertDialog(
                  contentPadding: EdgeInsets.only(
                    top: 10.0,
                  ),
                  // title: new Text(
                  //   "Thank You.......",
                  //   style: hintSfsemiboldb(),
                  //   textAlign: TextAlign.center,
                  // ),
                  content: Container(
                    height: 100.0,
                    child: Column(
                      children: <Widget>[
                        new Text(
                          "${onValue['response_data']}",
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
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            Login()),
                                    (Route<dynamic> route) => false);
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

            // if (mounted)
            //   Navigator.pushAndRemoveUntil(
            //       context,
            //       MaterialPageRoute(builder: (BuildContext context) => Login()),
            //       (Route<dynamic> route) => false);
            // setState(() {
            //   // popupType = 'login';
            // });
          } else if (onValue['statusCode'] == 400) {
            showAlert('${onValue['message'][0]['constraints']['isEmail']}');
          } else {
            showAlert('${onValue['response_data']}');
          }
        } catch (error) {
          sentryError.reportError(error, null);
        }
      }).catchError((error) {
        print('Error at 2');
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
            'Error at showalert',
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
            'Sign up',
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
      key: _formKey,
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
              buildusername(),
              buildusernameField(),
              buildEmailText(),
              buildEmailTextField(),
              buildPasswordText(),
              buildPasswordTextField(),
              buildsignuplink(),
              buildLoginButton(),
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

  Widget buildusername() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: GFTypography(
        // color: Colors.blue,
        showDivider: false,
        child: RichText(
          text: TextSpan(
            children: <TextSpan>[
              TextSpan(text: "UserName", style: emailTextNormal()),
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

  Widget buildusernameField() {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0, bottom: 10.0),
      child: Container(
        // color: Colors.blue,
        child: TextFormField(
          initialValue: "John Snow",
          style: labelStyle(),
          keyboardType: TextInputType.emailAddress,
          validator: (String value) {
            if (value.isEmpty || !RegExp(r'^[A-Za-z ]+$').hasMatch(value)) {
              return "Please Enter Valid Name";
            } else
              return null;
          },
          onSaved: (String value) {
            userName = value;
          },

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

  Widget buildEmailText() {
    return Padding(
      padding: const EdgeInsets.only(),
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
          initialValue: "user@demo.com",
          style: labelStyle(),
          keyboardType: TextInputType.emailAddress,
          validator: (String value) {
            if (value.isEmpty) {
              return "Please Enter Valid Email";
            } else
              return null;
          },
          onSaved: (String value) {
            email = value;
          },

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
        initialValue: "123456",
        style: labelStyle(),
        keyboardType: TextInputType.text,
        validator: (String value) {
          if (value.isEmpty || value.length < 6) {
            return "please Enter Valid Password";
          } else
            return null;
        },
        onSaved: (String value) {
          password = value;
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

  Widget buildsignuplink() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, bottom: 15.0),
      child: GFButton(
        // color: primary,
        size: GFSize.large,
        color: GFColor.warning,
        blockButton: true,

        onPressed: userSignup,
        text: 'Sign Up',
        textStyle: TextStyle(fontSize: 17.0, color: Colors.black),
      ),
    );
  }

  Widget buildLoginButton() {
    return InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Login()),
          );
        },
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: RichText(
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(
                    text: "Have got an account?", style: emailTextNormal()),
                TextSpan(
                  text: '  Log in!',
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
                "Sign Up with Facebook",
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
