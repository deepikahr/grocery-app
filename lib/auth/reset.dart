import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_picker_dropdown.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/components/appbar/gf_appbar.dart';
import 'package:getflutter/components/button/gf_button.dart';
import 'package:getflutter/components/typography/gf_typography.dart';
import 'package:grocery_pro/screens/home.dart';
import 'package:grocery_pro/style/style.dart';
import 'package:grocery_pro/verification/otp.dart';
import 'package:pin_entry_text_field/pin_entry_text_field.dart';

class ResetPassword extends StatefulWidget {
  ResetPassword({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GFAppBar(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20))),
        title: Text(
          'Password reset',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: primary,
        automaticallyImplyLeading: false,
      ),
      body: Container(
        child: ListView(
          // mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 20.0, bottom: 5.0),
              child: GFTypography(
                // color: Colors.blue,
                showDivider: false,
                child: Padding(
                  padding: const EdgeInsets.only(top: 20.0, bottom: 2.0),
                  child: RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                            text: "Enter new password",
                            style: emailTextNormal()),
                        TextSpan(
                          text: ' ',
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 20.0, right: 20.0, bottom: 20.0),
                child: TextFormField(
                  // initialValue: "user@demo.com",
                  // style: labelStyle(),
                  keyboardType: TextInputType.emailAddress,

                  decoration: InputDecoration(

                      // labelText: "yourEmail",
                      // labelStyle: labelStyle(),
                      contentPadding: EdgeInsets.all(10),
                      enabledBorder: const OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.grey, width: 0.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: primary),
                      )),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, bottom: 5.0),
              child: GFTypography(
                // color: Colors.blue,
                showDivider: false,
                child: RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                          text: "Re enter new password",
                          style: emailTextNormal()),
                      TextSpan(
                        text: ' ',
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: TextFormField(
                  // initialValue: "user@demo.com",
                  // style: labelStyle(),
                  keyboardType: TextInputType.emailAddress,

                  decoration: InputDecoration(

                      // labelText: "yourEmail",
                      // labelStyle: labelStyle(),
                      contentPadding: EdgeInsets.all(10),
                      enabledBorder: const OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.grey, width: 0.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: primary),
                      )),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5.0, left: 20.0, bottom: 5.0),
              child: GFTypography(
                // color: Colors.blue,
                showDivider: false,
                child: RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                          text: "Enter Reset code", style: emailTextNormal()),
                      TextSpan(
                        text: ' ',
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            PinEntryTextField(
              showFieldAsBox: true,
              fieldWidth: 30.0,
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
                              child: Image.asset('lib/assets/icons/Group.png'),
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
                                          'Yay ! Password Reset Successfully',
                                          style: TextStyle(
                                            color: const Color(0xFF33b17c),
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
                    }); //end showDialog()
              }, // end onSubmit
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 20.0, right: 20.0, top: 30.0),
              child: GFButton(
                // color: primary,

                color: GFColor.warning,
                size: GFSize.large,
                blockButton: true,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Home()),
                  );
                },
                text: 'Submit',
                textStyle: TextStyle(fontSize: 17.0, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownItem(Country country) => Container(
        child: Row(
          children: <Widget>[
            // CountryPickerUtils.getDefaultFlagImage(country),
            SizedBox(
              width: 8.0,
            ),
            Text("+${country.phoneCode}(${country.isoCode})"),
          ],
        ),
      );
}
