import 'package:flutter/material.dart';
import 'package:readymadeGroceryApp/service/sentry-service.dart';
import 'package:readymadeGroceryApp/style/style.dart';
import 'package:readymadeGroceryApp/widgets/appBar.dart';
import 'package:readymadeGroceryApp/widgets/button.dart';
import 'package:readymadeGroceryApp/widgets/normalText.dart';

SentryError sentryError = new SentryError();

class AddMoney extends StatefulWidget {
  final Map localizedValues;
  final String locale;
  AddMoney({Key key, this.locale, this.localizedValues});
  @override
  _AddMoneyState createState() => _AddMoneyState();
}

class _AddMoneyState extends State<AddMoney> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarPrimarynoradius(context, "ADD_MONEY"),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 14),
        child: ListView(
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            buildLabelText(),
            buildTextField(),
            buildcardLabelText(),
            buildcardTextField(),
            buildCardnameLabelText(),
            buildcardnameTextField(),
            buildexpireTextField()
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 80.0,
        color: Colors.transparent,
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 14),
        child: Column(
          children: [
            InkWell(
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => Thankyou()),
                  // );
                },
                child: regularbuttonPrimary(context, "ADD_MONEY")),
            SizedBox(height: 4),
          ],
        ),
      ),
    );
  }

  Widget buildLabelText() {
    return buildGFTypography(context, "AMOUNT", false, false);
  }

  Widget buildcardLabelText() {
    return buildGFTypography(context, "CARD_NUMBER", false, false);
  }

  Widget buildCardnameLabelText() {
    return buildGFTypography(context, "CARD_HOLDERS_NAME", false, false);
  }

  Widget buildexpireLabelText() {
    return buildGFTypography(context, "EXPIRING_ON", false, false);
  }

  Widget buildCvvText() {
    return buildGFTypography(context, "CVV", false, false);
  }

  Widget buildTextField() {
    return Container(
      margin: EdgeInsets.only(top: 5.0, bottom: 10.0),
      child: TextFormField(
        style: textBarlowRegularBlack(),
        keyboardType: TextInputType.text,
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
          prefixIcon: Padding(
            padding: const EdgeInsets.only(top: 15.0, bottom: 15, left: 12),
            child: Text(
              '\$:',
              style: textbarlowmediumwblack(),
            ),
          ),
          hintText: "00.00",
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

  Widget buildcardTextField() {
    return Container(
      margin: EdgeInsets.only(top: 5.0, bottom: 10.0),
      child: TextFormField(
        style: textBarlowRegularBlack(),
        keyboardType: TextInputType.text,
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

  Widget buildcardnameTextField() {
    return Container(
      margin: EdgeInsets.only(top: 5.0, bottom: 10.0),
      child: TextFormField(
        style: textBarlowRegularBlack(),
        keyboardType: TextInputType.text,
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

  Widget buildexpireTextField() {
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              buildexpireLabelText(),
              Container(
                margin: EdgeInsets.only(top: 5.0, bottom: 10.0),
                child: TextFormField(
                  style: textBarlowRegularBlack(),
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 0,
                        color: Color(0xFFF44242),
                      ),
                    ),
                    errorStyle: TextStyle(color: Color(0xFFF44242)),
                    fillColor: Colors.black,
                    hintText: "MM/YYYY",
                    focusColor: Colors.black,
                    contentPadding: EdgeInsets.only(
                      left: 15.0,
                      right: 15.0,
                      top: 10.0,
                      bottom: 10.0,
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.grey, width: 0.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: primary),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 15),
        Expanded(
          child: Column(
            children: [
              buildCvvText(),
              Container(
                margin: EdgeInsets.only(top: 5.0, bottom: 10.0),
                child: TextFormField(
                  style: textBarlowRegularBlack(),
                  keyboardType: TextInputType.text,
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
                    enabledBorder: const OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.grey, width: 0.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: primary),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
