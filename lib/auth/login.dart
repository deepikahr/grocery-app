import 'package:flutter/material.dart';
import 'package:getflutter/colors/gf_color.dart';
import 'package:getflutter/components/appbar/gf_appbar.dart';
import 'package:getflutter/components/button/gf_button.dart';
import 'package:getflutter/components/typography/gf_typography.dart';
import 'package:getflutter/getflutter.dart';
import 'package:getflutter/size/gf_size.dart';
import 'package:grocery_pro/auth/forgotpassword.dart';
import 'package:grocery_pro/style/style.dart';
import 'package:grocery_pro/verification/otp.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
              // buildusername(),
              // buildEmailTextField(),
              buildEmailText(),
              buildEmailTextField(),
              buildPasswordText(),
              buildPasswordTextField(),
              buildLoginButton(),
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

        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Otp()),
          );
        },
        text: 'Log In',
        textStyle: TextStyle(fontSize: 17.0, color: Colors.black),
      ),
    );
    //     )
    //   ],
    // );
  }

  Widget buildsignuplink() {
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
