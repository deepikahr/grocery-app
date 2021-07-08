import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:getwidget/getwidget.dart';
import 'package:readymadeGroceryApp/widgets/appBar.dart';
import 'package:readymadeGroceryApp/widgets/normalText.dart';
import '../../service/auth-service.dart';
import '../../service/sentry-service.dart';
import '../../widgets/loader.dart';
import 'package:readymadeGroceryApp/style/style.dart';

SentryError sentryError = new SentryError();

class AboutUs extends StatefulWidget {
  AboutUs({Key? key, this.locale, this.localizedValues}) : super(key: key);

  final Map? localizedValues;
  final String? locale;

  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  bool isAboutUsData = false, isBusinessInfoData = false;
  var aboutUs, businessInfo;

  @override
  void initState() {
    getAboutUsInfo();
    getBusinesInfo();
    super.initState();
  }

  getAboutUsInfo() {
    if (mounted) {
      setState(() {
        isAboutUsData = true;
      });
    }
    LoginService.aboutUs().then((value) {
      try {
        if (mounted) {
          setState(() {
            aboutUs = value['response_data']['description'];
            isAboutUsData = false;
          });
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

  getBusinesInfo() {
    if (mounted) {
      setState(() {
        isBusinessInfoData = true;
      });
    }
    LoginService.businessInfo().then((value) {
      try {
        if (mounted) {
          setState(() {
            businessInfo = value['response_data'];
            isBusinessInfoData = false;
          });
        }
      } catch (error, stackTrace) {
        if (mounted) {
          setState(() {
            isBusinessInfoData = false;
          });
        }
        sentryError.reportError(error, stackTrace);
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          isBusinessInfoData = false;
        });
      }
      sentryError.reportError(error, null);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg(context),
      appBar: appBarTransparent(context, "ABOUT_US") as PreferredSizeWidget?,
      body: isAboutUsData || isBusinessInfoData
          ? SquareLoader()
          : ListView(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(10),
                  child: Center(
                    child: GFAvatar(
                      backgroundImage: AssetImage("lib/assets/logo.png"),
                      radius: 60,
                    ),
                  ),
                ),
                textWithValue(context, "DESCRIPTION", null),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: Html(data: aboutUs ?? ""),
                ),
                textWithValue(
                    context, "STORE", businessInfo['storeName'].toString()),
                SizedBox(height: 5),
                textWithValue(context, "LOCATION",
                    businessInfo['officeLocation'].toString()),
                SizedBox(height: 5),
                textWithValue(
                    context, "ADDRESS", businessInfo['address'].toString()),
                SizedBox(height: 5),
                textWithValue(context, "MOBILE_NUMBER",
                    businessInfo['phoneNumber'].toString()),
                SizedBox(height: 5),
                textWithValue(
                    context, "EMAIL", businessInfo['email'].toString()),
                SizedBox(height: 5),
              ],
            ),
    );
  }
}
