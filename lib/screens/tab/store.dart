import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';
import 'package:grocery_pro/screens/categories/allcategories.dart';
import 'package:grocery_pro/screens/categories/subcategories.dart';
import 'package:grocery_pro/screens/product/product-details.dart';
import 'package:grocery_pro/screens/tab/searchitem.dart';
import 'package:grocery_pro/service/common.dart';
import 'package:grocery_pro/service/fav-service.dart';
import 'package:grocery_pro/service/product-service.dart';
import 'package:grocery_pro/service/sentry-service.dart';
import 'package:grocery_pro/style/style.dart';
import 'package:shared_preferences/shared_preferences.dart';

SentryError sentryError = new SentryError();

class Post {
  final String title;
  final String description;

  Post(this.title, this.description);
}

Future<List<Post>> search(String search) async {
  await Future.delayed(Duration(seconds: 2));
  return List.generate(search.length, (int index) {
    return Post(
      "Title : $search $index",
      "Description :$search $index",
    );
  });
}

class Store extends StatefulWidget {
  Future<List<Post>> search(String search) async {
    await Future.delayed(Duration(seconds: 2));
    return List.generate(search.length, (int index) {
      return Post(
        "Title : $search $index",
        "Description :$search $index",
      );
    });
  }

  @override
  _StoreState createState() => _StoreState();
}

class _StoreState extends State<Store> with TickerProviderStateMixin {
  final _scaffoldkey = new GlobalKey<ScaffoldState>();

  final GlobalKey<ScaffoldState> _scaffoldKeydrawer = new GlobalKey<ScaffoldState>();

  bool isLoadingcategory = false,
      isFavListLoading = false,
      isLoadingProducts = false,
      isLoadingcategoryList = false,
      isLoadingSubProductsList = false,
      isLoadingProductsList = false,
      getTokenValue = true;
  List categoryList, productsList, dealList, favList, favProductList;
  String currency;
  List list = [
    'Apple',
    'Orange',
    'Milk',
    'Coffee',
    'Grapes',
    'Cherry',
    'Avocado',
    'Mango',
  ];
  TabController tabController;

