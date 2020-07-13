import 'package:flutter/material.dart';
import 'package:readymadeGroceryApp/service/auth-service.dart';
import 'package:readymadeGroceryApp/service/localizations.dart';
import 'package:readymadeGroceryApp/service/sentry-service.dart';
import 'package:readymadeGroceryApp/style/style.dart';
import 'package:readymadeGroceryApp/widgets/loader.dart';

SentryError sentryError = new SentryError();

class TermsAndCondition extends StatefulWidget {
  TermsAndCondition({Key key, this.locale, this.localizedValues})
      : super(key: key);
  final Map localizedValues;
  final String locale;
  @override
  _TermsAndConditionState createState() => _TermsAndConditionState();
}

class _TermsAndConditionState extends State<TermsAndCondition> {
  bool isAboutUsData = false;
  var aboutUsDatails;
  @override
  void initState() {
    getAboutUsData();
    super.initState();
  }

  getAboutUsData() {
    if (mounted) {
      setState(() {
        isAboutUsData = true;
      });
    }
    LoginService.aboutUs().then((value) {
      try {
        if (value['response_code'] == 200) {
          if (mounted) {
            setState(() {
              aboutUsDatails = value['response_data'][0];
              isAboutUsData = false;
            });
          }
        }
      } catch (error, stackTrace) {
        if (mounted) {
          setState(() {
            isAboutUsData = false;
          });
        }
        sentryError.reportError(error, stackTrace);
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          isAboutUsData = false;
        });
      }
      sentryError.reportError(error, null);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          MyLocalizations.of(context).getLocalizations("PP_AND_TAND_C"),
          style: textbarlowSemiBoldBlack(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: isAboutUsData
          ? SquareLoader()
          : ListView(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  child: Container(
                    child: Text(
                      MyLocalizations.of(context)
                          .getLocalizations("TERMS_CONDITIONS", true),
                      style: textbarlowRegularBlackd(),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: Container(
                    child: Text(
                      aboutUsDatails['termsAndConditions'],
                      style: textbarlowRegularBlackd(),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: Container(
                    child: Text(
                      MyLocalizations.of(context)
                          .getLocalizations("PRIVACY_POLICY", true),
                      style: textbarlowRegularBlackd(),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: Container(
                    child: Text(
                      aboutUsDatails['privacyPolicy'],
                      style: textbarlowRegularBlackd(),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
