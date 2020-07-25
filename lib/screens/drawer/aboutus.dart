import 'package:flutter/material.dart';
import 'package:readymadeGroceryApp/service/auth-service.dart';
import 'package:readymadeGroceryApp/service/constants.dart';
import 'package:readymadeGroceryApp/service/localizations.dart';
import 'package:readymadeGroceryApp/service/sentry-service.dart';
import 'package:readymadeGroceryApp/style/style.dart';
import 'package:readymadeGroceryApp/widgets/loader.dart';
import 'package:url_launcher/url_launcher.dart';

SentryError sentryError = new SentryError();

class AboutUs extends StatefulWidget {
  AboutUs({Key key, this.locale, this.localizedValues}) : super(key: key);

  final Map localizedValues;
  final String locale;
  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  bool isAboutUsData = false;
  var aboutUsDatails;
  @override
  void initState() {
    getAboutUsData();
    super.initState();
  }

  getAboutUsData() async {
    if (mounted) {
      setState(() {
        isAboutUsData = true;
      });
    }
    await LoginService.aboutUs().then((value) {
      try {
        if (value['response_code'] == 200) {
          if (mounted) {
            setState(() {
              aboutUsDatails = value['response_data'];
              isAboutUsData = false;
            });
          }
        }
      } catch (error, stackTrace) {
        if (mounted) {
          setState(() {
            aboutUsDatails = null;
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

  _launchURLEmail(email) async {
    final Uri params = Uri(
      scheme: 'mailto',
      path: email,
    );
    String url = params.toString();
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _launchURLCall(int phone) async {
    if (await canLaunch("tel:$phone")) {
      await launch("tel:$phone");
    } else {
      throw 'Could not launch $phone';
    }
  }

  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          MyLocalizations.of(context).getLocalizations("ABOUT_US"),
          style: textbarlowSemiBoldBlack(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: isAboutUsData
          ? SquareLoader()
          : aboutUsDatails == null
              ? Center(
                  child: Image.asset('lib/assets/images/no-orders.png'),
                )
              : Container(
                  padding: EdgeInsets.all(10),
                  child: Stack(
                    children: <Widget>[
                      ListView(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.all(20),
                            child: Center(
                              child: Image.asset("lib/assets/logo.png",
                                  height: 200),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 15, right: 15.0),
                            child: Text(
                              MyLocalizations.of(context)
                                  .getLocalizations("DESCRIPTION", true),
                              style: textBarlowMediumBlack(),
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.all(15),
                                width: MediaQuery.of(context).size.width * 0.82,
                                child: Text(
                                  aboutUsDatails['aboutUs'] ?? "",
                                  style: textbarlowRegularBlackd(),
                                ),
                              )
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                left: 15, bottom: 15, right: 15.0),
                            child: Text(
                              MyLocalizations.of(context)
                                  .getLocalizations("ADDRESS", true),
                              style: textBarlowMediumBlack(),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 15.0, right: 15.0, bottom: 15),
                            child: Text(aboutUsDatails['address'] ?? ""),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                left: 15, bottom: 15, right: 15.0),
                            child: Text(
                              MyLocalizations.of(context)
                                  .getLocalizations("CONTACT_INFO", true),
                              style: textBarlowMediumBlack(),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              _launchURLCall(
                                  aboutUsDatails['phoneNumber'] ?? "");
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 15.0, right: 15.0, bottom: 15),
                              child: Row(
                                children: <Widget>[
                                  Icon(Icons.phone),
                                  Text(
                                      " " +
                                          MyLocalizations.of(context)
                                              .getLocalizations("CALL_US"),
                                      style: textbarlowRegularBlackd())
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              _launchURLEmail(aboutUsDatails['email'] ?? "");
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 15.0, bottom: 15, right: 15.0),
                              child: Row(
                                children: <Widget>[
                                  Icon(Icons.email),
                                  Text(
                                      ' ' +
                                          MyLocalizations.of(context)
                                              .getLocalizations("MAIL_US"),
                                      style: textbarlowRegularBlackd())
                                ],
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              TermsAndConditionAboutUs(
                                                  locale: widget.locale,
                                                  localizedValues:
                                                      widget.localizedValues,
                                                  title: MyLocalizations.of(
                                                          context)
                                                      .getLocalizations(
                                                          "TERMS_CONDITIONS"),
                                                  text: aboutUsDatails[
                                                      'termsAndConditions'])));
                                },
                                child: Text(
                                  MyLocalizations.of(context)
                                      .getLocalizations("TERMS_CONDITIONS"),
                                  style: textBarlowmediumLink(),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (BuildContext context) =>
                                  //             TermsAndConditionAboutUs(
                                  //                 locale: widget.locale,
                                  //                 localizedValues:
                                  //                     widget.localizedValues,
                                  //                 title: MyLocalizations.of(
                                  //                         context)
                                  //                     .getLocalizations(
                                  //                         "PRIVACY_POLICY"),
                                  //                 text: aboutUsDatails[
                                  //                     'privacyPolicy'])));
                                  _launchURL(Constants.apiUrl);
                                },
                                child: Text(
                                  MyLocalizations.of(context)
                                      .getLocalizations("PRIVACY_POLICY"),
                                  style: textBarlowmediumLink(),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
    );
  }
}

class TermsAndConditionAboutUs extends StatelessWidget {
  TermsAndConditionAboutUs(
      {Key key, this.locale, this.localizedValues, this.text, this.title})
      : super(key: key);
  final Map localizedValues;
  final String locale, title, text;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          title,
          style: textbarlowSemiBoldBlack(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Container(
            margin: EdgeInsets.all(15),
            width: MediaQuery.of(context).size.width * 0.82,
            child: Text(
              text,
              style: textbarlowRegularBlackd(),
            ),
          ),
        ),
      ),
    );
  }
}
