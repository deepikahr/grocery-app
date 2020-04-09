import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';
import 'package:grocery_pro/screens/authe/login.dart';
import 'package:grocery_pro/screens/product/product-details.dart';
import 'package:grocery_pro/service/common.dart';
import 'package:grocery_pro/service/sentry-service.dart';
import 'package:grocery_pro/service/fav-service.dart';
import 'package:grocery_pro/style/style.dart';
import 'package:shared_preferences/shared_preferences.dart';

SentryError sentryError = new SentryError();

class SavedItems extends StatefulWidget {
  @override
  _SavedItemsState createState() => _SavedItemsState();
}

class _SavedItemsState extends State<SavedItems> {
  bool isGetTokenLoading = false;
  bool isFavListLoading = false;
  String token, currency;
  List<dynamic> favProductList;
  @override
  void initState() {
    getToken();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  getFavListApi() async {
    if (mounted) {
      setState(() {
        isFavListLoading = true;
      });
    }
    await FavouriteService.getFavList().then((onValue) {
      try {
        if (mounted) {
          setState(() {
            isFavListLoading = false;
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

  getToken() async {
    if (mounted) {
      setState(() {
        isGetTokenLoading = true;
      });
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    currency = prefs.getString('currency');
    await Common.getToken().then((onValue) {
      try {
        if (onValue != null) {
          if (mounted) {
            setState(() {
              isGetTokenLoading = false;
              token = onValue;
              getFavListApi();
            });
          }
        } else {
          if (mounted) {
            setState(() {
              isGetTokenLoading = false;
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isGetTokenLoading
          ? null
          : token == null
              ? null
              : GFAppBar(
                  title: Text(
                    'Saved Items',
                    style: textbarlowSemiBoldBlack(),
                  ),
                  centerTitle: true,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  automaticallyImplyLeading: false,
                ),
      body: isGetTokenLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : token == null
              ? Login()
              : isFavListLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : favProductList.length != 0
                      ? GridView.builder(
                          physics: ScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: favProductList.length == null
                              ? 0
                              : favProductList.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2),
                          itemBuilder: (BuildContext context, int i) {
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductDetails(
                                      productDetail: favProductList[i]
                                          ['product'],
                                      favProductList: favProductList,
                                    ),
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
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 8.0),
                                          child: favProductList[i]['product']
                                                      ['discount'] ==
                                                  null
                                              ? Container(
                                                  height: 15,
                                                  width: 65,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(20),
                                                      bottomRight:
                                                          Radius.circular(20),
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
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(20),
                                                      bottomRight:
                                                          Radius.circular(20),
                                                    ),
                                                  ),
                                                  child: GFButtonBadge(
                                                    onPressed: null,
                                                    text: favProductList[i]
                                                        ['product']['discount'],
                                                    color:
                                                        Colors.deepOrange[300],
                                                  ),
                                                ),
                                        ),
                                      ],
                                    ),
                                    favProductList[i]['product']['imageUrl'] ==
                                            null
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Padding(
                                                padding:
                                                    const EdgeInsets.only(),
                                                child: Image.asset(
                                                  "lib/assets/images/no-orders.png",
                                                  fit: BoxFit.fill,
                                                  width: 124,
                                                  height: 60,
                                                ),
                                              ),
                                            ],
                                          )
                                        :

                                    Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Padding(
                                                padding:
                                                    const EdgeInsets.only(),
                                                child: Image.network(
                                                  favProductList[i]['product']
                                                      ['imageUrl'],
                                                  fit: BoxFit.cover,
                                                  width: 124,
                                                  height: 63,
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
                                                  top: 5.0),
                                              child: Text(
                                                favProductList[i]['product']
                                                    ['title'],
                                                style: textBarlowRegularBlack(),
                                              ),
                                            ),
                                            Row(
                                              children: <Widget>[
                                                Text(
                                                  currency,
                                                  style: textbarlowBoldGreen(),
                                                ),
                                                Text(
                                                  '${favProductList[i]['product']['variant'][0]['price']}',
                                                  style: textbarlowBoldGreen(),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        )
                      : Center(
                          child: Image.asset('lib/assets/images/no-orders.png'),
                        ),
    );
  }
}
