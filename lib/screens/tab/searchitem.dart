import 'dart:async';

import 'package:flutter/material.dart';
import 'package:readymadeGroceryApp/model/counterModel.dart';
import 'package:readymadeGroceryApp/screens/authe/login.dart';
import 'package:readymadeGroceryApp/screens/home/home.dart';
import 'package:readymadeGroceryApp/screens/product/product-details.dart';
import 'package:readymadeGroceryApp/service/common.dart';
import 'package:readymadeGroceryApp/service/localizations.dart';
import 'package:readymadeGroceryApp/service/product-service.dart';
import 'package:readymadeGroceryApp/service/error-service.dart';
import 'package:readymadeGroceryApp/style/style.dart';
import 'package:readymadeGroceryApp/widgets/button.dart';
import 'package:readymadeGroceryApp/widgets/loader.dart';
import 'package:readymadeGroceryApp/widgets/normalText.dart';
import 'package:readymadeGroceryApp/widgets/product_gridcard.dart';

import 'mycart.dart';

ReportError reportError = new ReportError();

class SearchItem extends StatefulWidget {
  final String? currency, locale;
  final bool? token;
  final Map? localizedValues;
  SearchItem(
      {Key? key, this.currency, this.locale, this.token, this.localizedValues})
      : super(key: key);
  @override
  _SearchItemState createState() => _SearchItemState();
}

class _SearchItemState extends State<SearchItem> {
  final globalKey = new GlobalKey<ScaffoldState>();
  final TextEditingController _controller = new TextEditingController();
  final GlobalKey<FormState> _formKeyForSearch = GlobalKey<FormState>();
  bool isSearching = false,
      isFirstTime = true,
      getTokenValue = false,
      isTokenGetLoading = false,
      lastApiCall = true;
  List searchresult = [];
  String? cartId, searchTerm;
  var cartData;
  String? currency;
  int productLimt = 10, productIndex = 0, totalProduct = 1;
  Timer? timer;
  @override
  void initState() {
    getCurrency();
    super.initState();
  }

