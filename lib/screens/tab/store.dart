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
      key: _scaffoldkey,
      body: (isLoadingcategoryList || isLoadingProductsList)
          ? Center(child: CircularProgressIndicator())
          : ListView(
              children: <Widget>[
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SearchItem()),
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
                              style: textBarlowRegularBlack()),
                        )
                      ],
                    ),
                  ),
                  // child: GFSearchBar(
                  //   searchBoxInputDecoration: InputDecoration(
                  //     prefixIcon: Icon(Icons.search),
                  //     labelText: 'What Are You Buying Today?',
                  //     labelStyle: textBarlowRegularBlack(),
                  //     enabledBorder: OutlineInputBorder(
                  //         borderSide: BorderSide(
                  //           color: Colors.grey,
                  //         ),
                  //         borderRadius: BorderRadius.circular(15)),
                  //   ),
                  //   searchList: productsList,
                  //   overlaySearchListHeight: 300.0,
                  //   searchQueryBuilder: (query, productsList) => productsList
                  //       .where((item) => item['title']
                  //           .toLowerCase()
                  //           .contains(query.toLowerCase()))
                  //       .toList(),
                  //   overlaySearchListItemBuilder: (item) => Container(
                  //     padding: const EdgeInsets.all(8),
                  //     child: Row(
                  //       children: <Widget>[
                  //         Padding(
                  //           padding: const EdgeInsets.only(bottom: 8.0),
                  //           child: Icon(Icons.search, color: Colors.black),
                  //         ),
                  //         Padding(
                  //           padding: const EdgeInsets.only(bottom: 10.0),
                  //           child: Text(item['title'].toLowerCase(),
                  //               style: textBarlowRegularBlack()),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  //   onItemSelected: (item) {
                  //     setState(
                  //       () {
                  //         Navigator.push(
                  //           context,
                  //           MaterialPageRoute(
                  //             builder: (context) => ProductDetails(
                  //                 productDetail: item,
                  //                 favProductList:
                  //                     getTokenValue ? favProductList : null),
                  //           ),
                  //         );
                  //       },
                  //     );
                  //   },
                  // ),
                ),

//         Row(
//           children: <Widget>[
//                                                Stack(
//                                       children: <Widget>[
//                                         GFCard(
//                                           shape: RoundedRectangleBorder(
//                                               borderRadius: BorderRadius.circular(20.0)),
//                                           boxFit: BoxFit.fill,
//                                           colorFilter: new ColorFilter.mode(
//                                               Colors.black.withOpacity(0.67),
//                                               BlendMode.darken),
//                                           content: Row(
//                                             // crossAxisAlignment: CrossAxisAlignment.start,
//                                             children: <Widget>[

//                                                   Column(
//                                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                                     children: <Widget>[
//                                                       Container(
//                                                         height: 100,
//                                                         width: 100,
//                                                         decoration: BoxDecoration(
// image: DecorationImage(image: AssetImage('lib/assets/images/grape.png'),fit: BoxFit.cover),
//                                                         ),
//                                                       ),
//   Row(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: <Widget>[
//                                       Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: <Widget>[
//                                           Padding(
//                                             padding:
//                                                 const EdgeInsets.only(top: 5.0),
//                                             child: Text(
//                                             'title',
//                                               style: textbarlowRegularBlack(),
//                                             ),
//                                           ),
//                                           Row(
//                                             children: <Widget>[
//                                               Text(
//                                                 currency,
//                                                 style: TextStyle(
//                                                     color: const Color(
//                                                         0xFF00BFA5)),
//                                               ),
//                                               Text(
//                                                 '43',
//                                                 style: TextStyle(
//                                                     color: const Color(
//                                                         0xFF00BFA5)),
//                                               )
//                                             ],
//                                           ),
//                                         ],
//                                       ),
//                                     ],
//                                   )
//                                                     ],
//                                                   ),

