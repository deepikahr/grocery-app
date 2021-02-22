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
  Widget build(BuildContext context) => Scaffold(
        appBar: appBarPrimarynoradius(context, "ADD_MONEY"),
        body: Container(
          margin: EdgeInsets.symmetric(horizontal: 14),
          child: ListView(
            shrinkWrap: true,
            children: [
              SizedBox(
                height: 40,
              ),
              buildImageView(),
              buildAddMoneyTextDescription(),
              buildLabelText(),
              buildTextField(),
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

  Widget buildLabelText() {
    return buildGFTypography(context, "AMOUNT", false, false);
  }

  Widget buildTextField() {
    return Container(
      margin: EdgeInsets.only(top: 5.0, bottom: 10.0),
      child: TextFormField(
        style: textBarlowRegularBlack(context),
        keyboardType: TextInputType.number,
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
              style: textbarlowmediumwblack(context),
            ),
          ),
          hintText: "00.00",
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

  buildImageView() => Image.asset(
        'lib/assets/images/addMoney.png',
        height: 300,
      );

  buildAddMoneyTextDescription() => Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Text(
          "PLEASE_ENTER_THE_AMOUNT_YOU_WANT_TO_ADD",
          style: textBarlowRegularBlack(context),
          textAlign: TextAlign.center,
        ),
      );
}
