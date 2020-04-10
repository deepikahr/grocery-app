import 'package:flutter/cupertino.dart';
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
import 'package:grocery_pro/widgets/categoryBlock.dart';
import 'package:grocery_pro/widgets/productCard.dart';
import 'package:grocery_pro/widgets/cardOverlay.dart';
import 'package:geocoder/geocoder.dart';

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
      print(value);
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
    return
      isLocationLoading || addressData == null ? Container() :
        Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Delivery Address',
              style: textBarlowRegularrBlacksm(),
            ),
            Text(
                      addressData.substring(0, 15) + '...',
              style: textBarlowSemiBoldBlackbig(),
            )
          ],
        ),
        InkWell(
          onTap: () => _scaffoldKeydrawer.currentState.openEndDrawer(),
          child: Image.asset('lib/assets/icons/menu.png'),
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
                productsList: productsList,
                currency: currency,
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
              child: Text('What are you buying today?',
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
            height: 120,
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
      key: _scaffoldKeydrawer,
      body: (isLoadingcategoryList || isLoadingProductsList)
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              physics: ScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 45),
                    deliveryAddress(),
                    searchBox(),
                    SizedBox(height: 10),
                    Row(
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
                    SizedBox(height: 20),
                    categoryRow(),
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
                                    crossAxisSpacing: 16,
                                    mainAxisSpacing: 16
                                ),
                            itemBuilder: (BuildContext context, int i) {
                              return
                                productsList[i]['outOfStock'] != null ||
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
                              child: Stack(
                                children: <Widget>[
                                  ProductCard(
                                    image: productsList[i]['imageUrl'],
                                    title: productsList[i]['title'],
                                    currency: currency,
                                    category: productsList[i]['category'],
                                    price: productsList[i]['variant'][0]['price'],
                                    rating: '4.5',
                                  ),
                                  Positioned(
                                    child: Stack(
                                      children: <Widget>[
                                        Image.asset('lib/assets/images/badge.png'),
                                        Text('  Organic', style: hintSfboldwhitemed(), textAlign: TextAlign.center,)
                                      ],
                                    )
                                  )
                                ],
                              )
                            ) :
                              Stack(
                                children: <Widget>[
                                  ProductCard(
                                    image: productsList[i]['imageUrl'],
                                    title: productsList[i]['title'],
                                    currency: currency,
                                    category: productsList[i]['category'],
                                    price: productsList[i]['variant'][0]
                                        ['price'],
                                    rating: '4.5',
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
