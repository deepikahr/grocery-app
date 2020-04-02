import 'package:flutter/material.dart';
import 'package:grocery_pro/style/style.dart';

class Chat extends StatefulWidget {
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: primary,
        elevation: 0,
        title: Text(
          'Chat',
          style: TextStyle(
              color: Colors.black, fontSize: 17.0, fontWeight: FontWeight.w600),
        ),
        iconTheme: new IconThemeData(color: Colors.black),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Positioned(
              child: ListView(
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
//              padding: EdgeInsets.only(bottom: 20),
                    child: ListView(
                      physics: ScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Flexible(
                                flex: 2,
                                fit: FlexFit.tight,
                                child: Container(
                                  margin: EdgeInsets.only(left: 15, right: 10),
                                  width: 55,
                                  height: 55,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          image: AssetImage(''),
                                          fit: BoxFit.fill)),
                                )),
                            Flexible(
                                flex: 20,
                                fit: FlexFit.tight,
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  constraints: BoxConstraints(
                                      maxWidth: 280, minHeight: 56),
                                  margin: EdgeInsets.only(
                                    left: 0,
                                    right: 20,
                                    top: 30,
                                  ),
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: Color(0xFFF0F0F0),
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(0),
                                          topRight: Radius.circular(40),
                                          bottomRight: Radius.circular(40),
                                          bottomLeft: Radius.circular(40))),
                                  child: Text(
                                    'Hi, How can I help you ?',
                                    // style: hintTextPopregularwhitesm(),
                                  ),
                                ))
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Flexible(
                                flex: 20,
                                fit: FlexFit.tight,
                                child: Container(
                                  alignment: Alignment.topRight,
                                  width: MediaQuery.of(context).size.width,
                                  constraints: BoxConstraints(
                                      maxWidth: 280, minHeight: 56),
                                  margin: EdgeInsets.only(
                                    left: 20,
                                    // right: 0,
                                    top: 30,
                                  ),
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color:
                                          Color(0xFFFFECAC).withOpacity(0.60),
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(40),
                                          topRight: Radius.circular(0),
                                          bottomRight: Radius.circular(40),
                                          bottomLeft: Radius.circular(40))),
                                  child: Text(
                                    'Hello',
                                    // style: hintTextPopregularwhitesm(),
                                  ),
                                )),
                            Flexible(
                                flex: 2,
                                fit: FlexFit.tight,
                                child: Container(
                                  margin: EdgeInsets.only(left: 15, right: 10),
                                  width: 55,
                                  height: 55,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    // image: DecorationImage(
                                    //     image: AssetImage(
                                    //         'lib/assets/images/profile.png'),
                                    //     fit: BoxFit.fill)
                                  ),
                                )),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
//            top: MediaQuery.of(context).size.height *0.8 ,
              bottom: 0,
              child: Container(
                height: 60,
                width: MediaQuery.of(context).size.width,
                color: Colors.grey,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      color: Colors.white,
                      height: 45,
                      margin: EdgeInsets.only(left: 8),
                      padding: EdgeInsets.only(left: 8),
                      width: MediaQuery.of(context).size.width * 0.85,
                      child: TextFormField(
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          border: InputBorder.none,

                          hintText: 'Type Message',
                          // hintStyle: regular(),
                        ),
                        // style: hintTextPopregular(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Icon(
                        Icons.send,
                        size: 27,
                        color: primary,
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
