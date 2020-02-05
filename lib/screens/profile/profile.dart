import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:getflutter/getflutter.dart';
import 'package:grocery_pro/style/style.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    Widget itemCard = Container(
      // height: 50,
      // width: 200,
      child: Image.asset('lib/assets/images/creditcard.png'),
    );
    return Scaffold(
      appBar: GFAppBar(
        // shape: RoundedRectangleBorder(
        //     borderRadius: BorderRadius.only(
        //         bottomLeft: Radius.circular(20),
        //         bottomRight: Radius.circular(20))),
        title: Text(
          'Profile',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: primary,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.grey[200],
          child: Column(
            children: <Widget>[
              Container(
                color: Colors.white38,
                child: GFListTile(
                    avatar: Image.asset('lib/assets/images/profile.png'),
                    title: Padding(
                      padding: const EdgeInsets.only(bottom: 18.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding:
                                const EdgeInsets.only(right: 56.0, bottom: 4.0),
                            child: Text(
                              'Billie Eilsh',
                              style: titleBold(),
                            ),
                          ),
                          Text(
                            'badguy@email.com',
                            style: TextStyle(
                                fontWeight: FontWeight.w300, fontSize: 14.0),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 5.0, right: 4.0),
                            child: Text('+91-9756 55 83 13'),
                          ),
                        ],
                      ),
                    ),
                    subTitle: Container(),
                    description: Container(),
                    icon: Padding(
                      padding: const EdgeInsets.only(top: 18.0),
                      child: Icon(
                        Icons.edit,
                        color: primary,
                      ),
                    )
                    // showDivider: false,
                    ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 10.0, bottom: 10.0, left: 20.0),
                    child: Text(
                      'Saved cards',
                      style: titleBold(),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 14.0),
                child: Container(
                  height: 150,
                  // width: 50,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: 2,
                    itemBuilder: (BuildContext context, int index) => Container(
                      height: 50,
                      child: itemCard,
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 20.0, top: 10.0, bottom: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(text: "Order History", style: titleBold()),
                          TextSpan(
                            text:
                                '                                                     View all',
                            style: TextStyle(color: primary),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                color: Colors.white38,
                child: GFListTile(
                  avatar: Container(
                      // width: 150,
                      child: Image.asset('lib/assets/images/orange.png')),
                  title: Padding(
                    padding: const EdgeInsets.only(bottom: 18.0, right: 25.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(bottom: 6.0),
                              child: Text(
                                'White walker',
                                style: titleBold(),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(bottom: 4.0),
                              child: Text(
                                'Blended scotch whiskey',
                                style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 14.0),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(bottom: 6.0),
                              child: Text(
                                '29/01/2020',
                                style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 14.0),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Icon(
                              IconData(
                                0xe913,
                                fontFamily: 'icomoon',
                              ),
                              color: Colors.black,
                              size: 11.0,
                            ),
                            Text('4566')
                          ],
                        )
                      ],
                    ),
                  ),
                  // showDivider: false,
                ),
              ),
              Container(
                color: Colors.white38,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                        child: GFButton(
                          onPressed: () {},
                          text: 'ReOrder',
                          color: primary,
                          // size: GFSize.small,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                        child: GFButton(
                          onPressed: () {},
                          text: 'Rate',
                          color: primary,
                          type: GFButtonType.outline,
                          size: GFSize.small,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 10.0, bottom: 10.0, left: 20.0),
                    child: Text(
                      'Help',
                      style: titleBold(),
                    ),
                  ),
                ],
              ),
              Container(
                color: Colors.white38,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 10.0, bottom: 10.0, left: 20.0),
                      child: Text(
                        'FAQs and Links',
                        style: emailTextNormal(),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Container(
                color: Colors.white38,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 10.0, bottom: 10.0, left: 20.0),
                      child: Text(
                        'Logout',
                        style: titleBold(),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 248.0),
                          child: Icon(Icons.exit_to_app),
                        )
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 40.0,
              )
            ],
          ),
        ),
      ),
    );
  }
}
