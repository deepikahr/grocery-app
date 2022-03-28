import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:getwidget/components/badge/gf_badge.dart';
import 'package:getwidget/shape/gf_badge_shape.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:readymadeGroceryApp/model/counterModel.dart';
import 'package:readymadeGroceryApp/screens/home/home.dart';
import 'package:readymadeGroceryApp/screens/product/product-details.dart';
import 'package:readymadeGroceryApp/screens/tab/searchitem.dart';
import 'package:readymadeGroceryApp/service/common.dart';
import 'package:readymadeGroceryApp/service/localizations.dart';
import 'package:readymadeGroceryApp/service/product-service.dart';
import 'package:readymadeGroceryApp/service/sentry-service.dart';
import 'package:readymadeGroceryApp/style/style.dart';
import 'package:readymadeGroceryApp/widgets/appBar.dart';
import 'package:readymadeGroceryApp/widgets/button.dart';
import 'package:readymadeGroceryApp/widgets/loader.dart';
import 'package:readymadeGroceryApp/widgets/normalText.dart';
import 'package:readymadeGroceryApp/widgets/product_gridcard.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../service/constants.dart';
import '../../service/locationService.dart';
import '../../style/style.dart';
import '../../widgets/loader.dart';

SentryError sentryError = new SentryError();

class AllProducts extends StatefulWidget {
  final Map? localizedValues;
  final String? locale, dealId, categoryId, pageTitle;

  AllProducts({
    Key? key,
    this.locale,
    this.localizedValues,
    this.dealId,
    this.categoryId,
    this.pageTitle,
  });
  @override
  _AllProductsState createState() => _AllProductsState();
}

class _AllProductsState extends State<AllProducts> {
  bool isUserLoaggedIn = false,
      getTokenValue = false,
      isFirstPageLoading = true,
      isNextPageLoading = false,
      isCategoryLoading = true,
      isProductsForDeal = false,
      isProductsForCategory = false,
      isCurrentLocationLoading = false;
  int? productsPerPage = 12,
      productsPageNumber = 0,
      totalProducts = 1,
      selectedCategoryIndex = 0;
  List? productsList = [], categoryList = [];
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  String? currency;
  ScrollController _scrollController = ScrollController();

  var cartData, addressData;

