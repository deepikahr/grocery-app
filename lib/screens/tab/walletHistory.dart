import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:readymadeGroceryApp/screens/orders/ordersDetails.dart';
import 'package:readymadeGroceryApp/service/auth-service.dart';
import 'package:readymadeGroceryApp/service/common.dart';
import 'package:readymadeGroceryApp/service/sentry-service.dart';
import 'package:readymadeGroceryApp/widgets/appBar.dart';
import 'package:readymadeGroceryApp/widgets/loader.dart';
import 'package:readymadeGroceryApp/widgets/normalText.dart';

SentryError sentryError = new SentryError();

class WalletHistory extends StatefulWidget {
  final String locale;
  final Map localizedValues;
  WalletHistory({Key key, this.locale, this.localizedValues}) : super(key: key);
  @override
  _WalletHistoryState createState() => _WalletHistoryState();
}

class _WalletHistoryState extends State<WalletHistory> {
  bool isWalletHistory = false, lastApiCall = true, isScrollLoading = true;
  int walletLimit = 15, walletIndex = 0, totalWalletIndex = 1;
  List walletHistoryList = [];
  String currency = '';
  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    if (mounted) {
      setState(() {
        isWalletHistory = true;
      });
    }
    getWalletHistory(walletIndex);
    _scrollController
      ..addListener(() {
        var triggerFetchMoreSize =
            0.9 * _scrollController.position.maxScrollExtent;
        if (_scrollController.position.pixels > triggerFetchMoreSize) {
          if (isScrollLoading == true) {
            isScrollLoading = false;
            walletIndex++;
            getWalletHistory(walletIndex);
          }
        }
      });
    super.initState();
  }

  getWalletHistory(walletIndex) async {
    await Common.getCurrency().then((value) {
      currency = value;
    });
    await LoginService.getWalletsHistory(walletIndex, walletLimit)
        .then((onValue) {
      if (mounted) {
        setState(() {
          print(onValue['response_data']);
          if (onValue['response_data'] != []) {
            walletHistoryList.addAll(onValue['response_data']);
            isScrollLoading = true;
          } else {
            isScrollLoading = false;
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
      backgroundColor: Color(0xFFFDFDFD),
      appBar: appBarPrimary(context, "WALLET_HISTORY"),
      body: isWalletHistory
          ? SquareLoader()
          : walletHistoryList.length > 0
              ? ListView(
                  controller: _scrollController,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 20, bottom: 10),
                      child: ListView.builder(
                        physics: ScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: walletHistoryList.length == null
                            ? 0
                            : walletHistoryList.length,
                        itemBuilder: (BuildContext context, int i) {
                          return walletHistoryList[i]["amount"] > 0
                              ? InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => OrderDetails(
                                          locale: widget.locale,
                                          localizedValues:
                                              widget.localizedValues,
                                          orderId: walletHistoryList[i]["_id"],
                                        ),
                                      ),
                                    );
                                  },
                                  child: walletWidget(walletHistoryList[i]),
                                )
                              : Container();
                        },
                      ),
                    ),
                    SizedBox(height: 30)
                  ],
                )
              : noDataImage(),
    );
  }

  walletWidget(walletDetails) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          walletText(context, "ORDER_ID", '#${walletDetails['orderID']}', true),
          walletText(
              context,
              "TRANSECTION_TYPE",
              (walletDetails['transactionType'] == "ORDER_PAYMENT"
                  ? "ORDER_PAYMENT"
                  : walletDetails['transactionType'] == "ORDER_CANCELLED"
                      ? "ORDER_CANCELLED"
                      : walletDetails['transactionType']),
              false),
          walletText(
              context, "ORDER_ID", '#${walletDetails['orderID']}', false),
          Divider()
        ],
      ),
    );
  }
}
