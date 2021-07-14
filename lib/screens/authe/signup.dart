import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:getwidget/getwidget.dart';
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
  final Map? localizedValues;
  final String? locale;
  Signup({Key? key, this.locale, this.localizedValues});

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var selectedCountryValue, currentLocale;
  late Map selectedCountry;
  bool isLoading = false,
      registerationLoading = false,
      rememberMe = false,
      value = false,
      passwordVisible = true,
      isChecked = false,
      _obscureText = true,
      isCuntryLoading = false;
  String? userName, email, password, firstName, lastName, mobileNumber;
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
    final form = _formKey.currentState!;
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
        body['email'] = email!.toLowerCase();
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
                        style: textBarlowRegularBlack(context)),
                  ],
                ),
              ),
              actions: <Widget>[
                GFButton(
                  color: Colors.transparent,
                  child: new Text(
                      MyLocalizations.of(context)!.getLocalizations("OK"),
                      style: textbarlowRegularaprimary(context)),
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
            MyLocalizations.of(context)!.getLocalizations("ERROR"),
            style: textBarlowRegularBlack(context),
            textAlign: TextAlign.center,
          ),
          content: Container(
            height: 100.0,
            child: Column(
              children: <Widget>[
                new Text(
                  "$message",
                  style: textBarlowRegularBlack(context),
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
                              MyLocalizations.of(context)!
                                  .getLocalizations("OK"),
                              style: textbarlowRegularaprimary(context),
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
      backgroundColor: bg(context),
      key: _scaffoldKey,
      appBar: appBarPrimary(context, "SIGNUP") as PreferredSizeWidget?,
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
                      // buildCountryNumberText(),
                      // buildCountryNumberTextField(),
                      buildMobileNumberText(),
                      buildMobileNumberTextField(),
                      buildPasswordText(),
                      buildPasswordTextField(),
                      buildsignuplink(),
                      buildLoginButton(),
                      SizedBox(height: 20),
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
          style: textBarlowRegularBlack(context),
          keyboardType: TextInputType.emailAddress,
          validator: (String? value) {
            if (value!.isEmpty) {
              return MyLocalizations.of(context)!
                  .getLocalizations("ENTER_FIRST_NAME", true);
            } else
              return null;
          },
          onSaved: (String? value) {
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
              borderSide: BorderSide(color: primary(context)),
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
          style: textBarlowRegularBlack(context),
          keyboardType: TextInputType.emailAddress,
          validator: (String? value) {
            if (value!.isEmpty) {
              return MyLocalizations.of(context)!
                  .getLocalizations("ENTER_LAST_NAME");
            } else
              return null;
          },
          onSaved: (String? value) {
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
              borderSide: BorderSide(color: primary(context)),
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
          style: textBarlowRegularBlack(context),
          keyboardType: TextInputType.emailAddress,
          validator: (String? value) {
            if (value!.isEmpty) {
              return null;
            } else if (!RegExp(Constants.emailValidation).hasMatch(value)) {
              return MyLocalizations.of(context)!
                  .getLocalizations("ERROR_MAIL");
            } else
              return null;
          },
          onSaved: (String? value) {
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
      margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
      child: TextFormField(
        style: textBarlowRegularBlack(context),
        keyboardType: TextInputType.text,
        validator: (String? value) {
          if (value!.isEmpty) {
            return MyLocalizations.of(context)!
                .getLocalizations("ENTER_PASSWORD");
          } else if (value.length < 6) {
            return MyLocalizations.of(context)!.getLocalizations("ERROR_PASS");
          } else
            return null;
        },
        onSaved: (String? value) {
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

  Widget buildMobileNumberText() {
    return buildGFTypography(context, "MOBILE_NUMBER", true, true);
  }

  Widget buildMobileNumberTextField() {
    return Container(
      margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
      child: TextFormField(
        maxLength: 15,
        style: textBarlowRegularBlack(context),
        keyboardType: TextInputType.number,
        validator: (String? value) {
          if (value!.isEmpty) {
            return MyLocalizations.of(context)!
                .getLocalizations("ENTER_YOUR_MOBILE_NUMBER");
          } else
            return null;
        },
        onSaved: (String? value) {
          mobileNumber = value;
        },
        decoration: InputDecoration(
          prefixIcon: InkWell(
            onTap: () {
              _settingModalBottomSheet(context);
            },
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 8),
              padding: EdgeInsets.symmetric(horizontal: 9),
              width: 100,
              decoration: BoxDecoration(
                  border: Border(right: BorderSide(color: Colors.grey[300]!))),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                        "${selectedCountry['code'] ?? ""}${selectedCountry['dial_code'] ?? ""}",
                        overflow: TextOverflow.ellipsis,
                        style: textBarlowSemiboldprimaryy(context)),
                  ),
                  Icon(Icons.keyboard_arrow_down,
                      size: 17, color: Colors.grey[400])
                ],
              ),
            ),
          ),
          counterText: "",
          prefixStyle: textBarlowRegularBlack(context),
          errorBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 0, color: Color(0xFFF44242))),
          errorStyle: TextStyle(color: Color(0xFFF44242)),
          fillColor: dark(context),
          focusColor: dark(context),
          contentPadding:
              EdgeInsets.only(left: 25.0, right: 15.0, top: 10.0, bottom: 10.0),
          enabledBorder: const OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey, width: 0.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: primary(context)),
          ),
        ),
      ),
    );
  }

  Widget buildsignuplink() {
    return InkWell(
        onTap: userSignupwithMobile,
        child: buttonprimary(context, "SIGNUP", registerationLoading));
  }

  Widget buildLoginButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Center(
        child: buildGFTypographyOtp(context, "HAVE_GOT_AN_ACCOUNT",
            ' ${MyLocalizations.of(context)!.getLocalizations("LOGIN")}'),
      ),
    );
  }

  void _settingModalBottomSheet(context) {
    var result = showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext bc) {
          return Container(
            decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  new BoxShadow(
                    color: Colors.black12,
                    blurRadius: 1.0,
                  ),
                ],
                borderRadius: new BorderRadius.only(
                  topLeft: Radius.circular(40.0),
                  topRight: Radius.circular(40.0),
                )),
            child: new ListView(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 60,
                  padding: EdgeInsets.only(top: 25, left: 20),
                  decoration: BoxDecoration(
                      color: dark(context),
                      borderRadius: new BorderRadius.only(
                        topLeft: Radius.circular(40.0),
                        topRight: Radius.circular(40.0),
                      )),
                  child: Text(
                    MyLocalizations.of(context)!
                        .getLocalizations('SELECT_YOUR_COUNTRY'),
                    style: textbarlowmediumwhitee(context),
                  ),
                ),
                ListView.builder(
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemCount: Constants.countryCode.length,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {
                          Navigator.of(context)
                              .pop(Constants.countryCode[index]);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "(${Constants.countryCode[index]['dial_code'] ?? ""}) ${Constants.countryCode[index]['name'] ?? ""}",
                                style: textbarlowRegularadd(context),
                              ),
                              Divider()
                            ],
                          ),
                        ),
                      );
                    }),
              ],
            ),
          );
        });
    result.then((value) {
      if (value != null) {
        setState(() {
          selectedCountry = value;
        });
      }
    });
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
