import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/components/carousel/gf_carousel.dart';
import 'package:getflutter/components/image/gf_image_overlay.dart';
import 'package:readymadeGroceryApp/screens/categories/allcategories.dart';
import 'package:readymadeGroceryApp/screens/categories/subcategories.dart';
import 'package:readymadeGroceryApp/screens/product/all_deals.dart';
import 'package:readymadeGroceryApp/screens/product/all_products.dart';
import 'package:readymadeGroceryApp/screens/product/product-details.dart';
import 'package:readymadeGroceryApp/service/auth-service.dart';
import 'package:readymadeGroceryApp/service/common.dart';
import 'package:readymadeGroceryApp/service/constants.dart';
import 'package:readymadeGroceryApp/service/localizations.dart';
import 'package:readymadeGroceryApp/service/product-service.dart';
import 'package:readymadeGroceryApp/service/sentry-service.dart';
import 'package:readymadeGroceryApp/style/style.dart';
import 'package:readymadeGroceryApp/widgets/loader.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:readymadeGroceryApp/widgets/categoryBlock.dart';
import 'package:readymadeGroceryApp/widgets/productCard.dart';
import 'package:readymadeGroceryApp/widgets/cardOverlay.dart';

SentryError sentryError = new SentryError();

class Store extends StatefulWidget {
  final Map<String, Map<String, String>> localizedValues;
  final String locale, currentLocation;
  Store({Key key, this.currentLocation, this.locale, this.localizedValues})
      : super(key: key);
  @override
  _StoreState createState() => _StoreState();
}