//                                             ],
//                                           ),
//                                         ),
//                                            Positioned(
//                            top: 16,
//                            left: 15,
//                             width: 126.0,
//                             height: 155.0,
//                             child: Container(
//                               padding: EdgeInsets.only(left:10,right:10),
//                               decoration: BoxDecoration(
//                                   color: Colors.black45,
//                                   borderRadius: BorderRadius.circular(20.0)),
//                               child:  Center(
//                                 child: Text(
//                                     'oops! Out of stock',
//                                     style: textBarlowMediumsmallWhite(

//                                     ),
//                                   ),
//                               ),

//                             ),
//                           )
//                                       ],
//                                     ),

//                                     Stack(
//                                       children: <Widget>[
//                                         GFCard(
//                                           shape: RoundedRectangleBorder(
//                                               borderRadius: BorderRadius.circular(20.0)),
//                                           boxFit: BoxFit.fill,
//                                           colorFilter: new ColorFilter.mode(
//                                               Colors.black.withOpacity(0.67),
//                                               BlendMode.darken),
//                                           content: Row(
//                                             // crossAxisAlignment: CrossAxisAlignment.start,
//                                             children: <Widget>[

//                                                   Column(
//                                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                                     children: <Widget>[
//                                                       Container(
//                                                         height: 100,
//                                                         width: 100,
//                                                         decoration: BoxDecoration(
// image: DecorationImage(image: AssetImage('lib/assets/images/grape.png'),fit: BoxFit.cover),
//                                                         ),
//                                                       ),
//   Row(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: <Widget>[
//                                       Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: <Widget>[
//                                           Padding(
//                                             padding:
//                                                 const EdgeInsets.only(top: 5.0),
//                                             child: Text(
//                                             'title',
//                                               style: textbarlowRegularBlack(),
//                                             ),
//                                           ),
//                                           Row(
//                                             children: <Widget>[
//                                               Text(
//                                                 currency,
//                                                 style: TextStyle(
//                                                     color: const Color(
//                                                         0xFF00BFA5)),
//                                               ),
//                                               Text(
//                                                 '43',
//                                                 style: TextStyle(
//                                                     color: const Color(
//                                                         0xFF00BFA5)),
//                                               )
//                                             ],
//                                           ),
//                                         ],
//                                       ),
//                                     ],
//                                   )
//                                                     ],
//                                                   ),

//                                             ],
//                                           ),
//                                         ),
//                                            Positioned(
//                            top: 16,
//                            left: 15,
//                             width: 126.0,
//                             height: 155.0,
//                             child: Container(
//                               padding: EdgeInsets.only(left:10,right:10),
//                               decoration: BoxDecoration(
//                                   color: Colors.black45,
//                                   borderRadius: BorderRadius.circular(20.0)),
//                               child:  Center(
//                                 child: Text(
//                                     'oops! Out of stock',
//                                     style: textBarlowMediumsmallWhite(

//                                     ),
//                                   ),
//                               ),

//                             ),
//                           )
//                                       ],
//                                     ),
//           ],
//         ),

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
                        margin: EdgeInsets.only(left: 5, right: 5.0),
                        height: 110.0,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(),
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
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: <Widget>[
                                      Column(
                                        children: <Widget>[
                                          Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.grey[300]),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Column(
                                              children: <Widget>[
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: Container(
                                                    height: 45,
                                                    width: 45,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
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
                                              ],
                                            ),
                                          ),
                                          Text(
                                            categoryList[index]['title'],
                                            style: textbarlowRegularBlack(),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    : Center(
                        child: Image.asset('lib/assets/images/no-orders.png'),
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
                                                  color: Colors.deepOrange[300],
                                                ),
                                              ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(),
                                        child: Image.network(
                                          productsList[i]['imageUrl'],
                                          fit: BoxFit.fill,
                                          width: 124,
                                          height: 60,
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
                                            padding:
                                                const EdgeInsets.only(top: 5.0),
                                            child: Text(
                                              productsList[i]['title'],
                                              style: textbarlowRegularBlack(),
                                            ),
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Text(
                                                currency,
                                                style: TextStyle(
                                                    color: const Color(
                                                        0xFF00BFA5)),
                                              ),
                                              Text(
                                                '${productsList[i]['variant'][0]['price']}',
                                                style: TextStyle(
                                                    color: const Color(
                                                        0xFF00BFA5)),
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
              ],
            ),
    );
  }
}
