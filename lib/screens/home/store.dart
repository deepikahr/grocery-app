import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/colors/gf_color.dart';
import 'package:getflutter/components/button/gf_button_bar.dart';
import 'package:getflutter/components/button/gf_icon_button.dart';
import 'package:getflutter/components/card/gf_card.dart';
import 'package:getflutter/components/list_tile/gf_list_tile.dart';
import 'package:getflutter/components/tabs/gf_tabBar.dart';
import 'package:getflutter/components/button/gf_button.dart';
import 'package:getflutter/components/tabs/gf_tabBarView.dart';
import 'package:getflutter/components/tabs/gf_segment_tabs.dart';
import 'package:grocery_pro/screens/categories/categories.dart';
import 'package:grocery_pro/screens/categories/fruits.dart';
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

class _StoreState extends State<Store> with TickerProviderStateMixin {
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.grey),
        title: Column(
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
      ),
      // endDrawer: Drawer(),
      // body: Container(
      // child: SafeArea(
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
                left: 20.0, right: 20.0, top: 10.0, bottom: 20.0),
            child: Container(
              padding: EdgeInsets.only(left: 15, right: 5, top: 0, bottom: 0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey[200],
              ),
              child: TextField(
                onSubmitted: (String term) {
                  // _searchForProducts(term);
                },
                // controller: _controller,
                style: new TextStyle(
                  color: Colors.grey,
                ),
                decoration: new InputDecoration(
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    prefixIcon: new Icon(
                      Icons.search,
                      color: Colors.grey,
                    ),
                    hintText: "What are you buying today?",
                    hintStyle: new TextStyle(color: Colors.grey)),
                // onChanged: _searchForProducts,
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Categories()),
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
                      MaterialPageRoute(builder: (context) => Fruits()),
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
              unselectedLabelColor: getGFColor(GFColor.dark),
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
          Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  child: GFCard(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    boxFit: BoxFit.cover,
                    colorFilter: new ColorFilter.mode(
                        Colors.black.withOpacity(0.67), BlendMode.darken),
                    image: Image.asset(
                      'lib/assets/images/apple.png',
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
                              child: Text('Apple'),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 5.0, top: 5.0),
                              child: Row(
                                children: <Widget>[
                                  Image.asset('lib/assets/icons/rupee.png'),
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
                                          color: getGFColor(GFColor.danger),
                                        )
                                      : Icon(
                                          Icons.favorite_border,
                                          color: Colors.grey,
                                        ),
                                ),
                                type: GFType.transparent,
                              ),
                            ),
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
                  image: Image.asset(
                    'lib/assets/images/apple.png',
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
                            child: Text('Orange'),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 5.0, top: 5.0),
                            child: Row(
                              children: <Widget>[
                                Image.asset('lib/assets/icons/orange.png'),
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
                                        color: getGFColor(GFColor.danger),
                                      )
                                    : Icon(
                                        Icons.favorite_border,
                                        color: Colors.grey,
                                      ),
                              ),
                              type: GFType.transparent,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
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
                            padding: const EdgeInsets.only(left: 5.0, top: 5.0),
                            child: Row(
                              children: <Widget>[
                                Image.asset('lib/assets/icons/rupee.png'),
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
                                        color: getGFColor(GFColor.danger),
                                      )
                                    : Icon(
                                        Icons.favorite_border,
                                        color: Colors.grey,
                                      ),
                              ),
                              type: GFType.transparent,
                            ),
                          ),
                        ],
                      )
                    ],
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
                            padding: const EdgeInsets.only(left: 5.0, top: 5.0),
                            child: Row(
                              children: <Widget>[
                                Image.asset('lib/assets/icons/rupee.png'),
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
                                        color: getGFColor(GFColor.danger),
                                      )
                                    : Icon(
                                        Icons.favorite_border,
                                        color: Colors.grey,
                                      ),
                              ),
                              type: GFType.transparent,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
