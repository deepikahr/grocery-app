import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';
import 'package:grocery_pro/screens/categories/allcategories.dart';
import 'package:grocery_pro/screens/categories/subcategories.dart';
import 'package:grocery_pro/screens/product/product-details.dart';
import 'package:grocery_pro/screens/searchitem/search.dart';
import 'package:grocery_pro/style/style.dart';

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
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.grey),
        title: Row(
          children: <Widget>[
            Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 15.0, right: 27.0),
                  child: Text(
                    'Delivery Address',
                    style: descriptionSemibold(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 0.0, top: 1.0),
                  child: Text(
                    'HSR Layout...',
                    style: boldHeading(),
                  ),
                ),
              ],
            ),
            // Column(
            //   children: <Widget>[
            //     InkWell(
            //         onTap: () {
            //           Navigator.push(
            //             context,
            //             MaterialPageRoute(builder: (context) => Search()),
            //           );
            //         },
            //         child: Padding(
            //           padding: const EdgeInsets.only(left: 148.0, top: 10.0),
            //           child: Icon(Icons.search, color: Colors.grey),
            //         ))
            //   ],
            // )
          ],
        ),
      ),
      // endDrawer: Drawer(),
      // body: Container(
      // child: SafeArea(
      body: ListView(
        children: <Widget>[
          // Padding(
          //   padding: const EdgeInsets.only(
          //       left: 20.0, right: 20.0, top: 10.0, bottom: 20.0),
          //   child: Container(
          //     padding: EdgeInsets.only(left: 15, right: 5, top: 0, bottom: 0),
          //     decoration: BoxDecoration(
          //       borderRadius: BorderRadius.circular(10),
          //       color: Colors.grey[200],
          //     ),
          //     child: TextField(
          //       onSubmitted: (String term) {
          //         // _searchForProducts(term);
          //       },
          //       // controller: _controller,
          //       style: new TextStyle(
          //         color: Colors.grey,
          //       ),
          //       decoration: new InputDecoration(
          //           focusedBorder: InputBorder.none,
          //           enabledBorder: InputBorder.none,
          //           prefixIcon: new Icon(
          //             Icons.search,
          //             color: Colors.grey,
          //           ),
          //           hintText: "What are you buying today?",
          //           hintStyle: new TextStyle(color: Colors.grey)),
          //       // onChanged: _searchForProducts,
          //     ),
          //   ),
          // ),
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
//              hideSearchBoxWhenItemSelected: false,
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
                          child:
                              Text(item, style: TextStyle(color: Colors.grey)),
                        ),
                      ],
                    ),
                  ),
