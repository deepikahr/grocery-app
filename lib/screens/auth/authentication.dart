import 'package:flutter/material.dart';
import 'package:grocery_pro/screens/home/home.dart';
import 'package:grocery_pro/style/style.dart' as prefix0;
import '../../style/style.dart';
import '../../service/auth-service.dart';
import '../../service/sentry-service.dart';
import 'package:flutter/services.dart';
import '../../service/common.dart';
// import '../home.dart';
import 'forgotPassword.dart';
import '../../translator/localizations.dart' show MyLocalizations;

SentryError sentryError = new SentryError();
// String defultEmail = "user@ionicfirebaseapp.com";
// String defultPass = "123456";

class AuthenticationPage extends StatefulWidget {
  final String popupType;
  final Map<String, Map<String, String>> localizedValues;
  var locale;
  AuthenticationPage(
      {Key key, this.popupType, this.locale, this.localizedValues})
      : super(key: key);
  @override
  _AuthenticationPageState createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyForLogin = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isLoading = false;
  bool registerationLoading = false;
  bool rememberMe = false;
  bool value = false;
  String firstname,
      lastname,
      email,
      password,
      mobilenumber,
      userEmail,
      userPassword;
  String popupType;

  @override
  void initState() {
    popupType = widget.popupType;
    // emailController.text = defultEmail;
    // passwordController.text = defultPass;
    super.initState();
  }

