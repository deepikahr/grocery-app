import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
import '../../style/style.dart';
import 'verifyNumber.dart';
import '../../service/auth-service.dart';
import '../../service/sentry-service.dart';
import '../../localizations.dart' show MyLocalizations;

SentryError sentryError = new SentryError();

class ForgotPassword extends StatefulWidget {
  final Map<String, Map<String, String>> localizedValues;
  var locale;
  ForgotPassword({Key key, this.locale, this.localizedValues})
      : super(key: key);
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String email;
  bool isLoading = false;
  // List currencies = ['94', '95', '96'];
  // var currentitem = '94';
  // verify email
  verifyEmail() async {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      if (mounted) {
        setState(() {
          isLoading = true;
        });
      }
      Map<String, dynamic> body = {"email": email.toLowerCase()};
      await LoginService.verifyEmail(body).then((onValue) {
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
                    builder: (BuildContext context) => VerifyNumber(
                          email: email.toLowerCase(),
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

  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Color(0xFFF4F7FA),
        appBar: AppBar(
//        leading: Image.asset('lib/assets/icons/back.png '),
          title: Text(
            MyLocalizations.of(context).forgotPassword,
            style: hintSfsemibold(),
          ),
          centerTitle: true,
          elevation: 0.0,
        ),
        body: Container(
            // height: 250.0,
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
                  MyLocalizations.of(context).whatsYourEmail,
                  style: hintSfbold(),
                ),
                Padding(padding: EdgeInsets.only(top: 5.0)),
                Text(
                  MyLocalizations.of(context).enterToContinue,
                  style: hintSfMediumgreysmall(),
                ),
                // Row(
                //   children: <Widget>[
//                     Flexible(
//                         flex: 3,
//                         fit: FlexFit.tight,
//                         child: Container(
//                             height: 48.5,
//                             decoration: BoxDecoration(
//                                 border: Border.all(color: Color(0xFFD4D4E0)),
//                                 borderRadius: BorderRadius.circular(1.81)),
//                             margin: EdgeInsets.only(
//                                 right: 4.0, top: 25.0, bottom: 20.0),
//                             padding: EdgeInsets.only(left: 10.0),
//                             child: Row(
//                               children: <Widget>[
//                                 Icon(
//                                   Icons.add,
//                                   size: 15.0,
//                                 ),
//                                 new DropdownButtonHideUnderline(
//                                     child: new DropdownButton<String>(
//                                   items: currencies.map((dropDownStringItem) {
//                                     return DropdownMenuItem<String>(
//                                       value: dropDownStringItem,
//                                       child: Text(dropDownStringItem),
//                                     );
//                                   }).toList(),
//                                   onChanged: (String newvalue) {
//                                     if(mounted)setState(() {
//                                       this.currentitem = newvalue;
//                                     });
//                                   },
//                                   value: currentitem,
//                                   isDense: true,
//                                   style: hintSfMediumgreyersmall(),
// //                            isDense: true,
// //                          style: textregularblacklight()
//                                 )),
//                               ],
//                             ))),
//                     Flexible(
//                         flex: 8,
//                         fit: FlexFit.tight,
                // child:
                Form(
                  key: _formKey,
                  child: Container(
                    padding: EdgeInsets.only(left: 15.0, right: 15.0),
                    margin: EdgeInsets.only(top: 25.0),
                    decoration: BoxDecoration(
                        border: Border.all(color: Color(0xFFD4D4E0)),
                        borderRadius: BorderRadius.circular(1.81)),
                    child: TextFormField(
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: MyLocalizations.of(context).enterYourEmail,
                          hintStyle: hintSfMediumgreyersmallLight(),
                          suffixIcon: Icon(Icons.close)
//                  suffixIcon: SvgPicture.asset('lib/assets/icons/close.svg', height: 10.0,)
                          ),
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
                      style: hintSfMediumgreyersmall(),
                      cursorColor: primary,
                    ),
                  ),
                ),
                // )
                //   ],
                // ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      FloatingActionButton(
                        backgroundColor: primary,
                        onPressed: verifyEmail,
                        child: isLoading
                            ? Image.asset(
                                'lib/assets/icons/spinner.gif',
                                width: 20.0,
                                height: 20.0,
                              )
                            : Image.asset(
                                'lib/assets/icons/arrow.png',
                                scale: 3,
                              ),
                      )
                    ],
                  ),
                )
              ],
            )));
  }
}
