import 'package:flutter/material.dart';
import 'package:readymade_grocery_app/model/counterModel.dart';
import 'package:readymade_grocery_app/screens/authe/login.dart';
import 'package:readymade_grocery_app/screens/home/home.dart';
import 'package:readymade_grocery_app/screens/product/product-details.dart';
import 'package:readymade_grocery_app/service/common.dart';
import 'package:readymade_grocery_app/service/sentry-service.dart';
import 'package:readymade_grocery_app/service/fav-service.dart';
import 'package:readymade_grocery_app/style/style.dart';
import 'package:readymade_grocery_app/widgets/appBar.dart';
import 'package:readymade_grocery_app/widgets/button.dart';
import 'package:readymade_grocery_app/widgets/loader.dart';
import 'package:readymade_grocery_app/widgets/normalText.dart';
import 'package:readymade_grocery_app/widgets/product_gridcard.dart';

SentryError sentryError = new SentryError();

class SavedItems extends StatefulWidget {
  final Map? localizedValues;
  final String? locale;

  SavedItems({Key? key, this.locale, this.localizedValues}) : super(key: key);
  @override
  _SavedItemsState createState() => _SavedItemsState();
}

class _SavedItemsState extends State<SavedItems> {
  bool isGetTokenLoading = false, isFavListLoading = false;
  String? token, currency;
  List<dynamic>? favProductList;
  var cartData;
  @override
  void initState() {
    getToken();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  getFavListMethod() async {
    if (mounted) {
      setState(() {
        isFavListLoading = true;
      });
    }
    await FavouriteService.getFavList().then((onValue) {
      if (mounted) {
        setState(() {
          isFavListLoading = false;
        });
      }
      if (mounted) {
        setState(() {
          favProductList = onValue['response_data'];
        });
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          isFavListLoading = false;
          favProductList = [];
        });
      }
      sentryError.reportError(error, null);
    });
  }

  getToken() async {
    if (mounted) {
      setState(() {
        isGetTokenLoading = true;
      });
    }
    await Common.getCurrency().then((value) {
      currency = value;
    });
    await Common.getToken().then((onValue) {
      if (onValue != null) {
        if (mounted) {
          setState(() {
            isGetTokenLoading = false;
            token = onValue;
            getFavListMethod();
          });
        }
      } else {
        if (mounted) {
          setState(() {
            isGetTokenLoading = false;
          });
        }
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          isGetTokenLoading = false;
        });
      }
      sentryError.reportError(error, null);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (token != null) {
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
    return Scaffold(
      backgroundColor: bg(context),
      appBar: isGetTokenLoading
          ? null
          : token == null
              ? null
              : appBarTransparent(context, "FAVORITE") as PreferredSizeWidget,
      body: isGetTokenLoading
          ? SquareLoader()
          : token == null
              ? Login(
                  locale: widget.locale,
                  localizedValues: widget.localizedValues,
                  isSaveItem: true,
                )
              : isFavListLoading
                  ? SquareLoader()
                  : favProductList?.length != 0
                      ? GridView.builder(
                          padding: EdgeInsets.symmetric(
                              vertical: 16, horizontal: 16),
                          physics: ScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: favProductList?.length == null
                              ? 0
                              : favProductList?.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio:
                                      MediaQuery.of(context).size.width / 520,
                                  crossAxisSpacing: 16,
                                  mainAxisSpacing: 16),
                          itemBuilder: (BuildContext context, int i) {
                            if (favProductList?[i]['averageRating'] == null) {
                              favProductList?[i]['averageRating'] = 0;
                            }

                            return InkWell(
                                onTap: () {
                                  var result = Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProductDetails(
                                        locale: widget.locale,
                                        localizedValues: widget.localizedValues,
                                        productID: favProductList?[i]['_id'],
                                      ),
                                    ),
                                  );
                                  result.then((value) {
                                    getToken();
                                  });
                                },
                                child: ProductGridCard(
                                  currency: currency,
                                  productData: favProductList?[i],
                                  isHome: false,
                                ));
                          },
                        )
                      : noDataImage(),
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
                result.then((value) => getToken());
              },
              child: cartInfoButton(context, cartData, currency)),
    );
  }
}
