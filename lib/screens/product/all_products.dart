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
  final Map localizedValues;
  final String locale, dealId, categoryId, pageTitle;
  final int categoryIndex;

  AllProducts({
    Key key,
    this.locale,
    this.localizedValues,
    this.dealId,
    this.categoryId,
    this.pageTitle,
    this.categoryIndex
  });
  @override
  _AllProductsState createState() => _AllProductsState();
}

class _AllProductsState extends State<AllProducts> {
  bool isUserLoaggedIn = false,
      isFirstPageLoading = true,
      isNextPageLoading = false,
      isSubCategoryLoading = true,
      isProductsForDeal = false,
      isProductsForCategory = false;
  int productsPerPage = 12,
      productsPageNumber = 0,
      totalProducts = 1,
      selectedSubCategoryIndex = 0, selectedCategoryIndex = 0;
  List productsList = [], subCategoryList = [];
  bool isLoadingProductsList = false, isCategoryLoadingList = false;
  List categoryList;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  String currency, selectedCategoryId, selectedCategoryTitle;
  ScrollController _scrollController = ScrollController();

  var cartData;

  @override
  void initState() {
    super.initState();
    getCategoryList();
    selectedCategoryIndex = widget.categoryIndex;
    selectedCategoryId = widget.categoryId;
    if (widget.dealId != null) {
      isProductsForDeal = true;
      isSubCategoryLoading = false;
    } else if (selectedCategoryId != null) {
      isProductsForCategory = true;
    } else {
      getSubCategoryList();
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
    if (_scrollController != null) _scrollController.dispose();
    super.dispose();
  }

  void methodCallsInitiate() {
    if (isProductsForDeal) {
      getProductListByDealId();
    } else if (isProductsForCategory) {
      if (selectedSubCategoryIndex == 0) {
        getSubCategoryListByCategoryId();
      } else {
        getProductsListBySubCategoryId();
      }
    } else {
      if (selectedSubCategoryIndex == 0) {
        getProductsList();
      } else {
        getProductsListBySubCategoryId();
      }
    }
  }

  void checkIfUserIsLoaggedIn() async {
    setState(() {
      isFirstPageLoading = true;
    });
    productsList = [];
    productsPageNumber = productsList.length;
    totalProducts = 1;
    await Common.getCurrency().then((value) {
      currency = value;
    });
    await Common.getToken().then((onValue) {
      if (onValue != null) {
        isUserLoaggedIn = true;
      }
      methodCallsInitiate();
    });
  }

  void getSubCategoryList() async {
    await ProductService.getSubCatList().then((onValue) {
      if (onValue['response_data'] != null) {
        subCategoryList = onValue['response_data'] as List;
      }
      if (mounted)
        setState(() {
          isSubCategoryLoading = false;
        });
    }).catchError((error) {
      if (mounted) {
        setState(() {
          isSubCategoryLoading = false;
        });
      }
      sentryError.reportError(error, null);
    });
  }

  void getSubCategoryListByCategoryId() async {
    if (totalProducts != productsList.length) {
      if (productsPageNumber > 0) {
        setState(() {
          isNextPageLoading = true;
        });
      }
      await ProductService.getProductToCategoryList(
          selectedCategoryId, productsPageNumber, productsPerPage)
          .then((onValue) {
        _refreshController.refreshCompleted();
        if (onValue['response_data'] != null) {
          productsList.addAll(onValue['response_data']['products']);
          subCategoryList = onValue['response_data']['subCategories'];
          totalProducts = onValue["total"];
          productsPageNumber++;
        }
        if (mounted)
          setState(() {
            isSubCategoryLoading = false;
            isFirstPageLoading = false;
            isNextPageLoading = false;
          });
      }).catchError((error) {
        if (mounted) {
          setState(() {
            isSubCategoryLoading = false;
            isFirstPageLoading = false;
            isNextPageLoading = false;
          });
        }
        sentryError.reportError(error, null);
      });
    }
  }

  void getProductsList() async {
    if (totalProducts != productsList.length) {
      if (productsPageNumber > 0) {
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
          productsList.addAll(onValue['response_data']);
          totalProducts = onValue["total"];
          productsPageNumber++;
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

  void getProductsListBySubCategoryId() async {
    if (totalProducts != productsList.length) {
      if (productsPageNumber > 0) {
        setState(() {
          isNextPageLoading = true;
        });
      }
      await ProductService.getProductToSubCategoryList(
              subCategoryList[selectedSubCategoryIndex - 1]['_id'],
              productsPageNumber,
              productsPerPage)
          .then((onValue) {
        _refreshController.refreshCompleted();
        if (onValue['response_data'] != null &&
            onValue['response_data'] != []) {
          productsList.addAll(onValue['response_data']);
          totalProducts = onValue["total"];
          productsPageNumber++;
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
    if (totalProducts != productsList.length) {
      if (productsPageNumber > 0) {
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
          productsList.addAll(onValue['response_data']);
          totalProducts = onValue["total"];
          productsPageNumber++;
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

  getCategoryList() async {
    if (mounted) {
      setState(() {
        isCategoryLoadingList = true;
      });
    }
    await ProductService.getCategoryList().then((onValue) {
      _refreshController.refreshCompleted();
      if (mounted) {
        setState(() {
          categoryList = onValue['response_data'];
          isCategoryLoadingList = false;
        });
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          categoryList = [];
          isCategoryLoadingList = false;
        });
      }
      sentryError.reportError(error, null);
    });
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
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: primary(context),
        title:  isCategoryLoadingList
            ? SquareLoader()
            : isProductsForDeal
            ? Container()
            :  Container(
          height: 45,
          child: ListView.builder(
              physics: ScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: categoryList.length,
              itemBuilder: (BuildContext context, int i) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      selectedCategoryIndex = i;
                      selectedCategoryId = categoryList[i]['_id'];
                      selectedSubCategoryIndex = 0;
                    });
                    checkIfUserIsLoaggedIn();
                  },
                  child: categoryTab(
                    context,
                    categoryList[i]['title'],
                    selectedCategoryIndex == i
                        ? darkbg
                        : primary(context),
                  ),
                );
              }),
        ),
      ),
      // appBarWhite(
      //   context,
      //   widget.pageTitle,
      //   false,
      //   true,
      //   InkWell(
      //     onTap: () {
      //       var result = Navigator.push(
      //         context,
      //         MaterialPageRoute(
      //           builder: (context) => SearchItem(
      //             locale: widget.locale,
      //             localizedValues: widget.localizedValues,
      //             currency: currency,
      //             token: isUserLoaggedIn,
      //           ),
      //         ),
      //       );
      //       result.then((value) {
      //         checkIfUserIsLoaggedIn();
      //       });
      //     },
      //     child: Padding(
      //       padding: EdgeInsets.only(right: 15, left: 15),
      //       child: Icon(
      //         Icons.search,
      //       ),
      //     ),
      //   ),
      // ),
      body: isSubCategoryLoading
          ? Center(child: SquareLoader())
          : Column(
        mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                isSubCategoryLoading
                    ? SquareLoader()
                    : isProductsForDeal
                        ? Container()
                        : Container(
                            height: 45,
                            margin: EdgeInsets.only(top: 8),
                            child: ListView.builder(
                                physics: ScrollPhysics(),
                                shrinkWrap: true,
                                padding: EdgeInsets.only(left: 10, right: 10),
                                scrollDirection: Axis.horizontal,
                                itemCount: subCategoryList.length + 1,
                                itemBuilder: (BuildContext context, int i) {
                                  return InkWell(
                                    onTap: () {
                                      setState(() {
                                        selectedSubCategoryIndex = i;
                                        selectedCategoryTitle = i == 0
                                            ? MyLocalizations.of(context)
                                            .getLocalizations('ALL')
                                            : subCategoryList[i - 1]['title'];
                                      });
                                      checkIfUserIsLoaggedIn();
                                    },
                                    child: subCatTab(
                                      context,
                                      i == 0
                                          ? MyLocalizations.of(context)
                                              .getLocalizations('ALL')
                                          : subCategoryList[i - 1]['title'],
                                      selectedSubCategoryIndex == i
                                          ? primary(context)
                                          : Color(0xFFf0F0F0),
                                    ),
                                  );
                                }),
                          ),
                selectedCategoryTitle == null ? Container() :
                Container(
                    padding: EdgeInsets.only(left: 14, bottom: 16, top: 4),
                    child: Text(selectedCategoryTitle, style: textBarlowBoldBlack(context),)
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
                              itemCount: productsList.length == null
                                  ? 0
                                  : productsList.length,
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
                                          productID: productsList[i]['_id'],
                                        ),
                                      ),
                                    );
                                    result.then((value) {
                                      checkIfUserIsLoaggedIn();
                                    });
                                  },
                                  child: ProductGridCard(
                                    currency: currency,
                                    productData: productsList[i],
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
