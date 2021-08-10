import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:readymadeGroceryApp/screens/categories/allcategories.dart';
import 'package:readymadeGroceryApp/screens/product/all_deals.dart';
import 'package:readymadeGroceryApp/screens/product/all_products.dart';
import 'package:readymadeGroceryApp/screens/product/product-details.dart';
import 'package:readymadeGroceryApp/screens/subsription/all_subscription_produts_list.dart';
import 'package:readymadeGroceryApp/service/cart-service.dart';
import 'package:readymadeGroceryApp/service/common.dart';
import 'package:readymadeGroceryApp/service/constants.dart';
import 'package:readymadeGroceryApp/service/localizations.dart';
import 'package:readymadeGroceryApp/service/product-service.dart';
import 'package:readymadeGroceryApp/service/sentry-service.dart';
import 'package:readymadeGroceryApp/style/style.dart';
import 'package:readymadeGroceryApp/widgets/loader.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:readymadeGroceryApp/widgets/categoryBlock.dart';
import 'package:readymadeGroceryApp/widgets/normalText.dart';
import 'package:readymadeGroceryApp/widgets/product_gridcard.dart';
import 'package:readymadeGroceryApp/widgets/subscription_card.dart';

SentryError sentryError = new SentryError();

class Store extends StatefulWidget {
  final Map? localizedValues;
  final String? locale, currentLocation;
  Store({Key? key, this.currentLocation, this.locale, this.localizedValues})
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
      isLoadingAllData = false,
      isGetSubcribeLoading = false;
  List? categoryList,
      productsList,
      searchProductList,
      dealList,
      topDealList,
      bannerList,
      subscriptionProductsList;
  String? currency;

  late TabController tabController;

  var addressData;
  String? locale;
  @override
  void initState() {
    getToken();
    getBanner();
    getAllData();
    getSubScriptionDataMethod();
    super.initState();
    tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  getToken() async {
    await Common.getCurrency().then((value) {
      currency = value;
    });
    await Common.getSelectedLanguage().then((value) async {
      locale = value;
      await Common.getToken().then((onValue) {
        if (onValue != null) {
          if (mounted) {
            setState(() {
              getTokenValue = true;
              getCartData();
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
    });
  }

  getCartData() {
    CartService.getProductToCart().then((value) {
      if (value['response_data'] is Map &&
          value['response_data']['products'] != []) {
        Common.setCartData(value['response_data']);
      } else if (value['response_code'] == 403) {
        Common.setCartData(null);
      } else {
        Common.setCartData(null);
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
    await Common.getBanner().then((value) {
      if (value == null || value['response_data'] == null) {
        if (mounted) {
          setState(() {
            getBannerData();
          });
        }
      } else {
        if (mounted) {
          setState(() {
            if (value['response_data'] == []) {
              bannerList = [];
            } else {
              bannerList = value['response_data'];
            }
            getBannerData();
            isBannerLoading = false;
          });
        }
      }
    });
  }

  getBannerData() async {
    await ProductService.getBanner().then((onValue) {
      _refreshController.refreshCompleted();
      if (mounted) {
        setState(() {
          if (onValue!['response_data'] == []) {
            bannerList = [];
          } else {
            bannerList = onValue['response_data'];
          }
          isBannerLoading = false;
        });
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          isBannerLoading = false;
        });
      }
      sentryError.reportError(error, null);
    });
  }

  getAllData() async {
    if (mounted) {
      setState(() {
        isLoadingAllData = true;
      });
    }
    await Common.getAllData().then((value) {
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
            productsList = value['response_data']['products'];
            categoryList = value['response_data']['categories'];
            dealList = value['response_data']['dealsOfDay'];
            topDealList = value['response_data']['topDeals'];
            getAllDataMethod();
          });
        }
      }
    });
  }

  getAllDataMethod() async {
    await ProductService.getProdCatDealTopDeal().then((onValue) {
      _refreshController.refreshCompleted();

      if (mounted) {
        setState(() {
          productsList = onValue!['response_data']['products'];
          categoryList = onValue['response_data']['categories'];
          dealList = onValue['response_data']['dealsOfDay'];
          topDealList = onValue['response_data']['topDeals'];
          isLoadingAllData = false;
        });
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          isLoadingAllData = false;
        });
      }
      sentryError.reportError(error, null);
    });
  }

  void getSubScriptionDataMethod() async {
    setState(() {
      isGetSubcribeLoading = true;
    });
    await Common.getSubcriptionData().then((value) async {
      if (value == null || value['response_data'] == null) {
        if (mounted) {
          setState(() {
            getSubScriptionData();
          });
        }
      } else {
        if (mounted) {
          setState(() {
            if (value['response_data'] == []) {
              subscriptionProductsList = [];
            } else {
              subscriptionProductsList = value['response_data'];
            }
            isGetSubcribeLoading = false;
            getSubScriptionData();
          });
        }
      }
    });
  }

  getSubScriptionData() {
    ProductService.getSubscriptionList(0, 4).then((onValue) {
      _refreshController.refreshCompleted();
      if (mounted) {
        setState(() {
          isGetSubcribeLoading = false;
          subscriptionProductsList = onValue['response_data'];
        });
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          isGetSubcribeLoading = false;
        });
      }
      sentryError.reportError(error, null);
    });
  }

