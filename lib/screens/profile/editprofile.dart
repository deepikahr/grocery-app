import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:getflutter/getflutter.dart';

import 'package:grocery_pro/style/style.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GFAppBar(
        title: Text(
          'Edit Profile',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: primary,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            height: 250,
            child: Stack(
              children: <Widget>[
                Center(
                  child: new Container(
                      width: 200.0,
                      height: 200.0,
                      decoration: new BoxDecoration(
                          // shape: BoxShape.circle,
                          borderRadius: BorderRadius.circular(20.0),
                          image: new DecorationImage(
                              fit: BoxFit.fill,
                              image: new NetworkImage(
                                  "https://i.imgur.com/BoN9kdC.png")))),
                ),
                Positioned(
                  left: 250,
                  top: 190,
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                        color: primary,
                        borderRadius: BorderRadius.circular(30.0)),
                    child: Icon(Icons.camera_alt),
                  ),
                )
              ],
            ),
          ),
          Center(child: Text('badguy@email.com')),
          SizedBox(
            height: 25,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 18.0, bottom: 5.0),
            child: Text(
              'User Name :',
              style: regular(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0),
            child: TextFormField(
              // initialValue: "123456",
              style: labelStyle(),
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  fillColor: Colors.black,
                  focusColor: Colors.black,
                  contentPadding: EdgeInsets.only(
                    left: 15.0,
                    right: 15.0,
                    top: 10.0,
                    bottom: 10.0,
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.grey, width: 0.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: primary),
                  )),
              // style: textBlackOSR(),
              // obscureText: true,
            ),
          ),
          SizedBox(
            height: 25,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 18.0, bottom: 5.0),
            child: Text(
              'Phone Number :',
              style: regular(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0),
            child: TextFormField(
              style: labelStyle(),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  fillColor: Colors.black,
                  focusColor: Colors.black,
                  contentPadding: EdgeInsets.only(
                    left: 15.0,
                    right: 15.0,
                    top: 10.0,
                    bottom: 10.0,
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.grey, width: 0.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: primary),
                  )),
            ),
          ),
          SizedBox(
            height: 25,
          ),
        ],
      ),
      bottomNavigationBar: Container(
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15.0),
          child: GFButton(
            onPressed: () {},
            color: primary,
            text: 'Save',
            textColor: Colors.black,
            blockButton: true,
          ),
        ),
      ),
    );
  }
}
