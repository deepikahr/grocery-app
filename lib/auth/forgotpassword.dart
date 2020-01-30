import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_picker_dropdown.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/components/appbar/gf_appbar.dart';
import 'package:getflutter/components/button/gf_button.dart';
import 'package:getflutter/components/typography/gf_typography.dart';
import 'package:grocery_pro/auth/reset.dart';
import 'package:grocery_pro/style/style.dart';
import 'package:grocery_pro/verification/otp.dart';

class ForgotPassword extends StatefulWidget {
  ForgotPassword({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
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
          'Forgot Password',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: primary,
      ),
      body: Container(
        child: ListView(
          // mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding:
                  const EdgeInsets.only(top: 40.0, left: 18.0, bottom: 4.0),
              child: Text(
                "Password reset",
                style: boldHeading(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 18.0, bottom: 25.0),
              child: Text(
                  "Please enter your registered E mail or Phone number to send the reset code."),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, bottom: 5.0),
              child: GFTypography(
                // color: Colors.blue,
                showDivider: false,
                child: RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(text: "Email", style: emailTextNormal()),
                      TextSpan(
                        text: ' *',
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
              padding: const EdgeInsets.only(top: 15.0, bottom: 10.0),
              child: Text(
                'OR',
                textAlign: TextAlign.center,
                style: emailTextNormal(),
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
                      TextSpan(text: "Phone Number", style: emailTextNormal()),
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
                  keyboardType: TextInputType.number,

                  decoration: InputDecoration(
                      prefixText: '+91',
                      labelText: "+91",
                      labelStyle: labelStyle(),
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
                    MaterialPageRoute(builder: (context) => ResetPassword()),
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
