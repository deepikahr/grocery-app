import 'package:flutter/material.dart';
import 'package:readymadeGroceryApp/service/common.dart';
import 'package:readymadeGroceryApp/service/product-service.dart';
import 'package:readymadeGroceryApp/service/sentry-service.dart';
import 'package:readymadeGroceryApp/style/style.dart';
import 'package:readymadeGroceryApp/widgets/appBar.dart';
import 'package:readymadeGroceryApp/widgets/loader.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:readymadeGroceryApp/widgets/subscription_card.dart';
import '../../style/style.dart';
import '../../widgets/loader.dart';

SentryError sentryError = new SentryError();

class AllSubscriptionProductsListPage extends StatefulWidget {
  final Map? localizedValues;
  final String? locale;

  AllSubscriptionProductsListPage({
    Key? key,
    this.locale,
    this.localizedValues,
  });
  @override
  _AllSubscriptionProductsListPageState createState() =>
      _AllSubscriptionProductsListPageState();
}

class _AllSubscriptionProductsListPageState
    extends State<AllSubscriptionProductsListPage> {
  bool isUserLoaggedIn = false,
      isFirstPageLoading = true,
      isNextPageLoading = false;
  int? productsPerPage = 12, productsPageNumber = 0, totalProducts = 1;
  List productsList = [];
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  String? currency;
  ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        getProductsList();
      }
    });
    checkIfUserIsLoaggedIn();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void checkIfUserIsLoaggedIn() async {
    setState(() {
      isFirstPageLoading = true;
    });
    productsList = [];
    productsPageNumber = productsList.length;
    totalProducts = 1;
    await Common.getCurrency().then((value) {
      currency = value;
    });
    await Common.getToken().then((onValue) {
      if (onValue != null) {
        isUserLoaggedIn = true;
      }
      getProductsList();
    });
  }

  void getProductsList() async {
    if (totalProducts != productsList.length) {
      if (productsPageNumber! > 0) {
        setState(() {
          isNextPageLoading = true;
        });
      }
      await ProductService.getSubscriptionList(
              productsPageNumber, productsPerPage)
          .then((onValue) {
        _refreshController.refreshCompleted();
        if (onValue['response_data'] != null &&
            onValue['response_data'] != []) {
          productsList.addAll(onValue['response_data']);
          totalProducts = onValue["total"];
          productsPageNumber = productsPageNumber! + 1;
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
      appBar: appBarPrimarynoradius(context, "SUBSCRIPTION_PRODUCTS")
          as PreferredSizeWidget?,
      body: Column(
        children: [
          SizedBox(height: 10),
          // Container(
          //   padding: const EdgeInsets.only(
          //       bottom: 0.0, left: 15.0, right: 15.0, top: 15.0),
          //   child: Container(
          //     child: new TextFormField(
          //       style: new TextStyle(
          //         color: Colors.black,
          //       ),
          //       validator: (String value) {
          //         if (value.isEmpty) {
          //           return MyLocalizations.of(context)
          //               .getLocalizations("WHAT_ARE_YOU_BUING_TODAY");
          //         } else
          //           return null;
          //       },
          //       decoration: new InputDecoration(
          //         prefixIcon: new Icon(Icons.search, color: Colors.black),
          //         hintText: MyLocalizations.of(context)
          //             .getLocalizations("WHAT_ARE_YOU_BUING_TODAY"),
          //         fillColor: Color(0xFFF0F0F0),
          //         filled: true,
          //         focusColor: Colors.black,
          //         contentPadding: EdgeInsets.only(
          //             left: 15.0, right: 15.0, top: 12.0, bottom: 10.0),
          //         border: InputBorder.none,
          //       ),
          //     ),
          //   ),
          // ),
          Flexible(
            child: isFirstPageLoading
                ? Center(child: SquareLoader())
                : Container(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: SmartRefresher(
                      enablePullDown: true,
                      enablePullUp: false,
                      controller: _refreshController,
                      onRefresh: () {
                        checkIfUserIsLoaggedIn();
                      },
                      child: GridView.builder(
                        physics: ScrollPhysics(),
                        controller: _scrollController,
                        shrinkWrap: true,
                        itemCount:
                            productsList.isEmpty ? 0 : productsList.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio:
                              MediaQuery.of(context).size.width / 500,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemBuilder: (BuildContext context, int i) {
                          return SubscriptionCard(
                            currency: currency,
                            productData: productsList[i],
                          );
                        },
                      ),
                    ),
                  ),
          ),
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
}
