import 'package:flutter/material.dart';
import 'package:getflutter/components/appbar/gf_appbar.dart';
import 'package:getflutter/components/button/gf_button.dart';
import 'package:getflutter/components/typography/gf_typography.dart';
import 'package:getflutter/getflutter.dart';
import 'package:getflutter/size/gf_size.dart';
import 'package:readymadeGroceryApp/screens/authe/login.dart';
import 'package:readymadeGroceryApp/service/auth-service.dart';
import 'package:readymadeGroceryApp/service/localizations.dart';
import 'package:readymadeGroceryApp/style/style.dart';
import 'package:readymadeGroceryApp/service/sentry-service.dart';

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
      passwordVisible = true;
  String userName, email, password, mobileNumber, firstName, lastName;

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
        "firstName": firstName,
        "lastName": lastName,
        "email": email.toLowerCase(),
        "password": password,
        "role": "User",
        "mobileNumber": mobileNumber
      };

      await LoginService.signUp(body).then((onValue) {
        try {
          if (mounted) {
            setState(() {
              registerationLoading = false;
            });
          }

          if (onValue['response_code'] == 201) {
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
                        MyLocalizations.of(context).ok,
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
          } else if (onValue['statusCode'] == 401) {
            showSnackbar('${onValue['response_data']}');
          } else {
            showSnackbar('${onValue['response_data']}');
          }
        } catch (error) {
          if (mounted) {
            setState(() {
              registerationLoading = false;
            });
          }
          sentryError.reportError(error, null);
        }
      }).catchError((error) {
        if (mounted) {
          setState(() {
            registerationLoading = false;
          });
        }
        sentryError.reportError(error, null);
      });
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
            MyLocalizations.of(context).error,
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
                              MyLocalizations.of(context).ok,
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
      appBar: GFAppBar(
        automaticallyImplyLeading: false,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20))),
        title: Text(
          MyLocalizations.of(context).signUp,
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
              buildEmailText(),
              buildEmailTextField(),
              buildMobileNumberText(),
              buildMobileNumberTextField(),
              buildPasswordText(),
              buildPasswordTextField(),
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
          MyLocalizations.of(context).letsgetstarted + " !",
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
                  text: MyLocalizations.of(context).fullName,
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
              return MyLocalizations.of(context).enterFullName;
            } else if (!RegExp(r'^[A-Za-z ]+$').hasMatch(value)) {
              return MyLocalizations.of(context).pleaseEnterValidFullName;
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

  Widget buildEmailText() {
    return Padding(
      padding: const EdgeInsets.only(),
      child: GFTypography(
        showDivider: false,
        child: RichText(
          text: TextSpan(
            children: <TextSpan>[
              TextSpan(
                  text: MyLocalizations.of(context).email,
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
              return MyLocalizations.of(context).enterYourEmail;
            } else if (!RegExp(
                    r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                .hasMatch(value)) {
              return MyLocalizations.of(context).pleaseEnterValidEmail;
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
        style: textBarlowRegularBlack(),
        keyboardType: TextInputType.text,
        validator: (String value) {
          if (value.isEmpty) {
            return MyLocalizations.of(context).enterPassword;
          } else if (value.length < 6) {
            return MyLocalizations.of(context).pleaseEnterMin6DigitPassword;
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
                text: MyLocalizations.of(context).contactNumber,
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
            return MyLocalizations.of(context).enterYourContactNumber;
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
        onPressed: userSignup,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              MyLocalizations.of(context).signUp,
              style: textBarlowRegularrBlack(),
            ),
            SizedBox(
              height: 10,
            ),
            registerationLoading
                ? GFLoader(
                    type: GFLoaderType.ios,
                  )
                : Text("")
          ],
        ),
      ),
    );
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
                    text: MyLocalizations.of(context).havegotanaccount,
                    style: textbarlowRegularBlack()),
                TextSpan(
                  text: MyLocalizations.of(context).login + '!',
                  style: textbarlowRegularaPrimary(),
                ),
              ],
            ),
          ),
        ));
  }

  Widget buildcontinuetext() {
    return Text(
      MyLocalizations.of(context).or,
      textAlign: TextAlign.center,
      style: textBarlowRegularBlack(),
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
                size: 28,
              ),
              buttonBoxShadow: true,
              color: Color(0xFF3B5998),
              onPressed: () {},
              child: Text(
                "Sign Up with Facebook",
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
