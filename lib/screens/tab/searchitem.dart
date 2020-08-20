import 'package:flutter/material.dart';
import 'package:readymadeGroceryApp/model/counterModel.dart';
import 'package:readymadeGroceryApp/screens/home/home.dart';
import 'package:readymadeGroceryApp/screens/product/product-details.dart';
import 'package:readymadeGroceryApp/service/common.dart';
import 'package:readymadeGroceryApp/service/localizations.dart';
import 'package:readymadeGroceryApp/service/product-service.dart';
import 'package:readymadeGroceryApp/service/sentry-service.dart';
import 'package:readymadeGroceryApp/style/style.dart';
import 'package:readymadeGroceryApp/widgets/button.dart';
import 'package:readymadeGroceryApp/widgets/loader.dart';
import 'package:readymadeGroceryApp/widgets/normalText.dart';
import 'package:readymadeGroceryApp/widgets/subCategoryProductCart.dart';

SentryError sentryError = new SentryError();

class SearchItem extends StatefulWidget {
  final String currency, locale;
  final bool token;
  final Map localizedValues;
  SearchItem(
      {Key key, this.currency, this.locale, this.token, this.localizedValues})
      : super(key: key);
  @override
  _SearchItemState createState() => _SearchItemState();
}

class _SearchItemState extends State<SearchItem> {
  final globalKey = new GlobalKey<ScaffoldState>();
  final TextEditingController _controller = new TextEditingController();
  bool isSearching = false,
      isFirstTime = true,
      getTokenValue = false,
      isTokenGetLoading = false;
  List searchresult = new List();
  String cartId, searchTerm;
  var cartData;
  String currency;

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
    await Common.getCurrency().then((value) {
      currency = value;
    });
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
      sentryError.reportError(error, null);
    });
  }

  void _searchForProducts(String query) async {
    searchTerm = query;
    if (query.length > 2) {
      if (mounted) {
        setState(() {
          isFirstTime = false;
          isSearching = true;
        });
      }
      ProductService.getSearchList(query).then((onValue) {
        if (mounted) {
          setState(() {
            searchresult = onValue['response_data'];
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
        sentryError.reportError(error, null);
      });
    } else {
      searchresult = [];
      if (mounted) {
        setState(() {
          isFirstTime = true;
          isSearching = false;
        });
      }
    }
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
      key: globalKey,
      body: isTokenGetLoading
          ? SquareLoader()
          : ListView(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                      bottom: 15.0, left: 15.0, right: 15.0, top: 50.0),
                  child: Container(
                    child: new TextField(
                      controller: _controller,
                      style: new TextStyle(
                        color: Colors.black,
                      ),
                      decoration: new InputDecoration(
                        prefixIcon: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child:
                              new Icon(Icons.arrow_back, color: Colors.black),
                        ),
                        hintText: MyLocalizations.of(context)
                            .getLocalizations("WHAT_ARE_YOU_BUING_TODAY"),
                        fillColor: Color(0xFFF0F0F0),
                        filled: true,
                        focusColor: Colors.black,
                        contentPadding: EdgeInsets.only(
                          left: 15.0,
                          right: 15.0,
                          top: 10.0,
                          bottom: 10.0,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: primary, width: 0.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: primary),
                        ),
                      ),
                      onSubmitted: (String term) {
                        searchTerm = term;

                        _searchForProducts(term);
                      },
                      onChanged: _searchForProducts,
                    ),
                  ),
                ),
                isFirstTime
                    ? searchPage(
                        context,
                        "TYPE_TO_SEARCH",
                        Icon(Icons.search, size: 50.0, color: primary),
                      )
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
                                            MyLocalizations.of(context)
                                                .getLocalizations(
                                                    "ITEMS_FOUNDS"),
                                        style: textBarlowMediumBlack()),
                                  ],
                                ),
                              ),
                              GridView.builder(
                                padding: EdgeInsets.symmetric(
                                    vertical: 16, horizontal: 16),
                                physics: ScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: searchresult.length == null
                                    ? 0
                                    : searchresult.length,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        childAspectRatio:
                                            MediaQuery.of(context).size.width /
                                                520,
                                        crossAxisSpacing: 16,
                                        mainAxisSpacing: 16),
                                itemBuilder: (BuildContext context, int index) {
                                  if (searchresult[index]['averageRating'] ==
                                      null) {
                                    searchresult[index]['averageRating'] = 0;
                                  }
                                  return InkWell(
                                    onTap: () {
                                      var result = Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ProductDetails(
                                            locale: widget.locale,
                                            localizedValues:
                                                widget.localizedValues,
                                            productID: searchresult[index]
                                                ['_id'],
                                          ),
                                        ),
                                      );
                                      result.then((value) {
                                        if (value != null) {
                                          searchresult = [];
                                          _searchForProducts(searchTerm);
                                        }
                                      });
                                    },
                                    child: Stack(
                                      children: <Widget>[
                                        SubCategoryProductCard(
                                          currency: currency,
                                          price: searchresult[index]['variant']
                                              [0]['price'],
                                          productData: searchresult[index],
                                          variantList: searchresult[index]
                                              ['variant'],
                                        ),
                                        searchresult[index]
                                                    ['isDealAvailable'] ==
                                                true
                                            ? buildBadge(
                                                context,
                                                searchresult[index]
                                                        ['dealPercent']
                                                    .toString(),
                                                "OFF")
                                            : Container()
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          )
                        : isSearching
                            ? Center(
                                child: SquareLoader(),
                              )
                            : searchPage(
                                context,
                                "NO_RESULT_FOUNDS",
                                Icon(Icons.hourglass_empty,
                                    size: 50.0, color: primary),
                              )
              ],
            ),
      bottomNavigationBar: cartData == null
          ? Container(height: 1)
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
                  if (searchTerm == null) {
                    getCurrency();
                  } else {
                    searchresult = [];
                    _searchForProducts(searchTerm);
                  }
                });
              },
              child: cartInfoButton(context, cartData, currency)),
    );
  }
}
