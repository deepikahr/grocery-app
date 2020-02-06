import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:getflutter/getflutter.dart';
import 'package:grocery_pro/screens/orders/orders.dart';
import 'package:grocery_pro/screens/address/address.dart';
import 'package:grocery_pro/style/style.dart';
import 'package:grocery_pro/screens/profile/editprofile.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    Widget itemCard = Container(
      padding: const EdgeInsets.only(right: 15.0),
      height: 141,
      width: 232,
      decoration: BoxDecoration(
          color: Colors.blue[400], borderRadius: BorderRadius.circular(5.0)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 38.0, top: 20.0),
                child: Image.asset('lib/assets/icons/mastercard-logo.png'),
              )
            ],
          ),
          SizedBox(height: 20),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Text(
                '3421 **** **** **34',
                style: TextStyle(fontSize: 19.0, color: Colors.white),
              ),
            ),
          ),
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text(
                    'Card holder',
                    style: TextStyle(fontSize: 12.0, color: Colors.white),
                  ),
                  Text(
                    'Billie Eilsh',
                    style: TextStyle(fontSize: 12.0, color: Colors.white),
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  Text(
                    'Expires',
                    style: TextStyle(fontSize: 12.0, color: Colors.white),
                  ),
                  Text(
                    '12/12',
                    style: TextStyle(fontSize: 12.0, color: Colors.white),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
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
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditProfile()),
                            );
                          },
                          child: Icon(
                            Icons.edit,
                            color: primary,
                          ),
                        ))
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
                padding: const EdgeInsets.only(
                  left: 15.0,
                ),
                child: Container(
                  height: 150,
                  // width: 50,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: 2,
                    itemBuilder: (BuildContext context, int index) => Padding(
                      padding: const EdgeInsets.only(right: 15.0),
                      child: Container(
                        // height: 50,
                        child: itemCard,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Address()),
                  );
                },
                child: Container(
                  color: Colors.white38,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 10.0, bottom: 10.0, left: 20.0),
                        child: Text(
                          'Address',
                          style: titleBold(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Orders()),
                  );
                },
                child: Container(
                  color: Colors.white38,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 10.0, bottom: 10.0, left: 20.0),
                        child: Text(
                          'Order History',
                          style: titleBold(),
                        ),
                      ),
                    ],
                  ),
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
                        'Help',
                        style: titleBold(),
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
