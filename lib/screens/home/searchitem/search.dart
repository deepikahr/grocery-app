import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:getflutter/components/badge/gf_button_badge.dart';
import 'package:getflutter/getflutter.dart';
import 'package:grocery_pro/style/style.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

bool monVal = false;
bool tuVal = false;
bool wedVal = false;
bool _isChecked = false;

class _SearchState extends State<Search> {
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      body: SingleChildScrollView(
          child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
                left: 5.0, right: 5.0, top: 40.0, bottom: 10.0),
            child: GFSearchBar(
                searchBoxInputDecoration: InputDecoration(
                  prefixIcon: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Search()),
                        );
                      },
                      child: Icon(Icons.search)),
                  labelText: 'Item Name',
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
                            child: Text(item,
                                style: TextStyle(color: Colors.grey)),
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
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 22.0),
                child: Text('3 items found', style: comments()),
              ),
            ],
          ),
          SizedBox(height: 15.0),
          InkWell(
            onTap: () {
              _onProductSelect(context);
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => Categories()),
              // );
            },
            child: Container(
              // color: Colors.white54,
              decoration: BoxDecoration(
                  // boxShadow: [
                  //   new BoxShadow(
                  //       // color: Colors.black,
                  //       // blurRadius: 1.0,
                  //       ),
                  // ],
                  // color: Colors.white38,
                  ),
              child: Row(
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Container(
                              // height: 150,
                              // width: 130,
                              child: Padding(
                            padding:
                                const EdgeInsets.only(bottom: 14.0, left: 10.0),
                            child: Image.asset('lib/assets/images/apple.png'),
                          )),
                        ],
                      ),
                      Positioned(
                        height: 26.0,
                        width: 117.0,
                        top: 77.0,
                        // left: 20.0,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20.0, top: 5.0),
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
                        ),
                      )
                    ],
                  ),
                  // Column(
                  //   children: <Widget>[
                  //     Image.asset('lib/assets/images/grape.png'),
                  //   ],
                  // ),
                  Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right: 32.0),
                        child: Text(
                          'Applee',
                          style: heading(),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 6.0,
                        ),
                        child: Text(
                          '100% Organic',
                          style: labelStyle(),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 32.0),
                        child: Row(
                          children: <Widget>[
                            Icon(
                              IconData(
                                0xe913,
                                fontFamily: 'icomoon',
                              ),
                              color: const Color(0xFF00BFA5),
                              size: 13.0,
                            ),
                            Text(
                              ' 85/kg',
                              style: TextStyle(
                                  color: const Color(0xFF00BFA5),
                                  fontSize: 17.0),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(
                                bottom: 20.0, left: 20.0, top: 15.0),
                            child: RatingBar(
                              initialRating: 3,
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemSize: 12.0,
                              itemPadding:
                                  EdgeInsets.symmetric(horizontal: 4.0),
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: Colors.red,
                                size: 15.0,
                              ),
                              onRatingUpdate: (rating) {
                                print(rating);
                              },
                            ),
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(20.0)),
                          height: 30,
                          width: 100,
                          child: Row(
                            children: <Widget>[
                              Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                    color: primary,
                                    borderRadius: BorderRadius.circular(20.0)),
                                child: Icon(Icons.add
                                    // IconData(
                                    //   0xe910,
                                    //   fontFamily: 'icomoon',
                                    // ),
                                    // color: getGFColor(GFColor.white),
                                    ),
                              ),
                              // Text(''),
                              Padding(
                                padding: const EdgeInsets.only(left: 14.0),
                                child: Container(child: Text('1')),
                              ),
                              Text(''),
                              Padding(
                                padding: const EdgeInsets.only(left: 17.0),
                                child: Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius:
                                          BorderRadius.circular(20.0)),
                                  child: Icon(
                                    Icons.remove, color: Colors.white,
                                    // IconData(
                                    //   0xe910,
                                    //   fontFamily: 'icomoon',
                                    // ),
                                    // color: getGFColor(GFColor.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      )),
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
  _onProductSelect(context) {
    _scaffoldkey.currentState.showBottomSheet((context) {
      return new Container(
        height: 350.0,
        decoration: new BoxDecoration(
            color: Colors.white,
            boxShadow: [
              new BoxShadow(
                color: Colors.black,
                // blurRadius: 1.0,
              ),
            ],
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40), topRight: Radius.circular(40))),
        child: Column(
          children: <Widget>[
            Center(
                child: Padding(
              padding: const EdgeInsets.only(
                top: 25.0,
              ),
              child: Text(
                'Choose Quantity',
                style: TextStyle(
                  fontSize: 18.0,
                  decoration: TextDecoration.none,
                  color: Colors.black,
                ),
              ),
            )),
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: 6,
                // gridDelegate:
                //     SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                itemBuilder: (BuildContext context, int index) {
                  return Container(child: itemcard);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 22.0, bottom: 10.0),
              child: Row(
                children: <Widget>[
                  Container(
                    width: 105.0,
                    height: 45.0,
                    child: GFButton(
                      onPressed: () {},
                      // text: 'Warning',
                      color: GFColor.dark,
                      shape: GFButtonShape.square,

                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 6.0),
                            child: Text('1kg:'),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 12.0),
                            child: Row(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Icon(
                                    IconData(
                                      0xe913,
                                      fontFamily: 'icomoon',
                                    ),
                                    color: Colors.white,
                                    size: 15.0,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 6.0),
                                  child: Text(
                                    '123',
                                    // style: TextStyle(color: const Color(0xFF00BFA5)),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: 210.0,
                    height: 45.0,
                    child: GFButton(
                      onPressed: () {},
                      shape: GFButtonShape.square,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            'Add to cart ',
                            style: TextStyle(color: Colors.black),
                          ),
                          Icon(
                            IconData(
                              0xe911,
                              fontFamily: 'icomoon',
                            ),
                            // color: getGFColor(GFColor.white),
                          ),
                        ],
                      ),
                      color: GFColor.warning,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      );
    });
  }
}
