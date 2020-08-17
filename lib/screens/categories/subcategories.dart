import 'package:flutter/material.dart';
import 'package:readymadeGroceryApp/model/counterModel.dart';
import 'package:readymadeGroceryApp/screens/home/home.dart';
import 'package:readymadeGroceryApp/screens/product/product-details.dart';
import 'package:readymadeGroceryApp/service/common.dart';
import 'package:readymadeGroceryApp/service/localizations.dart';
import 'package:readymadeGroceryApp/service/product-service.dart';
import 'package:readymadeGroceryApp/service/sentry-service.dart';
import 'package:readymadeGroceryApp/widgets/appBar.dart';
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
  bool isCatProLoading = false, isLoadingSubCatProductsList = false;
  List catProductsList = [], subCategryList, subCategryByProduct = [];
  bool isSelected = true,
      isSelectedIndexZero = false,
      catLastApiCall = true,
      subCatLastApiCall = true;
  String currency, isSelectetedId, currentSubCategoryId;
  var cartData;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  int catProductLimit = 15,
      catProductIndex = 0,
      catTotalProduct = 1,
      subCatProductLimit = 15,
      subCatProductIndex = 0,
      subCatTotalProduct = 1;
  @override
  void initState() {
    if (mounted) {
      setState(() {
        isCatProLoading = true;
        subCategryByProduct = [];
        subCatProductIndex = subCategryByProduct.length;
        catProductsList = [];
        catProductIndex = catProductsList.length;
      });
    }
    getCategoryProduct(widget.catId);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  getCategoryProduct(id) async {
    await Common.getCurrency().then((value) {
      currency = value;
    });

    await ProductService.getProductToCategoryList(
            id, catProductIndex, catProductLimit)
        .then((onValue) {
      _refreshController.refreshCompleted();
      if (mounted) {
        setState(() {
          catProductsList.addAll(onValue['response_data']['products']);
          subCategryList = onValue['response_data']['subCategories'];
          catTotalProduct = onValue["total"];
          subCategryByProduct = [];
          int index = catProductsList.length;
          if (catLastApiCall == true) {
            catProductIndex++;
            if (index < catTotalProduct) {
              getCategoryProduct(id);
            } else {
              if (index == catTotalProduct) {
                if (mounted) {
                  setState(() {
                    catProductIndex++;
                    catLastApiCall = false;
                    getCategoryProduct(id);
                  });
                }
              }
            }
          }
          isCatProLoading = false;
          isLoadingSubCatProductsList = false;
        });
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          isCatProLoading = false;
          isLoadingSubCatProductsList = false;
        });
      }
      sentryError.reportError(error, null);
    });
  }

  getProductToSubCategory(catId) async {
    await ProductService.getProductToSubCategoryList(
            catId, subCatProductIndex, subCatProductLimit)
        .then((onValue) {
      if (mounted)
        setState(() {
          subCategryByProduct.addAll(onValue['response_data']);
          subCatTotalProduct = onValue["total"];
          int index = subCategryByProduct.length;
          if (subCatLastApiCall == true) {
            subCatProductIndex++;
            if (index < subCatTotalProduct) {
              getProductToSubCategory(catId);
            } else {
              if (index == subCatTotalProduct) {
                if (mounted) {
                  subCatProductIndex++;
                  subCatLastApiCall = false;
                  getProductToSubCategory(catId);
                }
              }
            }
          }
          isLoadingSubCatProductsList = false;
        });
    }).catchError((error) {
      if (mounted) {
        setState(() {
          isLoadingSubCatProductsList = false;
        });
      }
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
      appBar: appBarTransparent(context, widget.catTitle),
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: false,
        controller: _refreshController,
        onRefresh: () {
          if (mounted) {
            setState(() {
              isCatProLoading = true;
              catProductsList = [];
              catProductIndex = catProductsList.length;
              subCategryByProduct = [];
              subCatProductIndex = subCategryByProduct.length;
            });
          }
          getCategoryProduct(widget.catId);
        },
        child: isCatProLoading
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
                                              if (mounted) {
                                                setState(() {
                                                  isCatProLoading = true;
                                                  isSelected = true;
                                                  isSelectedIndexZero = false;
                                                  isSelectetedId = null;
                                                  subCategryByProduct = [];
                                                  subCatProductIndex =
                                                      subCategryByProduct
                                                          .length;
                                                  catProductsList = [];
                                                  catProductIndex =
                                                      catProductsList.length;
                                                });
                                              }
                                              getCategoryProduct(widget.catId);
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
                                                MyLocalizations.of(context)
                                                    .getLocalizations("ALL"),
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
                                                  catProductsList = [];
                                                  currentSubCategoryId =
                                                      subCategryList[0]['_id']
                                                          .toString();
                                                  getProductToSubCategory(
                                                      subCategryList[0]['_id']
                                                          .toString());
                                                });
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
                                                '${subCategryList[0]['title'][0].toUpperCase()}${subCategryList[0]['title'].substring(1)}',
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
                                              currentSubCategoryId =
                                                  subCategryList[i]['_id']
                                                      .toString();

                                              getProductToSubCategory(
                                                  subCategryList[i]['_id']
                                                      .toString());
                                            });
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
                                            '${subCategryList[i]['title'][0].toUpperCase()}${subCategryList[i]['title'].substring(1)}',
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
                      : subCategryByProduct.length > 0
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
                                                        builder: (context) =>
                                                            ProductDetails(
                                                          locale: widget.locale,
                                                          localizedValues: widget
                                                              .localizedValues,
                                                          productID:
                                                              subCategryByProduct[
                                                                  i]['_id'],
                                                        ),
                                                      ),
                                                    );
                                                    result.then((value) {
                                                      if (value != null) {
                                                        if (mounted) {
                                                          setState(() {
                                                            isLoadingSubCatProductsList =
                                                                true;
                                                            subCategryByProduct =
                                                                [];
                                                            subCatProductIndex =
                                                                subCategryByProduct
                                                                    .length;
                                                            catProductsList =
                                                                [];
                                                            catProductIndex =
                                                                catProductsList
                                                                    .length;
                                                            getProductToSubCategory(
                                                                currentSubCategoryId);
                                                          });
                                                        }
                                                      }
                                                    });
                                                  },
                                                  child: Stack(
                                                    children: <Widget>[
                                                      SubCategoryProductCard(
                                                        currency: currency,
                                                        price:
                                                            subCategryByProduct[
                                                                        i]
                                                                    ['variant']
                                                                [0]['price'],
                                                        productData:
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
                                                                        subCategryByProduct[i]['dealPercent']
                                                                            .toString() +
                                                                        "% " +
                                                                        MyLocalizations.of(context)
                                                                            .getLocalizations("OFF"),
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
                                      catProductsList.length == 0
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
                                                  catProductsList.length == null
                                                      ? 0
                                                      : catProductsList.length,
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
                                                if (catProductsList[i]
                                                        ['averageRating'] ==
                                                    null) {
                                                  catProductsList[i]
                                                      ['averageRating'] = 0;
                                                }

                                                return InkWell(
                                                  onTap: () {
                                                    var result = Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            ProductDetails(
                                                          locale: widget.locale,
                                                          localizedValues: widget
                                                              .localizedValues,
                                                          productID:
                                                              catProductsList[i]
                                                                  ['_id'],
                                                        ),
                                                      ),
                                                    );
                                                    result.then((value) {
                                                      if (value != null) {
                                                        if (mounted) {
                                                          setState(() {
                                                            isCatProLoading =
                                                                true;
                                                            subCategryByProduct =
                                                                [];
                                                            subCatProductIndex =
                                                                subCategryByProduct
                                                                    .length;
                                                            catProductsList =
                                                                [];
                                                            catProductIndex =
                                                                catProductsList
                                                                    .length;
                                                            getCategoryProduct(
                                                                widget.catId);
                                                          });
                                                        }
                                                      }
                                                    });
                                                  },
                                                  child: Stack(
                                                    children: <Widget>[
                                                      SubCategoryProductCard(
                                                        currency: currency,
                                                        price:
                                                            catProductsList[i]
                                                                    ['variant']
                                                                [0]['price'],
                                                        productData:
                                                            catProductsList[i],
                                                        variantList:
                                                            catProductsList[i]
                                                                ['variant'],
                                                      ),
                                                      catProductsList[i][
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
                                                                        catProductsList[i]['dealPercent']
                                                                            .toString() +
                                                                        "% " +
                                                                        MyLocalizations.of(context)
                                                                            .getLocalizations("OFF"),
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
                var result = Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => Home(
                      locale: widget.locale,
                      localizedValues: widget.localizedValues,
                      currentIndex: 2,
                    ),
                  ),
                );
                result.then((value) {
                  if (mounted) {
                    setState(() {
                      isCatProLoading = true;
                      subCategryByProduct = [];
                      subCatProductIndex = subCategryByProduct.length;
                      catProductsList = [];
                      catProductIndex = catProductsList.length;
                      getCategoryProduct(widget.catId);
                    });
                  }
                });
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
                                '(${cartData['products'].length})  ' +
                                    MyLocalizations.of(context)
                                        .getLocalizations("ITEMS"),
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
                                  MyLocalizations.of(context)
                                      .getLocalizations("GO_TO_CART"),
                                  style: textBarlowRegularBlack(),
                                ),
                                SizedBox(width: 4),
                                Icon(
                                  const IconData(
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
