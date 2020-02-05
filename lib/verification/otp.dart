import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/colors/gf_color.dart';
import 'package:getflutter/components/appbar/gf_appbar.dart';
import 'package:getflutter/components/button/gf_button.dart';
import 'package:getflutter/components/typography/gf_typography.dart';
import 'package:grocery_pro/auth/signup.dart';
import 'package:grocery_pro/style/style.dart';
import 'package:pin_entry_text_field/pin_entry_text_field.dart';
import '../screens/home.dart';

class Otp extends StatefulWidget {
  Otp({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _OtpState createState() => _OtpState();
}

class _OtpState extends State<Otp> {
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
          'Welcome',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: primary,
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
              top: 40.0,
              left: 15.0,
            ),
            child: Text(
              "Verify your number",
              style: boldHeading(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 10.0),
            child: RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                      text: "We have sent a 4 digit code to",
                      style: TextStyle(color: Colors.black)),
                  TextSpan(
                    text: '  +91 98 6766 4312',
                    style: TextStyle(color: Colors.green),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0, bottom: 5.0, left: 20.0),
            child: GFTypography(
              // color: Colors.blue,
              showDivider: false,
              child: Text(
                'Enter Verification code',
                // style: emailTextNormal(),
              ),
            ),
          ),

          // decoration: BoxDecoration(
          //   border: Border.all(
          //     color: Colors.black,
          //     width: 8,
          //   ),
          //   borderRadius: BorderRadius.circular(12),
          // ),
          Container(
            width: 800,
            child: PinEntryTextField(
              showFieldAsBox: true,
              fieldWidth: 40.0,
              onSubmit: (String pin) {
                showDialog(
                    context: context,
                    builder: (context) {
                      return Container(
                        margin: const EdgeInsets.only(
                            top: 250.0, bottom: 50.0, left: 15.0, right: 15.0),
                        // width: 130.0,
                        // height: 80.0,
                        decoration: new BoxDecoration(
                          // shape: BoxShape.rectangle,
                          color: Colors.white,
                          borderRadius:
                              new BorderRadius.all(new Radius.circular(32.0)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 50.0, bottom: 20.0),
                              child: Image.asset('lib/assets/icons/cross.png'),
                            ),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 43.0),
                                    child: Container(
                                      padding: EdgeInsets.only(),
                                      height: 80,
                                      decoration: BoxDecoration(
                                          color: Colors.black,
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(32),
                                              bottomRight:
                                                  Radius.circular(32))),
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(top: 10.0),
                                        child: Text(
                                          'Oops! Phone number verification Failed',
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 18.0,
                                            decoration: TextDecoration.none,
                                            // fontFamily: 'helvetica_neue_light',
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      );
                      // return Container(
                      //   margin: const EdgeInsets.only(
                      //       top: 250.0, bottom: 50.0, left: 15.0, right: 15.0),
                      //   // width: 130.0,
                      //   // height: 80.0,
                      //   decoration: new BoxDecoration(
                      //     // shape: BoxShape.rectangle,
                      //     color: Colors.white,
                      //     borderRadius:
                      //         new BorderRadius.all(new Radius.circular(32.0)),
                      //   ),
                      //   child: Column(
                      //     crossAxisAlignment: CrossAxisAlignment.center,
                      //     children: <Widget>[
                      //       Padding(
                      //         padding: const EdgeInsets.only(
                      //             top: 50.0, bottom: 20.0),
                      //         child: Image.asset('lib/assets/icons/Group.png'),
                      //       ),
                      //       Row(
                      //         children: <Widget>[
                      //           Expanded(
                      //             child: Padding(
                      //               padding: const EdgeInsets.only(top: 43.0),
                      //               child: Container(
                      //                 padding: EdgeInsets.only(),
                      //                 height: 80,
                      //                 decoration: BoxDecoration(
                      //                     color: Colors.black,
                      //                     borderRadius: BorderRadius.only(
                      //                         bottomLeft: Radius.circular(32),
                      //                         bottomRight:
                      //                             Radius.circular(32))),
                      //                 child: Padding(
                      //                   padding:
                      //                       const EdgeInsets.only(top: 10.0),
                      //                   child: Text(
                      //                     'Yay ! Phone number verified Successfully',
                      //                     style: TextStyle(
                      //                       color: const Color(0xFF33b17c),
                      //                       fontSize: 18.0,
                      // decoration: TextDecoration.none,
                      //                       // fontFamily: 'helvetica_neue_light',
                      //                     ),
                      //                     textAlign: TextAlign.center,
                      //                   ),
                      //                 ),
                      //               ),
                      //             ),
                      //           )
                      //         ],
                      //       )
                      //     ],
                      //   ),
                      // );
                    }); //end showDialog()
              }, // end onSubmit
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 40.0),
            child: RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                      text: "Resend OTP in",
                      style: TextStyle(color: Colors.black)),
                  TextSpan(
                    text: ' 00:52 s',
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 30.0),
            child: GFButton(
              // color: primary,
              color: GFColor.warning,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Home()),
                );
              },
              text: 'Submit OTP',
              textStyle: TextStyle(fontSize: 20.0, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
