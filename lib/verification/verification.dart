import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/colors/gf_color.dart';
import 'package:getflutter/components/appbar/gf_appbar.dart';
import 'package:getflutter/components/button/gf_button.dart';
import 'package:getflutter/components/typography/gf_typography.dart';
import 'package:grocery_pro/style/style.dart';
import 'package:grocery_pro/verification/otp.dart';

class Verification extends StatefulWidget {
  Verification({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _VerificationState createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GFAppBar(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20))),
        title: Text(
          'Welcome',
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
                  const EdgeInsets.only(top: 40.0, left: 15.0, bottom: 30.0),
              child: Text(
                "Let's Get Started!",
                style: boldHeading(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, bottom: 5.0),
              child: GFTypography(
                // color: Colors.blue,
                showDivider: false,
                child: Text(
                  'Enter Mobile Number',
                  // style: emailTextNormal(),
                ),
              ),
            ),
            // Row(
            //   children: <Widget>[
            //     Expanded(
            //       // flex: 5,
            //       child: Padding(
            //         padding: const EdgeInsets.only(right: 38.0, left: 7.0),
            //         child: Container(
            //           width: 20.0,
            //           decoration: BoxDecoration(
            //               border: Border.all(
            //             color: Colors.black,
            //           )),
            //           child: CountryPickerDropdown(
            //             initialValue: 'tr',
            //             itemBuilder: _buildDropdownItem,
            //             onValuePicked: (Country country) {
            //               print("${country.name}");
            //             },
            //           ),
            //         ),
            //       ),
            //     ),
            // Expanded(
            //   flex: 5,
            Container(
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: TextFormField(
                  // initialValue: "+91",
                  // style: labelStyle(),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: "+91",
                      labelStyle: labelStyle(),
                      prefixText: '+91',
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
            //     )
            //   ],
            // ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 20.0, right: 20.0, top: 30.0),
              child: GFButton(
                // color: primary,

                color: GFColor.warning,

                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Otp()),
                  );
                },
                text: 'Continue',
                textStyle: TextStyle(fontSize: 17.0, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget _buildDropdownItem(Country country) => Container(
  //       child: Row(
  //         children: <Widget>[
  //           // CountryPickerUtils.getDefaultFlagImage(country),
  //           SizedBox(
  //             width: 8.0,
  //           ),
  //           Text("+${country.phoneCode}(${country.isoCode})"),
  //         ],
  //       ),
  //     );
}
