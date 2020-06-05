import 'package:flutter/material.dart';
import 'package:getflutter/components/appbar/gf_appbar.dart';
import 'package:getflutter/getflutter.dart';
import 'package:readymadeGroceryApp/model/counterModel.dart';
import 'package:readymadeGroceryApp/screens/home/home.dart';
import 'package:readymadeGroceryApp/screens/product/product-details.dart';
import 'package:readymadeGroceryApp/screens/tab/searchitem.dart';
import 'package:readymadeGroceryApp/service/common.dart';
import 'package:readymadeGroceryApp/service/localizations.dart';
import 'package:readymadeGroceryApp/service/product-service.dart';
import 'package:readymadeGroceryApp/service/sentry-service.dart';
import 'package:readymadeGroceryApp/style/style.dart';
import 'package:readymadeGroceryApp/widgets/cardOverlay.dart';
import 'package:readymadeGroceryApp/widgets/loader.dart';
import 'package:readymadeGroceryApp/widgets/subCategoryProductCart.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

SentryError sentryError = new SentryError();

class AllProducts extends StatefulWidget {
  final Map localizedValues;
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
  List productsList = [], favProductList;
  String currency;
  bool getTokenValue = false, isLoadingProductsList = false;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  ScrollController controller;
  ScrollController _scrollController = new ScrollController();
  int index = 0, totalIndex = 1;
  bool productListApiCall = false, isNewProductsLoading = false;
  var cartData;
  @override
  void initState() {
    favProductList = widget.favProductList;
    if (mounted) {
      setState(() {
        isLoadingProductsList = true;
      });
    }
    getTokenValueMethod();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (mounted) {
          setState(() {
            getTokenValueMethod();
          });
        }
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  getTokenValueMethod() async {
    await Common.getCurrency().then((value) {
      currency = value;
    });
    await Common.getToken().then((onValue) {
      try {
        if (onValue != null) {
          if (mounted) {
            setState(() {
              getTokenValue = true;
            });
          }
        } else {
          if (mounted) {
            setState(() {
              getTokenValue = false;
            });
          }
        }
      } catch (error, stackTrace) {
        if (mounted) {
          setState(() {
            getTokenValue = false;
          });
        }
        sentryError.reportError(error, stackTrace);
      }
      if (index < totalIndex) {
        if (getTokenValue) {
          getProductListMethodCardAdded(index);
        } else {
          getProductListMethod(index);
        }
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          getTokenValue = false;
        });
      }
      sentryError.reportError(error, null);
    });
  }

  getProductListMethod(productIndex) async {
    setState(() {
      isNewProductsLoading = true;
    });
    await ProductService.getProductListAll(productIndex).then((onValue) {
      try {
        _refreshController.refreshCompleted();
        if (onValue['response_code'] == 200) {
          if (mounted) {
            setState(() {
              productsList.addAll(onValue['response_data']['products']);
              index = productsList.length;
              totalIndex = onValue['response_data']["total"];
              isLoadingProductsList = false;
              isNewProductsLoading = false;
            });
          }
        } else {
          if (mounted) {
            setState(() {
              productsList = [];
              isLoadingProductsList = false;
              isNewProductsLoading = false;
            });
          }
        }
      } catch (error, stackTrace) {
        if (mounted) {
          setState(() {
            productsList = [];
            isLoadingProductsList = false;
            isNewProductsLoading = false;
          });
        }
        sentryError.reportError(error, stackTrace);
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          productsList = [];
          isLoadingProductsList = false;
          isNewProductsLoading = false;
        });
      }
      sentryError.reportError(error, null);
    });
  }

  getProductListMethodCardAdded(productIndex) async {
    setState(() {
      isNewProductsLoading = true;
    });
    await ProductService.getProductListAllCartAdded(productIndex)
        .then((onValue) {
      try {
        _refreshController.refreshCompleted();
        if (onValue['response_code'] == 200) {
          if (mounted) {
            setState(() {
              productsList.addAll(onValue['response_data']['products']);
              index = productsList.length;
              totalIndex = onValue['response_data']["total"];
              isLoadingProductsList = false;
              isNewProductsLoading = false;
            });
          }
        } else {
          if (mounted) {
            setState(() {
              productsList = [];
              isLoadingProductsList = false;
              isNewProductsLoading = false;
            });
          }
        }
      } catch (error, stackTrace) {
        if (mounted) {
          setState(() {
            productsList = [];
            isLoadingProductsList = false;
            isNewProductsLoading = false;
          });
        }
        sentryError.reportError(error, stackTrace);
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          productsList = [];
          isLoadingProductsList = false;
          isNewProductsLoading = false;
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
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          MyLocalizations.of(context).products,
          style: textbarlowSemiBoldBlack(),
        ),
        centerTitle: true,
        actions: <Widget>[
          InkWell(
            onTap: () {
              var result = Navigator.push(
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
              result.then((value) {
                if (mounted) {
                  setState(() {
                    isLoadingProductsList = true;
                  });
                }
                getTokenValueMethod();
              });
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
          if (index < totalIndex) {
            productsList = [];
            index = productsList.length;

            if (getTokenValue) {
              getProductListMethodCardAdded(index);
            } else {
              getProductListMethod(index);
            }
          }
        },
        child: isLoadingProductsList
            ? SquareLoader()
            : Container(
                margin: EdgeInsets.only(left: 15, right: 15, top: 15),
                child: ListView(
                  controller: _scrollController,
                  children: <Widget>[
                    GridView.builder(
                      padding: EdgeInsets.only(bottom: 25),
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      itemCount:
                          productsList.length == null ? 0 : productsList.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio:
                              MediaQuery.of(context).size.width / 520,
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
                                  var result = Navigator.push(
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
                                  result.then((value) {
                                    if (mounted) {
                                      setState(() {
                                        isLoadingProductsList = true;
                                      });
                                    }
                                    index = 0;
                                    totalIndex = 1;
                                    productsList = [];
                                    getTokenValueMethod();
                                  });
                                },
                                child: Stack(
                                  children: <Widget>[
                                    SubCategoryProductCard(
                                        image: productsList[i]['filePath'] == null
                                            ? productsList[i]['imageUrl']
                                            : productsList[i]['filePath'],
                                        isPath:
                                            productsList[i]['filePath'] == null
                                                ? false
                                                : true,
                                        title: productsList[i]['title'],
                                        currency: currency,
                                        category: productsList[i]['category'],
                                        price: productsList[i]['variant'][0]
                                            ['price'],
                                        dealPercentage: productsList[i]
                                                ['isDealAvailable']
                                            ? double.parse(productsList[i]
                                                    ['delaPercent']
                                                .toStringAsFixed(1))
                                            : null,
                                        variantStock: productsList[i]['variant']
                                            [0]['productstock'],
                                        unit: productsList[i]['variant'][0]
                                            ['unit'],
                                        rating: productsList[i]['averageRating']
                                            .toStringAsFixed(1),
                                        buttonName: "Add",
                                        cartAdded:
                                            productsList[i]['cartAdded'] ?? false,
                                        cartId: productsList[i]['cartId'],
                                        productQuantity: productsList[i]['cartAddedQuantity'] ?? 0,
                                        token: widget.token,
                                        productList: productsList[i],
                                        variantList: productsList[i]['variant'],
                                        subCategoryId: productsList[i]['subcategory']),
                                    productsList[i]['isDealAvailable'] == true
                                        ? Positioned(
                                            child: Stack(
                                              children: <Widget>[
                                                Container(
                                                  width: 61,
                                                  height: 18,
                                                  decoration: BoxDecoration(
                                                      color: Color(0xFFFFAF72),
                                                      borderRadius:
                                                          BorderRadius.only(
                                                              topLeft: Radius
                                                                  .circular(10),
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          10))),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(2.0),
                                                  child: Text(
                                                    " " +
                                                        productsList[i]
                                                                ['delaPercent']
                                                            .toString() +
                                                        "% " +
                                                        MyLocalizations.of(
                                                                context)
                                                            .off,
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
                                      image: productsList[i]['filePath'] == null
                                          ? productsList[i]['imageUrl']
                                          : productsList[i]['filePath'],
                                      isPath: productsList[i]['filePath'] == null
                                          ? false
                                          : true,
                                      title: productsList[i]['title'],
                                      currency: currency,
                                      category: productsList[i]['category'],
                                      price: productsList[i]['variant'][0]
                                          ['price'],
                                      dealPercentage: productsList[i]
                                              ['isDealAvailable']
                                          ? double.parse(productsList[i]
                                                  ['delaPercent']
                                              .toStringAsFixed(1))
                                          : null,
                                      unit: productsList[i]['variant'][0]
                                          ['unit'],
                                      rating: productsList[i]['averageRating']
                                          .toStringAsFixed(1),
                                      buttonName:
                                          MyLocalizations.of(context).add,
                                      cartAdded:
                                          productsList[i]['cartAdded'] ?? false,
                                      cartId: productsList[i]['cartId'],
                                      productQuantity: productsList[i]
                                              ['cartAddedQuantity'] ??
                                          0,
                                      token: widget.token,
                                      productList: productsList[i],
                                      variantList: productsList[i]['variant'],
                                      subCategoryId: productsList[i]
                                          ['subcategory']),
                                  CardOverlay()
                                ],
                              );
                      },
                    ),
                    isNewProductsLoading ? SquareLoader() : Container()
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => Home(
                      locale: widget.locale,
                      localizedValues: widget.localizedValues,
                      currentIndex: 2,
                    ),
                  ),
                );
              },
              child: Container(
                height: 55.0,
                decoration: BoxDecoration(color: primary, boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.29), blurRadius: 5)
                ]),
                padding: EdgeInsets.only(right: 20),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          color: Colors.black,
                          height: 55,
                          width: MediaQuery.of(context).size.width * 0.35,
                          child: Column(
                            children: <Widget>[
                              SizedBox(height: 7),
                              new Text(
                                '(${cartData['cart'].length})  ' +
                                    MyLocalizations.of(context).items,
                                style: textBarlowRegularWhite(),
                              ),
                              new Text(
                                "$currency${cartData['subTotal'].toStringAsFixed(2)}",
                                style: textbarlowBoldWhite(),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            new Text(
                              MyLocalizations.of(context).goToCart,
                              style: textBarlowRegularBlack(),
                            ),
                            SizedBox(width: 4),
                            Icon(
                              IconData(
                                0xe911,
                                fontFamily: 'icomoon',
                              ),
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
