import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/components/appbar/gf_appbar.dart';
import 'package:getflutter/components/carousel/gf_carousel.dart';
import 'package:grocery_pro/screens/categories/allcategories.dart';
import 'package:grocery_pro/screens/categories/subcategories.dart';
import 'package:grocery_pro/screens/product/all_products.dart';
import 'package:grocery_pro/screens/product/product-details.dart';
import 'package:grocery_pro/screens/tab/searchitem.dart';
import 'package:grocery_pro/service/common.dart';
import 'package:grocery_pro/service/fav-service.dart';
import 'package:grocery_pro/service/localizations.dart';
import 'package:grocery_pro/service/product-service.dart';
import 'package:grocery_pro/service/sentry-service.dart';
import 'package:grocery_pro/style/style.dart';
import 'package:grocery_pro/widgets/loader.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:grocery_pro/widgets/categoryBlock.dart';
import 'package:grocery_pro/widgets/productCard.dart';
import 'package:grocery_pro/widgets/cardOverlay.dart';
import 'package:geocoder/geocoder.dart';

SentryError sentryError = new SentryError();

class Store extends StatefulWidget {
  final Map<String, Map<String, String>> localizedValues;
  final String locale;
  final String currentLocation;
  Store({Key key, this.currentLocation, this.locale, this.localizedValues})
      : super(key: key);
  @override
  _StoreState createState() => _StoreState();
}

