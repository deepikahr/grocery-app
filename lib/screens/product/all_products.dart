import 'package:flutter/material.dart';
import 'package:getflutter/components/appbar/gf_appbar.dart';
import 'package:grocery_pro/screens/product/product-details.dart';
import 'package:grocery_pro/screens/tab/searchitem.dart';
import 'package:grocery_pro/service/localizations.dart';
import 'package:grocery_pro/service/product-service.dart';
import 'package:grocery_pro/service/sentry-service.dart';
import 'package:grocery_pro/style/style.dart';
import 'package:grocery_pro/widgets/cardOverlay.dart';
import 'package:grocery_pro/widgets/loader.dart';
import 'package:grocery_pro/widgets/productCard.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

SentryError sentryError = new SentryError();

class AllProducts extends StatefulWidget {
  final Map<String, Map<String, String>> localizedValues;
  final String locale, currency;
  final bool token;
  final List productsList, favProductList;

  AllProducts(
      {Key key,
      this.locale,
      this.localizedValues,
      this.favProductList,
      this.productsList,
      this.currency,
      this.token});
  @override
  _AllProductsState createState() => _AllProductsState();
}

class _AllProductsState extends State<AllProducts> {
  List productsList, favProductList;
  String currency;
  bool getTokenValue = false, isLoadingProductsList = false;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  ScrollController controller;
  @override
  void initState() {
    favProductList = widget.favProductList;
    currency = widget.currency;
    getTokenValue = widget.token;
    getProductListMethod();
    if (getTokenValue == true) {
      getProductListMethodCardAdded();
    } else {
      getProductListMethod();
    }
    super.initState();
  }

  getProductListMethod() async {
    if (mounted) {
      setState(() {
        isLoadingProductsList = true;
      });
    }
    await ProductService.getProductListAll().then((onValue) {
      try {
        _refreshController.refreshCompleted();
        if (onValue['response_code'] == 200) {
          if (mounted) {
            setState(() {
              productsList = onValue['response_data'];
              isLoadingProductsList = false;
            });
          }
        } else {
          if (mounted) {
            setState(() {
              productsList = [];
            });
          }
        }
      } catch (error, stackTrace) {
        sentryError.reportError(error, stackTrace);
      }
    }).catchError((error) {
      sentryError.reportError(error, null);
    });
  }

  getProductListMethodCardAdded() async {
    if (mounted) {
      setState(() {
        isLoadingProductsList = true;
      });
    }
    await ProductService.getProductListAllCartAdded().then((onValue) {
      try {
        _refreshController.refreshCompleted();
        if (onValue['response_code'] == 200) {
          if (mounted) {
            setState(() {
              productsList = onValue['response_data'];
              isLoadingProductsList = false;
            });
          }
        } else {
          if (mounted) {
            setState(() {
              productsList = [];
            });
          }
        }
      } catch (error, stackTrace) {
        sentryError.reportError(error, stackTrace);
      }
    }).catchError((error) {
      sentryError.reportError(error, null);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      appBar: GFAppBar(
        backgroundColor: bg,
        elevation: 0,
        title: Text(
          MyLocalizations.of(context).products,
          style: textbarlowSemiBoldBlack(),
        ),
        centerTitle: true,
        actions: <Widget>[
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SearchItem(
                      locale: widget.locale,
                      localizedValues: widget.localizedValues,
                      productsList: productsList,
                      currency: currency,
                      token: getTokenValue,
                      favProductList: getTokenValue ? favProductList : null),
                ),
              );
            },
            child: Padding(
              padding: EdgeInsets.only(right: 15, left: 15),
              child: Icon(
                Icons.search,
              ),
            ),
          ),
        ],
      ),
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: false,
        header: WaterDropHeader(),
        controller: _refreshController,
        onRefresh: () {
          if (widget.token == true) {
            getProductListMethodCardAdded();
          } else {
            getProductListMethod();
          }
        },
        child: isLoadingProductsList
            ? SquareLoader()
            : Container(
                margin: EdgeInsets.only(left: 15, right: 15, top: 15),
                child: ListView(
                  children: <Widget>[
//                    Row(
//                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                      children: <Widget>[
//                        Text(
//                          'Suggested for you',
//                          style: textBarlowMediumBlack(),
//                        ),
//                        Row(
//                          children: <Widget>[
//                            Image.asset(
//                              'lib/assets/icons/filter.png',
//                              width: 20,
//                            ),
//                            SizedBox(
//                              width: 5,
//                            ),
//                            Text(
//                              'Filters',
//                              style: textBarlowMediumBlack(),
//                            )
//                          ],
//                        ),
//                      ],
//                    ),
//                    Divider(
//                      color: Colors.black.withOpacity(0.20),
//                      thickness: 1,
//                    ),
                    GridView.builder(
                      padding: EdgeInsets.only(bottom: 25),
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      itemCount:
                          productsList.length == null ? 0 : productsList.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio:
                              MediaQuery.of(context).size.width / 400,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16),
                      itemBuilder: (BuildContext context, int i) {
                        if (productsList[i]['averageRating'] == null) {
                          productsList[i]['averageRating'] = 0;
                        }

                        return productsList[i]['outOfStock'] != null ||
                                productsList[i]['outOfStock'] != false
                            ? InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProductDetails(
                                          locale: widget.locale,
                                          localizedValues:
                                              widget.localizedValues,
                                          productID: productsList[i]['_id'],
                                          favProductList: getTokenValue
                                              ? favProductList
                                              : null),
                                    ),
                                  );
                                },
                                child: Stack(
                                  children: <Widget>[
                                    ProductCard(
                                      image: productsList[i]['imageUrl'],
                                      title:
                                          productsList[i]['title'].length > 10
                                              ? productsList[i]['title']
                                                      .substring(0, 10) +
                                                  ".."
                                              : productsList[i]['title'],
                                      currency: currency,
                                      category: productsList[i]['category'],
                                      price: productsList[i]['variant'][0]
                                          ['price'],
                                      rating: productsList[i]['averageRating']
                                          .toString(),
                                      buttonName:
                                          productsList[i]['cartAdded'] == true
                                              ? "Added"
                                              : "Add",
                                      token: getTokenValue,
                                      productList: productsList[i],
                                      variantList: productsList[i]['variant'],
                                    ),
                                    productsList[i]['isDealAvailable'] == true
                                        ? Positioned(
                                            child: Stack(
                                              children: <Widget>[
                                                Image.asset(
                                                    'lib/assets/images/badge.png'),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(2.0),
                                                  child: Text(
                                                    " " +
                                                        productsList[i]
                                                                ['delaPercent']
                                                            .toString() +
                                                        "% Off",
                                                    style: hintSfboldwhitemed(),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                )
                                              ],
                                            ),
                                          )
                                        : Container()
                                  ],
                                ),
                              )
                            : Stack(
                                children: <Widget>[
                                  ProductCard(
                                    image: productsList[i]['imageUrl'],
                                    title: productsList[i]['title'],
                                    currency: currency,
                                    category: productsList[i]['category'],
                                    price: productsList[i]['variant'][0]
                                        ['price'],
                                    rating: productsList[i]['averageRating']
                                        .toString(),
                                    buttonName:
                                        productsList[i]['cartAdded'] == true
                                            ? "Added"
                                            : "Add",
                                    token: getTokenValue,
                                    productList: productsList[i],
                                    variantList: productsList[i]['variant'],
                                  ),
                                  CardOverlay()
                                ],
                              );
                      },
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
