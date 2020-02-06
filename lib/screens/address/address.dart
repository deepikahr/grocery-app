import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/components/appbar/gf_appbar.dart';
import 'package:getflutter/getflutter.dart';
import 'package:grocery_pro/screens/address/add-address.dart';
import 'package:grocery_pro/style/style.dart';
// import '../screens/home.dart';

class Address extends StatefulWidget {
  @override
  _AddressState createState() => _AddressState();
}

class _AddressState extends State<Address> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GFAppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        title: Text(
          'Address',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: primary,
      ),
      body: ListView(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 20.0),
                child: Text(
                  'Saved Cards',
                  style: titleBold(),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 18.0),
            child: Container(
              child: Row(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: 60.0,
                        ),
                        child: Text(
                          '1',
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Container(
                        width: 250.0,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 18.0),
                          child: Text(
                            'HSR Layout , Agara, Bengaluru, Karnataka 560102, India',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 0.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            GFButton(
                              onPressed: null,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 18.0, right: 18.0),
                                child: Text(
                                  "Edit",
                                ),
                              ),
                              type: GFButtonType.outline,
                              color: GFColor.warning,
                              size: GFSize.medium,
                              // blockButton: true,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: GFButton(
                                onPressed: null,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, right: 8.0),
                                  child: Text(
                                    "Delete",
                                  ),
                                ),
                                color: GFColor.warning,
                                type: GFButtonType.outline,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 18.0),
            child: Container(
              child: Row(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: 60.0,
                        ),
                        child: Text(
                          '2',
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Container(
                        width: 250.0,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 18.0),
                          child: Text(
                            'HSR Layout , Agara, Bengaluru, Karnataka 560102, India',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 0.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            GFButton(
                              onPressed: null,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 18.0, right: 18.0),
                                child: Text(
                                  "Edit",
                                ),
                              ),
                              type: GFButtonType.outline,
                              color: GFColor.warning,
                              size: GFSize.medium,
                              // blockButton: true,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: GFButton(
                                onPressed: null,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, right: 8.0),
                                  child: Text(
                                    "Delete",
                                  ),
                                ),
                                color: GFColor.warning,
                                type: GFButtonType.outline,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
              child: GFButton(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: Text(
                    "Add new address",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                color: primary,
                type: GFButtonType.solid,
                blockButton: true,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddAddress()),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