  @override
  void initState() {
    getToken();
    getCategoryList();
    getProductsList();
    super.initState();
    tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
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

  getCategoryList() async {
    if (mounted) {
      setState(() {
        isLoadingcategoryList = true;
      });
    }
    await ProductService.getCategoryList().then((onValue) {
      try {
        if (onValue['response_code'] == 200) {
          if (mounted) {
            setState(() {
              categoryList = onValue['response_data'];
              isLoadingcategoryList = false;
            });
          }
        } else {
          if (mounted) {
            setState(() {
              categoryList = [];
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

  getProductsList() async {
    if (mounted) {
      setState(() {
        isLoadingProductsList = true;
      });
    }
    await ProductService.getProductsList().then((onValue) {
      try {
        if (onValue['response_code'] == 200) {
          if (mounted) {
            setState(() {
              productsList = onValue['response_data'];
              isLoadingProductsList = false;
            });
          }
        } else {
          if (mounted) {
            setState(() {
              productsList = [];
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
      key: _scaffoldKeydrawer,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        title: Container(
          margin: EdgeInsets.only(left: 7, top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Delivery Address',
                style: textBarlowRegularrBlacksm(),
              ),
              Text(
                'HSR Layout...',
                style: textBarlowSemiBoldBlackbig(),
              )
            ],
          ),
        ),

        actions: <Widget>[
          InkWell(
            onTap: () => _scaffoldKeydrawer.currentState.openEndDrawer(),
            child: Image.asset('lib/assets/icons/menu.png'),

          ),
        ],
        iconTheme: IconThemeData(color: Colors.black),
      ),
      endDrawer:  Drawer(
        child: Drawer(),
      ),
//      key: _scaffoldkey,
      body: (isLoadingcategoryList || isLoadingProductsList)
          ? Center(child: CircularProgressIndicator())
          : ListView(
              children: <Widget>[
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SearchItem(
                              productsList: productsList,
                              currency: currency,
                              favProductList:
                                  getTokenValue ? favProductList : null)),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.all(20),
                    padding: EdgeInsets.only(left: 15, right: 15),
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    decoration: BoxDecoration(
                        color: Color(0xFFF0F0F0),
                        borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.search),
                        Padding(
                          padding: const EdgeInsets.only(left: 4.0, bottom: 4),
                          child: Text('What are you buying today?',
                              style: textbarlowRegularad()),
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 18.0, right: 18.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Explore by Categories',
                        style: textBarlowMediumBlack(),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AllCategories()),
                          );
                        },
                        child: Text(
                          'View all',
                          style: textBarlowMediumPrimary(),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                categoryList.length > 0
                    ? Container(
//                  color: Colors.red,
                        margin: EdgeInsets.only(left: 5, right: 5.0),
                        height: 110.0,
                        width: MediaQuery.of(context).size.width,
//                        decoration: BoxDecoration(),
                        child: ListView.builder(
                          physics: ScrollPhysics(),
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: categoryList.length == null
                              ? 0
                              : categoryList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return SingleChildScrollView(
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SubCategories(
                                        catId: categoryList[index]['_id'],
                                        catTitle:
                                            '${categoryList[index]['title'][0].toUpperCase()}${categoryList[index]['title'].substring(1)}',
                                      ),
                                    ),
                                  );
                                },
                                child: Row(
                                  children: <Widget>[
                                    Container(
//                                      height:60,
                                      width:80,

                                      padding: EdgeInsets.all(10),
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                            padding: EdgeInsets.all(5),
//                                            height:45,
//                                            width:45,
                                            decoration: BoxDecoration(


                                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                              border: Border.all(color: Colors.black.withOpacity(0.20)),



                                            ),

                                            child:   Container(

                                              height:45,
                                              width:45,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                                image:
                                                new DecorationImage(
                                                  fit: BoxFit.fill,
                                                  image: new NetworkImage(
                                                      categoryList[index]
                                                      ['imageUrl']),
                                                ),


                                              ),


                                            ),


                                          ),
                                          Text(
                                            categoryList[index]['title'],
                                            style: textbarlowRegularBlack(),
                                            textAlign: TextAlign.center,
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
//                                child: Padding(
//                                  padding: const EdgeInsets.all(0.0),
//                                  child: Row(
//                                    children: <Widget>[
//                                      Column(
//                                        children: <Widget>[
//                                          Container(
//                                            decoration: BoxDecoration(
//                                              border: Border.all(
//                                                  color: Colors.grey[300]),
//                                              borderRadius:
//                                                  BorderRadius.circular(10),
//                                            ),
//                                            child: Column(
//                                              children: <Widget>[
//                                                Padding(
//                                                  padding: const EdgeInsets.all(
//                                                      0.0),
//                                                  child: Container(
//                                                    height: 45,
//                                                    width: 45,
//                                                    decoration: BoxDecoration(
//                                                      borderRadius:
//                                                          BorderRadius.circular(
//                                                              10),
//                                                      image:
//                                                          new DecorationImage(
//                                                        fit: BoxFit.fill,
//                                                        image: new NetworkImage(
//                                                            categoryList[index]
//                                                                ['imageUrl']),
//                                                      ),
//                                                    ),
//                                                  ),
//                                                ),
//                                              ],
//                                            ),
//                                          ),
//                                          Text(
//                                            categoryList[index]['title'],
//                                            style: textbarlowRegularBlack(),
//                                          )
//                                        ],
//                                      ),
//                                    ],
//                                  ),
//                                ),
                              ),
                            );
                          },
                        ),
                      )
                    : Center(
                        child: Image.asset('lib/assets/images/no-orders.png'),
                      ),
               Row(
                 children: <Widget>[
                   Expanded(child:   Stack(
                     children: <Widget>[
                       Container(

                         child:  GFCard(
//
                           content:
                           Column(
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: <Widget>[
                               Container(
                                 height: 117,
//                           width: 63,
                                 decoration: BoxDecoration(

                                     image: DecorationImage(image:AssetImage('lib/assets/images/apple.png'),
                                     )
                                 ),

                               ),
                               Text('Apple'),
                               Row(
                                 children: <Widget>[
                                   Text(
                                     currency,
                                     style: textbarlowBoldGreen(),
                                   ),
                                   Text(
                                     '500',
                                     style: textbarlowBoldGreen(),
                                   )
                                 ],
                               ),
                             ],
                           ),
                         ),
                       ),
                       Positioned(child:
                       Container(
                           alignment: Alignment.center,
                           margin: EdgeInsets.only(left:15, right:16, top:16,bottom: 16 ),
                           height: 171,width: MediaQuery.of(context).size.width,

                           decoration: BoxDecoration(
                             borderRadius: BorderRadius.all(Radius.circular(5)),
                             color: Colors.black.withOpacity(0.40),
                           ),
                           child: Column(
                             mainAxisAlignment: MainAxisAlignment.center,
                             children: <Widget>[
                               Text('Oops !', style: textBarlowSemiBoldwhite(),),
                               Text('Out of stock', style: textBarlowSemiBoldwhite(),),
                             ],
                           )
                       ),
                       )


                     ],
                   ),),
                   Expanded(child:
                 Stack(
                   children: <Widget>[
                    Container(

                      child:  GFCard(
//
                        content:
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              height: 117,
//                           width: 63,
                              decoration: BoxDecoration(

                                  image: DecorationImage(image:AssetImage('lib/assets/images/orange.png'),
                                  )
                              ),

                            ),
                            Text('Orange'),
                            Row(
                              children: <Widget>[
                                Text(
                                  currency,
                                  style: textbarlowBoldGreen(),
                                ),
                                Text(
                                  '500',
                                  style: textbarlowBoldGreen(),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(child:
                     Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(left:15, right:16, top:16,bottom: 16 ),
                        height: 171,width: MediaQuery.of(context).size.width,

                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          color: Colors.black.withOpacity(0.40),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text('Oops !', style: textBarlowSemiBoldwhite(),),
                            Text('Out of stock', style: textBarlowSemiBoldwhite(),),
                          ],
                        )
                      ),
                    )

                     
                   ],
                 ),
                   )
                 ],
               ),



                productsList.length > 0
                    ? GridView.builder(
                        physics: ScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: productsList.length == null
                            ? 0
                            : productsList.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2),
                        itemBuilder: (BuildContext context, int i) {
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProductDetails(
                                      productDetail: productsList[i],
                                      favProductList: getTokenValue
                                          ? favProductList
                                          : null),
                                ),
                              );
                            },
                            child: Column(
                              children: <Widget>[


                                GFCard(
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
                                            padding:
                                            const EdgeInsets.only(bottom: 8.0),
                                            child: productsList[i]['discount'] ==
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
                                                text: productsList[i]
                                                ['discount'],
                                                textStyle:
                                                textbarlowRegularBlack(),
                                                color: Colors.deepOrange[300],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

                                      Column(

                                        children: <Widget>[
                                          Image.network(
                                            productsList[i]['imageUrl'],
                                            fit: BoxFit.cover,
                                            width: 117,
                                            height: 63,
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Text(
                                                productsList[i]['title'],
                                                style: textbarlowRegularBlack(),

                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Text(
                                                currency,
                                                style: textbarlowBoldGreen(),
                                              ),
                                              Text(
                                                '${productsList[i]['variant'][0]['price']}',
                                                style: textbarlowBoldGreen(),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
//                                  Row(
//                                    mainAxisAlignment: MainAxisAlignment.center,
//                                    children: <Widget>[
//                                      Padding(
//                                        padding: const EdgeInsets.only(),
//                                        child: Image.network(
//                                          productsList[i]['imageUrl'],
//                                          fit: BoxFit.cover,
//                                          width: 117,
//                                          height: 63,
//                                        ),
//                                      ),
//                                    ],
//                                  ),
//                                  Row(
//                                    crossAxisAlignment:
//                                        CrossAxisAlignment.start,
//                                    children: <Widget>[
//                                      Column(
//                                        crossAxisAlignment:
//                                            CrossAxisAlignment.start,
//                                        children: <Widget>[
//                                          Padding(
//                                            padding: const EdgeInsets.only(
//                                                top: 5.0, bottom: 1),
//                                            child: Text(
//                                              productsList[i]['title'],
//                                              style: textbarlowRegularBlack(),
//                                            ),
//                                          ),
//                                          Row(
//                                            children: <Widget>[
//                                              Text(
//                                                currency,
//                                                style: textbarlowBoldGreen(),
//                                              ),
//                                              Text(
//                                                '${productsList[i]['variant'][0]['price']}',
//                                                style: textbarlowBoldGreen(),
//                                              )
//                                            ],
//                                          ),
//                                        ],
//                                      ),
//                                    ],
//                                  )
                                    ],
                                  ),
                                ),
                              ],
                            )

                          );
                        },
                      )
                    : Center(
                        child: Image.asset('lib/assets/images/no-orders.png'),
                      ),
              ],
            ),
    );
  }
}
