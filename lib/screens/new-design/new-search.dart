import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:readymadeGroceryApp/style/style.dart';

class NewSearchPage extends StatefulWidget {
  const NewSearchPage({Key? key}) : super(key: key);

  @override
  _NewSearchPageState createState() => _NewSearchPageState();
}

class _NewSearchPageState extends State<NewSearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(120.0),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(color: primarybg),
                child: GFAppBar(
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
              ),
              Container(
                padding: EdgeInsets.only(left: 15, right: 15, bottom: 15),
                color: primarybg,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: white,
                  ),
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      prefixIcon: Image.asset(
                        'lib/assets/icons/search.png',
                        scale: 3,
                      ),
                      hintText: 'Search Products',
                      hintStyle: textbarlowRegulargrey(context),
                      // contentPadding: EdgeInsets.all(10),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: Container(
          margin: EdgeInsets.only(left: 15, right: 15, top: 10),
          child: ListView(
            children: [
              Text(
                'Popular Searches',
                style: textbarlowBoldblack(context),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  searchHint('Apple'),
                  searchHint('Milk'),
                  searchHint('Bread'),
                  searchHint('Biscuits'),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Categories',
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
                height: 82,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    category(Column(
                      children: [
                        Image.asset(
                          'lib/assets/icons/cat1.png',
                          width: 65,
                        ),
                        Text(
                          'Fruits',
                          style: textbarlowblack(context),
                        )
                      ],
                    )),
                    category(Column(
                      children: [
                        Image.asset(
                          'lib/assets/icons/cat1.png',
                          width: 65,
                        ),
                        Text(
                          'Fruits',
                          style: textbarlowblack(context),
                        )
                      ],
                    )),
                    category(Column(
                      children: [
                        Image.asset(
                          'lib/assets/icons/cat1.png',
                          width: 65,
                        ),
                        Text(
                          'Fruits',
                          style: textbarlowblack(context),
                        )
                      ],
                    )),
                    category(Column(
                      children: [
                        Image.asset(
                          'lib/assets/icons/cat1.png',
                          width: 65,
                        ),
                        Text(
                          'Fruits',
                          style: textbarlowblack(context),
                        )
                      ],
                    )),
                    category(Column(
                      children: [
                        Image.asset(
                          'lib/assets/icons/cat1.png',
                          width: 65,
                        ),
                        Text(
                          'Fruits',
                          style: textbarlowblack(context),
                        )
                      ],
                    ))
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Image.asset('lib/assets/icons/banner1.png'),
              SizedBox(
                height: 10,
              ),
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      '\$10.99',
                                      style: textbarlowsemiboldyellow(context),
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      '\$11.99',
                                      style: textbarlowRegularsmallgreystrike(
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
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 10),
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
                          right: 5,
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      '\$10.99',
                                      style: textbarlowsemiboldyellow(context),
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      '\$11.99',
                                      style: textbarlowRegularsmallgreystrike(
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
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 10),
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
                          right: 5,
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      '\$10.99',
                                      style: textbarlowsemiboldyellow(context),
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      '\$11.99',
                                      style: textbarlowRegularsmallgreystrike(
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
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 10),
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
                          right: 5,
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      '\$10.99',
                                      style: textbarlowsemiboldyellow(context),
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      '\$11.99',
                                      style: textbarlowRegularsmallgreystrike(
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
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 10),
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
                          right: 5,
                          top: 10)
                    ],
                  )),
                ],
              )
            ],
          ),
        ));
  }

  Widget searchHint(title) {
    return Container(
      padding: EdgeInsets.only(top: 3, bottom: 3, left: 8, right: 8),
      margin: EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
          border: Border.all(color: Color(0xffAEB5C3)),
          borderRadius: BorderRadius.circular(8)),
      child: Text(
        title,
        style: textbarlowRegulargrey(context),
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