class _StoreState extends State<Store> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKeydrawer =
      new GlobalKey<ScaffoldState>();

  bool isLoadingcategory = false,
      isFavListLoading = false,
      isLoadingProducts = false,
      isLoadingcategoryList = false,
      isLoadingSubProductsList = false,
      isLoadingProductsList = false,
      getTokenValue = true,
      isCurrentLoactionLoading = false,
      isLocationLoading = false;
  List categoryList, productsList, dealList, favList, favProductList;
  String currency;

  final List<String> assetImg = [
    'lib/assets/images/product.png',
  ];

  TabController tabController;
  LocationData currentLocation;
  Location _location = new Location();
  var addressData;
  @override
  void initState() {
    getToken();
    getResult();
    getCategoryList();
    getProductsList();
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

  getCategoryList() async {
    if (mounted) {
      setState(() {
        isLoadingcategoryList = true;
      });
    }
    Common.getCatagrysList().then((value) {
      if (value == null) {
        if (mounted) {
          setState(() {
            categoryListMethod();
          });
        }
      } else {
        if (mounted) {
          setState(() {
            isLoadingcategoryList = false;

            categoryList = value['response_data'];

            categoryListMethod();
          });
        }
      }
    });
  }

  categoryListMethod() async {
    await ProductService.getCategoryList().then((onValue) {
      try {
        if (onValue['response_code'] == 200) {
          if (mounted) {
            setState(() {
              categoryList = onValue['response_data'];
              isLoadingcategoryList = false;
            });
          }
        } else {
          if (mounted) {
            setState(() {
              categoryList = [];
              isLoadingcategoryList = false;
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

  getProductsList() async {
    if (mounted) {
      setState(() {
        isLoadingProductsList = true;
      });
    }
    Common.getProductList().then((value) {
      if (value == null) {
        if (mounted) {
          setState(() {
            getProductListMethod();
          });
        }
      } else {
        if (mounted) {
          setState(() {
            isLoadingProductsList = false;

            productsList = value['response_data'];
            getProductListMethod();
          });
        }
      }
    });
  }

  getProductListMethod() async {
    await ProductService.getProductsList().then((onValue) {
      try {
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
    return isLocationLoading || addressData == null
        ? Container()
        : Row(
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

  searchBox() {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SearchItem(
                locale: widget.locale,
                localizedValues: widget.localizedValues,
                productsList: productsList,
                currency:currency,
                favProductList: getTokenValue ? favProductList : null),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        width: MediaQuery.of(context).size.width,
        height: 50,
        decoration: BoxDecoration(
            color: Color(0xFFF0F0F0), borderRadius: BorderRadius.circular(10)),
        child: Row(
          children: <Widget>[
            SizedBox(
              width: 24,
            ),
            Icon(
              Icons.search,
              color: Colors.black.withOpacity(0.5),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 4.0, bottom: 4),
              child: Text(
                  MyLocalizations.of(context).whatareyoubuyingtoday + '?',
                  style: textbarlowRegularad()),
            )
          ],
        ),
      ),
    );
  }

  categoryRow() {
    return categoryList.length > 0
        ? SizedBox(
            height: 100,
            child: ListView.builder(
              physics: ScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: categoryList.length == null ? 0 : categoryList.length,
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
                        ? categoryList[index]['title'].substring(0, 7) + ".."
                        : categoryList[index]['title'],
                  ),
                );
              },
            ),
          )
        : Center(
            child: Image.asset('lib/assets/images/no-orders.png'),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: GFAppBar(
      backgroundColor: bg,
      elevation: 0,
      title:    deliveryAddress(),
      actions: <Widget>[
       Padding(padding: EdgeInsets.only(right:15), child:  Icon(
         Icons.search,
       ),)
      ],
    ),
//      drawer: Drawer(),
      backgroundColor: bg,
      key: _scaffoldKeydrawer,
      body: (isLoadingcategoryList || isLoadingProductsList)
          ? SquareLoader()
          : SingleChildScrollView(
              physics: ScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 15),


                    GFCarousel(
                      autoPlay: true,
                      pagination: true,
                      viewportFraction: 1.0,
                      activeIndicator: Colors.transparent,
                      height: 140,
                      aspectRatio: 2,
                      items: assetImg
                          .map(
                            (url) =>   Stack(
                              children: <Widget>[
                                Container(
                                  height: 130,
                                  color: bg,
                                ),
                                Container(
                                  height: 106,
                                  margin: EdgeInsets.only(top:10),
                                  padding: EdgeInsets.only(top:5,  left: 20, right: 20),
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                      color: primary,
                                      borderRadius: BorderRadius.all(Radius.circular(5))
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text('Fruit \nSplash', style: textbarlowBoldwhite(),),
                                      InkWell(
                                        onTap: (){},
                                        child: Row(
                                          children: <Widget>[
                                            Text('Order Fruits now'),
                                            Icon(Icons.arrow_right)
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Positioned(
                                    right: 0,
                                    child: Container(
                                        height:122,
                                        width: 124,
                                        decoration:BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.black.withOpacity(0.33),
                                                  blurRadius: 6
                                              )
                                            ],
                                            shape: BoxShape.circle,
                                            image:DecorationImage(image:AssetImage('lib/assets/images/product.png'), fit: BoxFit.fill)
                                        )
                                    ))
                              ],
                            ),
                      )
                          .toList(),
                    ),

//                    deliveryAddress(),
//                    searchBox(),
//                    SizedBox(height: 10),
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
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    categoryRow(),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                         'Products',
                          style: textBarlowMediumBlack(),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (BuildContext context) => AllProducts()),
                            );
                          },
                          child: Text(
                            'View All',
                            style: textBarlowMediumPrimary(),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    productsList.length > 0
                        ? GridView.builder(
                            physics: ScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: productsList.length == null
                                ? 0
                                : productsList.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,

                                    crossAxisSpacing: 23,
                                    mainAxisSpacing: 23),
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
                                            builder: (context) =>
                                                ProductDetails(
                                                    locale: widget.locale,
                                                    localizedValues:
                                                        widget.localizedValues,
                                                    productDetail:
                                                        productsList[i],
                                                    favProductList:
                                                        getTokenValue
                                                            ? favProductList
                                                            : null),
                                          ),
                                        );
                                      },
                                      child: Stack(
                                        children: <Widget>[
                                          ProductCard(
                                            image: productsList[i]['imageUrl'],
                                            title: productsList[i]['title']
                                                        .length >
                                                    10
                                                ? productsList[i]['title']
                                                        .substring(0, 10) +
                                                    ".."
                                                : productsList[i]['title'],
                                            currency:currency,
                                            category: productsList[i]
                                                ['category'],
                                            price: productsList[i]['variant'][0]
                                                ['price'],
                                            rating: productsList[i]
                                                    ['averageRating']
                                                .toString(),
                                          ),
                                          productsList[i]['isDealAvailable'] ==
                                                  true
                                              ? Positioned(
                                                  child: Stack(
                                                    children: <Widget>[
                                                      Image.asset(
                                                          'lib/assets/images/badge.png'),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(2.0),
                                                        child: Text(
                                                          " " +
                                                              productsList[i][
                                                                      'delaPercent']
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
                                              : Container()
                                        ],
                                      ),
                                    )
                                  : Stack(
                                      children: <Widget>[
                                       ProductCard(
                                            image: productsList[i]['imageUrl'],
                                            title: productsList[i]['title'],
                                            currency:currency,
                                            category: productsList[i]['category'],
                                            price: productsList[i]['variant'][0]
                                            ['price'],
                                            rating: productsList[i]
                                            ['averageRating']
                                                .toString(),
                                          ),

                                        CardOverlay()
                                      ],
                                    );
                            },
                          )
                        : Center(
                            child:
                                Image.asset('lib/assets/images/no-orders.png'),
                          ),
                  ],
                ),
              ),
            ),
    );
  }
}
