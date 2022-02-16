import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:readymadeGroceryApp/style/style.dart';

class NewSubCategory extends StatefulWidget {
  @override
  _NewSubCategoryState createState() => _NewSubCategoryState();
}

class _NewSubCategoryState extends State<NewSubCategory>
    with TickerProviderStateMixin {
  late AnimationController controller;
  late Animation<Offset> offset;

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 1));

    offset = Tween<Offset>(begin: Offset.zero, end: Offset(0.0, 1.0))
        .animate(controller);
  }

  bool showcounter = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(190.0),
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
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
              ),
              color: primarybg,
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
                    height: 95,
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
                                style: textbarlowRegularstandardblack(context),
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
          ],
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(left: 15, right: 15),
        child: ListView(
          children: [
            Stack(
              children: [
                Container(
                  width: screenWidth(context),
                  height: 40,
                  margin: EdgeInsets.only(right: 30, top: 10),
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      Text(
                        'All',
                        style: textbarlowRegularstandarddgrey(context),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Container(
                        child: Column(
                          children: [
                            Text(
                              'Citrus Fruit',
                              style: textbarlowsemiblacksmall(context),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              height: 3,
                              width: 20,
                              color: primarybg,
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        'Apple',
                        style: textbarlowRegularstandarddgrey(context),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        'Pears',
                        style: textbarlowRegularstandarddgrey(context),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        'Fruits',
                        style: textbarlowRegularstandarddgrey(context),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        'Citrus Fruits',
                        style: textbarlowRegularstandarddgrey(context),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                    ],
                  ),
                ),
                Positioned(
                  right: 0,
                  child: InkWell(
                    onTap: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (builder) {
                            return new Container(
                                height: 350.0,
                                color: Color(
                                    0xFF737373), //could change this to Color(0xFF737373),
                                //so you don't have to change MaterialApp canvasColor
                                child: new Container(
                                  padding: EdgeInsets.all(15),
                                  decoration: new BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: new BorderRadius.only(
                                          topLeft: const Radius.circular(10.0),
                                          topRight:
                                              const Radius.circular(16.0))),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Filter Your Product',
                                            style: textbarlowsemiblack(context),
                                          ),
                                          Image.asset(
                                              'lib/assets/icons/cancel.png',
                                              scale: 3)
                                        ],
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Text(
                                        'Apple',
                                        style: textbarlowsemiy(context),
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Text(
                                        'Sort by Price',
                                        style: textbarlowmedblack(context),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: [
                                          searchHint('Low To High'),
                                          searchHint('High to Low'),
                                          searchHintSelected('Popularity'),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        'Package',
                                        style: textbarlowmedblack(context),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          searchHint('500g'),
                                          searchHint('700-800g'),
                                          searchHintSelected('1kg'),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 40,
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                              child: GFButton(
                                            blockButton: true,
                                            size: 50,
                                            type: GFButtonType.outline,
                                            color: Color(0xFFAEB5C3),
                                            onPressed: () {},
                                            child: Text(
                                              'Clear',
                                              style: textbarlowRegularblack(
                                                  context),
                                            ),
                                          )),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                              child: GFButton(
                                            blockButton: true,
                                            size: 50,
                                            type: GFButtonType.solid,
                                            color: primarybg,
                                            onPressed: () {},
                                            child: Text(
                                              'Apply',
                                              style:
                                                  textbarlowsemiwhite(context),
                                            ),
                                          ))
                                        ],
                                      )
                                    ],
                                  ),
                                ));
                          });
                    },
                    child: Image.asset(
                      'lib/assets/icons/filter.png',
                      scale: 3,
                    ),
                  ),
                )
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
                              ),
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
                              Container(
                                child: Column(
                                  children: [
                                    Image.asset(
                                      'lib/assets/icons/add.png',
                                      scale: 3,
                                    ),
                                    // Container(
                                    //   width: 25,
                                    //   height: 25,
                                    //   padding: EdgeInsets.only(top: 3),
                                    //   decoration: BoxDecoration(
                                    //       shape: BoxShape.circle,
                                    //       border:
                                    //           Border.all(color: Colors.grey)),
                                    //   child: Text(
                                    //     '1',
                                    //     textAlign: TextAlign.center,
                                    //   ),
                                    // ),
                                    // Image.asset(
                                    //   'lib/assets/icons/minus.png',
                                    //   scale: 3,
                                    // ),
                                  ],
                                ),
                              ),
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
      ),
      bottomNavigationBar: Container(
        height: 50,
        // color: black,
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: Row(
          children: [
            Expanded(
                child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: black,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    bottomLeft: Radius.circular(8)),
              ),
              child: Row(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '\$1 ',
                        style: textbarlowsemiwhitesmall(context),
                      ),
                      Text(
                        'items',
                        style: textbarlowwhite(context),
                      ),
                    ],
                  ),
                  VerticalDivider(
                    color: white,
                    thickness: 1,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '\$10.99 ',
                        style: textbarlowsemiwhitesmall(context),
                      ),
                      Text(
                        '(Saved \$1)',
                        style: textbarlowwhite(context),
                      ),
                    ],
                  )
                ],
              ),
            )),
            Expanded(
                child: Container(
              height: 50,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: primarybg,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(8),
                    bottomRight: Radius.circular(8)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'CHECKOUT',
                    style: textbarlowsemiwhite(context),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Image.asset(
                    'lib/assets/icons/front.png',
                    scale: 2,
                  ),
                ],
              ),
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

  Widget searchHintSelected(title) {
    return Container(
      padding: EdgeInsets.only(top: 3, bottom: 3, left: 8, right: 8),
      margin: EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
          color: black,
          border: Border.all(color: black),
          borderRadius: BorderRadius.circular(8)),
      child: Text(
        title,
        style: textbarlowsemiwhites(context),
      ),
    );
  }
}
