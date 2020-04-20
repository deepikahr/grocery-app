import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';
import 'package:grocery_pro/screens/home/drawer.dart';
import 'package:grocery_pro/style/style.dart';

class AboutUs extends StatefulWidget {
  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'About',
          style: textbarlowSemiBoldBlack(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      drawer: Drawer(
        child: DrawerPage(),
      ),
      body: Stack(
        children: <Widget>[
          ListView(
            children: <Widget>[
              Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child: Center(
                      child: Image.asset(
                    'lib/assets/icons/app.png',
                    width: 135,
                    height: 29,
                  ))),
              Container(
                  margin: EdgeInsets.only(left: 15),
                  child: Text('Description:', style: textBarlowMediumBlack())),
              Row(
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.all(15),
                      width: MediaQuery.of(context).size.width * 0.91,
                      child: Text(
                        'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor',
                        style: textbarlowRegularBlackd(),
                      ))
                ],
              ),
              Container(
                  margin: EdgeInsets.only(left: 15, bottom: 15),
                  child: Text('Contact:', style: textBarlowMediumBlack())),
              Padding(
                padding: const EdgeInsets.only(left: 15.0, bottom: 10),
                child: Row(
                  children: <Widget>[
                    Image.asset(
                      'lib/assets/icons/mobile.png',
                      width: 30,
                      height: 30,
                      color: Colors.black.withOpacity(0.60),
                    ),
                    Text(' Call Us', style: textbarlowRegularBlackd())
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0, bottom: 10),
                child: Row(
                  children: <Widget>[
                    Image.asset(
                      'lib/assets/icons/mail.png',
                      width: 30,
                      height: 30,
                      color: Colors.black.withOpacity(0.60),
                    ),
                    Text(' Mail Us', style: textbarlowRegularBlackd())
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0, bottom: 10),
                child: Row(
                  children: <Widget>[
                    Image.asset(
                      'lib/assets/icons/location.png',
                      width: 30,
                      height: 30,
                      color: Colors.black.withOpacity(0.60),
                    ),
                    Text(' Locate Us', style: textbarlowRegularBlackd())
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 30,
            left: 15,
            child: Text('Terms & Conditions', style: textBarlowmediumLink()),
          ),
          Positioned(
              bottom: 30,
              right: 15,
              child: Text('Privacy policy', style: textBarlowmediumLink())),
        ],
      ),
    );
  }
}
