import 'package:flutter/material.dart';

import 'package:getflutter/getflutter.dart';
import 'package:readymadeGroceryApp/screens/authe/login.dart';
import 'package:readymadeGroceryApp/service/auth-service.dart';
import 'package:readymadeGroceryApp/service/localizations.dart';
import 'package:readymadeGroceryApp/style/style.dart';
import 'package:readymadeGroceryApp/service/sentry-service.dart';
import 'package:readymadeGroceryApp/widgets/appBar.dart';
import 'package:readymadeGroceryApp/widgets/button.dart';

SentryError sentryError = new SentryError();

class Signup extends StatefulWidget {
  final Map localizedValues;
  final String locale;
  Signup({Key key, this.locale, this.localizedValues});

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool isLoading = false,
      registerationLoading = false,
      rememberMe = false,
      value = false,
      passwordVisible = true,
      isChecked = false,
      _obscureText = true;
  String userName, email, password, firstName, lastName;
  String mobileNumber;
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

  userSignup() async {
    final form = _formKey.currentState;
    if (form.validate()) {
      // if (isChecked == true) {
      form.save();
      if (mounted) {
        setState(() {
          registerationLoading = true;
        });
      }

      Map<String, dynamic> body = {
        "firstName": firstName,
        "lastName": lastName,
        "email": email.toLowerCase(),
        "password": password,
        "mobileNumber": mobileNumber
      };
      await LoginService.signUp(body).then((onValue) {
        if (mounted) {
          setState(() {
            registerationLoading = false;
          });
        }

        showDialog<Null>(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            return new AlertDialog(
              content: new SingleChildScrollView(
                child: new ListBody(
                  children: <Widget>[
                    new Text(
                      onValue['response_data'],
                      style: textBarlowRegularBlack(),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                new FlatButton(
                  child: new Text(
                    MyLocalizations.of(context).getLocalizations("OK"),
                    style: textbarlowRegularaPrimary(),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => Login(
                          locale: widget.locale,
                          localizedValues: widget.localizedValues,
                        ),
                      ),
                    );
                  },
                ),
              ],
            );
          },
        );
      }).catchError((error) {
        if (mounted) {
          setState(() {
            registerationLoading = false;
          });
        }
        sentryError.reportError(error, null);
      });
      // } else {
      //   showSnackbar(
      //       MyLocalizations.of(context).getLocalizations("ACCEPT_MSG"));
      // }
    } else {
      if (mounted) {
        setState(() {
          registerationLoading = false;
        });
      }

      return;
    }
  }

