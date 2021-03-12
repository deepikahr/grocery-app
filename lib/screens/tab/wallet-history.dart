import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:readymadeGroceryApp/screens/orders/ordersDetails.dart';
import 'package:readymadeGroceryApp/service/auth-service.dart';
import 'package:readymadeGroceryApp/service/common.dart';
import 'package:readymadeGroceryApp/service/localizations.dart';
import 'package:readymadeGroceryApp/service/sentry-service.dart';
import 'package:readymadeGroceryApp/style/style.dart';
import 'package:readymadeGroceryApp/widgets/appBar.dart';
import 'package:readymadeGroceryApp/widgets/loader.dart';
import 'package:readymadeGroceryApp/widgets/normalText.dart';

SentryError sentryError = new SentryError();

class WalletHistoryyPage extends StatefulWidget {
  final Map localizedValues;
  final String locale;
  WalletHistoryyPage({Key key, this.locale, this.localizedValues});
  @override
  _WalletHistoryyPageState createState() => _WalletHistoryyPageState();
}

class _WalletHistoryyPageState extends State<WalletHistoryyPage> {
  bool isWalletHistory = false, lastApiCall = true;
  int walletLimit = 15, walletIndex = 0, totalWalletIndex = 1;
  List walletHistoryList = [];
  String currency = '';
  @override
  void initState() {
    if (mounted) {
      setState(() {
        isWalletHistory = true;
      });
    }
    getWalletHistory();
    super.initState();
  }

  getWalletHistory() async {
    await Common.getCurrency().then((value) {
      currency = value;
    });
    await LoginService.getWalletsHistory(walletIndex, walletLimit)
        .then((onValue) {
      if (mounted) {
        setState(() {
          if (onValue['response_data'] != []) {
            walletHistoryList.addAll(onValue['response_data']);
            totalWalletIndex = onValue["total"];
            int index = walletHistoryList.length;
            if (index != totalWalletIndex) {
              walletIndex++;
              getWalletHistory();
            }
          }
          isWalletHistory = false;
        });
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          walletHistoryList = [];
          isWalletHistory = false;
        });
      }
      sentryError.reportError(error, null);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg(context),
      appBar: appBarPrimary(context, "RECENT_TRANSACTIONS"),
      body: isWalletHistory
          ? Center(child: SquareLoader())
          : walletHistoryList.length > 0
              ? ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: walletHistoryList.length == null
                      ? 0
                      : walletHistoryList.length,
                  itemBuilder: (BuildContext context, int index) => InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OrderDetails(
                              locale: widget.locale,
                              localizedValues: widget.localizedValues,
                              orderId: walletHistoryList[index]["orderId"]),
                        ),
                      );
                    },
                    child: wallethistory(walletHistoryList[index]),
                  ),
                )
              : noDataImage(),
    );
  }

  Widget wallethistory(walletDetails) {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(color: cartCardBg(context)),
      child: Column(
        children: [
          walletTransaction1(
              context, 'ORDER_ID', '#${walletDetails['orderID']}'),
          SizedBox(height: 3),
          walletTransaction(
              context,
              'DATE',
              DateFormat('dd/MM/yyyy, hh:mm a', widget.locale ?? "en").format(
                  DateTime.parse(walletDetails['createdAt'].toString())
                      .toLocal())),
          SizedBox(height: 3),
          walletTransaction(
              context, 'TRANSACTION_TYPE', walletDetails['transactionType']),
          SizedBox(height: 3),
          textTransactionAmount(context, 'AMOUNT',
              '$currency${walletDetails['amount'].toString()}'),
          SizedBox(height: 3),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Row(
                children: [
                  Text(
                      MyLocalizations.of(context)
                          .getLocalizations('WALLET', true),
                      style: textBarlowRegularBlackdl(context)),
                  Text(
                      MyLocalizations.of(context)
                          .getLocalizations((walletDetails['isCredited']
                              ? "CREDIT"
                              : !walletDetails['isCredited']
                                  ? "DEBIT"
                                  : "")),
                      style: textBarlowRegularBlackdl(context)),
                  SizedBox(width: 5),
                  Image.asset(
                      walletDetails['isCredited']
                          ? 'lib/assets/icons/green.png'
                          : 'lib/assets/icons/red.png',
                      width: 11,
                      height: 17)
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
