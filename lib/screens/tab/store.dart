import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';
import 'package:grocery_pro/screens/categories/allcategories.dart';
import 'package:grocery_pro/screens/categories/subcategories.dart';
import 'package:grocery_pro/screens/product/product-details.dart';
import 'package:grocery_pro/screens/tab/searchitem.dart';
import 'package:grocery_pro/service/common.dart';
import 'package:grocery_pro/service/fav-service.dart';
import 'package:grocery_pro/service/product-service.dart';
import 'package:grocery_pro/service/sentry-service.dart';
import 'package:grocery_pro/style/style.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

SentryError sentryError = new SentryError();

class Store extends StatefulWidget {
  const Store({Key key, this.currentLocation}) : super(key: key);

  final String currentLocation;
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
    currentLocation = await _location.getLocation();
    if (currentLocation != null) {
      getGeoLocation();
    }
  }

  getGeoLocation() async {
    if (mounted) {
      setState(() {
        isLocationLoading = true;
      });
    }
    await ProductService.geoApi(
            currentLocation.latitude, currentLocation.longitude)
        .then((onValue) {
      try {
        if (mounted) {
          setState(() {
            addressData = onValue['results'][0];
            isLocationLoading = false;
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
    return Scaffold(
      key: _scaffoldKeydrawer,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        title: isLocationLoading || addressData == null
            ? Container()
            : Container(
                margin: EdgeInsets.only(left: 7, top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Delivery Address',
                      style: textBarlowRegularrBlacksm(),
                    ),
                    Text(
                      addressData['formatted_address'].substring(0, 15) + '...',
                      style: textBarlowSemiBoldBlackbig(),
                    )
                  ],
                ),
              ),
        // actions: <Widget>[
        //   InkWell(
        //     onTap: () => _scaffoldKeydrawer.currentState.openEndDrawer(),
        //     child: Image.asset('lib/assets/icons/menu.png'),
        //   ),
        // ],
        iconTheme: IconThemeData(color: Colors.black),
      ),
      // endDrawer: Drawer(
      //   child: Drawer(),
      // ),
//      key: _scaffoldkey,
      body: (isLoadingcategoryList || isLoadingProductsList)
          ? Center(child: CircularProgressIndicator())
          : ListView(
              children: <Widget>[
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SearchItem(
                            productsList: productsList,
                            currency: currency,
                            favProductList:
                                getTokenValue ? favProductList : null),
                      ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.all(20),
                    padding: EdgeInsets.only(left: 15, right: 15),
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    decoration: BoxDecoration(
                        color: Color(0xFFF0F0F0),
                        borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.search),
                        Padding(
                          padding: const EdgeInsets.only(left: 4.0, bottom: 4),
                          child: Text('What are you buying today?',
                              style: textbarlowRegularad()),
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 18.0, right: 18.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Explore by Categories',
                        style: textBarlowMediumBlack(),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AllCategories()),
                          );
                        },
                        child: Text(
                          'View all',
                          style: textBarlowMediumPrimary(),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                categoryList.length > 0
                    ? Container(
                        margin: EdgeInsets.only(left: 5, right: 5.0),
                        height: 110.0,
                        width: MediaQuery.of(context).size.width,
                        child: ListView.builder(
                          physics: ScrollPhysics(),
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: categoryList.length == null
                              ? 0
                              : categoryList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return SingleChildScrollView(
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SubCategories(
                                        catId: categoryList[index]['_id'],
                                        catTitle:
                                            '${categoryList[index]['title'][0].toUpperCase()}${categoryList[index]['title'].substring(1)}',
                                      ),
                                    ),
                                  );
                                },
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      width: 80,
                                      padding: EdgeInsets.all(10),
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                            padding: EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                              border: Border.all(
                                                  color: Colors.black
                                                      .withOpacity(0.20)),
                                            ),
                                            child: Container(
                                              height: 45,
                                              width: 45,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10)),
                                                image: new DecorationImage(
                                                  fit: BoxFit.fill,
                                                  image: new NetworkImage(
                                                      categoryList[index]
                                                          ['imageUrl']),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Text(
                                            categoryList[index]['title']
                                                        .length >
                                                    6
                                                ? categoryList[index]['title']
                                                        .substring(0, 6) +
                                                    ".."
                                                : categoryList[index]['title'],
                                            style: textbarlowRegularBlack(),
                                            textAlign: TextAlign.center,
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    : Center(
                        child: Image.asset('lib/assets/images/no-orders.png'),
                      ),
                productsList.length > 0
                    ? GridView.builder(
                        physics: ScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: productsList.length == null
                            ? 0
                            : productsList.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2),
                        itemBuilder: (BuildContext context, int i) {
                          return productsList[i]['outOfStock'] != null ||
                                  productsList[i]['outOfStock'] != false
                              ? InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ProductDetails(
                                            productDetail: productsList[i],
                                            favProductList: getTokenValue
                                                ? favProductList
                                                : null),
                                      ),
                                    );
                                  },
                                  child: Column(
                                    children: <Widget>[
                                      GFCard(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0)),
                                        boxFit: BoxFit.fill,
                                        colorFilter: new ColorFilter.mode(
                                            Colors.black.withOpacity(0.67),
                                            BlendMode.darken),
                                        content: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 8.0),
                                                  child: productsList[i]
                                                              ['discount'] ==
                                                          null
                                                      ? Container(
                                                          height: 15,
                                                          width: 65,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .only(
                                                              topLeft: Radius
                                                                  .circular(20),
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          20),
                                                            ),
                                                          ),
                                                          child: GFButtonBadge(
                                                            onPressed: null,
                                                            text: '',
                                                            color: Colors.white,
                                                          ),
                                                        )
                                                      : Container(
                                                          height: 15,
                                                          width: 65,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .only(
                                                              topLeft: Radius
                                                                  .circular(20),
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          20),
                                                            ),
                                                          ),
                                                          child: GFButtonBadge(
                                                            onPressed: null,
                                                            text: productsList[
                                                                i]['discount'],
                                                            textStyle:
                                                                textbarlowRegularBlack(),
                                                            color: Colors
                                                                    .deepOrange[
                                                                300],
                                                          ),
                                                        ),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              children: <Widget>[
                                                Image.network(
                                                  productsList[i]['imageUrl'],
                                                  fit: BoxFit.cover,
                                                  width: 117,
                                                  height: 63,
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Row(
                                                  children: <Widget>[
                                                    Text(
                                                      productsList[i]['title'],
                                                      style:
                                                          textbarlowRegularBlack(),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: <Widget>[
                                                    Text(
                                                      currency,
                                                      style:
                                                          textbarlowBoldGreen(),
                                                    ),
                                                    Text(
                                                      '${productsList[i]['variant'][0]['price']}',
                                                      style:
                                                          textbarlowBoldGreen(),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Expanded(
                                  child: Stack(
                                    children: <Widget>[
                                      Container(
                                        child: GFCard(
                                          content: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Container(
                                                height: 90.0,
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    image: NetworkImage(
                                                        productsList[i]
                                                            ['imageUrl']),
                                                  ),
                                                ),
                                              ),
                                              Text(productsList[i]['title']),
                                              Row(
                                                children: <Widget>[
                                                  Text(
                                                    currency,
                                                    style:
                                                        textbarlowBoldGreen(),
                                                  ),
                                                  Text(
                                                    productsList[i]['variant']
                                                            [0]['price']
                                                        .toString(),
                                                    style:
                                                        textbarlowBoldGreen(),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        child: Container(
                                          alignment: Alignment.center,
                                          margin: EdgeInsets.only(
                                              left: 15,
                                              right: 16,
                                              top: 16,
                                              bottom: 16),
                                          height: 171,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5)),
                                            color:
                                                Colors.black.withOpacity(0.40),
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Text(
                                                'Oops !',
                                                style:
                                                    textBarlowSemiBoldwhite(),
                                              ),
                                              Text(
                                                'Out of stock',
                                                style:
                                                    textBarlowSemiBoldwhite(),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                );
                        },
                      )
                    : Center(
                        child: Image.asset('lib/assets/images/no-orders.png'),
                      ),
              ],
            ),
    );
  }
}
