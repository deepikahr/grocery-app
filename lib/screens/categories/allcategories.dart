import 'package:flutter/material.dart';
import 'package:getflutter/components/appbar/gf_appbar.dart';
import 'package:getflutter/getflutter.dart';

import 'package:grocery_pro/style/style.dart';

class AllCategories extends StatefulWidget {
  @override
  _AllCategoriesState createState() => _AllCategoriesState();
}

class _AllCategoriesState extends State<AllCategories>
    with TickerProviderStateMixin {
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
      appBar: GFAppBar(
        title: Text('Categories',
            style: TextStyle(
                color: Colors.black,
                fontSize: 17.0,
                fontWeight: FontWeight.w600)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black, size: 15.0),
      ),
      body: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 75,
                      width: 72,
                      decoration: BoxDecoration(
                          color: primary,
                          borderRadius: BorderRadius.circular(10.0)),
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 18.0),
                            child: Icon(
                              IconData(
                                0xe901,
                                fontFamily: 'icomoon',
                              ),
                              color: Colors.black,
                              size: 40.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text('Veggies')
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: Column(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                          color: primary,
                          borderRadius: BorderRadius.circular(10.0)),
                      height: 75,
                      width: 72,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 18.0),
                            child: Icon(
                              IconData(
                                0xe902,
                                fontFamily: 'icomoon',
                              ),
                              color: Colors.black,
                              size: 40.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text('Fruits')
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: Column(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                          color: primary,
                          borderRadius: BorderRadius.circular(10.0)),
                      height: 75,
                      width: 72,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 18.0),
                            child: Icon(
                              IconData(
                                0xe903,
                                fontFamily: 'icomoon',
                              ),
                              color: Colors.black,
                              size: 40.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text('Grocery')
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    // left: 20.0,
                    ),
                child: Column(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                          color: primary,
                          borderRadius: BorderRadius.circular(10.0)),
                      height: 75,
                      width: 72,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 18.0),
                            child: Icon(
                              IconData(
                                0xe904,
                                fontFamily: 'icomoon',
                              ),
                              color: Colors.black,
                              size: 40.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text('Bakery')
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: Row(
              children: <Widget>[
                InkWell(
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => Dairy()),
                    // );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: 75,
                          width: 72,
                          decoration: BoxDecoration(
                              color: primary,
                              borderRadius: BorderRadius.circular(10.0)),
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(top: 18.0),
                                child: Icon(
                                  IconData(
                                    0xe907,
                                    fontFamily: 'icomoon',
                                  ),
                                  color: Colors.black,
                                  size: 40.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text('Dairy')
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 15.0),
                  child: Column(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                            color: primary,
                            borderRadius: BorderRadius.circular(10.0)),
                        height: 75,
                        width: 72,
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 18.0),
                              child: Icon(
                                IconData(
                                  0xe910,
                                  fontFamily: 'icomoon',
                                ),
                                color: Colors.black,
                                size: 40.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text('Beverages')
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 15.0),
                  child: Column(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                            color: primary,
                            borderRadius: BorderRadius.circular(10.0)),
                        height: 75,
                        width: 72,
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 18.0),
                              child: Icon(
                                IconData(
                                  0xe90c,
                                  fontFamily: 'icomoon',
                                ),
                                color: Colors.black,
                                size: 40.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text('Cosmetis')
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      // left: 20.0,
                      ),
                  child: Column(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                            color: primary,
                            borderRadius: BorderRadius.circular(10.0)),
                        height: 75,
                        width: 72,
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 18.0),
                              child: Icon(
                                IconData(
                                  0xe908,
                                  fontFamily: 'icomoon',
                                ),
                                color: Colors.black,
                                size: 40.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text('Liquor')
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: 75,
                        width: 72,
                        child: Column(
                          children: <Widget>[],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 15.0),
                  child: Column(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                            color: primary,
                            borderRadius: BorderRadius.circular(10.0)),
                        height: 75,
                        width: 72,
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 18.0),
                              child: Icon(
                                IconData(
                                  0xe909,
                                  fontFamily: 'icomoon',
                                ),
                                color: Colors.black,
                                size: 40.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text('Frozen')
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 15.0),
                  child: Column(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                            color: primary,
                            borderRadius: BorderRadius.circular(10.0)),
                        height: 75,
                        width: 72,
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 18.0, right: 20.0),
                              child: Icon(
                                IconData(
                                  0xe905,
                                  fontFamily: 'icomoon',
                                ),
                                color: Colors.black,
                                size: 30.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text('House Hold')
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      // left: 20.0,
                      ),
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: 75,
                        width: 72,
                        child: Column(
                          children: <Widget>[],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      // Row(
      //   children: <Widget>[
      //     Expanded(
      //       child: Padding(
      //         padding: const EdgeInsets.only(left: 24.0, bottom: 30.0),
      //         child: Text(
      //           'Veggies',
      //           style: regular(),
      //         ),
      //       ),
      //     ),
      //     Expanded(
      //       child: Padding(
      //         padding: const EdgeInsets.only(left: 28.0, bottom: 30.0),
      //         child: Text(
      //           'Fruits',
      //           style: regular(),
      //         ),
      //       ),
      //     ),
      //     Expanded(
      //       child: Padding(
      //         padding: const EdgeInsets.only(left: 22.0, bottom: 30.0),
      //         child: Text(
      //           'Grocery',
      //           style: regular(),
      //         ),
      //       ),
      //     ),
      //     Expanded(
      //       child: Padding(
      //         padding: const EdgeInsets.only(left: 25.0, bottom: 30.0),
      //         child: Text(
      //           'Bakery',
      //           style: regular(),
      //         ),
      //       ),
      //     ),
      //   ],
      // ),
      // Row(
      //   mainAxisAlignment: MainAxisAlignment.start,
      //   children: <Widget>[
      //     Expanded(
      //       // flex: 1,
      //       child: Container(
      //         height: 100,
      //         // width: 100,
      //         child: GFCard(
      //           color: primary,
      //           // boxFit: BoxFit.cover,
      //           // colorFilter: new ColorFilter.mode(
      //           //     Colors.black.withOpacity(0.40), BlendMode.darken),
      //           // imageOverlay: AssetImage('lib/assets/icons/broccoli.png'),
      //           title: GFListTile(
      //             icon: Padding(
      //               padding: const EdgeInsets.only(top: 4.0, right: 10.0),
      //               child: Icon(
      //                 IconData(
      //                   0xe904,
      //                   fontFamily: 'icomoon',
      //                 ),
      //                 color: getGFColor(GFColor.dark),
      //                 size: 32.0,
      //               ),
      //             ),
      //           ),
      //         ),
      //       ),
      //     ),
      //     Expanded(
      //       // flex: 1,
      //       child: Container(
      //         height: 100,
      //         width: 100,
      //         child: GFCard(
      //           color: primary,
      //           // boxFit: BoxFit.cover,
      //           // colorFilter: new ColorFilter.mode(
      //           //     Colors.black.withOpacity(0.40), BlendMode.darken),
      //           // imageOverlay: AssetImage('lib/assets/icons/broccoli.png'),
      //           title: GFListTile(
      //             icon: Padding(
      //               padding: const EdgeInsets.only(top: 4.0, right: 10.0),
      //               child: Icon(
      //                 IconData(
      //                   0xe904,
      //                   fontFamily: 'icomoon',
      //                 ),
      //                 color: getGFColor(GFColor.dark),
      //                 size: 32.0,
      //               ),
      //             ),
      //           ),
      //         ),
      //       ),
      //     ),
      //     Expanded(
      //       // flex: 1,
      //       child: Container(
      //         height: 100,
      //         width: 100,
      //         child: GFCard(
      //           color: primary,
      //           // boxFit: BoxFit.cover,
      //           // colorFilter: new ColorFilter.mode(
      //           //     Colors.black.withOpacity(0.40), BlendMode.darken),
      //           // imageOverlay: AssetImage('lib/assets/icons/broccoli.png'),
      //           title: GFListTile(
      //             icon: Padding(
      //               padding: const EdgeInsets.only(top: 4.0, right: 10.0),
      //               child: Icon(
      //                 IconData(
      //                   0xe904,
      //                   fontFamily: 'icomoon',
      //                 ),
      //                 color: getGFColor(GFColor.dark),
      //                 size: 32.0,
      //               ),
      //             ),
      //           ),
      //         ),
      //       ),
      //     ),
      //     Expanded(
      //       // flex: 1,
      //       child: Container(
      //         height: 100,
      //         width: 100,
      //         child: GFCard(
      //           color: primary,
      //           // boxFit: BoxFit.cover,
      //           // colorFilter: new ColorFilter.mode(
      //           //     Colors.black.withOpacity(0.40), BlendMode.darken),
      //           // imageOverlay: AssetImage('lib/assets/icons/broccoli.png'),
      //           title: GFListTile(
      //             icon: Padding(
      //               padding: const EdgeInsets.only(top: 4.0, right: 10.0),
      //               child: Icon(
      //                 IconData(
      //                   0xe904,
      //                   fontFamily: 'icomoon',
      //                 ),
      //                 color: getGFColor(GFColor.dark),
      //                 size: 32.0,
      //               ),
      //             ),
      //           ),
      //         ),
      //       ),
      //     ),
      //   ],
      // ),
      // Row(
      //   children: <Widget>[
      //     Expanded(
      //       child: Padding(
      //         padding: const EdgeInsets.only(left: 28.0, bottom: 30.0),
      //         child: Text(
      //           'Dairy',
      //           style: regular(),
      //         ),
      //       ),
      //     ),
      //     Expanded(
      //       child: Padding(
      //         padding: const EdgeInsets.only(left: 18.0, bottom: 30.0),
      //         child: Text(
      //           'Beverages',
      //           style: regular(),
      //         ),
      //       ),
      //     ),
      //     Expanded(
      //       child: Padding(
      //         padding: const EdgeInsets.only(left: 15.0, bottom: 30.0),
      //         child: Text(
      //           'Cosmetics',
      //           style: regular(),
      //         ),
      //       ),
      //     ),
      //     Expanded(
      //       child: Padding(
      //         padding: const EdgeInsets.only(left: 28.0, bottom: 30.0),
      //         child: Text(
      //           'Liquor',
      //           style: regular(),
      //         ),
      //       ),
      //     ),
      //   ],
      // ),
      // Row(
      //   mainAxisAlignment: MainAxisAlignment.start,
      //   children: <Widget>[
      //     Expanded(
      //       child: Container(),
      //     ),
      //     Expanded(
      //       // flex: 1,
      //       child: Container(
      //         height: 100,
      //         width: 100,
      //         child: GFCard(
      //           color: primary,
      //           // boxFit: BoxFit.cover,
      //           // colorFilter: new ColorFilter.mode(
      //           //     Colors.black.withOpacity(0.40), BlendMode.darken),
      //           // imageOverlay: AssetImage('lib/assets/icons/broccoli.png'),
      //           title: GFListTile(
      //             icon: Padding(
      //               padding: const EdgeInsets.only(top: 4.0, right: 10.0),
      //               child: Icon(
      //                 IconData(
      //                   0xe904,
      //                   fontFamily: 'icomoon',
      //                 ),
      //                 color: getGFColor(GFColor.dark),
      //                 size: 32.0,
      //               ),
      //             ),
      //           ),
      //         ),
      //       ),
      //     ),
      //     Expanded(
      //       // flex: 1,
      //       child: Container(
      //         height: 100,
      //         width: 100,
      //         child: GFCard(
      //           color: primary,
      //           // boxFit: BoxFit.cover,
      //           // colorFilter: new ColorFilter.mode(
      //           //     Colors.black.withOpacity(0.40), BlendMode.darken),
      //           // imageOverlay: AssetImage('lib/assets/icons/broccoli.png'),
      //           title: GFListTile(
      //             icon: Padding(
      //               padding: const EdgeInsets.only(top: 4.0, right: 10.0),
      //               child: Icon(
      //                 IconData(
      //                   0xe904,
      //                   fontFamily: 'icomoon',
      //                 ),
      //                 color: getGFColor(GFColor.dark),
      //                 size: 32.0,
      //               ),
      //             ),
      //           ),
      //         ),
      //       ),
      //     ),
      //     Expanded(
      //       child: Container(),
      //     ),
      //   ],
      // ),
      // Row(
      //   children: <Widget>[
      //     Expanded(
      //       child: Padding(
      //         padding: const EdgeInsets.only(left: 28.0),
      //         child: Text(''),
      //       ),
      //     ),
      //     Expanded(
      //       child: Padding(
      //         padding: const EdgeInsets.only(left: 25.0, bottom: 30.0),
      //         child: Text(
      //           'Frozen',
      //           style: regular(),
      //         ),
      //       ),
      //     ),
      //     Expanded(
      //       child: Padding(
      //         padding: const EdgeInsets.only(left: 15.0, bottom: 30.0),
      //         child: Text(
      //           'House hold',
      //           style: regular(),
      //         ),
      //       ),
      //     ),
      //     Expanded(
      //       child: Padding(
      //         padding: const EdgeInsets.only(left: 28.0),
      //         child: Text(''),
      //       ),
      //     ),
      //   ],
      // ),
      //   ],
      // ),
    );
  }
}
