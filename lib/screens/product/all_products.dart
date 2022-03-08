import 'package:flutter/material.dart';
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
      isFirstPageLoading = true,
      isNextPageLoading = false,
      isCategoryLoading = true,
      isProductsForDeal = false,
      isProductsForCategory = false;
  int? productsPerPage = 12,
      productsPageNumber = 0,
      totalProducts = 1,
      selectedCategoryIndex = 0;
  List? productsList = [], categoryList = [];
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  String? currency;
  ScrollController _scrollController = ScrollController();

  var cartData;

  @override
  void initState() {
    super.initState();
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
    if (isUserLoaggedIn) {
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
      appBar: appBarWhite(
        context,
        widget.pageTitle,
        false,
        true,
        InkWell(
          onTap: () {
            var result = Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SearchItem(
                  locale: widget.locale,
                  localizedValues: widget.localizedValues,
                  currency: currency,
                  token: isUserLoaggedIn,
                ),
              ),
            );
            result.then((value) {
              checkIfUserIsLoaggedIn();
            });
          },
          child: Padding(
            padding: EdgeInsets.only(right: 15, left: 15),
            child: Icon(
              Icons.search,
            ),
          ),
        ),
      ) as PreferredSizeWidget?,
      body: isCategoryLoading
          ? Center(child: SquareLoader())
          : Column(
              children: [
                isCategoryLoading
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
                          ),
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
