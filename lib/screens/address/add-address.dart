import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/components/appbar/gf_appbar.dart';
import 'package:getflutter/getflutter.dart';
import 'package:grocery_pro/style/style.dart';

class AddAddress extends StatefulWidget {
  @override
  _AddAddressState createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GFAppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        title: Text(
          'Add Address',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: primary,
      ),
      body: ListView(
        children: <Widget>[
          SizedBox(
            height: 25,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 18.0, bottom: 5.0),
            child: Text(
              'House/Flat/Block number :',
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
              obscureText: true,
            ),
          ),
          SizedBox(
            height: 25,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 18.0, bottom: 5.0),
            child: Text(
              'LandMark :',
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
              obscureText: true,
            ),
          ),
          SizedBox(
            height: 25,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 18.0, bottom: 5.0),
            child: Text(
              'Area :',
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
              obscureText: true,
            ),
          ),
          SizedBox(
            height: 25,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 18.0, bottom: 5.0),
            child: Text(
              'Pincode :',
              style: regular(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0),
            child: TextFormField(
              // initialValue: "123456",
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
              // style: textBlackOSR(),
              obscureText: true,
            ),
          ),
          SizedBox(
            height: 25,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 18.0, bottom: 5.0),
            child: Text(
              'District :',
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
              obscureText: true,
            ),
          ),
          SizedBox(
            height: 25,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 18.0, bottom: 5.0),
            child: Text(
              'State :',
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
              obscureText: true,
            ),
          ),
          SizedBox(
            height: 30,
          )
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
