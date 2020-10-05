import 'package:flutter/material.dart';
import 'package:readymadeGroceryApp/screens/tab/wallethistoryy.dart';
import 'package:readymadeGroceryApp/widgets/appBar.dart';
import 'package:readymadeGroceryApp/widgets/normalText.dart';

class WalletPage extends StatefulWidget {
  final Map localizedValues;
  final String locale;
  WalletPage({Key key, this.locale, this.localizedValues});
  @override
  _WalletPageState createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarPrimary(context, "WALLET"),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(top: 80, bottom: 40, left: 15, right: 15),
            child: walletImage(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              walletCard1(
                  context,
                  'WALLET',
                  'BALANCE',
                  '\$ 50',
                  Image.asset(
                    'lib/assets/images/walleticon.png',
                    width: 38,
                    height: 36,
                  )),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WalletHistoryyPage(
                        locale: widget.locale,
                        localizedValues: widget.localizedValues,
                      ),
                    ),
                  );
                },
                child: walletCard2(
                    context,
                    'RECENT',
                    'TRANSACTIONS',
                    'VIEW',
                    Image.asset(
                      'lib/assets/images/walleticon.png',
                      width: 38,
                      height: 36,
                    )),
              )
            ],
          )
        ],
      ),
    );
  }

}