  getCurrency() async {
    if (mounted) {
      setState(() {
        isTokenGetLoading = true;
      });
    }
    await Common.getCurrency()
        .then((value) => setState(() => currency = value));

    await Common.getToken().then((onValue) {
      if (onValue != null) {
        if (mounted) {
          setState(() {
            getTokenValue = true;
            isTokenGetLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            getTokenValue = false;
            isTokenGetLoading = false;
          });
        }
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          getTokenValue = false;
          isTokenGetLoading = false;
        });
      }
      reportError.reportError(error, null);
    });
  }

  @override
  void dispose() {
    if (timer != null && timer!.isActive) {
      timer!.cancel();
    }
    super.dispose();
  }

  void _searchForProducts() async {
    final form = _formKeyForSearch.currentState!;
    if (form.validate()) {
      form.save();
      if (mounted) {
        setState(() {
          isFirstTime = false;
          isSearching = true;
          searchData();
          if (timer != null && timer!.isActive) timer!.cancel();
          timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
            if (lastApiCall == false) {
              productIndex++;
              searchData();
            }
          });
          FocusScopeNode currentScope = FocusScope.of(context);
          FocusScopeNode rootScope =
              WidgetsBinding.instance!.focusManager.rootScope;

          if (currentScope != rootScope) {
            currentScope.unfocus();
          }
        });
      }
    }
  }

  searchData() {
    setState(() {
      lastApiCall = true;
    });
    print(searchTerm);

    ProductService.getSearchList(searchTerm, productIndex, productLimt)
        .then((onValue) {
      if (mounted) {
        setState(() {
          setState(() {
            lastApiCall = false;
          });
          if (onValue['response_data'].length > 0) {
            searchresult.addAll(onValue['response_data']);
          } else {
            if (timer != null && timer!.isActive) timer!.cancel();
          }
          isSearching = false;
        });
      }
    }).catchError((error) {
      searchresult = [];
      if (mounted) {
        setState(() {
          isSearching = false;
        });
      }
      reportError.reportError(error, null);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (getTokenValue) {
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
    return new Scaffold(
      backgroundColor: bg(context),
      key: globalKey,
      body: isTokenGetLoading || isTokenGetLoading
          ? SquareLoader()
          : getTokenValue != true
              ? Login(
                  locale: widget.locale,
                  localizedValues: widget.localizedValues,
                  isCart: true,
                )
              : Form(
                  key: _formKeyForSearch,
                  child: ListView(
                    children: <Widget>[
                      Container(
                        color: primary(context),
                        padding: const EdgeInsets.only(
                            bottom: 15.0, left: 15.0, right: 15.0, top: 10),
                        child: Container(
                          child: new TextFormField(
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.search,
                            onEditingComplete: () {
                              FocusScopeNode currentScope =
                                  FocusScope.of(context);
                              FocusScopeNode rootScope = WidgetsBinding
                                  .instance!.focusManager.rootScope;

                              if (currentScope != rootScope) {
                                currentScope.unfocus();
                              }
                              productIndex = 0;
                              searchresult = [];
                              _searchForProducts();
                            },
                            controller: _controller,
                            style: new TextStyle(
                              color: Colors.black,
                            ),
                            onSaved: (String? value) {
                              if (mounted) {
                                setState(() {
                                  searchTerm = value;
                                });
                              }
                            },
                            validator: (String? value) {
                              if (value!.isEmpty) {
                                return MyLocalizations.of(context)!
                                    .getLocalizations("SEARCH_PRODUCTS");
                              } else
                                return null;
                            },
                            decoration: new InputDecoration(
                              prefixIcon: InkWell(
                                onTap: () {
                                  FocusScopeNode currentScope =
                                      FocusScope.of(context);
                                  FocusScopeNode rootScope = WidgetsBinding
                                      .instance!.focusManager.rootScope;

                                  if (currentScope != rootScope) {
                                    currentScope.unfocus();
                                  }
                                  productIndex = 0;
                                  searchresult = [];
                                  _searchForProducts();
                                },
                                child:
                                    new Icon(Icons.search, color: Colors.black),
                              ),
                              hintText: MyLocalizations.of(context)!
                                  .getLocalizations("SEARCH_PRODUCTS"),
                              hintStyle: new TextStyle(
                                color: greyb2,
                              ),
                              fillColor: Color(0xFFF0F0F0),
                              filled: true,
                              focusColor: Colors.black,
                              contentPadding: EdgeInsets.only(
                                  left: 15.0,
                                  right: 15.0,
                                  top: 10.0,
                                  bottom: 10.0),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: primary(context), width: 0.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: primary(context)),
                              ),
                            ),
                          ),
                        ),
                      ),
                      isFirstTime
                          ? searchPage(
                              context,
                              "TYPE_TO_SEARCH",
                              Icon(Icons.search,
                                  size: 50.0, color: primary(context)))
                          : searchresult.length > 0
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 18.0,
                                          bottom: 18.0,
                                          left: 20.0,
                                          right: 20),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                              searchresult.length.toString() +
                                                  " " +
                                                  MyLocalizations.of(context)!
                                                      .getLocalizations(
                                                          "ITEMS_FOUNDS"),
                                              style: textBarlowMediumBlack(
                                                  context)),
                                        ],
                                      ),
                                    ),
                                    GridView.builder(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 16, horizontal: 16),
                                        physics: ScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: searchresult.isEmpty
                                            ? 0
                                            : searchresult.length,
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
                                            (BuildContext context, int i) {
                                          if (searchresult[i]
                                                  ['averageRating'] ==
                                              null) {
                                            searchresult[i]['averageRating'] =
                                                0;
                                          }
                                          if (searchresult[i]
                                                  ['averageRating'] ==
                                              null) {
                                            searchresult[i]['averageRating'] =
                                                0;
                                          }
                                          return searchresult[i]
                                                          ['outOfStock'] !=
                                                      null ||
                                                  searchresult[i]
                                                          ['outOfStock'] !=
                                                      false
                                              ? InkWell(
                                                  onTap: () {
                                                    var result =
                                                        showModalBottomSheet(
                                                            isScrollControlled:
                                                                true,
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    bc) {
                                                              return Container(
                                                                height: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .height /
                                                                    1.45,
                                                                child:
                                                                    ProductDetails(
                                                                  locale: widget
                                                                      .locale,
                                                                  localizedValues:
                                                                      widget
                                                                          .localizedValues,
                                                                  productID:
                                                                      searchresult[
                                                                              i]
                                                                          [
                                                                          '_id'],
                                                                ),
                                                              );
                                                            });
                                                    result.then((value) {
                                                      productIndex = 0;
                                                      searchresult = [];
                                                      _searchForProducts();
                                                    });
                                                  },
                                                  child: ProductGridCard(
                                                    currency: currency,
                                                    productData:
                                                        searchresult[i],
                                                    isHome: false,
                                                  ),
                                                )
                                              : ProductGridCard(
                                                  currency: currency,
                                                  productData: searchresult[i],
                                                  isHome: false,
                                                );
                                        }),
                                  ],
                                )
                              : isSearching
                                  ? Center(child: SquareLoader())
                                  : searchPage(
                                      context,
                                      "NO_RESULT_FOUNDS",
                                      Icon(Icons.hourglass_empty,
                                          size: 50.0, color: primary(context)),
                                    )
                    ],
                  ),
                ),
      bottomNavigationBar: cartData == null
          ? Container(height: 1)
          : InkWell(
              onTap: () {
                FocusScopeNode currentScope = FocusScope.of(context);
                FocusScopeNode rootScope =
                    WidgetsBinding.instance!.focusManager.rootScope;

                if (currentScope != rootScope) {
                  currentScope.unfocus();
                }
                var result = Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => Home(
                        locale: widget.locale,
                        localizedValues: widget.localizedValues,
                        currentIndex: 2),
                  ),
                );
                result.then((value) {
                  if (searchTerm!.length > 0) {
                    productIndex = 0;
                    searchresult = [];
                    _searchForProducts();
                  }
                });
              },
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MyCart(
                                locale: widget.locale,
                                localizedValues: widget.localizedValues,
                              )));
                },
                child: cartInfoButton(context, cartData, currency),
              )),
    );
  }
}
