import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:readymadeGroceryApp/screens/authe/otp.dart';
import 'package:readymadeGroceryApp/service/common.dart';
import 'package:readymadeGroceryApp/service/constants.dart';
import 'package:readymadeGroceryApp/service/localizations.dart';
import 'package:readymadeGroceryApp/service/otp-service.dart';
import 'package:readymadeGroceryApp/style/style.dart';
import 'package:readymadeGroceryApp/service/sentry-service.dart';
import 'package:readymadeGroceryApp/widgets/appBar.dart';
import 'package:readymadeGroceryApp/widgets/button.dart';
import 'package:readymadeGroceryApp/widgets/loader.dart';
import 'package:readymadeGroceryApp/widgets/normalText.dart';

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
  var selectedCountryValue, currentLocale;
  Map selectedCountry;
  bool isLoading = false,
      registerationLoading = false,
      rememberMe = false,
      value = false,
      passwordVisible = true,
      isChecked = false,
      _obscureText = true,
      isCuntryLoading = false;
  String userName, email, password, firstName, lastName, mobileNumber;
  // Toggles the password
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  void initState() {
    getCuntry();
    super.initState();
  }

  getCuntry() {
    setState(() {
      isCuntryLoading = true;
    });
    Common.getCountryInfo().then((value) {
      setState(() {
        selectedCountry = Constants.countryCode[0];
        isCuntryLoading = false;
        if (value != null) {
          for (int i = 0; i < Constants.countryCode.length; i++) {
            if (Constants.countryCode[i]['code'].toString() ==
                value.toString()) {
              selectedCountry = Constants.countryCode[i];
            }
          }
        }
      });
    });
  }

  userSignupwithMobile() async {
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
        "password": password,
        "mobileNumber": mobileNumber,
        "countryCode": selectedCountry['dial_code'],
        "countryName": selectedCountry['name'],
      };
      if (email != null && email != "") {
        body['email'] = email.toLowerCase();
      }
      await OtpService.signUpWithNumber(body).then((onValue) {
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
                    new Text(onValue['response_data'],
                        style: textBarlowRegularBlack()),
                  ],
                ),
              ),
              actions: <Widget>[
                new FlatButton(
                  child: new Text(
                      MyLocalizations.of(context).getLocalizations("OK"),
                      style: textbarlowRegularaPrimary()),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => Otp(
                          locale: widget.locale,
                          localizedValues: widget.localizedValues,
                          signUpTime: true,
                          mobileNumber: mobileNumber,
                          sId: onValue['sId'],
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
      body: isCuntryLoading
          ? Center(child: SquareLoader())
          : Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: Container(
                  child: ListView(
                    children: <Widget>[
                      buildwelcometext(),
                      buildUserFirstName(),
                      buildUserFirstNameField(),
                      buildUserLastName(),
                      buildUserLastNameField(),
                      buildEmailText(),
                      buildEmailTextField(),
                      buildCountryNumberText(),
                      buildCountryNumberTextField(),
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
            ),
    );
  }

  Widget buildwelcometext() {
    return buildBoldText(context, "LETS_GET_STARTED");
  }

  Widget buildUserFirstName() {
    return buildGFTypography(context, "FIRST_NAME", true, true);
  }

  Widget buildUserFirstNameField() {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
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
    return buildGFTypography(context, "LAST_NAME", true, true);
  }

  Widget buildUserLastNameField() {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
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
    return buildGFTypography(context, "EMAIL_OPTIONAL", false, true);
  }

  Widget buildEmailTextField() {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
      child: Container(
        child: TextFormField(
          style: textBarlowRegularBlack(),
          keyboardType: TextInputType.emailAddress,
          validator: (String value) {
            if (value.isEmpty) {
              return null;
            } else if (!RegExp(Constants.emailValidation).hasMatch(value)) {
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
    return buildGFTypography(context, "PASSWORD", true, true);
  }

  Widget buildPasswordTextField() {
    return Container(
      margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
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
    return buildGFTypography(context, "MOBILE_NUMBER", true, true);
  }

  Widget buildMobileNumberTextField() {
    return Container(
      margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
      child: TextFormField(
        maxLength: 15,
        style: textBarlowRegularBlack(),
        keyboardType: TextInputType.number,
        validator: (String value) {
          if (value.isEmpty) {
            return MyLocalizations.of(context)
                .getLocalizations("ENTER_YOUR_MOBILE_NUMBER");
          } else
            return null;
        },
        onSaved: (String value) {
          mobileNumber = value;
        },
        decoration: InputDecoration(
          prefixText: selectedCountry['dial_code'].toString(),
          counterText: "",
          prefixStyle: textBarlowRegularBlack(),
          errorBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 0, color: Color(0xFFF44242))),
          errorStyle: TextStyle(color: Color(0xFFF44242)),
          fillColor: Colors.black,
          focusColor: Colors.black,
          contentPadding:
              EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0, bottom: 10.0),
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

  Widget buildCountryNumberText() {
    return buildGFTypography(context, "COUNTRY", true, true);
  }

  Widget buildCountryNumberTextField() {
    return Container(
      margin: EdgeInsets.only(top: 5.0, bottom: 5.0, left: 1, right: 1),
      padding: EdgeInsets.only(left: 10, right: 10),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(4)),
          boxShadow: [BoxShadow(color: Colors.black, blurRadius: 0)]),
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
          dropdownColor: Colors.white,
          isExpanded: true,
          hint: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                new Text(selectedCountry['name'],
                    style: textBarlowRegularBlack()),
                new Text(" (${selectedCountry['dial_code'].toString()})",
                    style: textBarlowRegularBlack()),
              ],
            ),
          ),
          value: selectedCountryValue,
          onChanged: (newValue) async {
            setState(() {
              selectedCountry = newValue;
            });
          },
          items: Constants.countryCode.map((country) {
            return DropdownMenuItem(
              child: Row(
                children: [
                  new Text(country['name']),
                  new Text("(${country['dial_code']})"),
                ],
              ),
              value: country,
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget buildsignuplink() {
    return InkWell(
        onTap: userSignupwithMobile,
        child: buttonPrimary(context, "SIGNUP", registerationLoading));
  }

  Widget buildLoginButton() {
    return InkWell(
        onTap: () {
          Navigator.pop(context);
        },
        child: buildGFTypographyOtp(context, "HAVE_GOT_AN_ACCOUNT",
            ' ${MyLocalizations.of(context).getLocalizations("LOGIN")}'));
  }

  void showSnackbar(message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: Duration(milliseconds: 3000),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
}