  // user registeration
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
        "firstName": firstname,
        "lastName": lastname,
        "email": email.toLowerCase(),
        "password": password,
        "mobileNumber": mobilenumber,
        "role": "User"
      };
      await LoginService.signUp(body).then((onValue) {
        try {
          if (mounted) {
            setState(() {
              registerationLoading = false;
            });
          }
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
                  title: new Text(
                    "Thank You.......",
                    style: hintSfsemiboldb(),
                    textAlign: TextAlign.center,
                  ),
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
                                            AuthenticationPage(
                                                popupType: 'login')),
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

            if (mounted)
              setState(() {
                popupType = 'login';
              });
          } else if (onValue['statusCode'] == 400) {
            showAlert('${onValue['message'][0]['constraints']['isEmail']}');
          } else {
            showAlert('${onValue['response_data']}');
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

  // user login
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
        "email": userEmail.toLowerCase(),
        "password": userPassword
      };
      await LoginService.signIn(body).then((onValue) {
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
                    MyLocalizations.of(context).thankYou + "...",
                    style: hintSfsemiboldb(),
                    textAlign: TextAlign.center,
                  ),
                  content: Container(
                    height: 100.0,
                    child: Column(
                      children: <Widget>[
                        new Text(
                          MyLocalizations.of(context).loginSuccessful,
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
                                        builder: (BuildContext context) => Home(
                                              locale: widget.locale,
                                              localizedValues:
                                                  widget.localizedValues,
                                            )),
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

            // showDialog<Null>(
            //   context: context,
            //   barrierDismissible: false, // user must tap button!
            //   builder: (BuildContext context) {
            //     return new AlertDialog(
            //       title: new Text('Thank You.........'),
            //       content: new SingleChildScrollView(
            //         child: new ListBody(
            //           children: <Widget>[
            //             new Text('Login Successfully......'),
            //           ],
            //         ),
            //       ),
            //       actions: <Widget>[
            //         new FlatButton(
            //           child: new Text('OK'),
            //           onPressed: () {
            //             Navigator.pushAndRemoveUntil(
            //                 context,
            //                 MaterialPageRoute(
            //                     builder: (BuildContext context) => HomePage()),
            //                 (Route<dynamic> route) => false);
            //           },
            //         ),
            //       ],
            //     );
            //   },
            // );
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
        backgroundColor: Color(0xFFF4F7FA),
        appBar: AppBar(
          elevation: 0.0,
          leading: Container(
            width: 100.0,
            child: GestureDetector(
              onTap: () {
                if (mounted) {
                  setState(() {
                    popupType = 'login';
                  });
                }
              },
              child: Padding(
                padding: EdgeInsets.only(left: 8.0, top: 16.0),
                child: Text(
                  MyLocalizations.of(context).signIn,
//                    overflow: TextOverflow.ellipsis,
                  style: popupType == 'login'
                      ? hintSfMediumprimarysmall()
                      : hintSfMediumgreysmall(),
                ),
              ),
            ),
          ),
          actions: <Widget>[
            GestureDetector(
              onTap: () {
                if (mounted) {
                  setState(() {
                    popupType = 'signup';
                  });
                }
              },
              child: Padding(
                padding: EdgeInsets.only(right: 8.0, top: 16.0),
                child: Text(
                  MyLocalizations.of(context).signUp,
                  style: popupType != 'login'
                      ? hintSfMediumprimarysmall()
                      : hintSfMediumgreysmall(),
                ),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
              height: popupType == 'login' ? 340.0 : 600.0,
              decoration: new BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    new BoxShadow(
                      color: Color(0XFF80828B),
                      blurRadius: 10.0,
                    ),
                  ],
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(5.44),
                      bottomLeft: Radius.circular(5.44))),
              padding: EdgeInsets.only(left: 14.0, right: 14.0, top: 25.0),
              child: popupType == 'login'
                  ? Form(
                      key: _formKeyForLogin,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            MyLocalizations.of(context).signInToKools +
                                ' Vegyfruit App',
                            style: hintSfbold(),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              MyLocalizations.of(context).enterToContinue,
                              style: hintSfMediumgreysmall(),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(
                              left: 15.0,
                            ),
                            margin: EdgeInsets.only(top: 25.0),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: prefix0.border, width: 0.23),
                                borderRadius: BorderRadius.circular(1.81)),
                            child: TextFormField(
                              // controller: emailController,
                              // initialValue: defultEmail,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: MyLocalizations.of(context)
                                      .enterYourEmail,
                                  hintStyle: hintSfMediumgreyersmallLight(),
                                  suffixIcon: InkWell(
                                    onTap: () {
                                      // emailController.text = "";
                                    },
                                    child: Image.asset(
                                      'lib/assets/icons/close.png',
                                      scale: 3.5,
                                    ),
                                  )),
                              onSaved: (String value) {
                                userEmail = value;
                              },
                              validator: (String value) {
                                if (value.isEmpty ||
                                    !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                                        .hasMatch(value)) {
                                  return MyLocalizations.of(context)
                                      .pleaseEnterValidEmail;
                                } else
                                  return null;
                              },
                              keyboardType: TextInputType.emailAddress,
                              style: hintSfMediumgreyersmall(),
                              cursorColor: primary,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(
                              left: 15.0,
                            ),
                            margin: EdgeInsets.only(top: 15.0, bottom: 20.0),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: prefix0.border, width: 0.23),
                                borderRadius: BorderRadius.circular(1.81)),
                            child: TextFormField(
                              // controller: passwordController,
                              // initialValue: defultPass,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText:
                                      MyLocalizations.of(context).enterPassword,
                                  hintStyle: hintSfMediumgreyersmallLight(),
                                  suffixIcon: InkWell(
                                    onTap: () {
                                      // passwordController.text = "";
                                    },
                                    child: Image.asset(
                                      'lib/assets/icons/close.png',
                                      scale: 3.5,
                                    ),
                                  )),
                              style: hintSfMediumgreyersmall(),
                              cursorColor: primary,
                              obscureText: true,
                              onSaved: (String value) {
                                userPassword = value;
                              },
                              validator: (String value) {
                                if (value.isEmpty || value.length < 6) {
                                  return MyLocalizations.of(context)
                                      .pleaseEnterValidPassword;
                                } else
                                  return null;
                              },
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              // GestureDetector(
                              //   onTap: () {
                              //     if(mounted)setState(() {
                              //       _value = !_value;
                              //     });
                              //   },
                              //   child: Container(
                              //       width: 24.0,
                              //       height: 24.0,
                              //       margin: EdgeInsets.only(
                              //           right: 15.0, bottom: 0),
                              //       decoration: BoxDecoration(
                              //         border: Border.all(
                              //           color: _value
                              //               ? Colors.white
                              //               : Color(0xFFBBC2C3),
                              //         ),
                              //       ),
                              //       child: Padding(
                              //         padding: const EdgeInsets.all(0.0),
                              //         child: _value
                              //             ? Container(
                              //                 color: primary,
                              //                 child: Icon(
                              //                   Icons.check,
                              //                   size: 15.0,
                              //                   color: Colors.white,
                              //                 ),
                              //               )
                              //             : Icon(
                              //                 Icons.check,
                              //                 size: 15.0,
                              //                 color: Colors.black
                              //                     .withOpacity(0.0),
                              //               ),
                              //       )),
                              // ),
//               Checkbox(
//                 activeColor: primary,
//                 value: rememberMe,
//                 onChanged: (bool value) {
//                   if(mounted)setState(() {
//                     rememberMe = value;
//                   });
//                 },
//               ),
                              // Text(
                              //   'Keep me signed in',
                              //   style: hintSfMediumgreysmaller(),
                              // ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            ForgotPassword(
                                              localizedValues:
                                                  widget.localizedValues,
                                              locale: widget.locale,
                                            )),
                                  );
                                },
                                child: Text(
                                    MyLocalizations.of(context).forgotPassword +
                                        '?',
                                    style: hintSfsemigreysmaller()),
                              ),

                              Expanded(
                                  child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  SizedBox(
                                    height: 48.5,
                                    width: 48.5,
                                    child: FloatingActionButton(
                                      elevation: 0.0,
                                      backgroundColor: primary,
                                      onPressed: userLogin,
                                      // onPressed: () {
                                      // Navigator.push(
                                      //   context,
                                      //   MaterialPageRoute(
                                      //       builder: (BuildContext
                                      //               context) =>
                                      //           AddNumber()),
                                      // );
                                      // },
                                      child: isLoading
                                          ? Image.asset(
                                              'lib/assets/icons/spinner.gif',
                                              width: 20.0,
                                              height: 20.0,
                                              color: Colors.white,
                                            )
                                          : Image.asset(
                                              'lib/assets/icons/arrow.png',
                                              scale: 3,
                                            ),
                                    ),
                                  )
                                ],
                              ))
                            ],
                          )
                        ],
                      ))
                  : Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            MyLocalizations.of(context).signInToKools +
                                ' Vegyfruit App',
                            style: hintSfbold(),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              MyLocalizations.of(context).letsGetStarted,
                              style: hintSfMediumgreysmall(),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 15.0, right: 15.0),
                            margin: EdgeInsets.only(top: 25.0),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: prefix0.border, width: 0.23),
                                borderRadius: BorderRadius.circular(1.81)),
                            child: TextFormField(
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: MyLocalizations.of(context)
                                    .enterYourFirstName,
                                hintStyle: hintSfMediumgreyersmallLight(),
                              ),
                              style: hintSfMediumgreyersmall(),
                              cursorColor: primary,
                              onSaved: (String value) {
                                firstname = value;
                              },
                              validator: (String value) {
                                final RegExp nameExp =
                                    new RegExp(r'^[A-Za-z ]+$');
                                if (value.isEmpty || !nameExp.hasMatch(value)) {
                                  return MyLocalizations.of(context)
                                      .pleaseEnterValidName;
                                } else
                                  return null;
                              },
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 15.0, right: 15.0),
                            margin: EdgeInsets.only(top: 25.0),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: prefix0.border, width: 0.23),
                                borderRadius: BorderRadius.circular(1.81)),
                            child: TextFormField(
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: MyLocalizations.of(context)
                                    .enterYourLastName,
                                hintStyle: hintSfMediumgreyersmallLight(),
                              ),
                              style: hintSfMediumgreyersmall(),
                              cursorColor: primary,
                              onSaved: (String value) {
                                lastname = value;
                              },
                              validator: (String value) {
                                final RegExp nameExp =
                                    new RegExp(r'^[A-Za-z ]+$');
                                if (value.isEmpty || !nameExp.hasMatch(value)) {
                                  return MyLocalizations.of(context)
                                      .pleaseEnterValidName;
                                } else
                                  return null;
                              },
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 15.0, right: 15.0),
                            margin: EdgeInsets.only(top: 25.0),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: prefix0.border, width: 0.23),
                                borderRadius: BorderRadius.circular(1.81)),
                            child: TextFormField(
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText:
                                    MyLocalizations.of(context).enterYourEmail,
                                hintStyle: hintSfMediumgreyersmallLight(),
                              ),
                              style: hintSfMediumgreyersmall(),
                              cursorColor: primary,
                              onSaved: (String value) {
                                email = value;
                              },
                              validator: (String value) {
                                if (value.isEmpty ||
                                    !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                                        .hasMatch(value)) {
                                  return MyLocalizations.of(context)
                                      .pleaseEnterValidEmail;
                                } else
                                  return null;
                              },
                              keyboardType: TextInputType.emailAddress,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 15.0, right: 15.0),
                            margin: EdgeInsets.only(top: 15.0),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: prefix0.border, width: 0.23),
                                borderRadius: BorderRadius.circular(1.81)),
                            child: TextFormField(
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText:
                                      MyLocalizations.of(context).enterPassword,
                                  hintStyle: hintSfMediumgreyersmallLight()),
                              style: hintSfMediumgreyersmall(),
                              cursorColor: primary,
                              obscureText: true,
                              onSaved: (String value) {
                                password = value;
                              },
                              validator: (String value) {
                                if (value.isEmpty || value.length < 6) {
                                  return MyLocalizations.of(context)
                                      .pleaseEnterValidPassword;
                                } else
                                  return null;
                              },
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 15.0, right: 15.0),
                            margin: EdgeInsets.only(top: 15.0, bottom: 15.0),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: prefix0.border, width: 0.23),
                                borderRadius: BorderRadius.circular(1.81)),
                            child: TextFormField(
                              decoration: InputDecoration(
                                  counterText: '',
                                  border: InputBorder.none,
                                  hintText: MyLocalizations.of(context)
                                      .enterYourContactNumber,
                                  hintStyle: hintSfMediumgreyersmallLight()),
                              style: hintSfMediumgreyersmall(),
                              cursorColor: primary,
                              onSaved: (String value) {
                                mobilenumber = value;
                              },
                              maxLength: 10,
                              inputFormatters: [
                                WhitelistingTextInputFormatter(RegExp(r'\d+'))
                              ],
                              // autofocus: true,
                              enableInteractiveSelection: false,
                              validator: (String value) {
                                if (value.length != 10)
                                  return MyLocalizations.of(context)
                                      .pleaseEnterValidMobileNumber;
                                else
                                  return null;
                              },
                              keyboardType: TextInputType.phone,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              SizedBox(
                                width: 48.5,
                                height: 48.5,
                                child: FloatingActionButton(
                                  elevation: 0.0,
                                  backgroundColor: primary,
                                  onPressed: userSignup,
                                  child: registerationLoading
                                      ? Image.asset(
                                          'lib/assets/icons/spinner.gif',
                                          width: 20.0,
                                          height: 20.0,
                                          color: Colors.white,
                                        )
                                      : Image.asset(
                                          'lib/assets/icons/arrow.png',
                                          scale: 3,
                                        ),
                                ),
                              )
                            ],
                          )
                        ],
                      ))),
        ));
  }
}
