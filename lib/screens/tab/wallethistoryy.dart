import 'package:flutter/material.dart';
import 'package:readymadeGroceryApp/service/localizations.dart';
import 'package:readymadeGroceryApp/style/style.dart';
import 'package:readymadeGroceryApp/widgets/appBar.dart';
import 'package:readymadeGroceryApp/widgets/normalText.dart';

class WalletHistoryyPage extends StatefulWidget {
  final Map localizedValues;
  final String locale;
  WalletHistoryyPage({Key key, this.locale, this.localizedValues});
  @override
  _WalletHistoryyPageState createState() => _WalletHistoryyPageState();
}

class _WalletHistoryyPageState extends State<WalletHistoryyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBarPrimary(context, "RECENT_TRANSACTIONS"),
      body: ListView(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            margin: EdgeInsets.only(top: 15),
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: 3,
                itemBuilder: (BuildContext context, int index) =>
                    InkWell(child: wallethistory())),
          ),
        ],
      ),
    );
  }

  Widget wallethistory() {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(color: Color(0xFFF7F7F7)),
      child: Column(
        children: [
          walletTransaction1(context, 'ORDER_ID', '12345'),
          SizedBox(height: 3),
          walletTransaction(context, 'DATE', '10/12/2020'),
          SizedBox(height: 3),
          walletTransaction(context, 'TRANSACTION_TYPE', 'Order Cancelled'),
          SizedBox(height: 3),
          textTransactionAmount(context, 'AMOUNT', '\$5'),
          SizedBox(height: 3),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Row(
                children: [
                  Text(
                    MyLocalizations.of(context).getLocalizations('WALLET') +
                        ' : ',
                    style: textBarlowRegularBlackdl(),
                  ),
                  Text(
                    MyLocalizations.of(context).getLocalizations('credit'),
                    style: textBarlowRegularBlackdl(),
                  ),
                  SizedBox(width: 5),
                  // on credit
                  Image.asset(
                    'lib/assets/icons/green.png',
                    width: 11,
                    height: 17,
                  ),

                  // on debit
                  Image.asset(
                    'lib/assets/icons/red.png',
                    width: 11,
                    height: 17,
                  )
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