class _StoreState extends State<Store> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKeydrawer =
      new GlobalKey<ScaffoldState>();

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  bool getTokenValue = true,
      isLocationLoading = false,
      isBannerLoading = false,
      isLoadingAllData = false;
  List categoryList,
      productsList,
      searchProductList,
      dealList,
      topDealList,
      favProductList,
      bannerList;
  String currency;
  final List<String> assetImg = [
    'lib/assets/images/product.png',
  ];

  TabController tabController;

  var addressData;
  String locale;
  @override
  void initState() {
    getToken();
    getBanner();
    getAllData();

    super.initState();
    tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    currency = prefs.getString('currency');
    locale = prefs.getString('selectedLanguage') ?? 'en';
    await Common.getToken().then((onValue) {
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
    }).catchError((error) {
      sentryError.reportError(error, null);
    });
  }

  getBanner() async {
    if (mounted) {
      setState(() {
        isBannerLoading = true;
      });
    }
    Common.getBanner().then((value) {
      if (value == null || value['response_data'] == null) {
        if (mounted) {
          setState(() {
            getBannerData();
          });
        }
      } else {
        if (mounted) {
          setState(() {
            isBannerLoading = false;
            bannerList = value['response_data']['banners'];
            getBannerData();
          });
        }
      }
    });
  }

  getBannerData() async {
    await LoginService.getBanner().then((onValue) {
      try {
        _refreshController.refreshCompleted();
        if (mounted) {
          setState(() {
            bannerList = onValue['response_data']['banners'];
            isBannerLoading = false;
          });
        }
      } catch (error, stackTrace) {
        sentryError.reportError(error, stackTrace);
      }
    }).catchError((error) {
      sentryError.reportError(error, null);
    });
  }

  getAllData() async {
    if (mounted) {
      setState(() {
        isLoadingAllData = true;
      });
    }
    Common.getAllData().then((value) {
      if (value == null || value['response_data'] == null) {
        if (mounted) {
          setState(() {
            getAllDataMethod();
          });
        }
      } else {
        if (mounted) {
          setState(() {
            isLoadingAllData = false;
            categoryList = value['response_data']['categories'];
            productsList = value['response_data']['products'];
            topDealList = value['response_data']['topDeals'];
            dealList = value['response_data']['dealsOfDay'];

            getAllDataMethod();
          });
        }
      }
    });
  }

  getAllDataMethod() async {
    await ProductService.getProdCatDealTopDeal().then((onValue) {
      try {
        _refreshController.refreshCompleted();
        if (onValue['response_code'] == 200) {
          if (mounted) {
            setState(() {
              categoryList = onValue['response_data']['categories'];
              productsList = onValue['response_data']['products'];
              topDealList = onValue['response_data']['topDeals'];
              dealList = onValue['response_data']['dealsOfDay'];
              isLoadingAllData = false;
            });
          }
        } else {
          if (mounted) {
            setState(() {
              categoryList = [];
              productsList = [];
              dealList = [];
              topDealList = [];
              isLoadingAllData = false;
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

  categoryRow() {
    return categoryList.length > 0
        ? Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    MyLocalizations.of(context).explorebyCategories,
                    style: textBarlowMediumBlack(),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AllCategories(
                            locale: widget.locale,
                            localizedValues: widget.localizedValues,
                            getTokenValue: getTokenValue,
                          ),
                        ),
                      );
                    },
                    child: Text(
                      MyLocalizations.of(context).viewAll,
                      style: textBarlowMediumPrimary(),
                    ),
                  )
                ],
              ),
              SizedBox(height: 20),
              SizedBox(
                height: 100,
                child: ListView.builder(
                  physics: ScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount:
                      categoryList.length != null ? categoryList.length : 0,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SubCategories(
                                locale: widget.locale,
                                localizedValues: widget.localizedValues,
                                catId: categoryList[index]['_id'],
                                isSubCategoryAvailable: categoryList[index]
                                        ['isSubCategoryAvailable'] ??
                                    false,
                                catTitle:
                                    '${categoryList[index]['title'][0].toUpperCase()}${categoryList[index]['title'].substring(1)}',
                                token: getTokenValue),
                          ),
                        );
                      },
                      child: CategoryBlock(
                        image: categoryList[index]['filePath'] == null
                            ? categoryList[index]['imageUrl']
                            : categoryList[index]['filePath'],
                        title: categoryList[index]['title'],
                        isPath: categoryList[index]['filePath'] == null
                            ? false
                            : true,
                      ),
                    );
                  },
                ),
              ),
            ],
          )
        : Center(
            child: Image.asset('lib/assets/images/no-orders.png'),
          );
  }

  banner() {
    return GFCarousel(
      autoPlay: true,
      pagination: true,
      viewportFraction: 1.0,
      activeIndicator: Colors.transparent,
      height: 150,
      aspectRatio: 2,
      items: bannerList.map((url) {
        return InkWell(
          onTap: () {
            if (url['bannerType'] == "Product") {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetails(
                      locale: widget.locale,
                      localizedValues: widget.localizedValues,
                      productID: url['product'],
                      favProductList: getTokenValue ? favProductList : null),
                ),
              );
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SubCategories(
                      locale: widget.locale,
                      localizedValues: widget.localizedValues,
                      catId: url['category'],
                      catTitle:
                          '${url['title'][0].toUpperCase()}${url['title'].substring(1)}',
                      token: getTokenValue),
                ),
              );
            }
          },
          child: Stack(
            children: <Widget>[
              Container(
                height: 130,
                color: bg,
              ),
              Container(
                height: 115,
                margin: EdgeInsets.only(top: 10),
                padding: EdgeInsets.only(top: 5, left: 20, right: 20),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: primary,
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                        right: locale == 'ar' ? 0 : 100,
                        left: locale == 'ar' ? 100 : 0,
                      ),
                      child: Text(
                        url['title'],
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: textbarlowBoldwhite(),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        if (url['bannerType'] == "Product") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDetails(
                                  locale: widget.locale,
                                  localizedValues: widget.localizedValues,
                                  productID: url['product'],
                                  favProductList:
                                      getTokenValue ? favProductList : null),
                            ),
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SubCategories(
                                  locale: widget.locale,
                                  localizedValues: widget.localizedValues,
                                  catId: url['category'],
                                  catTitle:
                                      '${url['title'][0].toUpperCase()}${url['title'].substring(1)}',
                                  token: getTokenValue),
                            ),
                          );
                        }
                      },
                      child: Row(
                        children: <Widget>[
                          Text(MyLocalizations.of(context).ordernow),
                          Icon(Icons.arrow_right)
                        ],
                      ),
                    )
                  ],
                ),
              ),
              url['filePath'] == null && url['imageURL'] == null
                  ? Container()
                  : Positioned(
                      right: locale == 'ar' ? null : 0,
                      left: locale == 'ar' ? 0 : null,
                      child: Container(
                        height: 122,
                        width: 124,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.33),
                                blurRadius: 6)
                          ],
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: NetworkImage((url['filePath'] == null
                                ? url['imageURL']
                                : Constants.IMAGE_URL_PATH +
                                    "tr:dpr-auto,tr:w-500" +
                                    url['filePath'])),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        );
      }).toList(),
    );
  }

  productRow(titleTranslate, list) {
    return list.length > 0
        ? Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    titleTranslate,
                    style: textBarlowMediumBlack(),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => AllProducts(
                            locale: widget.locale,
                            localizedValues: widget.localizedValues,
                            productsList: list,
                            favProductList: favProductList,
                            currency: currency,
                            token: getTokenValue,
                          ),
                        ),
                      );
                    },
                    child: Text(
                      MyLocalizations.of(context).viewAll,
                      style: textBarlowMediumPrimary(),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              list.length > 0
                  ? GridView.builder(
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: list.length != null ? list.length : 0,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 14,
                        childAspectRatio:
                            MediaQuery.of(context).size.width / 435,
                      ),
                      itemBuilder: (BuildContext context, int i) {
                        if (list[i]['averageRating'] == null) {
                          list[i]['averageRating'] = 0;
                        }
                        return list[i]['outOfStock'] != null ||
                                list[i]['outOfStock'] != false
                            ? Padding(
                                padding: const EdgeInsets.all(1.0),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ProductDetails(
                                            locale: widget.locale,
                                            localizedValues:
                                                widget.localizedValues,
                                            productID: list[i]['_id'],
                                            favProductList: getTokenValue
                                                ? favProductList
                                                : null),
                                      ),
                                    );
                                  },
                                  child: Stack(
                                    children: <Widget>[
                                      ProductCard(
                                        image: list[i]['filePath'] == null
                                            ? list[i]['imageUrl']
                                            : list[i]['filePath'],
                                        isPath: list[i]['filePath'] == null
                                            ? false
                                            : true,
                                        title: list[i]['title'],
                                        currency: currency,
                                        category: list[i]['category'],
                                        price: double.parse(list[i]['variant']
                                                [0]['price']
                                            .toStringAsFixed(2)),
                                        unit: list[i]['variant'][0]['unit']
                                            .toString(),
                                        dealPercentage:
                                            list[i]['isDealAvailable'] == true
                                                ? double.parse(list[i]
                                                        ['delaPercent']
                                                    .toStringAsFixed(1))
                                                : null,
                                        rating: list[i]['averageRating'] ==
                                                    null ||
                                                list[i]['averageRating'] ==
                                                    '0.0' ||
                                                list[i]['averageRating'] == 0.0
                                            ? null
                                            : list[i]['averageRating']
                                                .toStringAsFixed(1),
                                        buttonName: null,
                                        productList: list[i],
                                        variantList: list[i]['variant'],
                                      ),
                                      list[i]['isDealAvailable'] == true
                                          ? Positioned(
                                              child: Stack(
                                                children: <Widget>[
                                                  Image.asset(
                                                      'lib/assets/images/badge.png'),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            2.0),
                                                    child: Text(
                                                      " " +
                                                          list[i]['delaPercent']
                                                              .toString() +
                                                          "% " +
                                                          MyLocalizations.of(
                                                                  context)
                                                              .off,
                                                      style:
                                                          hintSfboldwhitemed(),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            )
                                          : Positioned(
                                              child: Stack(
                                                children: <Widget>[
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            2.0),
                                                    child: Text(
                                                      " ",
                                                      style:
                                                          hintSfboldwhitemed(),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            )
                                    ],
                                  ),
                                ),
                              )
                            : Stack(
                                children: <Widget>[
                                  ProductCard(
                                    image: list[i]['filePath'] ??
                                        list[i]['imageUrl'],
                                    title: list[i]['title'],
                                    currency: currency,
                                    category: list[i]['category'],
                                    price: double.parse(list[i]['variant'][0]
                                            ['price']
                                        .toStringAsFixed(2)),
                                    rating: list[i]['averageRating']
                                        .toStringAsFixed(1),
                                    dealPercentage:
                                        list[i]['isDealAvailable'] == true
                                            ? double.parse(list[i]
                                                    ['delaPercent']
                                                .toStringAsFixed(1))
                                            : null,
                                    buttonName: null,
                                    productList: list[i],
                                    variantList: list[i]['variant'],
                                  ),
                                  CardOverlay()
                                ],
                              );
                      },
                    )
                  : Center(
                      child: Image.asset('lib/assets/images/no-orders.png'),
                    ),
            ],
          )
        : Container();
  }

  topDealsRow(titleTranslate, list, dealsType) {
    return list.length > 0
        ? Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    titleTranslate,
                    style: textBarlowMediumBlack(),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => AllDealsList(
                              locale: widget.locale,
                              localizedValues: widget.localizedValues,
                              productsList: list,
                              favProductList: favProductList,
                              currency: currency,
                              token: getTokenValue,
                              dealType: dealsType,
                              title: titleTranslate),
                        ),
                      );
                    },
                    child: Text(
                      MyLocalizations.of(context).viewAll,
                      style: textBarlowMediumPrimary(),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 200,
                child: list.length > 0
                    ? ListView.builder(
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: list.length != null ? list.length : 0,
                        itemBuilder: (BuildContext context, int i) {
                          return InkWell(
                            onTap: () {
                              if (list[i]['delalType'] == 'Category') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SubCategories(
                                        locale: widget.locale,
                                        localizedValues: widget.localizedValues,
                                        catId: list[i]['category'],
                                        catTitle:
                                            '${list[i]['name'][0].toUpperCase()}${list[i]['name'].substring(1)}',
                                        token: getTokenValue),
                                  ),
                                );
                              } else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductDetails(
                                        locale: widget.locale,
                                        localizedValues: widget.localizedValues,
                                        productID: list[i]['product'],
                                        favProductList: getTokenValue
                                            ? favProductList
                                            : null),
                                  ),
                                );
                              }
                            },
                            child: Container(
                              width: 150,
                              margin: EdgeInsets.only(right: 15),
                              child: GFImageOverlay(
                                image: NetworkImage(list[i]['filePath'] == null
                                    ? list[i]['imageUrl']
                                    : Constants.IMAGE_URL_PATH +
                                        "tr:dpr-auto,tr:w-500" +
                                        list[i]['filePath']),
                                boxFit: BoxFit.cover,
                                color: Colors.black,
                                colorFilter: ColorFilter.mode(
                                    Colors.black.withOpacity(0.40),
                                    BlendMode.darken),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(4)),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 10, left: 10, right: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Text(list[i]['name'],
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: textBarlowSemiBoldwbig()),
                                      Text(
                                        list[i]['delaPercent'].toString() +
                                            "% " +
                                            MyLocalizations.of(context).off,
                                        style: textBarlowRegularrwhsm(),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    : Center(
                        child: Image.asset('lib/assets/images/no-orders.png'),
                      ),
              ),
            ],
          )
        : Container();
  }

  todayDealsRow(titleTranslate, list, dealsType) {
    return list.length > 0
        ? Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    titleTranslate,
                    style: textBarlowMediumBlack(),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => AllDealsList(
                              locale: widget.locale,
                              localizedValues: widget.localizedValues,
                              productsList: list,
                              favProductList: favProductList,
                              currency: currency,
                              token: getTokenValue,
                              dealType: dealsType,
                              title: titleTranslate),
                        ),
                      );
                    },
                    child: Text(
                      MyLocalizations.of(context).viewAll,
                      style: textBarlowMediumPrimary(),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 200,
                child: list.length > 0
                    ? ListView.builder(
                        physics: ScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: list.length != null ? list.length : 0,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int i) {
                          return InkWell(
                            onTap: () {
                              if (list[i]['delalType'] == 'Category') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SubCategories(
                                        locale: widget.locale,
                                        localizedValues: widget.localizedValues,
                                        catId: list[i]['category'],
                                        catTitle:
                                            '${list[i]['name'][0].toUpperCase()}${list[i]['name'].substring(1)}',
                                        token: getTokenValue),
                                  ),
                                );
                              } else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductDetails(
                                        locale: widget.locale,
                                        localizedValues: widget.localizedValues,
                                        productID: list[i]['product'],
                                        favProductList: getTokenValue
                                            ? favProductList
                                            : null),
                                  ),
                                );
                              }
                            },
                            child: Container(
                              width: 150,
                              margin: EdgeInsets.only(right: 15),
                              child: GFImageOverlay(
                                image: NetworkImage(
                                  list[i]['filePath'] == null
                                      ? list[i]['imageUrl']
                                      : Constants.IMAGE_URL_PATH +
                                          "tr:dpr-auto,tr:w-500" +
                                          list[i]['filePath'],
                                ),
                                boxFit: BoxFit.cover,
                                color: Colors.black,
                                colorFilter: ColorFilter.mode(
                                    Colors.black.withOpacity(0.40),
                                    BlendMode.darken),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(4)),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 10, left: 10, right: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Text(
                                          list[i]['delaPercent'].toString() +
                                              "% " +
                                              MyLocalizations.of(context).off,
                                          style: textoswaldboldwhite()),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        list[i]['name'],
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: textBarlowmediumsmallWhite(),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    : Center(
                        child: Image.asset('lib/assets/images/no-orders.png'),
                      ),
              ),
            ],
          )
        : Container();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      key: _scaffoldKeydrawer,
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: false,
        controller: _refreshController,
        onRefresh: () {
          setState(() {
            isLoadingAllData = true;
            isBannerLoading = true;
            getBannerData();
            getAllDataMethod();
          });
        },
        child: isLoadingAllData
            ? SquareLoader()
            : SingleChildScrollView(
                physics: ScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 20),
                      banner(),
                      SizedBox(height: 15),
                      categoryRow(),
                      Divider(),
                      SizedBox(height: 10),
                      topDealsRow(MyLocalizations.of(context).topDeals,
                          topDealList, "TopDeals"),
                      SizedBox(height: 10),
                      Divider(),
                      SizedBox(height: 10),
                      productRow(
                          MyLocalizations.of(context).products, productsList),
                      SizedBox(height: 10),
                      Divider(),
                      SizedBox(height: 10),
                      todayDealsRow(MyLocalizations.of(context).dealsoftheday,
                          dealList, "TodayDeals"),
                      SizedBox(height: 10),
                      Divider(),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
