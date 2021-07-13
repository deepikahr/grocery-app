import 'package:flutter/material.dart';
import 'package:readymadeGroceryApp/screens/tab/wallet-history.dart';
import 'package:readymadeGroceryApp/service/auth-service.dart';
import 'package:readymadeGroceryApp/service/common.dart';
import 'package:readymadeGroceryApp/service/sentry-service.dart';
import 'package:readymadeGroceryApp/widgets/appBar.dart';
import 'package:readymadeGroceryApp/widgets/button.dart';
import 'package:readymadeGroceryApp/widgets/loader.dart';
import 'package:readymadeGroceryApp/widgets/normalText.dart';

import 'addmoney.dart';

SentryError sentryError = new SentryError();

class WalletPage extends StatefulWidget {
  final Map? localizedValues;
  final String? locale;
  WalletPage({Key? key, this.locale, this.localizedValues});
  @override
  _WalletPageState createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  bool isGetWalletInfoLoading = false;
  Map? userInfo;
  String currency = "";
  @override
  void initState() {
    userInfoMethod();
    super.initState();
  }

  userInfoMethod() async {
    if (mounted) {
      setState(() {
        isGetWalletInfoLoading = true;
      });
    }
    await Common.getCurrency().then((value) {
      currency = value;
    });
    await LoginService.getUserInfo().then((onValue) {
      if (mounted) {
        setState(() {
          userInfo = onValue['response_data'];
          Common.setUserID(userInfo!['_id']);
          isGetWalletInfoLoading = false;
        });
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          isGetWalletInfoLoading = false;
        });
      }
      sentryError.reportError(error, null);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarPrimarynoradius(context, "WALLET") as PreferredSizeWidget?,
      body: isGetWalletInfoLoading
          ? Center(child: SquareLoader())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin:
                      EdgeInsets.only(top: 80, bottom: 40, left: 15, right: 15),
                  child: walletImage(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    walletCard1(context, 'WALLET', 'BALANCE',
                        '$currency ${userInfo!['walletAmount'] ?? 0}'),
                    InkWell(
                      onTap: () {
                        var result = Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WalletHistoryyPage(
                                locale: widget.locale,
                                localizedValues: widget.localizedValues),
                          ),
                        );
                        result.then((value) => userInfoMethod());
                      },
                      child: walletCard2(
                          context, 'RECENT', 'TRANSACTIONS', "VIEW"),
                    )
                  ],
                )
              ],
            ),
      bottomNavigationBar: isGetWalletInfoLoading
          ? Container(height: 1)
          : Container(
              height: 80.0,
              color: Colors.transparent,
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 14),
              child: Column(
                children: [
                  InkWell(
                      onTap: () {
                        var result = Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddMoney(
                                locale: widget.locale,
                                localizedValues: widget.localizedValues),
                          ),
                        );
                        result.then((value) => userInfoMethod());
                      },
                      child: regularbuttonPrimary(context, "ADD_MONEY", false)),
                  SizedBox(height: 4),
                ],
              ),
            ),
    );
  }
}
