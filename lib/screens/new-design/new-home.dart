import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:readymadeGroceryApp/style/style.dart';

final List<String> imageList = [
  "https://cdn.pixabay.com/photo/2017/12/03/18/04/christmas-balls-2995437_960_720.jpg",
  "https://cdn.pixabay.com/photo/2017/12/13/00/23/christmas-3015776_960_720.jpg",
  "https://cdn.pixabay.com/photo/2019/12/19/10/55/christmas-market-4705877_960_720.jpg",
  "https://cdn.pixabay.com/photo/2019/12/20/00/03/road-4707345_960_720.jpg",
  "https://cdn.pixabay.com/photo/2019/12/22/04/18/x-mas-4711785__340.jpg",
  "https://cdn.pixabay.com/photo/2016/11/22/07/09/spruce-1848543__340.jpg"
];
final List<String> assetImg = [
  'lib/assets/images/red.png',
  'lib/assets/images/purple.png',
  'lib/assets/images/orange.png',
  'lib/assets/images/red.png',
];

final List<Color> gradientColor = [
  const Color(0xffF0417C),
  const Color(0xFFFF3636),
];

class NewHomePage extends StatefulWidget {
  const NewHomePage({Key? key}) : super(key: key);

  @override
  _NewHomePageState createState() => _NewHomePageState();
}

