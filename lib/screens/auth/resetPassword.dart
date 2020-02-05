import 'package:flutter/material.dart';
import 'package:grocery_pro/localizations.dart';
import '../../style/style.dart';
import '../../service/auth-service.dart';
import '../../service/sentry-service.dart';
import 'authentication.dart';

SentryError sentryError = new SentryError();

class ResetPassword extends StatefulWidget {
  final String token;
  final Map<String, Map<String, String>> localizedValues;
  var locale;
  ResetPassword({Key key, this.token, this.localizedValues, this.locale})
      : super(key: key);
  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String password;
  bool success = false;

  bool isLoading = false;

  resetPassword() async {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      if (mounted) {
        setState(() {
          isLoading = true;
        });
      }
      Map<String, dynamic> body = {"password": password};
      await LoginService.resetPassword(body, widget.token).then((onValue) {
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
                    builder: (BuildContext context) => AuthenticationPage(
                          popupType: 'login',
                          localizedValues: widget.localizedValues,
                          locale: widget.locale,
                        )),
                (Route<dynamic> route) => false);

            // if(mounted)setState(() {
            //   success = true;
            // });
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
          centerTitle: true,
          elevation: 0.0,
          title: Text(
            MyLocalizations.of(context).resetPassword,
            style: hintSfsemibold(),
          ),
        ),
        body: Container(
            height: 250.0,
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
                  MyLocalizations.of(context).resetYourPassword,
                  style: hintSfbold(),
                ),
                Padding(padding: EdgeInsets.only(top: 5.0)),
                Text(
                  MyLocalizations.of(context).enterNewPassword,
                  style: hintSfMediumgreysmall(),
                ),
                Form(
                    key: _formKey,
                    child: Container(
                      height: 45.8,
                      padding: EdgeInsets.only(left: 12.0, right: 0.0),
                      margin: EdgeInsets.only(top: 25.0, bottom: 20.0),
                      decoration: BoxDecoration(
                          border: Border.all(color: Color(0xFFD4D4E0)),
                          borderRadius: BorderRadius.circular(1.81)),
                      child: TextFormField(
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintStyle: hintSfletterspacingMediumgreyersmall(),
                            suffixIcon: Icon(Icons.close)
//                  suffixIcon: SvgPicture.asset('lib/assets/icons/close.svg', height: 10.0,)
                            ),
                        style: hintSfletterspacingMediumgreyersmall(),
                        cursorColor: primary,
                        obscureText: true,
                        onSaved: (String value) {
                          password = value;
                        },
                      ),
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    FloatingActionButton(
                      backgroundColor: primary,
                      onPressed: resetPassword,
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
              ],
            )));
//     success
//         ? Positioned(
//             child: GestureDetector(
//               onTap: () {
//                 if(mounted)setState(() {
//                   success = false;
//                 });
//               },
//               child: Stack(
//                 children: <Widget>[
//                   Container(
//                     color: Color(0xFFc0c1ca),
//                     height: screenHeight,
//                   ),
//                   Positioned(
//                       left: 10.0,
//                       right: 10.0,
//                       top: 170.0,
//                       child: Material(
//                         child: Container(
//                           height: 320,
//                           width: screenWidth,
//                           decoration: new BoxDecoration(
//                               color: Colors.white,
//                               boxShadow: [
//                                 new BoxShadow(
//                                   color: Color(0XFF80828B),
//                                   blurRadius: 10.0,
//                                 ),
//                               ],
//                               borderRadius:
//                                   BorderRadius.all(Radius.circular(1.81))),
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: <Widget>[
//                               Padding(
//                                 padding: EdgeInsets.only(top: 30.0),
//                                 child: SvgPicture.asset(
//                                   'lib/assets/imgs/success.svg',
//                                   color: primary,
//                                 ),
//                               ),
//                               Text(
//                                 'Congratulations!',
//                                 style: hintSfsemiblack(),
//                               ),
//                               Text(
//                                 'Your mobile number verified successfull! You can now continue using Koolls online shopping',
//                                 style: hintSfMediumgrey(),
//                                 textAlign: TextAlign.center,
//                               ),
//                               Container(
//                                 height: 48.8,
//                                 width: 378,
//                                 decoration: new BoxDecoration(
//                                     color: primary,
//                                     borderRadius: BorderRadius.only(
//                                         bottomRight: Radius.circular(1.81),
//                                         bottomLeft: Radius.circular(1.81))),
//                                 child: RawMaterialButton(
//                                   onPressed: () {
//                                     Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                           builder: (BuildContext context) =>
//                                               AuthenticationPage(
//                                                   popupType: 'login')),
//                                     );
// //
//                                   },
//                                   child: Text(
//                                     'Sign in',
//                                     style: hintSfMediumwhitesmaller(),
//                                   ),
//                                 ),
//                               )
//                             ],
//                           ),
//                         ),
//                       ))
//                 ],
//               ),
//             ),
//           )
//         : Container();
  }
}
