import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
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
  final Map? localizedValues;
  final String? locale;
  WalletHistoryyPage({Key? key, this.locale, this.localizedValues});
  @override
  _WalletHistoryyPageState createState() => _WalletHistoryyPageState();
}

class _WalletHistoryyPageState extends State<WalletHistoryyPage> {
  bool isFirstPageLoading = true, isNextPageLoading = false;
  int? walletPerPage = 12, walletsPageNumber = 0, totalWallet = 1;
  List walletHistoryList = [];
  String currency = '';
  ScrollController _scrollController = ScrollController();
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        getwalletHistoryList();
      }
    });
    checkIfUserIsLoaggedIn();
    super.initState();
  }

  void checkIfUserIsLoaggedIn() async {
    setState(() {
      isFirstPageLoading = true;
    });
    walletHistoryList = [];
    walletsPageNumber = walletHistoryList.length;
    totalWallet = 1;
    await Common.getCurrency().then((value) {
      currency = value;
    });
    getwalletHistoryList();
  }

  void getwalletHistoryList() async {
    if (totalWallet != walletHistoryList.length) {
      if (walletsPageNumber! > 0) {
        setState(() {
          isNextPageLoading = true;
        });
      }
      await LoginService.getWalletsHistory(walletsPageNumber, walletPerPage)
          .then((onValue) {
        _refreshController.refreshCompleted();
        if (onValue['response_data'] != null &&
            onValue['response_data'] != []) {
          walletHistoryList.addAll(onValue['response_data']);
          totalWallet = onValue["total"];
          walletsPageNumber = walletsPageNumber! + 1;
        }
        if (mounted) {
          setState(() {
            isFirstPageLoading = false;
            isNextPageLoading = false;
          });
        }
      }).catchError((error) {
        if (mounted) {
          setState(() {
            isFirstPageLoading = false;
            isNextPageLoading = false;
          });
        }
        sentryError.reportError(error, null);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg(context),
      appBar:
          appBarPrimary(context, "RECENT_TRANSACTIONS") as PreferredSizeWidget?,
      body: Column(
        children: <Widget>[
          Flexible(
              child: isFirstPageLoading
                  ? Center(child: SquareLoader())
                  : walletHistoryList.length > 0
                      ? Container(
                          padding: EdgeInsets.only(left: 5, right: 5),
                          child: SmartRefresher(
                            enablePullDown: true,
                            enablePullUp: false,
                            controller: _refreshController,
                            onRefresh: () {
                              checkIfUserIsLoaggedIn();
                            },
                            child: ListView.builder(
                              physics: ScrollPhysics(),
                              shrinkWrap: true,
                              controller: _scrollController,
                              itemCount: walletHistoryList.isEmpty
                                  ? 0
                                  : walletHistoryList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return InkWell(
                                  onTap: () {
                                    if (walletHistoryList[index]
                                            ['transactionType'] !=
                                        "WALLET_TOPUP") {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => OrderDetails(
                                              locale: widget.locale,
                                              localizedValues:
                                                  widget.localizedValues,
                                              orderId: walletHistoryList[index]
                                                  ["orderId"]),
                                        ),
                                      );
                                    }
                                  },
                                  child:
                                      wallethistory(walletHistoryList[index]),
                                );
                              },
                            ),
                          ),
                        )
                      : noDataImage()),
          isNextPageLoading
              ? Container(
                  padding: EdgeInsets.only(top: 30, bottom: 20),
                  child: SquareLoader(),
                )
              : Container()
        ],
      ),
    );
  }

  Widget wallethistory(walletDetails) {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(color: cartCardBg(context)),
      child: Column(
        children: [
          walletDetails['transactionType'] == "WALLET_TOPUP"
              ? Container()
              : walletTransaction1(
                  context, 'ORDER_ID', '#${walletDetails['orderID'] ?? ""}'),
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
                      MyLocalizations.of(context)!
                          .getLocalizations('WALLET', true),
                      style: textBarlowRegularBlackdl(context)),
                  Text(
                      MyLocalizations.of(context)!
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
