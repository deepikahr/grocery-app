import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';
import 'package:grocery_pro/model/bottomSheet.dart';
import 'package:grocery_pro/screens/authe/login.dart';
import 'package:grocery_pro/screens/product/product-details.dart';
import 'package:grocery_pro/service/localizations.dart';
import 'package:grocery_pro/service/product-service.dart';
import 'package:grocery_pro/service/sentry-service.dart';
import 'package:grocery_pro/style/style.dart';
import 'package:grocery_pro/widgets/loader.dart';

SentryError sentryError = new SentryError();

class SearchItem extends StatefulWidget {
  final List productsList, favProductList;
  final String currency, locale;
  final bool token;
  final Map<String, Map<String, String>> localizedValues;
  SearchItem(
      {Key key,
      this.productsList,
      this.favProductList,
      this.currency,
      this.locale,
      this.token,
      this.localizedValues})
      : super(key: key);
  @override
  _SearchItemState createState() => _SearchItemState();
}

class _SearchItemState extends State<SearchItem> {
  final globalKey = new GlobalKey<ScaffoldState>();
  final TextEditingController _controller = new TextEditingController();
  bool isSearching = false, isFirstTime = true;
  List searchresult = new List();

  void _searchForProducts(String query) async {
    if (query.length > 2) {
      if (mounted) {
        setState(() {
          isFirstTime = false;
          isSearching = true;
        });
      }
      ProductService.getSearchList(query).then((onValue) {
        try {
          if (onValue != null && onValue['response_data'] is List) {
            if (mounted) {
              setState(() {
                searchresult = onValue['response_data'];
              });
            }
          } else {
            if (mounted) {
              setState(() {
                searchresult = [];
              });
            }
          }
          if (mounted) {
            setState(() {
              isSearching = false;
            });
          }
        } catch (error, stackTrace) {
          sentryError.reportError(error, stackTrace);
        }
      }).catchError((error) {
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

  void _searchForProductsCartAdded(String query) async {
    if (query.length > 2) {
      if (mounted) {
        setState(() {
          isFirstTime = false;
          isSearching = true;
        });
      }
      ProductService.getSearchListCartAdded(query).then((onValue) {
        try {
          if (onValue != null && onValue['response_data'] is List) {
            if (mounted) {
              setState(() {
                searchresult = onValue['response_data'];
              });
            }
          } else {
            if (mounted) {
              setState(() {
                searchresult = [];
              });
            }
          }
          if (mounted) {
            setState(() {
              isSearching = false;
            });
          }
        } catch (error, stackTrace) {
          sentryError.reportError(error, stackTrace);
        }
      }).catchError((error) {
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
    return new Scaffold(
      key: globalKey,
      body: ListView(
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
                    child: new Icon(Icons.arrow_back, color: Colors.black),
                  ),
                  hintText:
                      MyLocalizations.of(context).whatareyoubuyingtoday + "?",
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
                  if (widget.token == true) {
                    _searchForProductsCartAdded(term);
                  } else {
                    _searchForProducts(term);
                  }
                },
                onChanged: widget.token == true
                    ? _searchForProductsCartAdded
                    : _searchForProducts,
              ),
            ),
          ),
          isFirstTime
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 100.0),
                      child: Text(
                        MyLocalizations.of(context).typeToSearch,
                        textAlign: TextAlign.center,
                        style: hintSfMediumprimary(),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Icon(
                      Icons.search,
                      size: 50.0,
                      color: primary,
                    ),
                  ],
                )
              : searchresult.length > 0
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 18.0, bottom: 18.0, left: 20.0, right: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                  searchresult.length.toString() +
                                      " " +
                                      MyLocalizations.of(context).iteamsFounds,
                                  style: textBarlowMediumBlack()),
                            ],
                          ),
                        ),
                        new ListView.builder(
                          shrinkWrap: true,
                          itemCount: searchresult.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              margin: EdgeInsets.only(bottom: 20),
                              color: Colors.grey[100],
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProductDetails(
                                          locale: widget.locale,
                                          localizedValues:
                                              widget.localizedValues,
                                          productID: searchresult[index]['_id'],
                                          favProductList:
                                              widget.favProductList == null
                                                  ? null
                                                  : widget.favProductList),
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: <Widget>[
                                      new ListTile(
                                        leading: Image(
                                          height: 60,
                                          width: 90,
                                          image: NetworkImage(
                                              searchresult[index]['imageUrl']),
                                        ),
                                        title: new Text(
                                          searchresult[index]['title'].length >
                                                  20
                                              ? searchresult[index]['title']
                                                      .substring(0, 20) +
                                                  ".."
                                              : searchresult[index]['title']
                                                  .toString(),
                                          style: textbarlowRegularBlack(),
                                        ),
                                        subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                new Text(
                                                  widget.currency +
                                                      searchresult[index]
                                                                  ['variant'][0]
                                                              ['price']
                                                          .toString() +
                                                      "/" +
                                                      searchresult[index]
                                                                  ['variant'][0]
                                                              ['unit']
                                                          .toString(),
                                                  style:
                                                      textBarlowMediumGreen(),
                                                ),
                                                searchresult[index][
                                                            'isDealAvailable'] ==
                                                        true
                                                    ? Container(
                                                        height: 20,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    20),
                                                            bottomRight:
                                                                Radius.circular(
                                                                    20),
                                                          ),
                                                        ),
                                                        child: GFButtonBadge(
                                                          text:
                                                              "${searchresult[index]['delaPercent']}% off",
                                                          onPressed: null,
                                                          color: Colors
                                                              .deepOrange[300],
                                                        ),
                                                      )
                                                    : Container()
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5.0,
                                            ),
                                            searchresult[index]['cartAdded'] ==
                                                    true
                                                ? Container(
                                                    height: 22,
                                                    child: GFButton(
                                                      onPressed: () async {},
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 18.0,
                                                                right: 18.0),
                                                        child: Text("Added"),
                                                      ),
                                                      type: GFButtonType.solid,
                                                      color: Colors.green,
                                                      size: GFSize.MEDIUM,
                                                    ),
                                                  )
                                                : Container(
                                                    height: 22,
                                                    child: GFButton(
                                                      onPressed: () async {
                                                        showModalBottomSheet(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    bc) {
                                                              return BottonSheetClassDryClean(
                                                                  locale: widget
                                                                      .locale,
                                                                  localizedValues:
                                                                      widget
                                                                          .localizedValues,
                                                                  currency: widget
                                                                      .currency,
                                                                  productList:
                                                                      searchresult[
                                                                          index],
                                                                  variantsList:
                                                                      searchresult[
                                                                              index]
                                                                          [
                                                                          'variant']);
                                                            });
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 18.0,
                                                                right: 18.0),
                                                        child: Text("Add"),
                                                      ),
                                                      type: GFButtonType.solid,
                                                      color: primary,
                                                      size: GFSize.MEDIUM,
                                                    ),
                                                  ),
                                            SizedBox(
                                              height: 5.0,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
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
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 100.0),
                              child: Text(
                                MyLocalizations.of(context).noResultsFound,
                                textAlign: TextAlign.center,
                                style: hintSfMediumprimary(),
                              ),
                            ),
                            SizedBox(height: 20.0),
                            Icon(
                              Icons.hourglass_empty,
                              size: 50.0,
                              color: primary,
                            ),
                          ],
                        )
        ],
      ),
    );
  }
}
