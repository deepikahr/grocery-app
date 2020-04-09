import 'package:flutter/material.dart';

import 'package:getflutter/getflutter.dart';
import 'package:grocery_pro/screens/product/product-details.dart';
import 'package:grocery_pro/service/common.dart';
import 'package:grocery_pro/service/fav-service.dart';
import 'package:grocery_pro/service/product-service.dart';
import 'package:grocery_pro/service/sentry-service.dart';
import 'package:shared_preferences/shared_preferences.dart';

SentryError sentryError = new SentryError();

class SubCategories extends StatefulWidget {
  final String catTitle;
  final String catId;

  SubCategories({Key key, this.catId, this.catTitle}) : super(key: key);
  @override
  _SubCategoriesState createState() => _SubCategoriesState();
}

class _SubCategoriesState extends State<SubCategories> {
  bool isLoadingSubProductsList = false, getTokenValue = false;
  List subProductsList, favProductList;
  String currency;
  @override
  void initState() {
    getToken();
    super.initState();
    getProductToCategory(widget.catId);
  }

  @override
  void dispose() {
    super.dispose();
  }

  getProductToCategory(id) async {
    if (mounted)
      setState(() {
        isLoadingSubProductsList = true;
      });
    await ProductService.getProductToCategoryList(id).then((onValue) {
      try {
        if (mounted)
          setState(() {
            subProductsList = onValue['response_data'];
            isLoadingSubProductsList = false;
          });
      } catch (error, stackTrace) {
        sentryError.reportError(error, stackTrace);
      }
    }).catchError((error) {
      sentryError.reportError(error, null);
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GFAppBar(
        title: Text('${widget.catTitle}',
            style: TextStyle(
                color: Colors.black,
                fontSize: 17.0,
                fontWeight: FontWeight.w600)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black, size: 1.0),
      ),
      body: isLoadingSubProductsList
          ? Center(child: CircularProgressIndicator())
          : Stack(
              children: <Widget>[
                subProductsList.length == 0
                    ? Center(
                        child: Image.asset('lib/assets/images/no-orders.png'),
                      )
                    : GridView.builder(
                        physics: ScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: subProductsList.length == null
                            ? 0
                            : subProductsList.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2),
                        itemBuilder: (BuildContext context, int i) {
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProductDetails(
                                      productDetail: subProductsList[i],
                                      favProductList: getTokenValue
                                          ? favProductList
                                          : null),
                                ),
                              );
                            },
                            child: GFCard(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0)),
                              boxFit: BoxFit.fill,
                              colorFilter: new ColorFilter.mode(
                                  Colors.black.withOpacity(0.67),
                                  BlendMode.darken),
                              content: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Stack(
                                    fit: StackFit.loose,
                                    children: <Widget>[
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 20, top: 15.0),
                                            child: Image.network(
                                              subProductsList[i]['imageUrl'],
                                              fit: BoxFit.fill,
                                              width: 80,
                                              height: 70,
                                            ),
                                          ),
                                        ],
                                      ),
                                      subProductsList[i]['discount'] == null
                                          ? Positioned(
                                              height: 15.0,
                                              width: 60.0,
                                              child: GFButtonBadge(
                                                onPressed: () {},
                                                text: '',
                                                color: Colors.white,
                                              ),
                                            )
                                          : Positioned(
                                              height: 15.0,
                                              width: 60.0,
                                              child: GFButtonBadge(
                                                onPressed: () {},
                                                text: subProductsList[i]
                                                    ['discount'],
                                                color: Colors.deepOrange[300],
                                              ),
                                            ),
                                      Positioned(
                                        height: 15.0,
                                        width: 60.0,
                                        // top: 4.0,
                                        bottom: 78.0,
                                        left: 80.0,
                                        child: GFIconButton(
                                          onPressed: null,
                                          icon: GestureDetector(
                                            onTap: () {},
                                          ),
                                          type: GFButtonType.transparent,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 10.0),
                                            child: Text(
                                                subProductsList[i]['title']),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 2.0),
                                            child: Row(
                                              children: <Widget>[
                                                Text(
                                                  currency,
                                                  style: TextStyle(
                                                      color: const Color(
                                                          0xFF00BFA5)),
                                                ),
                                                Text(
                                                  subProductsList[i]['variant']
                                                          [0]['price']
                                                      .toString(),
                                                  style: TextStyle(
                                                      color: const Color(
                                                          0xFF00BFA5)),
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ],
            ),
    );
  }
}
