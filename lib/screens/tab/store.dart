import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/components/appbar/gf_appbar.dart';
import 'package:getflutter/components/carousel/gf_carousel.dart';
import 'package:getflutter/components/image/gf_image_overlay.dart';
import 'package:grocery_pro/screens/categories/allcategories.dart';
import 'package:grocery_pro/screens/categories/subcategories.dart';
import 'package:grocery_pro/screens/product/all_deals.dart';
import 'package:grocery_pro/screens/product/all_products.dart';
import 'package:grocery_pro/screens/product/product-details.dart';
import 'package:grocery_pro/screens/tab/searchitem.dart';
import 'package:grocery_pro/service/auth-service.dart';
import 'package:grocery_pro/service/common.dart';
import 'package:grocery_pro/service/fav-service.dart';
import 'package:grocery_pro/service/localizations.dart';
import 'package:grocery_pro/service/product-service.dart';
import 'package:grocery_pro/service/sentry-service.dart';
import 'package:grocery_pro/style/style.dart';
import 'package:grocery_pro/widgets/loader.dart';
import 'package:location/location.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:grocery_pro/widgets/categoryBlock.dart';
import 'package:grocery_pro/widgets/productCard.dart';
import 'package:grocery_pro/widgets/cardOverlay.dart';
import 'package:geocoder/geocoder.dart';

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

  final List<String> imageList = [
    'lib/assets/images/cherry.png',
    'lib/assets/images/product.png',
    'lib/assets/images/apple.png',
    'lib/assets/images/orange.png',
  ];
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
  String currency, itemCount = '4';
  final List<String> assetImg = [
    'lib/assets/images/product.png',
  ];

  TabController tabController;
  LocationData currentLocation;
  Location _location = new Location();
  var addressData;
  String locale;
  @override
  void initState() {
    getProductListMethod();
    getToken();
    getResult();
    getBanner();
    getAllData();

    super.initState();
    tabController = TabController(length: 4, vsync: this);
  }

  getProductListMethod() async {
    await ProductService.getProductListAll().then((onValue) {
      try {
        _refreshController.refreshCompleted();
        if (onValue['response_code'] == 200) {
          if (mounted) {
            setState(() {
              searchProductList = onValue['response_data'];
            });
          }
        } else {
          if (mounted) {
            setState(() {
              searchProductList = [];
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
            getFavListApi();
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

  getResult() async {
    if (mounted) {
      setState(() {
        isLocationLoading = true;
      });
    }
    Common.getCurrentLocation().then((value) async {
      if (value != null) {
        if (mounted) {
          setState(() {
            isLocationLoading = false;
            addressData = value;
          });
        }
      }
      currentLocation = await _location.getLocation();
      final coordinates =
          new Coordinates(currentLocation.latitude, currentLocation.longitude);
      var addresses =
          await Geocoder.local.findAddressesFromCoordinates(coordinates);
      var first = addresses.first;
      addressData = first.addressLine;
      Common.setCurrentLocation(addressData);
      return first;
    });
  }

  deliveryAddress() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              MyLocalizations.of(context).deliveryAddress,
              style: textBarlowRegularrBlacksm(),
            ),
            Text(
              addressData.substring(0, 22) + '...',
              style: textBarlowSemiBoldBlackbig(),
            )
          ],
        ),
      ],
    );
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
                  itemCount: categoryList.length < int.parse(itemCount)
                      ? categoryList.length
                      : int.parse(itemCount),
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
                              catTitle:
                                  '${categoryList[index]['title'][0].toUpperCase()}${categoryList[index]['title'].substring(1)}',
                            ),
                          ),
                        );
                      },
                      child: CategoryBlock(
                        image: categoryList[index]['imageUrl'],
                        title: categoryList[index]['title'].length > 7
                            ? categoryList[index]['title'].substring(0, 7) +
                                ".."
                            : categoryList[index]['title'],
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
      height: 140,
      aspectRatio: 2,
      items: bannerList
          .map(
            (url) => InkWell(
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
                      ),
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
                    height: 106,
                    margin: EdgeInsets.only(top: 10),
                    padding: EdgeInsets.only(top: 5, left: 20, right: 20),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: primary,
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          url['title'],
                          style: textbarlowBoldwhite(),
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
                                      favProductList: getTokenValue
                                          ? favProductList
                                          : null),
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
                                  ),
                                ),
                              );
                            }
                          },
                          child: Row(
                            children: <Widget>[
                              Text('Order  now'),
                              Icon(Icons.arrow_right)
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  locale == "ar"
                      ? Positioned(
                          left: 0,
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
                                  image: NetworkImage(url['imageURL']),
                                  fit: BoxFit.fill),
                            ),
                          ),
                        )
                      : Positioned(
                          right: 0,
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
                                  image: NetworkImage(url['imageURL']),
                                  fit: BoxFit.fill),
                            ),
                          ),
                        ),
                ],
              ),
            ),
          )
          .toList(),
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
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20),
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
                                        image: list[i]['imageUrl'],
                                        title: list[i]['title'].length > 10
                                            ? list[i]['title']
                                                    .substring(0, 10) +
                                                ".."
                                            : list[i]['title'],
                                        currency: currency,
                                        category: list[i]['category'],
                                        price: list[i]['variant'][0]['price']
                                            .toString(),
                                        rating:
                                            list[i]['averageRating'].toString(),
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
                                                          "% Off",
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
                                    image: list[i]['imageUrl'],
                                    title: list[i]['title'],
                                    currency: currency,
                                    category: list[i]['category'],
                                    price: list[i]['variant'][0]['price'],
                                    rating: list[i]['averageRating'].toString(),
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
                                image: NetworkImage(list[i]['imageUrl']),
                                color: Colors.black,
                                colorFilter: ColorFilter.mode(
                                    Colors.black.withOpacity(0.40),
                                    BlendMode.darken),
                                height: 150,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(4)),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 10, left: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Text(list[i]['name'],
                                          style: textBarlowSemiBoldwbig()),
                                      Text(
                                        list[i]['delaPercent'].toString() +
                                            "% OFF",
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
                height: 150,
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
                                        productID: list[i]['product'],
                                        favProductList: getTokenValue
                                            ? favProductList
                                            : null),
                                  ),
                                );
                              }
                            },
                            child: Container(
                              width: 180,
                              margin: EdgeInsets.only(right: 15),
                              child: GFImageOverlay(
                                image: NetworkImage(list[i]['imageUrl']),
                                color: Colors.black,
                                colorFilter: ColorFilter.mode(
                                    Colors.black.withOpacity(0.40),
                                    BlendMode.darken),
                                height: 60,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(4)),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 10, left: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Text(
                                          list[i]['delaPercent'].toString() +
                                              "% OFF",
                                          style: textoswaldboldwhite()),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        list[i]['name'],
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
      appBar: GFAppBar(
        backgroundColor: bg,
        elevation: 0,
        title: isLocationLoading || addressData == null
            ? Container()
            : deliveryAddress(),
        actions: <Widget>[
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SearchItem(
                      locale: widget.locale,
                      localizedValues: widget.localizedValues,
                      productsList: searchProductList,
                      currency: currency,
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
//      drawer: Drawer(),
      backgroundColor: bg,
      key: _scaffoldKeydrawer,
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: false,
        header: WaterDropHeader(),
        controller: _refreshController,
        onRefresh: () {
          setState(() {
            isLoadingAllData = true;
            isBannerLoading = true;
            getProductListMethod();
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
                      SizedBox(height: 10),
                      productRow(
                          MyLocalizations.of(context).products, productsList),
                      SizedBox(height: 10),
                      Divider(),
                      SizedBox(height: 10),
                      topDealsRow(MyLocalizations.of(context).topDeals,
                          topDealList, "TopDeals"),
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