  showAlert(message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.only(
            top: 10.0,
          ),
          title: new Text(
            MyLocalizations.of(context).getLocalizations("ERROR"),
            style: textBarlowRegularBlack(),
            textAlign: TextAlign.center,
          ),
          content: Container(
            height: 100.0,
            child: Column(
              children: <Widget>[
                new Text(
                  "$message",
                  style: textBarlowRegularBlack(),
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
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(),
                            child: Text(
                              MyLocalizations.of(context)
                                  .getLocalizations("OK"),
                              style: textbarlowRegularaPrimary(),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )
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
      key: _scaffoldKey,
      appBar: appBarPrimary(context, "SIGNUP"),
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
              buildUserFirstName(),
              buildUserFirstNameField(),
              buildUserLastName(),
              buildUserLastNameField(),
              buildEmailText(),
              buildEmailTextField(),
              buildMobileNumberText(),
              buildMobileNumberTextField(),
              buildPasswordText(),
              buildPasswordTextField(),
              // buildTermsAndCondiField(),
              buildsignuplink(),
              buildLoginButton(),
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
          MyLocalizations.of(context).getLocalizations("LETS_GET_STARTED") +
              " !",
          style: textbarlowMediumBlack(),
        ),
      ),
    );
  }

  Widget buildUserFirstName() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: GFTypography(
        showDivider: false,
        child: RichText(
          text: TextSpan(
            children: <TextSpan>[
              TextSpan(
                  text: MyLocalizations.of(context)
                      .getLocalizations("FIRST_NAME"),
                  style: textbarlowRegularBlackdull()),
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

  Widget buildUserFirstNameField() {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0, bottom: 10.0),
      child: Container(
        child: TextFormField(
          style: textBarlowRegularBlack(),
          keyboardType: TextInputType.emailAddress,
          validator: (String value) {
            if (value.isEmpty) {
              return MyLocalizations.of(context)
                  .getLocalizations("ENTER_FIRST_NAME", true);
            } else
              return null;
          },
          onSaved: (String value) {
            firstName = value;
          },
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

  Widget buildUserLastName() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: GFTypography(
        showDivider: false,
        child: RichText(
          text: TextSpan(
            children: <TextSpan>[
              TextSpan(
                  text: MyLocalizations.of(context)
                      .getLocalizations("LAST_NAME", true),
                  style: textbarlowRegularBlackdull()),
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

  Widget buildUserLastNameField() {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0, bottom: 10.0),
      child: Container(
        child: TextFormField(
          style: textBarlowRegularBlack(),
          keyboardType: TextInputType.emailAddress,
          validator: (String value) {
            if (value.isEmpty) {
              return MyLocalizations.of(context)
                  .getLocalizations("ENTER_LAST_NAME");
            } else
              return null;
          },
          onSaved: (String value) {
            lastName = value;
          },
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

  Widget buildEmailText() {
    return Padding(
      padding: const EdgeInsets.only(),
      child: GFTypography(
        showDivider: false,
        child: RichText(
          text: TextSpan(
            children: <TextSpan>[
              TextSpan(
                  text: MyLocalizations.of(context)
                      .getLocalizations("EMAIL", true),
                  style: textbarlowRegularBlackdull()),
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
          style: textBarlowRegularBlack(),
          keyboardType: TextInputType.emailAddress,
          validator: (String value) {
            if (value.isEmpty) {
              return MyLocalizations.of(context)
                  .getLocalizations("ENTER_YOUR_EMAIL");
            } else if (!RegExp(
                    r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                .hasMatch(value)) {
              return MyLocalizations.of(context).getLocalizations("ERROR_MAIL");
            } else
              return null;
          },
          onSaved: (String value) {
            email = value;
          },
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
                text: MyLocalizations.of(context)
                    .getLocalizations("PASSWORD", true),
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
        style: textBarlowRegularBlack(),
        keyboardType: TextInputType.text,
        validator: (String value) {
          if (value.isEmpty) {
            return MyLocalizations.of(context)
                .getLocalizations("ENTER_PASSWORD");
          } else if (value.length < 6) {
            return MyLocalizations.of(context).getLocalizations("ERROR_PASS");
          } else
            return null;
        },
        onSaved: (String value) {
          password = value;
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

  Widget buildMobileNumberText() {
    return GFTypography(
      showDivider: false,
      child: RichText(
        text: TextSpan(
          children: <TextSpan>[
            TextSpan(
                text: MyLocalizations.of(context)
                    .getLocalizations("CONTACT_NUMBER", true),
                style: textbarlowRegularBlack()),
            TextSpan(
              text: ' *',
              style: TextStyle(color: Color(0xFFF44242)),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMobileNumberTextField() {
    return Container(
      margin: EdgeInsets.only(top: 5.0, bottom: 10.0),
      child: TextFormField(
        maxLength: 15,
        style: textBarlowRegularBlack(),
        keyboardType: TextInputType.number,
        validator: (String value) {
          if (value.isEmpty) {
            return MyLocalizations.of(context)
                .getLocalizations("ENTER_YOUR_CONTACT_NUMBER");
          } else
            return null;
        },
        onSaved: (String value) {
          mobileNumber = value;
        },
        decoration: InputDecoration(
          counterText: "",
          errorBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 0, color: Color(0xFFF44242))),
          errorStyle: TextStyle(color: Color(0xFFF44242)),
          fillColor: Colors.black,
          focusColor: Colors.black,
          contentPadding: EdgeInsets.only(
            left: 15.0,
            right: 15.0,
            top: 10.0,
            bottom: 10.0,
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey, width: 0.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: primary),
          ),
        ),
      ),
    );
  }

  Widget buildsignuplink() {
    return InkWell(
        onTap: userSignup,
        child: buttonPrimary(context, "SIGNUP", registerationLoading));
  }

  Widget buildLoginButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: RichText(
          text: TextSpan(
            children: <TextSpan>[
              TextSpan(
                  text: MyLocalizations.of(context)
                      .getLocalizations("HAVE_GOT_AN_ACCOUNT"),
                  style: textbarlowRegularBlack()),
              TextSpan(
                text: MyLocalizations.of(context).getLocalizations("LOGIN"),
                style: textbarlowRegularaPrimary(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildcontinuetext() {
    return Text(
      MyLocalizations.of(context).getLocalizations("OR"),
      textAlign: TextAlign.center,
      style: textBarlowRegularBlack(),
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
