import 'package:flutter/material.dart';

import 'package:getflutter/getflutter.dart';
import 'package:grocery_pro/model/counterModel.dart';
import 'package:grocery_pro/screens/home/home.dart';
import 'package:grocery_pro/screens/product/product-details.dart';
import 'package:grocery_pro/service/fav-service.dart';
import 'package:grocery_pro/service/localizations.dart';
import 'package:grocery_pro/service/product-service.dart';
import 'package:grocery_pro/service/sentry-service.dart';
import 'package:grocery_pro/widgets/loader.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:grocery_pro/widgets/subCategoryProductCart.dart';
import 'package:grocery_pro/style/style.dart';

import '../../style/style.dart';

SentryError sentryError = new SentryError();

class SubCategories extends StatefulWidget {
  final String catTitle, locale, catId;
  final bool token, isSubCategoryAvailable;
  final Map<String, Map<String, String>> localizedValues;

  SubCategories(
      {Key key,
      this.catId,
      this.catTitle,
      this.locale,
      this.localizedValues,
      this.isSubCategoryAvailable,
      this.token})
      : super(key: key);
  @override
  _SubCategoriesState createState() => _SubCategoriesState();
}

class _SubCategoriesState extends State<SubCategories> {
  bool isLoadingSubProductsList = false, isLoadingSubCatProductsList = false;
  List subProductsList, favProductList, subCategryList, subCategryByProduct;
  bool isColorChange = false;
  String currency;
  var cartData;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    if (mounted) {
      setState(() {
        isLoadingSubProductsList = true;
      });
    }
    if (widget.token == true) {
      getProductToCategoryCartAdded(widget.catId);
      getFavListApi();
    } else {
      getProductToCategory(widget.catId);
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  getProductToCategory(id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    currency = prefs.getString('currency');
    await ProductService.getProductToCategoryList(id).then((onValue) {
      try {
        if (mounted)
          setState(() {
            subProductsList = onValue['response_data']['products'];
            subCategryList = onValue['response_data']['subCategory'];
            isLoadingSubProductsList = false;
            isLoadingSubCatProductsList = false;
            _refreshController.refreshCompleted();
          });
      } catch (error, stackTrace) {
        if (mounted) {
          setState(() {
            isLoadingSubProductsList = false;
            isLoadingSubCatProductsList = false;
          });
        }
        sentryError.reportError(error, stackTrace);
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          isLoadingSubProductsList = false;
          isLoadingSubCatProductsList = false;
        });
      }
      sentryError.reportError(error, null);
    });
  }

  getProductToCategoryCartAdded(id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    currency = prefs.getString('currency');
    await ProductService.getProductToCategoryListCartAdded(id).then((onValue) {
      try {
        if (mounted)
          setState(() {
            subProductsList = onValue['response_data']['products'];
            subCategryList = onValue['response_data']['subCategory'];

            isLoadingSubProductsList = false;
            isLoadingSubCatProductsList = false;
          });
      } catch (error, stackTrace) {
        if (mounted) {
          setState(() {
            isLoadingSubProductsList = false;
            isLoadingSubCatProductsList = false;
          });
        }
        sentryError.reportError(error, stackTrace);
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          isLoadingSubProductsList = false;
          isLoadingSubCatProductsList = false;
        });
      }
      sentryError.reportError(error, null);
    });
  }

  getProductToSubCategory(catId) async {
    await ProductService.getProductToSubCategoryList(catId).then((onValue) {
      try {
        if (mounted)
          setState(() {
            subCategryByProduct = onValue['response_data'];
            isLoadingSubCatProductsList = false;
          });
      } catch (error, stackTrace) {
        if (mounted) {
          setState(() {
            isLoadingSubCatProductsList = false;
          });
        }
        sentryError.reportError(error, stackTrace);
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          isLoadingSubCatProductsList = false;
        });
      }
      sentryError.reportError(error, null);
    });
  }

  getProductToSubCategoryCartAdded(catId) async {
    await ProductService.getProductToSubCategoryListCartAdded(catId)
        .then((onValue) {
      try {
        if (mounted)
          setState(() {
            subCategryByProduct = onValue['response_data'];

            isLoadingSubCatProductsList = false;
          });
      } catch (error, stackTrace) {
        if (mounted) {
          setState(() {
            isLoadingSubCatProductsList = false;
          });
        }
        sentryError.reportError(error, stackTrace);
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          isLoadingSubCatProductsList = false;
        });
      }
      sentryError.reportError(error, null);
    });
  }

  getFavListApi() async {
    await FavouriteService.getFavList().then((onValue) {
      try {
        if (mounted) {
          setState(() {
            favProductList = onValue['response_data'];
          });
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
    if (widget.token) {
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
      appBar: GFAppBar(
        title: Text(
          '${widget.catTitle}',
          style: TextStyle(
              color: Colors.black, fontSize: 17.0, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black, size: 1.0),
      ),
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: false,
        controller: _refreshController,
        onRefresh: () {
          if (widget.token) {
            getProductToCategoryCartAdded(widget.catId);
          } else {
            getProductToCategory(widget.catId);
          }
        },
        child: isLoadingSubProductsList
            ? SquareLoader()
            : ListView(
                children: <Widget>[
                  subCategryList.length > 0
                      ? Container(
                          height: 70,
                          child: Container(
                            margin: EdgeInsets.only(left: 20, right: 20),
                            height: 35,
                            child: ListView.builder(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 16),
                              physics: ScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemCount: subCategryList.length == null
                                  ? 0
                                  : subCategryList.length,
                              itemBuilder: (BuildContext context, int i) {
                                if (subCategryList[i]['isSelected'] == null) {
                                  subCategryList[i]['isSelected'] = false;
                                }
                                return i == 0
                                    ? Row(
                                        children: <Widget>[
                                          InkWell(
                                            onTap: () {
                                              subCategryByProduct = null;
                                              if (widget.token == true) {
                                                if (mounted) {
                                                  setState(() {
                                                    isLoadingSubCatProductsList =
                                                        true;
                                                  });
                                                }
                                                getProductToCategoryCartAdded(
                                                    widget.catId);
                                              } else {
                                                getProductToCategory(
                                                    widget.catId);
                                              }
                                            },
                                            child: Container(
                                              height: 35,
                                              padding: EdgeInsets.only(
                                                  left: 25, right: 25, top: 8),
                                              margin:
                                                  EdgeInsets.only(right: 15),
                                              decoration: BoxDecoration(
                                                color: Color(0xFFFFCF2D),
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(4),
                                                ),
                                              ),
                                              child: Text(
                                                'All',
                                                textAlign: TextAlign.center,
                                                style: textbarlowMediumBlackm(),
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              if (mounted) {
                                                setState(() {
                                                  isLoadingSubCatProductsList =
                                                      true;
                                                });
                                              }
                                              if (widget.token == true) {
                                                getProductToSubCategoryCartAdded(
                                                    subCategryList[0]['_id']
                                                        .toString());
                                              } else {
                                                getProductToSubCategory(
                                                    subCategryList[0]['_id']
                                                        .toString());
                                              }
                                            },
                                            child: Container(
                                              height: 35,
                                              padding: EdgeInsets.only(
                                                  left: 15, right: 15, top: 8),
                                              margin:
                                                  EdgeInsets.only(right: 15),
                                              decoration: BoxDecoration(
                                                color: Color(0xFFf0F0F0),
                                                border: Border.all(
                                                    color: Color(0xFFDFDFDF)),
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(4),
                                                ),
                                              ),
                                              child: Text(
                                                subCategryList[0]['title'],
                                                textAlign: TextAlign.center,
                                                style: textbarlowMediumBlackm(),
                                              ),
                                            ),
                                          )
                                        ],
                                      )
                                    : InkWell(
                                        onTap: () {
                                          if (mounted) {
                                            setState(() {
                                              isLoadingSubCatProductsList =
                                                  true;
                                            });
                                          }
                                          for (int j = 0;
                                              j < subCategryList.length;
                                              j++) {
                                            if (subCategryList[j]['_id'] ==
                                                subCategryList[i]['_id']) {
                                              if (mounted) {
                                                setState(() {
                                                  subCategryList[i]
                                                      ['isSelected'] = true;
                                                });
                                              }
                                            } else {
                                              if (mounted) {
                                                setState(() {
                                                  subCategryList[i]
                                                      ['isSelected'] = false;
                                                });
                                              }
                                            }
                                          }
                                          if (widget.token == true) {
                                            getProductToSubCategoryCartAdded(
                                                subCategryList[i]['_id']
                                                    .toString());
                                          } else {
                                            getProductToSubCategory(
                                                subCategryList[i]['_id']
                                                    .toString());
                                          }
                                        },
                                        child: Container(
                                          height: 35,
                                          padding: EdgeInsets.only(
                                              left: 15, right: 15, top: 8),
                                          margin: EdgeInsets.only(right: 15),
                                          decoration: BoxDecoration(
                                            color: !subCategryList[i]
                                                    ['isSelected']
                                                ? Color(0xFFFFCF2D)
                                                : Color(0xFFf0F0F0),
                                            border: Border.all(
                                                color: Color(0xFFDFDFDF)),
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(4),
                                            ),
                                          ),
                                          child: Text(
                                            subCategryList[i]['title'],
                                            textAlign: TextAlign.center,
                                            style: textbarlowMediumBlackm(),
                                          ),
                                        ),
                                      );
                              },
                            ),
                          ),
                        )
                      : Container(),
                  isLoadingSubCatProductsList
                      ? SquareLoader()
                      : subCategryByProduct != null
                          ? Container(
                              height: MediaQuery.of(context).size.height - 201,
                              child: ListView(
                                children: <Widget>[
                                  Stack(
                                    children: <Widget>[
                                      subCategryByProduct.length == 0
                                          ? Center(
                                              child: Image.asset(
                                                  'lib/assets/images/no-orders.png'),
                                            )
                                          : GridView.builder(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 16, vertical: 16),
                                              physics: ScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount: subCategryByProduct
                                                          .length ==
                                                      null
                                                  ? 0
                                                  : subCategryByProduct.length,
                                              gridDelegate:
                                                  SliverGridDelegateWithFixedCrossAxisCount(
                                                      crossAxisCount: 2,
                                                      childAspectRatio:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              500,
                                                      crossAxisSpacing: 16,
                                                      mainAxisSpacing: 16),
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int i) {
                                                if (subCategryByProduct[i]
                                                        ['averageRating'] ==
                                                    null) {
                                                  subCategryByProduct[i]
                                                      ['averageRating'] = 0;
                                                }

                                                return InkWell(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) => ProductDetails(
                                                            locale:
                                                                widget.locale,
                                                            localizedValues: widget
                                                                .localizedValues,
                                                            productID:
                                                                subCategryByProduct[
                                                                    i]['_id'],
                                                            favProductList: widget
                                                                    .token
                                                                ? favProductList
                                                                : null),
                                                      ),
                                                    );
                                                  },
                                                  child: Stack(
                                                    children: <Widget>[
                                                      SubCategoryProductCard(
                                                        image:
                                                            subCategryByProduct[
                                                                i]['imageUrl'],
                                                        title: subCategryByProduct[
                                                                            i][
                                                                        'title']
                                                                    .length >
                                                                10
                                                            ? subCategryByProduct[
                                                                            i][
                                                                        'title']
                                                                    .substring(
                                                                        0, 10) +
                                                                ".."
                                                            : subCategryByProduct[
                                                                i]['title'],
                                                        currency: currency,
                                                        category:
                                                            subCategryByProduct[
                                                                i]['category'],
                                                        price:
                                                            subCategryByProduct[
                                                                        i]
                                                                    ['variant']
                                                                [0]['price'],
                                                        rating: subCategryByProduct[
                                                                    i][
                                                                'averageRating']
                                                            .toString(),
                                                        buttonName: "Add",
                                                        cartAdded:
                                                            subCategryByProduct[
                                                                        i][
                                                                    'cartAdded'] ??
                                                                false,
                                                        cartId:
                                                            subCategryByProduct[
                                                                i]['cartId'],
                                                        productQuantity:
                                                            subCategryByProduct[
                                                                        i][
                                                                    'cartAddedQuantity'] ??
                                                                0,
                                                        token: widget.token,
                                                        productList:
                                                            subCategryByProduct[
                                                                i],
                                                        variantList:
                                                            subCategryByProduct[
                                                                i]['variant'],
                                                      ),
                                                      subCategryByProduct[i][
                                                                  'isDealAvailable'] ==
                                                              true
                                                          ? Positioned(
                                                              child: Stack(
                                                                children: <
                                                                    Widget>[
                                                                  Image.asset(
                                                                      'lib/assets/images/badge.png'),
                                                                  Text(
                                                                    " " +
                                                                        subCategryByProduct[i]['delaPercent']
                                                                            .toString() +
                                                                        "% Off",
                                                                    style:
                                                                        hintSfboldwhitemed(),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                  )
                                                                ],
                                                              ),
                                                            )
                                                          : Container()
                                                    ],
                                                  ),
                                                );
                                              },
                                            ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          : Container(
                              height: MediaQuery.of(context).size.height - 201,
                              child: ListView(
                                children: <Widget>[
                                  Stack(
                                    children: <Widget>[
                                      subProductsList.length == 0
                                          ? Center(
                                              child: Image.asset(
                                                  'lib/assets/images/no-orders.png'),
                                            )
                                          : GridView.builder(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 16, vertical: 16),
                                              physics: ScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount:
                                                  subProductsList.length == null
                                                      ? 0
                                                      : subProductsList.length,
                                              gridDelegate:
                                                  SliverGridDelegateWithFixedCrossAxisCount(
                                                      crossAxisCount: 2,
                                                      childAspectRatio:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              500,
                                                      crossAxisSpacing: 16,
                                                      mainAxisSpacing: 16),
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int i) {
                                                if (subProductsList[i]
                                                        ['averageRating'] ==
                                                    null) {
                                                  subProductsList[i]
                                                      ['averageRating'] = 0;
                                                }

                                                return InkWell(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) => ProductDetails(
                                                            locale:
                                                                widget.locale,
                                                            localizedValues: widget
                                                                .localizedValues,
                                                            productID:
                                                                subProductsList[
                                                                    i]['_id'],
                                                            favProductList: widget
                                                                    .token
                                                                ? favProductList
                                                                : null),
                                                      ),
                                                    );
                                                  },
                                                  child: Stack(
                                                    children: <Widget>[
                                                      SubCategoryProductCard(
                                                        image:
                                                            subProductsList[i]
                                                                ['imageUrl'],
                                                        title: subProductsList[
                                                                            i][
                                                                        'title']
                                                                    .length >
                                                                10
                                                            ? subProductsList[i]
                                                                        [
                                                                        'title']
                                                                    .substring(
                                                                        0, 10) +
                                                                ".."
                                                            : subProductsList[i]
                                                                ['title'],
                                                        currency: currency,
                                                        category:
                                                            subProductsList[i]
                                                                ['category'],
                                                        price:
                                                            subProductsList[i]
                                                                    ['variant']
                                                                [0]['price'],
                                                        rating: subProductsList[
                                                                    i][
                                                                'averageRating']
                                                            .toString(),
                                                        buttonName: "Add",
                                                        cartAdded: subProductsList[
                                                                    i]
                                                                ['cartAdded'] ??
                                                            false,
                                                        cartId:
                                                            subProductsList[i]
                                                                ['cartId'],
                                                        productQuantity:
                                                            subProductsList[i][
                                                                    'cartAddedQuantity'] ??
                                                                0,
                                                        token: widget.token,
                                                        productList:
                                                            subProductsList[i],
                                                        variantList:
                                                            subProductsList[i]
                                                                ['variant'],
                                                      ),
                                                      subProductsList[i][
                                                                  'isDealAvailable'] ==
                                                              true
                                                          ? Positioned(
                                                              child: Stack(
                                                                children: <
                                                                    Widget>[
                                                                  Image.asset(
                                                                      'lib/assets/images/badge.png'),
                                                                  Text(
                                                                    " " +
                                                                        subProductsList[i]['delaPercent']
                                                                            .toString() +
                                                                        "% Off",
                                                                    style:
                                                                        hintSfboldwhitemed(),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                  )
                                                                ],
                                                              ),
                                                            )
                                                          : Container()
                                                    ],
                                                  ),
                                                );
                                              },
                                            ),
                                    ],
                                  ),
                                ],
                              ),
                            )
//
                ],
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
