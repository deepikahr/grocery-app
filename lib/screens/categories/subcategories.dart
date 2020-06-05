import 'package:flutter/material.dart';

import 'package:getflutter/getflutter.dart';
import 'package:readymadeGroceryApp/model/counterModel.dart';
import 'package:readymadeGroceryApp/screens/home/home.dart';
import 'package:readymadeGroceryApp/screens/product/product-details.dart';
import 'package:readymadeGroceryApp/service/common.dart';
import 'package:readymadeGroceryApp/service/fav-service.dart';
import 'package:readymadeGroceryApp/service/localizations.dart';
import 'package:readymadeGroceryApp/service/product-service.dart';
import 'package:readymadeGroceryApp/service/sentry-service.dart';
import 'package:readymadeGroceryApp/widgets/loader.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:readymadeGroceryApp/widgets/subCategoryProductCart.dart';
import 'package:readymadeGroceryApp/style/style.dart';

import '../../style/style.dart';

SentryError sentryError = new SentryError();

class SubCategories extends StatefulWidget {
  final String catTitle, locale, catId;
  final bool token, isSubCategoryAvailable;
  final Map localizedValues;

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

  bool isSelected = true, isSelectedIndexZero = false;
  String currency, isSelectetedId, currentSubCategoryId;
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
    await Common.getCurrency().then((value) {
      currency = value;
    });
    await ProductService.getProductToCategoryList(id).then((onValue) {
      try {
        _refreshController.refreshCompleted();

        if (onValue['response_code'] == 200) {
          if (mounted)
            setState(() {
              subProductsList = onValue['response_data']['products'];
              subCategryList = onValue['response_data']['subCategory'];
              isLoadingSubProductsList = false;
              isLoadingSubCatProductsList = false;
            });
        } else {
          if (mounted)
            setState(() {
              subProductsList = [];
              subCategryList = [];
              isLoadingSubProductsList = false;
              isLoadingSubCatProductsList = false;
            });
        }
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
    await Common.getCurrency().then((value) {
      currency = value;
    });
    await ProductService.getProductToCategoryListCartAdded(id).then((onValue) {
      try {
        _refreshController.refreshCompleted();

        if (onValue['response_code'] == 200) {
          if (mounted)
            setState(() {
              subProductsList = onValue['response_data']['products'];
              subCategryList = onValue['response_data']['subCategory'];
              isLoadingSubProductsList = false;
              isLoadingSubCatProductsList = false;
            });
        } else {
          if (mounted)
            setState(() {
              subProductsList = [];
              subCategryList = [];
              isLoadingSubProductsList = false;
              isLoadingSubCatProductsList = false;
            });
        }
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
        if (onValue['response_code'] == 200) {
          if (mounted)
            setState(() {
              subCategryByProduct = onValue['response_data'];
              isLoadingSubCatProductsList = false;
            });
        } else {
          if (mounted)
            setState(() {
              subCategryByProduct = [];
              isLoadingSubCatProductsList = false;
            });
        }
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
        if (onValue['response_code'] == 200) {
          if (mounted)
            setState(() {
              subCategryByProduct = onValue['response_data'];
              isLoadingSubCatProductsList = false;
            });
        } else {
          if (mounted)
            setState(() {
              subCategryByProduct = [];
              isLoadingSubCatProductsList = false;
            });
        }
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
        if (onValue['response_code'] == 200) {
          if (mounted) {
            setState(() {
              favProductList = onValue['response_data'];
            });
          }
        } else {
          if (mounted) {
            setState(() {
              favProductList = [];
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
          if (mounted) {
            setState(() {
              isLoadingSubProductsList = true;
            });
          }
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
                                              if (mounted) {
                                                setState(() {
                                                  isLoadingSubProductsList =
                                                      true;
                                                  isSelected = true;
                                                  isSelectedIndexZero = false;
                                                  isSelectetedId = null;
                                                });
                                              }
                                              if (widget.token == true) {
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
                                                color: isSelected
                                                    ? primary
                                                    : Color(0xFFf0F0F0),
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
                                                  isSelected = false;
                                                  isSelectedIndexZero = true;
                                                  isSelectetedId = null;
                                                });
                                              }
                                              currentSubCategoryId =
                                                  subCategryList[0]['_id']
                                                      .toString();
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
                                                color: isSelectedIndexZero
                                                    ? primary
                                                    : Color(0xFFf0F0F0),
                                                border: Border.all(
                                                  color: Color(0xFFDFDFDF),
                                                ),
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
                                              isSelected = false;
                                              isSelectedIndexZero = false;
                                              isLoadingSubCatProductsList =
                                                  true;
                                              isSelectetedId =
                                                  subCategryList[i]['_id'];
                                            });
                                          }
                                          currentSubCategoryId =
                                              subCategryList[i]['_id']
                                                  .toString();
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
                                            color: isSelectetedId ==
                                                    subCategryList[i]['_id']
                                                ? primary
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
                                                              520,
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
                                                    var result = Navigator.push(
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
                                                    result.then((value) {
                                                      if (mounted) {
                                                        setState(() {
                                                          isLoadingSubCatProductsList =
                                                              true;
                                                        });
                                                      }
                                                      getProductToSubCategoryCartAdded(
                                                          currentSubCategoryId);
                                                    });
                                                  },
                                                  child: Stack(
                                                    children: <Widget>[
                                                      SubCategoryProductCard(
                                                        image: subCategryByProduct[
                                                                        i][
                                                                    'filePath'] ==
                                                                null
                                                            ? subCategryByProduct[
                                                                i]['imageUrl']
                                                            : subCategryByProduct[
                                                                i]['filePath'],
                                                        isPath: subCategryByProduct[
                                                                        i][
                                                                    'filePath'] ==
                                                                null
                                                            ? false
                                                            : true,
                                                        title:
                                                            subCategryByProduct[
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
                                                        dealPercentage: subCategryByProduct[
                                                                    i][
                                                                'isDealAvailable']
                                                            ? double.parse(
                                                                subCategryByProduct[
                                                                            i][
                                                                        'delaPercent']
                                                                    .toStringAsFixed(
                                                                        1))
                                                            : null,
                                                        variantStock:
                                                            subCategryByProduct[
                                                                        i][
                                                                    'variant'][0]
                                                                [
                                                                'productstock'],
                                                        unit:
                                                            subCategryByProduct[
                                                                        i]
                                                                    ['variant']
                                                                [0]['unit'],
                                                        rating: subCategryByProduct[
                                                                    i][
                                                                'averageRating']
                                                            .toStringAsFixed(1),
                                                        buttonName:
                                                            MyLocalizations.of(
                                                                    context)
                                                                .add,
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
                                                        subCategoryId:
                                                            subCategryByProduct[
                                                                    i]
                                                                ['subcategory'],
                                                      ),
                                                      subCategryByProduct[i][
                                                                  'isDealAvailable'] ==
                                                              true
                                                          ? Positioned(
                                                              child: Stack(
                                                                children: <
                                                                    Widget>[
                                                                  Container(
                                                                    width: 61,
                                                                    height: 18,
                                                                    decoration: BoxDecoration(
                                                                        color: Color(
                                                                            0xFFFFAF72),
                                                                        borderRadius: BorderRadius.only(
                                                                            topLeft:
                                                                                Radius.circular(10),
                                                                            bottomRight: Radius.circular(10))),
                                                                  ),
                                                                  Text(
                                                                    " " +
                                                                        subCategryByProduct[i]['delaPercent']
                                                                            .toString() +
                                                                        "% " +
                                                                        MyLocalizations.of(context)
                                                                            .off,
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
                                                              520,
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
                                                    var result = Navigator.push(
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
                                                    result.then((value) {
                                                      if (mounted) {
                                                        setState(() {
                                                          isLoadingSubProductsList =
                                                              true;
                                                        });
                                                      }
                                                      if (widget.token ==
                                                          true) {
                                                        getProductToCategoryCartAdded(
                                                            widget.catId);
                                                        getFavListApi();
                                                      } else {
                                                        getProductToCategory(
                                                            widget.catId);
                                                      }
                                                    });
                                                  },
                                                  child: Stack(
                                                    children: <Widget>[
                                                      SubCategoryProductCard(
                                                          image: subProductsList[i]['filePath'] ==
                                                                  null
                                                              ? subProductsList[i]
                                                                  ['imageUrl']
                                                              : subProductsList[i]
                                                                  ['filePath'],
                                                          isPath:
                                                              subProductsList[i]['filePath'] ==
                                                                      null
                                                                  ? false
                                                                  : true,
                                                          title:
                                                              subProductsList[i]
                                                                  ['title'],
                                                          currency: currency,
                                                          category:
                                                              subProductsList[i]
                                                                  ['category'],
                                                          price:
                                                              subProductsList[i]
                                                                      ['variant']
                                                                  [0]['price'],
                                                          dealPercentage:
                                                              subProductsList[i]
                                                                      ['isDealAvailable']
                                                                  ? double.parse(subProductsList[i]['delaPercent'].toStringAsFixed(1))
                                                                  : null,
                                                          variantStock: subProductsList[i]['variant'][0]['productstock'],
                                                          unit: subProductsList[i]['variant'][0]['unit'],
                                                          rating: subProductsList[i]['averageRating'].toStringAsFixed(1),
                                                          buttonName: MyLocalizations.of(context).add,
                                                          cartAdded: subProductsList[i]['cartAdded'] ?? false,
                                                          cartId: subProductsList[i]['cartId'],
                                                          productQuantity: subProductsList[i]['cartAddedQuantity'] ?? 0,
                                                          token: widget.token,
                                                          productList: subProductsList[i],
                                                          variantList: subProductsList[i]['variant'],
                                                          subCategoryId: subProductsList[i]['subcategory']),
                                                      subProductsList[i][
                                                                  'isDealAvailable'] ==
                                                              true
                                                          ? Positioned(
                                                              child: Stack(
                                                                children: <
                                                                    Widget>[
                                                                  Container(
                                                                    width: 61,
                                                                    height: 18,
                                                                    decoration: BoxDecoration(
                                                                        color: Color(
                                                                            0xFFFFAF72),
                                                                        borderRadius: BorderRadius.only(
                                                                            topLeft:
                                                                                Radius.circular(10),
                                                                            bottomRight: Radius.circular(10))),
                                                                  ),
                                                                  Text(
                                                                    " " +
                                                                        subProductsList[i]['delaPercent']
                                                                            .toString() +
                                                                        "% " +
                                                                        MyLocalizations.of(context)
                                                                            .off,
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
                ],
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
                padding: EdgeInsets.only(right: 20),
                decoration: BoxDecoration(color: primary, boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.29), blurRadius: 5)
                ]),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          color: Colors.black,
                          width: MediaQuery.of(context).size.width * 0.35,
                          height: 55,
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
                        Column(
                          children: <Widget>[
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
                  ],
                ),
              ),
            ),
    );
  }
}
