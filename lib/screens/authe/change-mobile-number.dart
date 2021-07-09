import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:readymadeGroceryApp/screens/authe/change-mobile-otp-verify.dart';
import 'package:readymadeGroceryApp/service/localizations.dart';
import 'package:readymadeGroceryApp/service/otp-service.dart';
import 'package:readymadeGroceryApp/service/sentry-service.dart';
import 'package:readymadeGroceryApp/style/style.dart';
import 'package:readymadeGroceryApp/widgets/appBar.dart';
import 'package:readymadeGroceryApp/widgets/button.dart';
import 'package:readymadeGroceryApp/widgets/normalText.dart';

SentryError sentryError = new SentryError();

class ChangeMobileNumber extends StatefulWidget {
  final String? locale;
  final Map? localizedValues;
  ChangeMobileNumber({Key? key, this.localizedValues, this.locale})
      : super(key: key);

  @override
  _ChangeMobileNumberState createState() => _ChangeMobileNumberState();
}

class _ChangeMobileNumberState extends State<ChangeMobileNumber> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String? mobileNumber;
  bool isUpdateMobileNumberLoading = false;

  updateMobileNumber() async {
    final form = _formKey.currentState!;
    if (form.validate()) {
      form.save();
      if (mounted) {
        setState(() {
          isUpdateMobileNumberLoading = true;
        });
      }
      Map<String, dynamic> body = {"mobileNumber": mobileNumber};
      await OtpService.changeMobileNumber(body).then((onValue) {
        if (mounted) {
          setState(() {
            isUpdateMobileNumberLoading = false;
          });
        }
        showDialog<Null>(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            return new AlertDialog(
              content: new SingleChildScrollView(
                child: new ListBody(
                  children: <Widget>[
                    new Text(onValue['response_data'],
                        style: textBarlowRegularBlack(context)),
                  ],
                ),
              ),
              actions: <Widget>[
                GFButton(
                  color: Colors.transparent,
                  child: new Text(
                      MyLocalizations.of(context)!.getLocalizations("OK"),
                      style: textbarlowRegularaprimary(context)),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) =>
                            ChangeMobileNumberOtpVerify(
                                locale: widget.locale,
                                localizedValues: widget.localizedValues,
                                mobileNumber: mobileNumber,
                                sId: onValue['sId']),
                      ),
                    );
                  },
                ),
              ],
            );
          },
        );
      }).catchError((error) {
        if (mounted) {
          setState(() {
            isUpdateMobileNumberLoading = false;
          });
        }
        sentryError.reportError(error, null);
      });
    } else {
      if (mounted) {
        setState(() {
          isUpdateMobileNumberLoading = false;
        });
      }
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg(context),
      key: _scaffoldKey,
      appBar: appBarPrimary(context, "CHANGE_MOBILE_NUMBER")
          as PreferredSizeWidget?,
      body: Form(
        key: _formKey,
        child: Container(
          child: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child:
                    buildGFTypography(context, "NEW_MOBILE_NUMBER", true, true),
              ),
              Container(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 20.0, right: 20.0, bottom: 20.0),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      errorBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 0, color: Color(0xFFF44242))),
                      errorStyle: TextStyle(color: Color(0xFFF44242)),
                      contentPadding: EdgeInsets.all(10),
                      enabledBorder: const OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.grey, width: 0.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: primary(context))),
                    ),
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return MyLocalizations.of(context)!
                            .getLocalizations("ENTER_YOUR_NEW_MOBILE_NUMBER");
                      } else
                        return null;
                    },
                    onSaved: (String? value) {
                      mobileNumber = value;
                    },
                  ),
                ),
              ),
              InkWell(
                onTap: updateMobileNumber,
                child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: buttonprimary(
                        context, "SUBMIT", isUpdateMobileNumberLoading)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showSnackbar(message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(milliseconds: 3000),
      ),
    );
  }
}