//              noItemsFoundWidget: Container(
//                color: Colors.green,
//                child: Text("no items found..."),
//              ),
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
                    TextSpan(text: "Explore by Categories", style: comments()),
                    TextSpan(
                      text: '                             View all',
                      style: TextStyle(color: primary),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: GFTabBar(
              initialIndex: 0,
              length: 4,
              controller: tabController,
              tabs: [
                Tab(
                  icon: Container(
                    width: 50,
                    height: 40,
                    // decoration: BoxDecoration(
                    //color:primary,
                    //   border: Border.all(
                    //       color: Colors.black,
                    //       ),
                    //   borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    // ),
                    child: Icon(
                      IconData(
                        0xe901,
                        fontFamily: 'icomoon',
                      ),
                      // color: getGFColor(GFColor.white),
                      size: 30.0,
                    ),
                  ),
                  text: "Veggies",
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SubCategories()),
                    );
                  },
                  child: Tab(
                    icon: Icon(
                      IconData(
                        0xe902,
                        fontFamily: 'icomoon',
                      ),
                      // color: getGFColor(GFColor.white),
                      size: 30.0,
                    ),
                    text: "Fruits",
                  ),
                ),
                Tab(
                  icon: Icon(
                    IconData(
                      0xe903,
                      fontFamily: 'icomoon',
                    ),
                    // color: getGFColor(GFColor.white),
                    size: 30.0,
                  ),
                  text: "Grocery",
                ),
                Tab(
                  icon: Icon(
                    IconData(
                      0xe904,
                      fontFamily: 'icomoon',
                    ),
                    // color: getGFColor(GFColor.white),
                    size: 30.0,
                  ),
                  text: "Bakery",
                ),
              ],
              indicatorColor: primary,
              indicatorSize: TabBarIndicatorSize.label,
              labelColor: primary,
              labelPadding: EdgeInsets.all(0),
              tabBarColor: Colors.transparent,
              unselectedLabelColor: Colors.black,
              labelStyle: TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 10.0,
                color: Colors.black,
                fontFamily: 'OpenSansBold',
              ),
              unselectedLabelStyle: TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 10.0,
                color: Colors.black,
                fontFamily: 'OpenSansBold',
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProductDetails()),
              );
            },
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    child: GFCard(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      boxFit: BoxFit.cover,
                      colorFilter: new ColorFilter.mode(
                          Colors.black.withOpacity(0.67), BlendMode.darken),
                      // image: Image.asset(
                      //   'lib/assets/images/apple.png',
                      //   // width: MediaQuery.of(context).size.width,
                      //   fit: BoxFit.fitHeight,
                      //   width: 80,
                      //   height: 80,
                      // ),

//              imageOverlay: AssetImage("lib/assets/food.jpeg"),
                      // titlePosition: GFPosition.end,
                      content: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Stack(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(left: 22.0),
                                    child: Image.asset(
                                      'lib/assets/images/apple.png',
                                      // width: MediaQuery.of(context).size.width,
                                      fit: BoxFit.fitHeight,

                                      width: 80,
                                      height: 80,
                                    ),
                                  ),
                                  Positioned(
                                    height: 18.0,
                                    width: 60.0,
                                    top: 0.0,
                                    left: 0.0,
                                    child: GFButtonBadge(
                                      // icon: GFBadge(
                                      //   // text: '6',
                                      //   shape: GFBadgeShape.pills,
                                      // ),
                                      // fullWidthButton: true,
                                      onPressed: () {},
                                      text: '25% off',
                                      color: Colors.deepOrange[300],
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(right: 5.0),
                                    child: Text('Apple'),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 3.0, top: 5.0),
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
                                              color: const Color(0xFF00BFA5)),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 38.0, bottom: 15.0),
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
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GFCard(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    boxFit: BoxFit.cover,
                    colorFilter: new ColorFilter.mode(
                        Colors.black.withOpacity(0.67), BlendMode.darken),
                    // image: Image.asset(
                    //   'lib/assets/images/apple.png',
                    //   // width: MediaQuery.of(context).size.width,
                    //   fit: BoxFit.fitHeight,
                    //   width: 80,
                    //   height: 80,
                    // ),

//              imageOverlay: AssetImage("lib/assets/food.jpeg"),
                    // titlePosition: GFPosition.end,
                    content: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Stack(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(left: 22.0),
                                  child: Image.asset(
                                    'lib/assets/images/orange.png',
                                    // width: MediaQuery.of(context).size.width,
                                    fit: BoxFit.fitHeight,

                                    width: 80,
                                    height: 80,
                                  ),
                                ),
                                Positioned(
                                  height: 18.0,
                                  width: 60.0,
                                  top: 0.0,
                                  left: 0.0,
                                  child: GFButtonBadge(
                                      // icon: GFBadge(
                                      //   // text: '6',
                                      //   shape: GFBadgeShape.pills,
                                      // ),
                                      // fullWidthButton: true,
                                      onPressed: () {},
                                      text: '25% off',
                                      color: const Color(0xFF00BFA5)),
                                )
                              ],
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(right: 5.0),
                                  child: Text('Orange'),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 3.0, top: 5.0),
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
                                            color: const Color(0xFF00BFA5)),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 38.0, bottom: 15.0),
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
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                child: GFCard(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  boxFit: BoxFit.cover,
                  colorFilter: new ColorFilter.mode(
                      Colors.black.withOpacity(0.67), BlendMode.darken),
                  image: Image.asset(
                    'lib/assets/images/grape.png',
                    // width: MediaQuery.of(context).size.width,
                    fit: BoxFit.fitHeight,
                    width: 80,
                    height: 80,
                  ),

//              imageOverlay: AssetImage("lib/assets/food.jpeg"),
                  // titlePosition: GFPosition.end,
                  content: Row(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(right: 5.0),
                            child: Text('Grapes'),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 18.0),
                            child: Text(
                              'Green',
                              style: TextStyle(
                                  fontSize: 11.0, fontWeight: FontWeight.w300),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 3.0, top: 5.0),
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
                                  style:
                                      TextStyle(color: const Color(0xFF00BFA5)),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 38.0, bottom: 15.0),
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
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                  child: Row(
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      GFCard(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        boxFit: BoxFit.cover,
                        colorFilter: new ColorFilter.mode(
                            Colors.black.withOpacity(0.67), BlendMode.darken),
                        image: Image.asset(
                          'lib/assets/images/cherry.png',
                          // width: MediaQuery.of(context).size.width,
                          fit: BoxFit.fitHeight,
                          width: 80,
                          height: 80,
                        ),

//              imageOverlay: AssetImage("lib/assets/food.jpeg"),
                        // titlePosition: GFPosition.end,
                        content: Row(
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(right: 5.0),
                                  child: Text('Cherry'),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 3.0, top: 5.0),
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
                                            color: const Color(0xFF00BFA5)),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 38.0, bottom: 15.0),
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
                                              // color: GFColor.danger,
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
                            )
                          ],
                        ),
                      ),
                      Positioned(
                        top: 18.0,
                        left: 16.0,
                        width: 148.0,
                        height: 144.0,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.black45,
                              borderRadius: BorderRadius.circular(20.0)),
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 19.0, top: 40.0),
                            child: Text(
                              '     oops!               Out of stock',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              )),
            ],
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.start,
          //   children: <Widget>[
          //     Padding(
          //       padding: const EdgeInsets.only(left: 25.0),
          //       child: RichText(
          //         text: TextSpan(
          //           children: <TextSpan>[
          //             TextSpan(text: "Recent Searches", style: comments()),
          //             TextSpan(
          //               text: '                                Show More',
          //               style: TextStyle(color: primary),
          //             ),
          //           ],
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
          // Padding(
          //   padding: const EdgeInsets.only(
          //     left: 22.0,
          //     top: 15.0,
          //     right: 22.0,
          //   ),
          //   child: Container(
          //     decoration: BoxDecoration(
          //         border: Border(bottom: BorderSide(color: Colors.grey[300]))),
          //     child: Row(
          //       children: <Widget>[
          //         Padding(
          //           padding: const EdgeInsets.only(bottom: 8.0),
          //           child: Icon(Icons.search, color: Colors.grey),
          //         ),
          //         Padding(
          //           padding: const EdgeInsets.only(bottom: 10.0),
          //           child: Text('  Tomatoes',
          //               style: TextStyle(color: Colors.grey)),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          // Padding(
          //   padding: const EdgeInsets.only(
          //     left: 22.0,
          //     top: 10.0,
          //     right: 22.0,
          //   ),
          //   child: Container(
          //     decoration: BoxDecoration(
          //         border: Border(bottom: BorderSide(color: Colors.grey[300]))),
          //     child: Row(
          //       children: <Widget>[
          //         Padding(
          //           padding: const EdgeInsets.only(bottom: 8.0),
          //           child: Icon(Icons.search, color: Colors.grey),
          //         ),
          //         Padding(
          //           padding: const EdgeInsets.only(bottom: 10.0),
          //           child:
          //               Text('  Oranges', style: TextStyle(color: Colors.grey)),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.start,
          //   children: <Widget>[
          //     Padding(
          //       padding: const EdgeInsets.only(top: 18.0, left: 22.0),
          //       child: Text('3 items found', style: comments()),
          //     ),
          //   ],
          // ),
          // SizedBox(height: 15.0),
          // InkWell(
          //   onTap: () {
          //     _onProductSelect(context);
          //     // Navigator.push(
          //     //   context,
          //     //   MaterialPageRoute(builder: (context) => Categories()),
          //     // );
          //   },
          //   child: Container(
          //     // color: Colors.white54,
          //     decoration: BoxDecoration(
          //       // boxShadow: [
          //       //   new BoxShadow(
          //       //       // color: Colors.black,
          //       //       // blurRadius: 1.0,
          //       //       ),
          //       // ],
          //       color: Colors.white,
          //     ),
          //     child: Row(
          //       children: <Widget>[
          //         Stack(
          //           children: <Widget>[
          //             Column(
          //               children: <Widget>[
          //                 Container(
          //                     // height: 150,
          //                     // width: 130,
          //                     child: Padding(
          //                   padding:
          //                       const EdgeInsets.only(bottom: 14.0, left: 10.0),
          //                   child: Image.asset('lib/assets/images/apple.png'),
          //                 )),
          //               ],
          //             ),
          //             Positioned(
          //               height: 26.0,
          //               width: 117.0,
          //               top: 77.0,
          //               // left: 20.0,
          //               child: Padding(
          //                 padding: const EdgeInsets.only(left: 20.0, top: 5.0),
          //                 child: GFButtonBadge(
          //                   // icon: GFBadge(
          //                   //   // text: '6',
          //                   //   shape: GFBadgeShape.pills,
          //                   // ),
          //                   // fullWidthButton: true,
          //                   onPressed: () {},
          //                   text: '25% off',
          //                   color: Colors.deepOrange[300],
          //                 ),
          //               ),
          //             )
          //           ],
          //         ),
          //         // Column(
          //         //   children: <Widget>[
          //         //     Image.asset('lib/assets/images/grape.png'),
          //         //   ],
          //         // ),
          //         Column(
          //           children: <Widget>[
          //             Padding(
          //               padding: const EdgeInsets.only(right: 32.0),
          //               child: Text(
          //                 'Applee',
          //                 style: heading(),
          //               ),
          //             ),
          //             Padding(
          //               padding: const EdgeInsets.only(
          //                 left: 6.0,
          //               ),
          //               child: Text(
          //                 '100% Organic',
          //                 style: labelStyle(),
          //               ),
          //             ),
          //             Padding(
          //               padding: const EdgeInsets.only(right: 32.0),
          //               child: Row(
          //                 children: <Widget>[
          //                   Icon(
          //                     IconData(
          //                       0xe913,
          //                       fontFamily: 'icomoon',
          //                     ),
          //                     color: const Color(0xFF00BFA5),
          //                     size: 11.0,
          //                   ),
          //                   Text(
          //                     '85/kg',
          //                     style: TextStyle(
          //                         color: const Color(0xFF00BFA5),
          //                         fontSize: 17.0),
          //                   )
          //                 ],
          //               ),
          //             ),
          //           ],
          //         ),
          //         Column(
          //           children: <Widget>[
          //             Row(
          //               children: <Widget>[
          //                 Padding(
          //                   padding: const EdgeInsets.only(
          //                       bottom: 20.0, left: 20.0, top: 15.0),
          //                   child: RatingBar(
          //                     initialRating: 3,
          //                     minRating: 1,
          //                     direction: Axis.horizontal,
          //                     allowHalfRating: true,
          //                     itemCount: 5,
          //                     itemSize: 12.0,
          //                     itemPadding:
          //                         EdgeInsets.symmetric(horizontal: 4.0),
          //                     itemBuilder: (context, _) => Icon(
          //                       Icons.star,
          //                       color: Colors.red,
          //                       size: 15.0,
          //                     ),
          //                     onRatingUpdate: (rating) {
          //                       print(rating);
          //                     },
          //                   ),
          //                 )
          //               ],
          //             ),
          //             Padding(
          //               padding: const EdgeInsets.only(left: 20.0),
          //               child: Container(
          //                 decoration: BoxDecoration(
          //                     color: Colors.grey[200],
          //                     borderRadius: BorderRadius.circular(20.0)),
          //                 height: 30,
          //                 width: 100,
          //                 child: Row(
          //                   children: <Widget>[
          //                     Container(
          //                       width: 30,
          //                       height: 30,
          //                       decoration: BoxDecoration(
          //                           color: primary,
          //                           borderRadius: BorderRadius.circular(20.0)),
          //                       child: Icon(Icons.add
          //                           // IconData(
          //                           //   0xe910,
          //                           //   fontFamily: 'icomoon',
          //                           // ),
          //                           // color: getGFColor(GFColor.white),
          //                           ),
          //                     ),
          //                     // Text(''),
          //                     Padding(
          //                       padding: const EdgeInsets.only(left: 14.0),
          //                       child: Container(child: Text('1')),
          //                     ),
          //                     Text(''),
          //                     Padding(
          //                       padding: const EdgeInsets.only(left: 17.0),
          //                       child: Container(
          //                         width: 30,
          //                         height: 30,
          //                         decoration: BoxDecoration(
          //                             color: Colors.black,
          //                             borderRadius:
          //                                 BorderRadius.circular(20.0)),
          //                         child: Icon(
          //                           Icons.remove, color: Colors.white,
          //                           // IconData(
          //                           //   0xe910,
          //                           //   fontFamily: 'icomoon',
          //                           // ),
          //                           // color: getGFColor(GFColor.white),
          //                         ),
          //                       ),
          //                     ),
          //                   ],
          //                 ),
          //               ),
          //             )
          //           ],
          //         )
          //       ],
          //     ),
          //   ),
          // ),
          // SizedBox(
          //   height: 30.0,
          // )
        ],
      ),
    );
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
