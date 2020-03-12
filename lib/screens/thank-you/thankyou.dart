import 'package:flutter/material.dart';

import 'package:grocery_pro/style/style.dart';

class Thankyou extends StatefulWidget {

  @override
  _ThankyouState createState() => _ThankyouState();
}

class _ThankyouState extends State<Thankyou> {
  int selectedRadio;

setSelectedRadio(int val) async {
    setState(() {
      selectedRadio = val;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: primary
        ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset('lib/assets/images/thank-you.png'),
              SizedBox(height:10.0),
              Text('Order Placed',style: hintSfboldtext(),),
              SizedBox(height:13.0),

              Text('THANK YOU!',style: hintSfbold(),)
            ],
          ),
       
      ),
    );

 
  }
}