  @override
  void initState() {
    super.initState();
    getResult();
    if (widget.dealId != null) {
      isProductsForDeal = true;
      isCategoryLoading = false;
    } else if (widget.categoryId != null) {
      isProductsForCategory = true;
    } else {
      getCategoryList();
    }
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        methodCallsInitiate();
      }
    });
    checkIfUserIsLoaggedIn();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void methodCallsInitiate() {
    if (isProductsForDeal) {
      getProductListByDealId();
    } else if (isProductsForCategory) {
      if (selectedCategoryIndex == 0) {
        getCategoryListByCategoryId();
      } else {
        getProductsListByCategoryId();
      }
    } else {
      if (selectedCategoryIndex == 0) {
        getProductsList();
      } else {
        getProductsListByCategoryId();
      }
    }
  }

  void checkIfUserIsLoaggedIn() async {
    setState(() {
      isFirstPageLoading = true;
    });
    productsList = [];
    productsPageNumber = productsList!.length;
    totalProducts = 1;
    await Common.getCurrency()
        .then((value) => setState(() => currency = value));

    await Common.getToken().then((onValue) {
      if (onValue != null) {
        isUserLoaggedIn = true;
      }
      methodCallsInitiate();
    });
  }

  void getCategoryList() async {
    await ProductService.getCategoryList().then((onValue) {
      if (onValue['response_data'] != null) {
        categoryList = onValue['response_data'] as List?;
      }
      if (mounted)
        setState(() {
          isCategoryLoading = false;
        });
    }).catchError((error) {
      if (mounted) {
        setState(() {
          isCategoryLoading = false;
        });
      }
      sentryError.reportError(error, null);
    });
  }

  deliveryAddress() {
    return locationText(context, addressData == null ? null : "YOUR_LOCATION",
        addressData ?? Constants.appName);
  }

  getToken() async {
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
      if (mounted) {
        setState(() {
          getTokenValue = false;
        });
      }
      sentryError.reportError(error, null);
    });
  }

  getResult() async {
    await Common.getCurrentLocation().then((address) async {
      if (address != null) {
        if (mounted) {
          setState(() {
            addressData = address;
          });
        }
      }
      bool? permission = await LocationUtils().locationPermission();

      if (permission) {
        Position position = await LocationUtils().currentLocation();
        var addressValue = await LocationUtils().getAddressFromLatLng(
          LatLng(
            position.latitude,
            position.longitude,
          ),
        );
        List<Placemark> placemarks = await placemarkFromCoordinates(
            position.latitude, position.longitude);
        if (mounted) {
          setState(() {
            addressData = addressValue.formattedAddress;
            isCurrentLocationLoading = false;
          });
        }
        await Common.setCountryInfo(placemarks[0].isoCountryCode ?? '');
        await Common.setCurrentLocation(addressData);
      }
    });
  }

  void getCategoryListByCategoryId() async {
    if (totalProducts != productsList!.length) {
      if (productsPageNumber! > 0) {
        setState(() {
          isNextPageLoading = true;
        });
      }
      await ProductService.getProductToCategoryList(
              widget.categoryId, productsPageNumber, productsPerPage)
          .then((onValue) {
        _refreshController.refreshCompleted();
        if (onValue['response_data'] != null) {
          productsList!.addAll(onValue['response_data']['products']);
          totalProducts = onValue["total"];
          productsPageNumber = productsPageNumber! + 1;
        }
        if (mounted)
          setState(() {
            isCategoryLoading = false;
            isFirstPageLoading = false;
            isNextPageLoading = false;
          });
      }).catchError((error) {
        if (mounted) {
          setState(() {
            isCategoryLoading = false;
            isFirstPageLoading = false;
            isNextPageLoading = false;
          });
        }
        sentryError.reportError(error, null);
      });
    }
  }

  void getProductsList() async {
    if (totalProducts != productsList!.length) {
      if (productsPageNumber! > 0) {
        setState(() {
          isNextPageLoading = true;
        });
      }
      await ProductService.getProductListAll(
              productsPageNumber, productsPerPage)
          .then((onValue) {
        _refreshController.refreshCompleted();
        if (onValue['response_data'] != null &&
            onValue['response_data'] != []) {
          productsList!.addAll(onValue['response_data']);
          totalProducts = onValue["total"];
          productsPageNumber = productsPageNumber! + 1;
        }
        if (mounted) {
          setState(() {
            isFirstPageLoading = false;
            isNextPageLoading = false;
          });
        }
      }).catchError((error) {
        if (mounted) {
          setState(() {
            isFirstPageLoading = false;
            isNextPageLoading = false;
          });
        }
        sentryError.reportError(error, null);
      });
    }
  }

  void getProductsListByCategoryId() async {
    if (totalProducts != productsList!.length) {
      if (productsPageNumber! > 0) {
        setState(() {
          isNextPageLoading = true;
        });
      }
      await ProductService.getProductToCategoryList(
              categoryList![selectedCategoryIndex! - 1]['_id'],
              productsPageNumber,
              productsPerPage)
          .then((onValue) {
        _refreshController.refreshCompleted();
        if (onValue['response_data'] != null &&
            onValue['response_data'] != []) {
          productsList!.addAll(onValue['response_data']['products']);
          totalProducts = onValue["total"];
          productsPageNumber = productsPageNumber! + 1;
        }
        if (mounted) {
          setState(() {
            isFirstPageLoading = false;
            isNextPageLoading = false;
          });
        }
      }).catchError((error) {
        if (mounted) {
          setState(() {
            isFirstPageLoading = false;
            isNextPageLoading = false;
          });
        }
        sentryError.reportError(error, null);
      });
    }
  }

  void getProductListByDealId() async {
    if (totalProducts != productsList!.length) {
      if (productsPageNumber! > 0) {
        setState(() {
          isNextPageLoading = true;
        });
      }
      await ProductService.getDealProductListAll(
              widget.dealId, productsPageNumber, productsPerPage)
          .then((onValue) {
        _refreshController.refreshCompleted();
        if (onValue['response_data'] != null &&
            onValue['response_data'] != []) {
          productsList!.addAll(onValue['response_data']);
          totalProducts = onValue["total"];
          productsPageNumber = productsPageNumber! + 1;
        }
        if (mounted) {
          setState(() {
            isFirstPageLoading = false;
            isNextPageLoading = false;
          });
        }
      }).catchError((error) {
        if (mounted) {
          setState(() {
            isFirstPageLoading = false;
            isNextPageLoading = false;
          });
        }
        sentryError.reportError(error, null);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg(context),
      appBar: appBarPrimarynoradiusWithContent(
        context,
        deliveryAddress(),
        true,
        true,
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
                onTap: () {},
                child: Stack(
                  children: [
                    Icon(Icons.shopping_cart),
                    Positioned(
                      right: 2,
                      child: GFBadge(
                        child: Text(
                          '${cartData.toString()}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: "bold",
                              fontSize: 11),
                        ),
                        shape: GFBadgeShape.circle,
                        color: Colors.red,
                        size: 20,
                      ),
                    ),
                  ],
                )),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchItem(
                      locale: widget.locale,
                      localizedValues: widget.localizedValues,
                      currency: currency,
                      token: getTokenValue,
                    ),
                  ),
                );
              },
              child: Padding(
                padding: EdgeInsets.only(right: 15, left: 10),
                child: Icon(Icons.notifications_none),
              ),
            ),
          ],
        ),
      ) as PreferredSizeWidget?,
      body: isCategoryLoading
          ? Center(child: SquareLoader())
          : Column(
              children: [
                SizedBox(height: 20,),
               /* isCategoryLoading
                    ? SquareLoader()
                    : isProductsForDeal
                        ? Container()
                        : Container(
                            height: 45,
                            child: ListView.builder(
                                physics: ScrollPhysics(),
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: categoryList!.length + 1,
                                itemBuilder: (BuildContext context, int i) {
                                  return InkWell(
                                    onTap: () {
                                      setState(() {
                                        selectedCategoryIndex = i;
                                      });
                                      checkIfUserIsLoaggedIn();
                                    },
                                    child: catTab(
                                      context,
                                      i == 0
                                          ? MyLocalizations.of(context)!
                                              .getLocalizations('ALL')
                                          : categoryList![i - 1]['title'],
                                      selectedCategoryIndex == i
                                          ? primary(context)
                                          : Color(0xFFf0F0F0),
                                    ),
                                  );
                                }),
                          ),*/
                Flexible(
                  child: isFirstPageLoading
                      ? Center(child: SquareLoader())
                      : Container(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: SmartRefresher(
                            enablePullDown: true,
                            enablePullUp: false,
                            controller: _refreshController,
                            onRefresh: () {
                              checkIfUserIsLoaggedIn();
                            },
                            child: GridView.builder(
                              physics: ScrollPhysics(),
                              controller: _scrollController,
                              shrinkWrap: true,
                              itemCount: productsList!.isEmpty
                                  ? 0
                                  : productsList!.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio:
                                    MediaQuery.of(context).size.width / 520,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                              ),
                              itemBuilder: (BuildContext context, int i) {
                                return InkWell(
                                  onTap: () {
                                    var result = Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ProductDetails(
                                          locale: widget.locale,
                                          localizedValues:
                                              widget.localizedValues,
                                          productID: productsList![i]['_id'],
                                        ),
                                      ),
                                    );
                                    result.then((value) {
                                      checkIfUserIsLoaggedIn();
                                    });
                                  },
                                  child: ProductGridCard(
                                    currency: currency,
                                    productData: productsList![i],
                                    isHome: false,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                ),
                isNextPageLoading
                    ? Container(
                        padding: EdgeInsets.only(top: 30, bottom: 20),
                        child: SquareLoader(),
                      )
                    : Container()
              ],
            ),
      bottomNavigationBar: cartData == null
          ? Container(height: 10.0)
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
                  checkIfUserIsLoaggedIn();
                });
              },
              child: cartInfoButton(
                context,
                cartData,
                currency,
              ),
            ),
    );
  }
}