class _NewHomePageState extends State<NewHomePage>
    with SingleTickerProviderStateMixin {
  TabController? tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    tabController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GFAppBar(
        backgroundColor: primarybg,
        automaticallyImplyLeading: false,
        elevation: 0,
        leading: Image.asset(
          'lib/assets/icons/menu.png',
          scale: 3,
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Delivery Location',
              style: textbarlowRegularsmall(context),
            ),
            Text(
              'HSR.., Bangalore',
              style: textbarlowRegularstandard(context),
            )
          ],
        ),
        actions: [
          Image.asset(
            'lib/assets/icons/bell.png',
            scale: 3,
          )
        ],
      ),
      body: Container(
        child: ListView(
          children: [
            Stack(
              children: [
                Positioned(
                  child: Container(
                    color: primarybg,
                    height: 160,
                    padding: EdgeInsets.only(
                      left: 20,
                      right: 20,
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Categories',
                              style: textbarlowsemiwhite(context),
                            ),
                            Text(
                              'See All',
                              style: textbarlowsemiwhitesmall(context),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Container(
                          height: 85,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              Container(
                                margin: EdgeInsets.only(right: 10),
                                child: Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle, color: black),
                                      child: Image.asset(
                                        'lib/assets/icons/cat1.png',
                                        width: 65,
                                      ),
                                    ),
                                    Text(
                                      'Fruits',
                                      style: textbarlowsemiblacksmall(context),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(right: 10),
                                child: Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle, color: white),
                                      child: Image.asset(
                                        'lib/assets/icons/cat2.png',
                                        width: 65,
                                      ),
                                    ),
                                    Text(
                                      'Veggies',
                                      style: textbarlowRegularstandardblack(
                                          context),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(right: 10),
                                child: Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle, color: white),
                                      child: Image.asset(
                                        'lib/assets/icons/cat2.png',
                                        width: 65,
                                      ),
                                    ),
                                    Text(
                                      'Veggies',
                                      style: textbarlowRegularstandardblack(
                                          context),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                    child: Container(
                  margin: EdgeInsets.only(top: 120),
                  child: GFCarousel(
                    height: 90,
                    hasPagination: true,
                    activeIndicator: primarybg,
                    passiveIndicator: white,
                    autoPlay: true,
                    // viewportFraction: 1,
                    // viewportFraction: 1,
                    items: imageList.map(
                      (url) {
                        return Image.asset(
                          'lib/assets/icons/banner2.png',
                          fit: BoxFit.contain,
                          height: 100,
                        );
                      },
                    ).toList(),
                    onPageChanged: (index) {
                      setState(() {
                        index;
                      });
                    },
                  ),
                  //  GFCarousel(
                  //   autoPlay: true,
                  //   hasPagination: true,
                  //   viewportFraction: 1.2,
                  //   activeIndicator: primarybg,
                  //   passiveIndicator: white,
                  //   items: [
                  //     Image.asset('lib/assets/icons/banner2.png'),
                  //     Image.asset('lib/assets/icons/banner2.png'),
                  //     Image.asset('lib/assets/icons/banner2.png')
                  //   ],
                  // ),
                )),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Container(
                margin: EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Popular Products',
                          style: textbarlowBoldblack(context),
                        ),
                        Text(
                          'See All',
                          style: textbarlowsemiyellow(context),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 170,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          Stack(
                            fit: StackFit.loose,
                            children: [
                              Container(
                                width: 157,
                                child: popularProducts(Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin:
                                          EdgeInsets.symmetric(vertical: 10),
                                      alignment: Alignment.center,
                                      child: Image.asset(
                                        'lib/assets/icons/dairymilk.png',
                                        height: 75,
                                      ),
                                    ),
                                    Text(
                                      'Dairy Milk',
                                      style: textbarlowsemiblack(context),
                                    ),
                                    Text(
                                      '94 Cal',
                                      style:
                                          textbarlowRegularsmallgrey(context),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              '\$10.99',
                                              style: textbarlowsemiboldyellow(
                                                  context),
                                            ),
                                            SizedBox(width: 10),
                                            Text(
                                              '\$11.99',
                                              style:
                                                  textbarlowRegularsmallgreystrike(
                                                      context),
                                            )
                                          ],
                                        ),
                                        Image.asset(
                                          'lib/assets/icons/add.png',
                                          scale: 3,
                                        )
                                      ],
                                    )
                                  ],
                                )),
                              ),
                              Positioned(
                                  child: Container(
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    color: Color(0xFFFC7651),
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(8),
                                        bottomRight: Radius.circular(8))),
                                child: Text(
                                  '10% off',
                                  style: textbarlowmedsmallwhite(context),
                                ),
                              )),
                              Positioned(
                                  child: Image.asset(
                                    'lib/assets/icons/heart.png',
                                    scale: 3,
                                  ),
                                  right: 10,
                                  top: 10)
                            ],
                          ),
                          SizedBox(width: 10),
                          Stack(
                            fit: StackFit.loose,
                            children: [
                              Container(
                                width: 157,
                                child: popularProducts(Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin:
                                          EdgeInsets.symmetric(vertical: 10),
                                      alignment: Alignment.center,
                                      child: Image.asset(
                                        'lib/assets/icons/apple.png',
                                        height: 75,
                                      ),
                                    ),
                                    Text(
                                      'Apple 1kg',
                                      style: textbarlowsemiblack(context),
                                    ),
                                    Text(
                                      '94 Cal',
                                      style:
                                          textbarlowRegularsmallgrey(context),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              '\$10.99',
                                              style: textbarlowsemiboldyellow(
                                                  context),
                                            ),
                                            SizedBox(width: 10),
                                            Text(
                                              '\$11.99',
                                              style:
                                                  textbarlowRegularsmallgreystrike(
                                                      context),
                                            )
                                          ],
                                        ),
                                        Image.asset(
                                          'lib/assets/icons/add.png',
                                          scale: 3,
                                        )
                                      ],
                                    )
                                  ],
                                )),
                              ),
                              Positioned(
                                  child: Container(
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    color: Color(0xFFFC7651),
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(8),
                                        bottomRight: Radius.circular(8))),
                                child: Text(
                                  '10% off',
                                  style: textbarlowmedsmallwhite(context),
                                ),
                              )),
                              Positioned(
                                  child: Image.asset(
                                    'lib/assets/icons/heart.png',
                                    scale: 3,
                                  ),
                                  right: 10,
                                  top: 10)
                            ],
                          ),
                          SizedBox(width: 10),
                          Stack(
                            fit: StackFit.loose,
                            children: [
                              Container(
                                width: 157,
                                child: popularProducts(Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin:
                                          EdgeInsets.symmetric(vertical: 10),
                                      alignment: Alignment.center,
                                      child: Image.asset(
                                        'lib/assets/icons/apple.png',
                                        height: 75,
                                      ),
                                    ),
                                    Text(
                                      'Apple 1kg',
                                      style: textbarlowsemiblack(context),
                                    ),
                                    Text(
                                      '94 Cal',
                                      style:
                                          textbarlowRegularsmallgrey(context),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              '\$10.99',
                                              style: textbarlowsemiboldyellow(
                                                  context),
                                            ),
                                            SizedBox(width: 10),
                                            Text(
                                              '\$11.99',
                                              style:
                                                  textbarlowRegularsmallgreystrike(
                                                      context),
                                            )
                                          ],
                                        ),
                                        Image.asset(
                                          'lib/assets/icons/add.png',
                                          scale: 3,
                                        )
                                      ],
                                    )
                                  ],
                                )),
                              ),
                              Positioned(
                                  child: Container(
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    color: Color(0xFFFC7651),
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(8),
                                        bottomRight: Radius.circular(8))),
                                child: Text(
                                  '10% off',
                                  style: textbarlowmedsmallwhite(context),
                                ),
                              )),
                              Positioned(
                                  child: Image.asset(
                                    'lib/assets/icons/heart.png',
                                    scale: 3,
                                  ),
                                  right: 10,
                                  top: 10)
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Image.asset('lib/assets/icons/banner1.png'),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      'DEALS OF THE DAY',
                      style: textbarlowsemigreen(context),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: Stack(
                          fit: StackFit.loose,
                          children: [
                            Container(
                              width: screenWidth(context),
                              child: popularProducts(Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: EdgeInsets.symmetric(vertical: 10),
                                    alignment: Alignment.center,
                                    child: Image.asset(
                                      'lib/assets/icons/apple.png',
                                      height: 75,
                                    ),
                                  ),
                                  Text(
                                    'Apple 1kg',
                                    style: textbarlowsemiblack(context),
                                  ),
                                  Text(
                                    '94 Cal',
                                    style: textbarlowRegularsmallgrey(context),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            '\$10.99',
                                            style: textbarlowsemiboldyellow(
                                                context),
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                            '\$11.99',
                                            style:
                                                textbarlowRegularsmallgreystrike(
                                                    context),
                                          )
                                        ],
                                      ),
                                      Image.asset(
                                        'lib/assets/icons/add.png',
                                        scale: 3,
                                      )
                                    ],
                                  )
                                ],
                              )),
                            ),
                            Positioned(
                                child: Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  color: Color(0xFFFC7651),
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(8),
                                      bottomRight: Radius.circular(8))),
                              child: Text(
                                '10% off',
                                style: textbarlowmedsmallwhite(context),
                              ),
                            )),
                            Positioned(
                                child: Image.asset(
                                  'lib/assets/icons/heart.png',
                                  scale: 3,
                                ),
                                right: 10,
                                top: 10)
                          ],
                        )),
                        SizedBox(width: 10),
                        Expanded(
                            child: Stack(
                          fit: StackFit.loose,
                          children: [
                            Container(
                              width: screenWidth(context),
                              child: popularProducts(Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: EdgeInsets.symmetric(vertical: 10),
                                    alignment: Alignment.center,
                                    child: Image.asset(
                                      'lib/assets/icons/apple.png',
                                      height: 75,
                                    ),
                                  ),
                                  Text(
                                    'Apple 1kg',
                                    style: textbarlowsemiblack(context),
                                  ),
                                  Text(
                                    '94 Cal',
                                    style: textbarlowRegularsmallgrey(context),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            '\$10.99',
                                            style: textbarlowsemiboldyellow(
                                                context),
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                            '\$11.99',
                                            style:
                                                textbarlowRegularsmallgreystrike(
                                                    context),
                                          )
                                        ],
                                      ),
                                      Image.asset(
                                        'lib/assets/icons/add.png',
                                        scale: 3,
                                      )
                                    ],
                                  )
                                ],
                              )),
                            ),
                            Positioned(
                                child: Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  color: Color(0xFFFC7651),
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(8),
                                      bottomRight: Radius.circular(8))),
                              child: Text(
                                '10% off',
                                style: textbarlowmedsmallwhite(context),
                              ),
                            )),
                            Positioned(
                                child: Image.asset(
                                  'lib/assets/icons/heart.png',
                                  scale: 3,
                                ),
                                right: 10,
                                top: 10)
                          ],
                        )),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: Stack(
                          fit: StackFit.loose,
                          children: [
                            Container(
                              width: screenWidth(context),
                              child: popularProducts(Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: EdgeInsets.symmetric(vertical: 10),
                                    alignment: Alignment.center,
                                    child: Image.asset(
                                      'lib/assets/icons/apple.png',
                                      height: 75,
                                    ),
                                  ),
                                  Text(
                                    'Apple 1kg',
                                    style: textbarlowsemiblack(context),
                                  ),
                                  Text(
                                    '94 Cal',
                                    style: textbarlowRegularsmallgrey(context),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            '\$10.99',
                                            style: textbarlowsemiboldyellow(
                                                context),
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                            '\$11.99',
                                            style:
                                                textbarlowRegularsmallgreystrike(
                                                    context),
                                          )
                                        ],
                                      ),
                                      Image.asset(
                                        'lib/assets/icons/add.png',
                                        scale: 3,
                                      )
                                    ],
                                  )
                                ],
                              )),
                            ),
                            Positioned(
                                child: Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  color: Color(0xFFFC7651),
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(8),
                                      bottomRight: Radius.circular(8))),
                              child: Text(
                                '10% off',
                                style: textbarlowmedsmallwhite(context),
                              ),
                            )),
                            Positioned(
                                child: Image.asset(
                                  'lib/assets/icons/heart.png',
                                  scale: 3,
                                ),
                                right: 10,
                                top: 10)
                          ],
                        )),
                        SizedBox(width: 10),
                        Expanded(
                            child: Stack(
                          fit: StackFit.loose,
                          children: [
                            Container(
                              width: screenWidth(context),
                              child: popularProducts(Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: EdgeInsets.symmetric(vertical: 10),
                                    alignment: Alignment.center,
                                    child: Image.asset(
                                      'lib/assets/icons/apple.png',
                                      height: 75,
                                    ),
                                  ),
                                  Text(
                                    'Apple 1kg',
                                    style: textbarlowsemiblack(context),
                                  ),
                                  Text(
                                    '94 Cal',
                                    style: textbarlowRegularsmallgrey(context),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            '\$10.99',
                                            style: textbarlowsemiboldyellow(
                                                context),
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                            '\$11.99',
                                            style:
                                                textbarlowRegularsmallgreystrike(
                                                    context),
                                          )
                                        ],
                                      ),
                                      Image.asset(
                                        'lib/assets/icons/add.png',
                                        scale: 3,
                                      )
                                    ],
                                  )
                                ],
                              )),
                            ),
                            Positioned(
                                child: Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  color: Color(0xFFFC7651),
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(8),
                                      bottomRight: Radius.circular(8))),
                              child: Text(
                                '10% off',
                                style: textbarlowmedsmallwhite(context),
                              ),
                            )),
                            Positioned(
                                child: Image.asset(
                                  'lib/assets/icons/heart.png',
                                  scale: 3,
                                ),
                                right: 10,
                                top: 10)
                          ],
                        )),
                      ],
                    )
                  ],
                ))
          ],
        ),
      ),
    );
  }

  Widget category(child) {
    return Container(
      padding: EdgeInsets.all(5),
      // height: 70,
      width: 65,
      margin: EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: white,
          boxShadow: [
            BoxShadow(color: Color(0xFFf0f4f7), blurRadius: 6, spreadRadius: 3)
          ]),
      child: child,
    );
  }

  Widget popularProducts(child) {
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: white,
          boxShadow: [
            BoxShadow(color: Color(0xFFf0f4f7), blurRadius: 6, spreadRadius: 3)
          ]),
      child: child,
    );
  }
}
