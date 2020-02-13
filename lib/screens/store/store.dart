import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';
import 'package:grocery_pro/screens/categories/allcategories.dart';
import 'package:grocery_pro/screens/categories/subcategories.dart';
import 'package:grocery_pro/screens/product/product-details.dart';
import 'package:grocery_pro/screens/searchitem/search.dart';
import 'package:grocery_pro/service/product-service.dart';
import 'package:grocery_pro/service/sentry-service.dart';
import 'package:grocery_pro/style/style.dart';

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

bool fav = false;
bool fav1 = false;
bool fav2 = false;
bool _isChecked = false;

class _StoreState extends State<Store> with TickerProviderStateMixin {
  final _scaffoldkey = new GlobalKey<ScaffoldState>();
  bool isLoadingProductsList = false;
  bool isLoadingSubProductsList = false;
  bool isLoadingcategoryList = false;
  bool isLoadingProducts = false;
  bool isLoadingcategory = false;
  List categoryList = List();
  List productsList = List();
  List dealList = List();
  List favList = List();

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
    super.initState();
    tabController = TabController(length: 4, vsync: this);
    getCategoryList();
    getProductsList();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  getCategoryList() async {
    if (!isLoadingcategory) {
      if (mounted) {
        setState(() {
          isLoadingcategoryList = true;
        });
      }
      await ProductService.getCategoryList().then((onValue) {
        print("getCategoryList value on store $onValue");
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
  }

  getProductsList() async {
    if (!isLoadingProducts) {
      if (mounted) {
        setState(() {
          isLoadingProductsList = true;
        });
      }
      await ProductService.getProductsList().then((onValue) {
        print("prod $onValue");

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldkey,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.grey),
        ),
        body: (isLoadingcategoryList && isLoadingProductsList)
            ? Center(child: CircularProgressIndicator())
            : ListView(children: <Widget>[
                GFSearchBar(
                    searchBoxInputDecoration: InputDecoration(
                      prefixIcon: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Search()),
                            );
                          },
                          child: Icon(Icons.search)),
                      labelText: 'What Are You Buying Today?',
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                          ),
                          borderRadius: BorderRadius.circular(30)),
                    ),
                    searchList: list,
                    overlaySearchListHeight: 300.0,
                    searchQueryBuilder: (query, list) => list
                        .where((item) =>
                            item.toLowerCase().contains(query.toLowerCase()))
                        .toList(),
                    overlaySearchListItemBuilder: (item) => Container(
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Icon(Icons.search, color: Colors.grey),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: Text(item,
                                    style: TextStyle(color: Colors.grey)),
                              ),
                            ],
                          ),
                        ),
                    onItemSelected: (item) {
                      setState(() {
                        print('ssssssss $item');
                      });
                    }),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AllCategories()),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 18.0),
                    child: RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                              text: "Explore by Categories", style: comments()),
                          TextSpan(
                            text: 'View all',
                            style: TextStyle(color: primary),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                    margin: EdgeInsets.only(left: 5, right: 5.0),
                    height: 100.0,
                    width: MediaQuery.of(context).size.width,
                    child: ListView.builder(
                        physics: ScrollPhysics(),
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: categoryList.length == null
                            ? 0
                            : categoryList.length,
                        itemBuilder: (BuildContext context, int index) {
                          print(categoryList.length);
                          return SingleChildScrollView(
                              child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SubCategories(
                                              catId: categoryList[index]['_id'],
                                              catTitle:
                                                  '${categoryList[index]['title'][0].toUpperCase()}${categoryList[index]['title'].substring(1)}')),
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(children: <Widget>[
                                      Column(
                                        children: <Widget>[
                                          Container(
                                            width: 60,
                                            height: 60,
                                            child: Column(
                                              children: <Widget>[
                                                Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 0.0),
                                                    child: Image.network(
                                                      categoryList[index]
                                                          ['imageUrl'],
                                                      width: 60,
                                                      fit: BoxFit.fill,
                                                      height: 60,
                                                    )),
                                              ],
                                            ),
                                          ),
                                          Text(categoryList[index]['title'])
                                        ],
                                      ),
                                    ]),
                                  )));
                        })),
                GridView.builder(
                  physics: ScrollPhysics(),
                  shrinkWrap: true,
                  itemCount:
                      productsList.length == null ? 0 : productsList.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  itemBuilder: (BuildContext context, int i) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProductDetails(
                                  productDetail: productsList[i])),
                        );
                      },
                      child: GFCard(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        boxFit: BoxFit.fill,
                        colorFilter: new ColorFilter.mode(
                            Colors.black.withOpacity(0.67), BlendMode.darken),
                        content: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Stack(
                              fit: StackFit.loose,
                              children: <Widget>[
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  // mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20, top: 15.0),
                                      child: Image.network(
                                        productsList[i]['imageUrl'],
                                        fit: BoxFit.fill,
                                        width: 80,
                                        height: 70,
                                      ),
                                    ),
                                  ],
                                ),
                                Positioned(
                                  height: 15.0,
                                  width: 60.0,
                                  // top: 4.0,
                                  // bottom: 4.0,
                                  // left: 6.0,
                                  child: GFButtonBadge(
                                    onPressed: () {},
                                    text: '25% off',
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
                                      onTap: () {
                                        setState(() {
                                          fav = !fav;
                                        });
                                      },
                                      child: fav
                                          ? Icon(
                                              Icons.favorite,
                                              color: Colors.red,
                                            )
                                          : Icon(
                                              Icons.favorite_border,
                                              color: Colors.grey,
                                            ),
                                    ),
                                    type: GFButtonType.transparent,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10.0),
                                      child: Text(productsList[i]['title']),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 2.0),
                                      child: Row(
                                        children: <Widget>[
                                          Icon(
                                            IconData(
                                              0xe913,
                                              fontFamily: 'icomoon',
                                            ),
                                            color: const Color(0xFF00BFA5),
                                            size: 11.0,
                                          ),
                                          Text(
                                            '${productsList[i]['variant'][0]['price']}',
                                            style: TextStyle(
                                                color: const Color(0xFF00BFA5)),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                // Column(
                                //   children: <Widget>[
                                //     Padding(
                                //       padding: const EdgeInsets.only(top: 5.0),
                                //       child: GFIconButton(
                                //         onPressed: null,
                                //         icon: GestureDetector(
                                //           onTap: () {
                                //             setState(() {
                                //               fav = !fav;
                                //             });
                                //           },
                                //           child: fav
                                //               ? Icon(
                                //                   Icons.favorite,
                                //                   color: Colors.red,
                                //                 )
                                //               : Icon(
                                //                   Icons.favorite_border,
                                //                   color: Colors.grey,
                                //                 ),
                                //         ),
                                //         type: GFButtonType.transparent,
                                //       ),
                                //     ),
                                //   ],
                                // )
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ]));
  }

  Widget itemcard = Container(
    child: CheckboxListTile(
      title: Row(
        children: <Widget>[
          Container(
              height: 70,
              width: 100,
              child: Image.asset('lib/assets/images/apple.png')),
          Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  'Apple(1kg)',
                  style: regular(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 25.0),
                child: Row(
                  children: <Widget>[
                    Icon(
                      IconData(
                        0xe913,
                        fontFamily: 'icomoon',
                      ),
                      color: const Color(0xFF00BFA5),
                      size: 11.0,
                    ),
                    Text(
                      '85/kg',
                      style: TextStyle(
                          color: const Color(0xFF00BFA5),
                          fontSize: 17.0,
                          decoration: TextDecoration.none),
                    )
                  ],
                ),
              ),
            ],
          )
        ],
      ),

      // secondary: Container(
      //     height: 50,
      //     width: 50,
      //     child: Image.asset('lib/assets/images/apple.png')),
      // subtitle: Image.asset('lib/assets/images/apple.png'),
      value: _isChecked,
      onChanged: (bool val) {
        // setState(() {
        //   _isChecked = val;
        // });
      },
    ),
  );

  // _onProductSelect(context) {
  //   _scaffoldkey.currentState.showBottomSheet((context) {
  //     return new Container(
  //       height: 350.0,
  //       decoration: new BoxDecoration(
  //           color: Colors.grey[200],
  //           borderRadius: BorderRadius.only(
  //               topLeft: Radius.circular(40), topRight: Radius.circular(40))),
  //       child: Column(
  //         children: <Widget>[
  //           Center(
  //               child: Padding(
  //             padding: const EdgeInsets.only(
  //               top: 25.0,
  //             ),
  //             child: Text(
  //               'Choose Quantity',
  //               style: TextStyle(
  //                 fontSize: 18.0,
  //                 decoration: TextDecoration.none,
  //                 color: Colors.black,
  //               ),
  //             ),
  //           )),
  //           Expanded(
  //             child: ListView.builder(
  //               scrollDirection: Axis.vertical,
  //               itemCount: 6,
  //               // gridDelegate:
  //               //     SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
  //               itemBuilder: (BuildContext context, int index) {
  //                 return Container(child: itemcard);
  //               },
  //             ),
  //           ),
  //           Padding(
  //             padding: const EdgeInsets.only(left: 22.0, bottom: 10.0),
  //             child: Row(
  //               children: <Widget>[
  //                 Container(
  //                   width: 105.0,
  //                   height: 45.0,
  //                   child: GFButton(
  //                     onPressed: () {},
  //                     // text: 'Warning',
  //                     color: GFColor.dark,
  //                     shape: GFButtonShape.square,

  //                     child: Column(
  //                       children: <Widget>[
  //                         Padding(
  //                           padding: const EdgeInsets.only(top: 6.0),
  //                           child: Text('1kg:'),
  //                         ),
  //                         Padding(
  //                           padding: const EdgeInsets.only(left: 12.0),
  //                           child: Row(
  //                             children: <Widget>[
  //                               Padding(
  //                                 padding: const EdgeInsets.only(left: 8.0),
  //                                 child: Icon(
  //                                   IconData(
  //                                     0xe913,
  //                                     fontFamily: 'icomoon',
  //                                   ),
  //                                   color: Colors.white,
  //                                   size: 15.0,
  //                                 ),
  //                               ),
  //                               Padding(
  //                                 padding: const EdgeInsets.only(right: 6.0),
  //                                 child: Text(
  //                                   '123',
  //                                   // style: TextStyle(color: const Color(0xFF00BFA5)),
  //                                 ),
  //                               )
  //                             ],
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //                 Container(
  //                   width: 210.0,
  //                   height: 45.0,
  //                   child: GFButton(
  //                     onPressed: () {},
  //                     shape: GFButtonShape.square,
  //                     child: Row(
  //                       mainAxisAlignment: MainAxisAlignment.end,
  //                       children: <Widget>[
  //                         Text(
  //                           'Add to cart ',
  //                           style: TextStyle(color: Colors.black),
  //                         ),
  //                         Icon(
  //                           IconData(
  //                             0xe911,
  //                             fontFamily: 'icomoon',
  //                           ),
  //                           // color: getGFColor(GFColor.white),
  //                         ),
  //                       ],
  //                     ),
  //                     color: GFColor.warning,
  //                   ),
  //                 )
  //               ],
  //             ),
  //           )
  //         ],
  //       ),
  //     );
  //   });
  // }
}
