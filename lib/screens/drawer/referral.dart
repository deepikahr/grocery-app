import 'package:flutter/material.dart';
import 'package:readymadeGroceryApp/widgets/appBar.dart';
import 'package:readymadeGroceryApp/widgets/button.dart';
import 'package:readymadeGroceryApp/widgets/normalText.dart';
import '../../service/sentry-service.dart';

SentryError sentryError = new SentryError();

class ReferralPage extends StatefulWidget {
  ReferralPage({Key? key, this.locale, this.localizedValues}) : super(key: key);

  final Map? localizedValues;
  final String? locale;

  @override
  _ReferralPageState createState() => _ReferralPageState();
}

class _ReferralPageState extends State<ReferralPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBarPrimary(context, "REFER_EARN") as PreferredSizeWidget?,
      body: ListView(
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
            child: Image.asset("lib/assets/images/ref.png"),
          ),
          referText(context, "REFER_EARN"),
          SizedBox(height: 10),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 25),
            child: regularText(context,
                "REFER_US_to a friend and get \$3 credited to your wallet, Your friends will receive the same amount on signing up as well."),
          ),
          SizedBox(height: 30),
          regularTextblack87(context, "REFERRAL_CODE"),
          SizedBox(height: 8),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 100),
            child: dottedBorderButtonn(context, "12345678"),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: InkWell(
            onTap: () {
              _settingModalBottomSheet(context);
            },
            child: regularbuttonPrimary(context, "REFER", false)),
      ),
    );
  }

  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext bc) {
          return Container(
            // padding: EdgeInsets.all(20),
            height: 250.0,
            decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  new BoxShadow(
                    color: Colors.black,
                    blurRadius: 1.0,
                  ),
                ],
                borderRadius: new BorderRadius.only(
                  topLeft: Radius.circular(40.0),
                  topRight: Radius.circular(40.0),
                )),
            child: ListView(children: <Widget>[
              Container(
                height: 52,
                decoration: BoxDecoration(
                  borderRadius: new BorderRadius.only(
                    topLeft: Radius.circular(40.0),
                    topRight: Radius.circular(40.0),
                  ),
                  color: Color(0xFFF8F8F8),
                ),
                child: referText(context, "SHARE_VIA"),
              ),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Image.asset("lib/assets/images/wapp.png",
                          width: 64, height: 64),
                      SizedBox(height: 5),
                      regularText(context, "WHATSAPP"),
                    ],
                  ),
                  Column(
                    children: [
                      Image.asset("lib/assets/images/sms.png",
                          width: 64, height: 64),
                      SizedBox(height: 5),
                      regularText(context, "SMS"),
                    ],
                  ),
                  Column(
                    children: [
                      Image.asset("lib/assets/images/copylink.png",
                          width: 64, height: 64),
                      SizedBox(height: 5),
                      regularText(context, "COPY_LINK"),
                    ],
                  ),
                ],
              )
            ]),
          );
        });
  }
}