  Widget _buildTitleViewAllTile(String name, {Widget? route, valueKey}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        homePageBoldText(context, name),
        InkWell(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (BuildContext context) => route!));
          },
          child: viewAllBoldText(context, "VIEW_ALL", valueKey: valueKey),
        )
      ],
    );
  }

  categoryRow() {
    return Column(
      children: <Widget>[
        _buildTitleViewAllTile("EXPLORE_BY_CATEGORIES",
            route: AllCategories(
              locale: widget.locale,
              localizedValues: widget.localizedValues,
              getTokenValue: getTokenValue,
            ),
            valueKey: ValueKey('view-all-categories')),
        SizedBox(height: 20),
        SizedBox(
          height: 100,
          child: ListView.builder(
            physics: ScrollPhysics(),
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: categoryList!.isNotEmpty ? categoryList!.length : 0,
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AllProducts(
                        locale: widget.locale,
                        localizedValues: widget.localizedValues,
                        categoryId: categoryList![index]['_id'],
                        pageTitle: categoryList![index]['title'],
                      ),
                    ),
                  );
                },
                child: CategoryBlock(
                    image: categoryList![index]['filePath'] == null
                        ? categoryList![index]['imageUrl']
                        : categoryList![index]['filePath'],
                    title: categoryList![index]['title'],
                    isPath:
                        categoryList![index]['filePath'] == null ? false : true,
                    isHome: true),
              );
            },
          ),
        ),
      ],
    );
  }

  banner() {
    return GFCarousel(
      autoPlay: true,
      pagination: true,
      viewportFraction: 1.0,
      activeIndicator: primarybg,
      passiveIndicator: primaryLight2,
      height: 150,
      aspectRatio: 2,
      onPageChanged: (_) {
        setState(() {
          //do not remove this setstate
        });
      },
      items: bannerList!.map((url) {
        return InkWell(
          onTap: () {
            if (url['bannerType'] == "PRODUCT") {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetails(
                    locale: widget.locale,
                    localizedValues: widget.localizedValues,
                    productID: url['productId'],
                  ),
                ),
              );
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AllProducts(
                    locale: widget.locale,
                    localizedValues: widget.localizedValues,
                    categoryId: url['categoryId'],
                    pageTitle: url['title'],
                  ),
                ),
              );
            }
          },
          child: Stack(
            children: <Widget>[
              Container(height: 130, color: bg(context)),
              Container(
                height: 115,
                margin: EdgeInsets.only(top: 10),
                padding: EdgeInsets.only(top: 5, left: 20, right: 20),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    // color: primary(context),
                    image: DecorationImage(image: AssetImage('lib/assets/images/banner_bg.png'),fit: BoxFit.cover),
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.only(
                          right: locale == 'ar' ? 0 : 100,
                          left: locale == 'ar' ? 100 : 0,
                          top:10
                        ),
                        child: bannerTitle(
                            '${url['title'][0].toUpperCase()}${url['title'].substring(1)}',
                            context)),
                    InkWell(
                        onTap: () {
                          if (url['bannerType'] == "PRODUCT") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductDetails(
                                  locale: widget.locale,
                                  localizedValues: widget.localizedValues,
                                  productID: url['productId'],
                                ),
                              ),
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AllProducts(
                                  locale: widget.locale,
                                  localizedValues: widget.localizedValues,
                                  categoryId: url['categoryId'],
                                  pageTitle: url['title'],
                                ),
                              ),
                            );
                          }
                        },
                        child: orderNowPrimary(context, "ORDER_NOW"))
                  ],
                ),
              ),
              // url['filePath'] == null && url['imageURL'] == null
              //     ? Container()
              //     : Positioned(
              //         right: locale == 'ar' ? null : 0,
              //         left: locale == 'ar' ? 0 : null,
              //         child: CachedNetworkImage(
              //           imageUrl: url['filePath'] == null
              //               ? url['imageURL']
              //               : Constants.imageUrlPath! +
              //                   "/tr:dpr-auto,tr:w-500" +
              //                   url['filePath'],
              //           imageBuilder: (context, imageProvider) => Container(
              //             height: 134,
              //             width: 134,
              //             decoration: BoxDecoration(
              //               boxShadow: [
              //                 BoxShadow(
              //                     color: dark(context).withOpacity(0.33),
              //                     blurRadius: 6)
              //               ],
              //               shape: BoxShape.circle,
              //               image: DecorationImage(
              //                   image: imageProvider, fit: BoxFit.cover),
              //             ),
              //           ),
              //           placeholder: (context, url) => Container(
              //               decoration: BoxDecoration(
              //                 boxShadow: [
              //                   BoxShadow(
              //                       color: dark(context).withOpacity(0.33),
              //                       blurRadius: 6)
              //                 ],
              //                 shape: BoxShape.circle,
              //               ),
              //               height: 134,
              //               width: 134,
              //               child: noDataImage()),
              //           errorWidget: (context, url, error) => Container(
              //               decoration: BoxDecoration(
              //                 boxShadow: [
              //                   BoxShadow(
              //                       color: dark(context).withOpacity(0.33),
              //                       blurRadius: 6)
              //                 ],
              //                 shape: BoxShape.circle,
              //               ),
              //               height: 134,
              //               width: 134,
              //               child: noDataImage()),
              //         ),
              //       ),
            ],
          ),
        );
      }).toList(),
    );
  }

  productRow(titleTranslate, list) {
    return Column(
      children: <Widget>[
        _buildTitleViewAllTile(
          titleTranslate,
          route: AllProducts(
            locale: widget.locale,
            localizedValues: widget.localizedValues,
            pageTitle: "PRODUCTS",
          ),
        ),
        SizedBox(height: 20),
        GridView.builder(
          physics: ScrollPhysics(),
          shrinkWrap: true,
          itemCount: list.length != null ? list.length : 0,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: MediaQuery.of(context).size.width / 435,
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
                              localizedValues: widget.localizedValues,
                              productID: list[i]['_id'],
                            ),
                          ),
                        );
                      },
                      child: ProductGridCard(
                          currency: currency,
                          productData: list[i],
                          isHome: true),
                    ),
                  )
                : ProductGridCard(
                    currency: currency,
                    productData: list[i],
                    isHome: true,
                  );
          },
        ),
      ],
    );
  }

  subscriptionProductsRow(titleTranslate, list) {
    return Column(
      children: <Widget>[
        _buildTitleViewAllTile(
          titleTranslate,
          route: AllSubscriptionProductsListPage(
            locale: widget.locale,
            localizedValues: widget.localizedValues,
          ),
        ),
        SizedBox(height: 20),
        GridView.builder(
          physics: ScrollPhysics(),
          shrinkWrap: true,
          itemCount: list.length != null ? list.length : 0,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: MediaQuery.of(context).size.width / 520,
          ),
          itemBuilder: (BuildContext context, int i) {
            return SubscriptionCard(
              currency: currency,
              productData: list[i],
            );
          },
        ),
      ],
    );
  }

  topDealsRow(titleTranslate, list) {
    return Column(
      children: <Widget>[
        _buildTitleViewAllTile(
          titleTranslate,
          route: AllDealsList(
              locale: widget.locale,
              localizedValues: widget.localizedValues,
              productsList: list,
              currency: currency,
              token: getTokenValue,
              title: titleTranslate),
        ),
        SizedBox(height: 20),
        Container(
          height: 200,
          child: ListView.builder(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: list.length != null ? list.length : 0,
            itemBuilder: (BuildContext context, int i) {
              return InkWell(
                onTap: () {
                  if (list[i]['dealType'] == 'CATEGORY') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AllProducts(
                          locale: widget.locale,
                          localizedValues: widget.localizedValues,
                          categoryId: list[i]['categoryId'],
                          pageTitle: list[i]['title'],
                        ),
                      ),
                    );
                  } else if (list[i]['dealType'] == "PRODUCT" &&
                      list[i]['productId'] == null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AllProducts(
                          locale: widget.locale,
                          localizedValues: widget.localizedValues,
                          dealId: list[i]['_id'],
                          pageTitle: list[i]['title'],
                        ),
                      ),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetails(
                          locale: widget.locale,
                          localizedValues: widget.localizedValues,
                          productID: list[i]['productId'],
                        ),
                      ),
                    );
                  }
                },
                child: CachedNetworkImage(
                  imageUrl: list[i]['filePath'] == null
                      ? list[i]['imageUrl']
                      : Constants.imageUrlPath! +
                          "/tr:dpr-auto,tr:w-500" +
                          list[i]['filePath'],
                  imageBuilder: (context, imageProvider) => Container(
                      width: 150,
                      margin: EdgeInsets.only(right: 15),
                      child: GFImageOverlay(
                          image: NetworkImage(list[i]['filePath'] == null
                              ? list[i]['imageUrl']
                              : Constants.imageUrlPath! +
                                  "/tr:dpr-auto,tr:w-500" +
                                  list[i]['filePath']),
                          boxFit: BoxFit.cover,
                          color: dark(context),
                          colorFilter: ColorFilter.mode(
                              dark(context).withOpacity(0.40),
                              BlendMode.darken),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(4)),
                          child: Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 10, left: 10, right: 10),
                              child: topDeals(
                                  '${list[i]['title'][0].toUpperCase()}${list[i]['title'].substring(1)}',
                                  list[i]['dealPercent'].toString() +
                                      "% " +
                                      MyLocalizations.of(context)!
                                          .getLocalizations("OFF"),
                                  context)))),
                  placeholder: (context, url) => Container(
                      width: 150,
                      margin: EdgeInsets.only(right: 15),
                      child: noDataImage()),
                  errorWidget: (context, url, error) => Container(
                      width: 150,
                      margin: EdgeInsets.only(right: 15),
                      child: GFImageOverlay(
                          image: AssetImage("lib/assets/images/no-orders.png"),
                          boxFit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(
                              dark(context).withOpacity(0.40),
                              BlendMode.darken),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(4)),
                          child: Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 10, left: 10, right: 10),
                              child: topDeals(
                                  '${list[i]['title'][0].toUpperCase()}${list[i]['title'].substring(1)}',
                                  list[i]['dealPercent'].toString() +
                                      "% " +
                                      MyLocalizations.of(context)!
                                          .getLocalizations("OFF"),
                                  context)))),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  todayDealsRow(titleTranslate, list) {
    return Column(
      children: <Widget>[
        _buildTitleViewAllTile(titleTranslate,
            route: AllDealsList(
                locale: widget.locale,
                localizedValues: widget.localizedValues,
                productsList: list,
                currency: currency,
                token: getTokenValue,
                title: titleTranslate)),
        SizedBox(height: 20),
        Container(
          height: 200,
          child: ListView.builder(
            physics: ScrollPhysics(),
            shrinkWrap: true,
            itemCount: list.length != null ? list.length : 0,
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int i) {
              return InkWell(
                onTap: () {
                  if (list[i]['dealType'] == 'CATEGORY') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AllProducts(
                          locale: widget.locale,
                          localizedValues: widget.localizedValues,
                          categoryId: list[i]['categoryId'],
                          pageTitle: list[i]['title'],
                        ),
                      ),
                    );
                  } else if (list[i]['dealType'] == "PRODUCT" &&
                      list[i]['productId'] == null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AllProducts(
                          locale: widget.locale,
                          localizedValues: widget.localizedValues,
                          dealId: list[i]['_id'],
                          pageTitle: list[i]['title'],
                        ),
                      ),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetails(
                          locale: widget.locale,
                          localizedValues: widget.localizedValues,
                          productID: list[i]['productId'],
                        ),
                      ),
                    );
                  }
                },
                child: CachedNetworkImage(
                  imageUrl: list[i]['filePath'] == null
                      ? list[i]['imageUrl']
                      : Constants.imageUrlPath! +
                          "/tr:dpr-auto,tr:w-500" +
                          list[i]['filePath'],
                  imageBuilder: (context, imageProvider) => Container(
                      width: 150,
                      margin: EdgeInsets.only(right: 15),
                      child: GFImageOverlay(
                          image: NetworkImage(list[i]['filePath'] == null
                              ? list[i]['imageUrl']
                              : Constants.imageUrlPath! +
                                  "/tr:dpr-auto,tr:w-500" +
                                  list[i]['filePath']),
                          boxFit: BoxFit.cover,
                          color: dark(context),
                          colorFilter: ColorFilter.mode(
                              dark(context).withOpacity(0.40),
                              BlendMode.darken),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(4)),
                          child: Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 10, left: 10, right: 10),
                              child: todayDeal(
                                  '${list[i]['title'][0].toUpperCase()}${list[i]['title'].substring(1)}',
                                  list[i]['dealPercent'].toString() +
                                      "% " +
                                      MyLocalizations.of(context)!
                                          .getLocalizations("OFF"),
                                  context)))),
                  errorWidget: (context, url, error) => Container(
                    width: 150,
                    margin: EdgeInsets.only(right: 15),
                    child: GFImageOverlay(
                      image: AssetImage("lib/assets/images/no-orders.png"),
                      boxFit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                          dark(context).withOpacity(0.40), BlendMode.darken),
                      borderRadius: const BorderRadius.all(Radius.circular(4)),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            bottom: 10, left: 10, right: 10),
                        child: todayDeal(
                            '${list[i]['title'][0].toUpperCase()}${list[i]['title'].substring(1)}',
                            list[i]['dealPercent'].toString() +
                                "% " +
                                MyLocalizations.of(context)!
                                    .getLocalizations("OFF"),
                            context),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg(context),
      key: _scaffoldKeydrawer,
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: false,
        controller: _refreshController,
        onRefresh: () {
          setState(() {
            isLoadingAllData = true;
            isBannerLoading = true;
            isGetSubcribeLoading = true;
            getBannerData();
            getAllDataMethod();
            getSubScriptionData();
          });
        },
        child: isLoadingAllData || isBannerLoading || isGetSubcribeLoading
            ? SquareLoader()
            : (categoryList!.length == 0 &&
                    productsList!.length == 0 &&
                    dealList!.length == 0 &&
                    topDealList!.length == 0 &&
                    bannerList!.length == 0 &&
                    subscriptionProductsList!.length == 0)
                ? noDataImage()
                : SingleChildScrollView(
                    physics: ScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: <Widget>[
                          bannerList!.length > 0
                              ? Column(
                                  children: [banner(), Divider()],
                                )
                              : Container(),
                          categoryList!.length > 0
                              ? Column(
                                  children: [categoryRow(), Divider()],
                                )
                              : Container(),
                          topDealList!.length > 0
                              ? Column(
                                  children: [
                                    topDealsRow("TOP_DEALS", topDealList),
                                    Divider()
                                  ],
                                )
                              : Container(),
                          productsList!.length > 0
                              ? Column(
                                  children: [
                                    productRow("PRODUCTS", productsList),
                                    Divider()
                                  ],
                                )
                              : Container(),
                          subscriptionProductsList!.length > 0
                              ? Column(
                                  children: [
                                    subscriptionProductsRow(
                                        "SUBSCRIPTION_PRODUCTS",
                                        subscriptionProductsList),
                                    Divider()
                                  ],
                                )
                              : Container(),
                          dealList!.length > 0
                              ? Column(
                                  children: [
                                    todayDealsRow(
                                        "DEALS_OF_THE_DAYS", dealList),
                                    Divider()
                                  ],
                                )
                              : Container(),
                          SizedBox(height: 10)
                        ],
                      ),
                    ),
                  ),
      ),
    );
  }
}
