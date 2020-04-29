import 'package:flutter/material.dart';

import 'package:getflutter/getflutter.dart';
import 'package:grocery_pro/screens/product/product-details.dart';
import 'package:grocery_pro/service/common.dart';
import 'package:grocery_pro/service/fav-service.dart';
import 'package:grocery_pro/service/product-service.dart';
import 'package:grocery_pro/service/sentry-service.dart';
import 'package:grocery_pro/widgets/loader.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:grocery_pro/widgets/productCard.dart';
import 'package:grocery_pro/widgets/subCategoryProductCart.dart';
import 'package:grocery_pro/style/style.dart';

import '../../style/style.dart';

SentryError sentryError = new SentryError();

class SubCategories extends StatefulWidget {
  final String catTitle, locale, catId;
  final bool token;
  final Map<String, Map<String, String>> localizedValues;

  SubCategories(
      {Key key,
      this.catId,
      this.catTitle,
      this.locale,
      this.localizedValues,
      this.token})
      : super(key: key);
  @override
  _SubCategoriesState createState() => _SubCategoriesState();
}

class _SubCategoriesState extends State<SubCategories> {
  bool isLoadingSubProductsList = false;
  List subProductsList, favProductList;
  String currency;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  @override
  void initState() {
    if (widget.token == true) {
      getProductToCategoryCartAdded(widget.catId);

      getFavListApi();
    } else {
      getProductToCategory(widget.catId);
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  getProductToCategory(id) async {
    if (mounted) {
      setState(() {
        isLoadingSubProductsList = true;
      });
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    currency = prefs.getString('currency');
    await ProductService.getProductToCategoryList(id).then((onValue) {
      try {
        if (mounted)
          setState(() {
            subProductsList = onValue['response_data'];
            isLoadingSubProductsList = false;
            _refreshController.refreshCompleted();
          });
      } catch (error, stackTrace) {
        sentryError.reportError(error, stackTrace);
      }
    }).catchError((error) {
      sentryError.reportError(error, null);
    });
  }

  getProductToCategoryCartAdded(id) async {
    if (mounted) {
      setState(() {
        isLoadingSubProductsList = true;
      });
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    currency = prefs.getString('currency');
    await ProductService.getProductToCategoryListCartAdded(id).then((onValue) {
      try {
        if (mounted)
          setState(() {
            subProductsList = onValue['response_data'];
            isLoadingSubProductsList = false;
            _refreshController.refreshCompleted();
          });
      } catch (error, stackTrace) {
        sentryError.reportError(error, stackTrace);
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
        title: Text(
          '${widget.catTitle}',
          style: TextStyle(
              color: Colors.black, fontSize: 17.0, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black, size: 1.0),
      ),
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: false,
        header: WaterDropHeader(),
        controller: _refreshController,
        onRefresh: () {
          if (widget.token) {
            getProductToCategoryCartAdded(widget.catId);
          } else {
            getProductToCategory(widget.catId);
          }
        },
        child: isLoadingSubProductsList
            ? SquareLoader()
            : ListView(
            children: <Widget>[
              Container(
                height: 120,

                child: Column(
                  children: <Widget>[
                    Container(
                      height: 53,
                      padding: EdgeInsets.only(top:5),
                      margin: EdgeInsets.only(left: 20, right:20),
                      decoration: BoxDecoration(
                          color: Color(0xFFF0F0F0),
                          borderRadius: BorderRadius.all(Radius.circular(8))
                      ),
                      child: TextFormField(
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.search, color: blacktext,),
                            border: InputBorder.none,
                            hintText: 'What are you buying today?',
                            hintStyle: textBarlowRegularBlackwithOpa()
                        ),
                        style: textBarlowRegularBlackwithOpa(),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 20, right:20, top:20),
                      height: 35,
                      child:  ListView(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        children: <Widget>[
                          Container(
                            height:35,
                            padding: EdgeInsets.only(left: 25, right: 25, top:8),
                            margin: EdgeInsets.only(right: 15),
                            decoration: BoxDecoration(
                                color: Color(0xFFFFCF2D),
                                borderRadius: BorderRadius.all(Radius.circular(4))
                            ),
                            child: Text('All', textAlign: TextAlign.center, style: textbarlowMediumBlackm(),),
                          ),

                          Container(
                            height:35,
                            padding: EdgeInsets.only(left: 15, right: 15,  top:8),
                            margin: EdgeInsets.only(right: 15),
                            decoration: BoxDecoration(
                                color: Color(0xFFf0F0F0),
                                border: Border.all(color: Color(0xFFDFDFDF)),
                                borderRadius: BorderRadius.all(Radius.circular(4))
                            ),
                            child: Text('Newly Arrived', textAlign: TextAlign.center, style: textbarlowMediumBlackm(),),
                          ),
                          Container(
                            height:35,
                            padding: EdgeInsets.only(left: 15, right: 15,  top:8),
                            margin: EdgeInsets.only(right: 15),
                            decoration: BoxDecoration(
                                color: Color(0xFFf0F0F0),
                                border: Border.all(color: Color(0xFFDFDFDF)),
                                borderRadius: BorderRadius.all(Radius.circular(4))
                            ),
                            child: Text('Best Deals', textAlign: TextAlign.center, style: textbarlowMediumBlackm(),),
                          ),
                          Container(
                            height:35,
                            padding: EdgeInsets.only(left: 15, right: 15,  top:8),
                            margin: EdgeInsets.only(right: 15),
                            decoration: BoxDecoration(
                                color: Color(0xFFf0F0F0),
                                border: Border.all(color: Color(0xFFDFDFDF)),
                                borderRadius: BorderRadius.all(Radius.circular(4))
                            ),
                            child: Text('Imported', textAlign: TextAlign.center, style: textbarlowMediumBlackm(),),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),

                  Container(
                      height: MediaQuery.of(context).size.height - 201,
                      child: ListView(
                          children: <Widget>[
                        Stack(
              children: <Widget>[
                subProductsList.length == 0
                    ? Center(
                  child: Image.asset('lib/assets/images/no-orders.png'),
                )
                    : GridView.builder(

                  padding: EdgeInsets.symmetric(
                      horizontal: 16, vertical: 16),
                  physics: ScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: subProductsList.length == null
                      ? 0
                      : subProductsList.length,
                  gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
//                      childAspectRatio:
//                      MediaQuery.of(context).size.width / 500,
                      childAspectRatio:
                      MediaQuery.of(context).size.width / 580,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16),
                  itemBuilder: (BuildContext context, int i) {
                    if (subProductsList[i]['averageRating'] == null) {
                      subProductsList[i]['averageRating'] = 0;
                    }

                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductDetails(
                                locale: widget.locale,
                                localizedValues: widget.localizedValues,
                                productID: subProductsList[i]['_id'],
                                favProductList: widget.token
                                    ? favProductList
                                    : null),
                          ),
                        );
                      },
                      child: Stack(
                        children: <Widget>[
                          SubCategoryProductCard(
                            image: subProductsList[i]['imageUrl'],

                            title:
                            subProductsList[i]['title'].length > 10
                                ? subProductsList[i]['title']
                                .substring(0, 10) +
                                ".."
                                : subProductsList[i]['title'],
                            currency: currency,
                            category: subProductsList[i]['category'],
                            price: subProductsList[i]['variant'][0]
                            ['price'],
                            rating: subProductsList[i]['averageRating']
                                .toString(),
                            buttonName:
                            subProductsList[i]['cartAdded'] == true
                                ? "Added"
                                : "Add",
                            token: widget.token,
                            productList: subProductsList[i],
                            variantList: subProductsList[i]['variant'],
                          ),
                          subProductsList[i]['isDealAvailable'] == true
                              ? Positioned(
                            child: Stack(
                              children: <Widget>[
                                Image.asset(
                                    'lib/assets/images/badge.png'),
                                Text(
                                  " " +
                                      subProductsList[i]
                                      ['delaPercent']
                                          .toString() +
                                      "% Off",
                                  style: hintSfboldwhitemed(),
                                  textAlign: TextAlign.center,
                                )
                              ],
                            ),
                          )
                              : Container()
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),


                        ],
                        ),

                  )
//
            ],
          ),

      ),
    );
  }
}
