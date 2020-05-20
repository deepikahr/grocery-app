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

  final Map<String, Map<String, String>> localizedValues;
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

  // _launchURL(location) async {
  //   if (await canLaunch(location)) {
  //     await launch(location);
  //   } else {
  //     throw 'Could not launch $location';
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          MyLocalizations.of(context).aboutUs,
          style: textbarlowSemiBoldBlack(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: isAboutUsData
          ? SquareLoader()
          : Container(
              padding: EdgeInsets.all(10),
              child: Stack(
                children: <Widget>[
                  ListView(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.all(20),
                        child: Center(
                          child: Image.network(
                            aboutUsDatails['userApp']['filePath'] == null
                                ? aboutUsDatails['userApp']['imageUrl']
                                : Constants.IMAGE_URL_PATH +
                                    "tr:dpr-auto,tr:w-500" +
                                    aboutUsDatails['userApp']['filePath'],
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 15),
                        child: Text(
                          MyLocalizations.of(context).description + ':',
                          style: textBarlowMediumBlack(),
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.all(15),
                            width: MediaQuery.of(context).size.width * 0.82,
                            child: Text(
                              aboutUsDatails['aboutUs'],
                              style: textbarlowRegularBlackd(),
                            ),
                          )
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 15, bottom: 15),
                        child: Text(
                          MyLocalizations.of(context).addressInformation + ':',
                          style: textBarlowMediumBlack(),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 15.0, right: 15.0, bottom: 15),
                        child: Text(aboutUsDatails['address']),
                      ),

                      Container(
                        margin: EdgeInsets.only(left: 15, bottom: 15),
                        child: Text(
                          MyLocalizations.of(context).contactInformation + ':',
                          style: textBarlowMediumBlack(),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          _launchURLCall(aboutUsDatails['phoneNumber']);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 15.0, right: 15.0, bottom: 15),
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.phone),
                              Text(" " + MyLocalizations.of(context).callUs,
                                  style: textbarlowRegularBlackd())
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          _launchURLEmail(aboutUsDatails['email']);
                        },
                        child: Padding(
                          padding:
                              const EdgeInsets.only(left: 15.0, bottom: 15),
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.email),
                              Text(' ' + MyLocalizations.of(context).mailUs,
                                  style: textbarlowRegularBlackd())
                            ],
                          ),
                        ),
                      ),
                      // InkWell(
                      //   onTap: () {
                      //     _launchURL(aboutUsDatails['googleUrl']);
                      //   },
                      //   child: Padding(
                      //     padding: const EdgeInsets.only(left: 15.0, bottom: 15),
                      //     child: Row(
                      //       children: <Widget>[
                      //         Icon(Icons.location_searching),
                      //         Text(' Locate Us', style: textbarlowRegularBlackd())
                      //       ],
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                  // Positioned(
                  //   bottom: 30,
                  //   left: 15,
                  //   child: InkWell(
                  //     onTap: () {
                  //       _launchURL(aboutUsDatails['tearmsAndConditionUrl']);
                  //     },
                  //     child: Text(
                  //       'Terms & Conditions',
                  //       style: textBarlowmediumLink(),
                  //     ),
                  //   ),
                  // ),
                  // Positioned(
                  //   bottom: 30,
                  //   right: 15,
                  //   child: InkWell(
                  //     onTap: () {
                  //       _launchURL(aboutUsDatails['privacyPolicyUrl']);
                  //     },
                  //     child: Text(
                  //       'Privacy policy',
                  //       style: textBarlowmediumLink(),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
    );
  }
}
