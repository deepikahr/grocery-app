import 'package:flutter/material.dart';
import 'package:getflutter/components/appbar/gf_appbar.dart';
import 'package:grocery_pro/model/counterModel.dart';
import 'package:grocery_pro/screens/home/home.dart';
import 'package:grocery_pro/screens/product/product-details.dart';
import 'package:grocery_pro/screens/tab/searchitem.dart';
import 'package:grocery_pro/service/common.dart';
import 'package:grocery_pro/service/localizations.dart';
import 'package:grocery_pro/service/product-service.dart';
import 'package:grocery_pro/service/sentry-service.dart';
import 'package:grocery_pro/style/style.dart';
import 'package:grocery_pro/widgets/cardOverlay.dart';
import 'package:grocery_pro/widgets/loader.dart';
import 'package:grocery_pro/widgets/subCategoryProductCart.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  var cartData;
  @override
  void initState() {
    favProductList = widget.favProductList;
    getTokenValueMethod();
    super.initState();
  }

  getTokenValueMethod() async {
    if (mounted) {
      setState(() {
        isLoadingProductsList = true;
      });
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    currency = prefs.getString('currency');
    await Common.getToken().then((onValue) {
      try {
        if (onValue != null) {
          if (mounted) {
            setState(() {
              getTokenValue = true;
              getProductListMethodCardAdded();
            });
          }
        } else {
          if (mounted) {
            setState(() {
              getTokenValue = false;
              getProductListMethod();
            });
          }
        }
      } catch (error, stackTrace) {
        if (mounted) {
          setState(() {
            getTokenValue = false;
            getProductListMethod();
          });
        }
        sentryError.reportError(error, stackTrace);
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          getTokenValue = false;
          getProductListMethod();
        });
      }
      sentryError.reportError(error, null);
    });
  }

  getProductListMethod() async {
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
              isLoadingProductsList = false;
            });
          }
        }
      } catch (error, stackTrace) {
        if (mounted) {
          setState(() {
            productsList = [];
            isLoadingProductsList = false;
          });
        }
        sentryError.reportError(error, stackTrace);
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          productsList = [];
          isLoadingProductsList = false;
        });
      }
      sentryError.reportError(error, null);
    });
  }

  getProductListMethodCardAdded() async {
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
              isLoadingProductsList = false;
            });
          }
        }
      } catch (error, stackTrace) {
        if (mounted) {
          setState(() {
            productsList = [];
            isLoadingProductsList = false;
          });
        }
        sentryError.reportError(error, stackTrace);
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          productsList = [];
          isLoadingProductsList = false;
        });
      }
      sentryError.reportError(error, null);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (getTokenValue) {
      CounterModel().getCartDataMethod().then((res) {
        if (mounted) {
          setState(() {
            cartData = res;
          });
        }
      });
    } else {
      if (mounted) {
        setState(() {
          cartData = null;
        });
      }
    }

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
        controller: _refreshController,
        onRefresh: () {
          if (getTokenValue) {
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
                              MediaQuery.of(context).size.width / 500,
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
                                    SubCategoryProductCard(
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
                                      buttonName: "Add",
                                      cartAdded:
                                          productsList[i]['cartAdded'] ?? false,
                                      cartId: productsList[i]['cartId'],
                                      productQuantity: productsList[i]
                                              ['cartAddedQuantity'] ??
                                          0,
                                      token: widget.token,
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
                                  SubCategoryProductCard(
                                    image: productsList[i]['imageUrl'],
                                    title: productsList[i]['title'].length > 10
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
                                    buttonName: "Add",
                                    cartAdded:
                                        productsList[i]['cartAdded'] ?? false,
                                    cartId: productsList[i]['cartId'],
                                    productQuantity: productsList[i]
                                            ['cartAddedQuantity'] ??
                                        0,
                                    token: widget.token,
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
      bottomNavigationBar: cartData == null
          ? Container(
              height: 10.0,
            )
          : InkWell(
              onTap: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => Home(
                        locale: widget.locale,
                        localizedValues: widget.localizedValues,
                        languagesSelection: false,
                        currentIndex: 2,
                      ),
                    ),
                    (Route<dynamic> route) => false);
              },
              child: Container(
                height: 35.0,
                color: primary,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20.0, right: 20.0, top: 5.0, bottom: 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          new Text(
                            '${cartData['cart'].length} ' +
                                MyLocalizations.of(context).items +
                                " " +
                                " | " +
                                "$currency${cartData['grandTotal']}",
                            style: textBarlowRegularBlack(),
                          ),
                          new Text(
                            MyLocalizations.of(context).goToCart,
                            style: textbarlowBoldsmBlack(),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 6),
                  ],
                ),
              ),
            ),
    );
  }
}
