import 'package:flutter/material.dart';
import 'package:grocery_pro/localizations.dart';
import 'package:grocery_pro/screens/auth/resetPassword.dart';
import '../../style/style.dart';
// import 'package:flutter_svg/flutter_svg.dart';
import 'resetPassword.dart';
import '../../service/auth-service.dart';
import 'pin-text-field.dart';
import 'package:flutter/cupertino.dart';
import '../../service/sentry-service.dart';

SentryError sentryError = new SentryError();

class VerifyNumber extends StatefulWidget {
  final String email, token;
  final Map<String, Map<String, String>> localizedValues;
  var locale;
  VerifyNumber(
      {Key key, this.email, this.token, this.locale, this.localizedValues})
      : super(key: key);
  @override
  _VerifyNumberState createState() => _VerifyNumberState();
}

class _VerifyNumberState extends State<VerifyNumber> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AnimationController controller;
  TextEditingController _controller = TextEditingController();
  Animation<Offset> offset;
  String enteredOtp;
  bool isLoading = false, isEmailLoading = false;
  // List currencies = ['94', '95', '96'];
  // var currentitem = '94';
  // verify email
  verifyOTP() async {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      if (mounted) {
        setState(() {
          isLoading = true;
          isEmailLoading = false;
        });
      }
      Map<String, dynamic> body = {"otp": enteredOtp};
      await LoginService.verifyOtp(body, widget.token).then((onValue) {
        try {
          if (mounted) {
            setState(() {
              isLoading = false;
            });
          }
          if (onValue['response_code'] == 200) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => ResetPassword(
                          token: onValue['response_data']['token'],
                          locale: widget.locale,
                          localizedValues: widget.localizedValues,
                        )),
                (Route<dynamic> route) => false);
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

  verifyEmail() async {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      if (mounted) {
        setState(() {
          isEmailLoading = true;
          isLoading = false;
        });
      }
      Map<String, dynamic> body = {"email": widget.email};
      await LoginService.verifyEmail(body).then((onValue) {
        try {
          if (mounted) {
            setState(() {
              isEmailLoading = false;
            });
          }
          if (onValue['response_code'] == 200) {
          } else if (onValue['response_code'] == 400) {
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
    showDialog<Null>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text(MyLocalizations.of(context).error),
          content: new SingleChildScrollView(
            child: new ListBody(
              children: <Widget>[
                new Text('$message'),
              ],
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    // var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Color(0xFFF4F7FA),
        appBar: AppBar(
//        leading: Image.asset('lib/assets/icons/back.png '),
          title: Text(
            MyLocalizations.of(context).verify,
            style: hintSfsemibold(),
          ),
          centerTitle: true,
          elevation: 0.0,
        ),
        body: Container(
            height: 270.0,
            width: screenWidth,
            padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 25.0),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  MyLocalizations.of(context).verifyYourEmail,
                  style: hintSfbold(),
                ),
                Padding(padding: EdgeInsets.only(top: 5.0)),
                // Row(
                //   children: <Widget>[
                //     Text(
                //       "4 digit code sent to",
                //       style: hintSfMediumgreysmall(),
                //     ),
                //     Text(
                //       " +94 71 87 86 729",
                //       style: hintSfboldprimary(),
                //     ),
                //   ],
                // ),
                Row(
                  children: <Widget>[
                    Text(
                      MyLocalizations.of(context).codeSentTo,
                      style: hintSfMediumgreysmall(),
                    ),
                    Text(
                      " ${widget.email}",
                      style: hintSfboldprimary(),
                    ),
                  ],
                ),
                Form(
                  key: _formKey,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[numberinputBox(screenWidth)],
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      width: 143.52,
                      height: 48.58,
                      decoration: BoxDecoration(
                          border: Border.all(color: Color(0xFFF34949)),
                          borderRadius: BorderRadius.circular(1.81)),
                      child: RawMaterialButton(
                        onPressed: verifyEmail,
                        child: isEmailLoading
                            ? Image.asset(
                                'lib/assets/icons/spinner.gif',
                                width: 20.0,
                                height: 20.0,
                              )
                            : Text(
                                MyLocalizations.of(context).resend,
                                style: hintSfMediumredsmall(),
                              ),
                      ),
                    ),
                    FloatingActionButton(
                      backgroundColor: Color(0xFFC5C9D3),
                      onPressed: verifyOTP,
                      child: isLoading
                          ? Image.asset(
                              'lib/assets/icons/spinner.gif',
                              width: 20.0,
                              height: 20.0,
                            )
                          : Image.asset(
                              'lib/assets/icons/correct.svg',
                              color: Colors.white,
                            ),
                    )
                  ],
                ),

//                Row(
//                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                  children: <Widget>[
//                RichText(
//                text: TextSpan(
//                  children: <TextSpan>[
//                    TextSpan(text: 'Resend in:', style: hintSfsemigreysmaller()),
//                    TextSpan(text: ' 00:42s', style: hintSfsemiboldred()),
//                  ],
//                ),
//        ),
//                    FloatingActionButton(
//                      backgroundColor: primary,
//                      onPressed: (){
//                        Navigator.push(
//                          context,
//                          MaterialPageRoute(
//                            builder: (BuildContext context) => EnterPassword()
//                          ),
//                        );
//                      }, child: SvgPicture.asset('lib/assets/icons/correct.svg', color: Colors.white,),)
//                  ],
//                ),
              ],
            )));
  }

  Widget numberinputBox(screenWidth) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: PinCodeTextField(
        autofocus: true,
        controller: _controller,
        hideCharacter: true,
        highlight: true,
        pinBoxHeight: 60.0,
        pinBoxWidth: screenWidth * 0.18,
        highlightColor: Colors.transparent,
        defaultBorderColor: grey,
        hasTextBorderColor: Colors.transparent,
        maxLength: 4,
        hasError: false,
        maskCharacter: "*",
        onTextChanged: (text) {
          if (mounted) {
            setState(() {
              enteredOtp = text;
            });
          }
        },
        isCupertino: true,
        // onDone: (_) {
        //   verifyOTP();
        // },
        pinCodeTextFieldLayoutType:
            PinCodeTextFieldLayoutType.AUTO_ADJUST_WIDTH,
        wrapAlignment: WrapAlignment.start,
        pinBoxDecoration: ProvidedPinBoxDecoration.defaultPinBoxDecoration,
        pinTextStyle: TextStyle(fontSize: 30.0),
        pinTextAnimatedSwitcherTransition:
            ProvidedPinBoxTextAnimation.scalingTransition,
        pinTextAnimatedSwitcherDuration: Duration(milliseconds: 300),
      ),
    );
  }
}
