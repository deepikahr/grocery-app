//import 'package:flutter/material.dart';
//import '../../styles/styles.dart';
//import 'package:flutter_svg/flutter_svg.dart';
//import 'forgotPassword.dart';
//import '../pages/home.dart';
//
//class EnterPassword extends StatefulWidget {
//  @override
//  _EnterPasswordState createState() => _EnterPasswordState();
//}
//
//class _EnterPasswordState extends State<EnterPassword> {
//  bool success = false;
//
//  @override
//  Widget build(BuildContext context) {
//    var screenWidth = MediaQuery.of(context).size.width;
//    var screenHeight = MediaQuery.of(context).size.height;
//    return Stack(
//      children: <Widget>[
//        Scaffold(
//            backgroundColor: Color(0xFFF4F7FA),
//            appBar: AppBar(
////        leading: Image.asset('lib/assets/icons/back.png '),
//              centerTitle: true,
//              elevation: 0.0,
//              actions: <Widget>[
//                GestureDetector(
//                  onTap: () {
//                    if(mounted)setState(() {
////                login = false;
//                    });
//                  },
//                  child: Padding(
//                    padding: EdgeInsets.only(right: 8.0, top: 16.0),
//                    child: Text('Sign up', style: hintSfMediumprimarysmall()),
//                  ),
//                ),
//              ],
//            ),
//            body: Container(
//                height: 250.0,
//                width: screenWidth,
//                padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 25.0),
//                decoration: new BoxDecoration(
//                    color: Colors.white,
//                    boxShadow: [
//                      new BoxShadow(
//                        color: Color(0XFF80828B),
//                        blurRadius: 10.0,
//                      ),
//                    ],
//                    borderRadius: BorderRadius.only(
//                        bottomRight: Radius.circular(5.44),
//                        bottomLeft: Radius.circular(5.44))),
//                child: Column(
//                  crossAxisAlignment: CrossAxisAlignment.start,
//                  children: <Widget>[
//                    Text(
//                      'Enter password',
//                      style: hintSfbold(),
//                    ),
//                    Padding(padding: EdgeInsets.only(top: 5.0)),
//                    Text(
//                      "Enter password to sign in",
//                      style: hintSfMediumgreysmall(),
//                    ),
//                    Container(
//                      height: 45.8,
//                      padding: EdgeInsets.only(left: 15.0, right: 0.0),
//                      margin: EdgeInsets.only(top: 25.0, bottom: 20.0),
//                      decoration: BoxDecoration(
//                          border: Border.all(color: Color(0xFFD4D4E0)),
//                          borderRadius: BorderRadius.circular(1.81)),
//                      child: TextFormField(
//                        decoration: InputDecoration(
//                            border: InputBorder.none,
//                            hintStyle: hintSfletterspacingMediumgreyersmall(),
//                            suffixIcon: Icon(Icons.close)
////                  suffixIcon: SvgPicture.asset('lib/assets/icons/close.svg', height: 10.0,)
//                            ),
//                        style: hintSfletterspacingMediumgreyersmall(),
//                        obscureText: true,
//                        cursorColor: primary,
//                      ),
//                    ),
//                    Row(
//                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                      children: <Widget>[
//                        GestureDetector(
//                          onTap: () {
//                            Navigator.push(
//                              context,
//                              MaterialPageRoute(
//                                  builder: (BuildContext context) =>
//                                      ForgotPassword()),
//                            );
//                          },
//                          child: Text('Forgot password?',
//                              style: hintSfsemigreysmaller()),
//                        ),
//                        FloatingActionButton(
//                          backgroundColor: primary,
//                          onPressed: () {
//                            if(mounted)setState(() {
//                              success = true;
//                            });
//                          },
//                          child: SvgPicture.asset(
//                            'lib/assets/icons/correct.svg',
//                            color: Colors.white,
//                          ),
//                        )
//                      ],
//                    ),
//                  ],
//                ))),
//        success
//            ? Positioned(
//                child: GestureDetector(
//                  onTap: () {
//                    if(mounted)setState(() {
//                      success = false;
//                    });
//                  },
//                  child: Stack(
//                    children: <Widget>[
//                      Container(
//                        color: Color(0xFFc0c1ca),
//                        height: screenHeight,
//                      ),
//                      Positioned(
//                          left: 10.0,
//                          right: 10.0,
//                          top: 170.0,
//                          child: Material(
//                            child: Container(
//                              height: 320,
//                              width: screenWidth,
//                              decoration: new BoxDecoration(
//                                  color: Colors.white,
//                                  boxShadow: [
//                                    new BoxShadow(
//                                      color: Color(0XFF80828B),
//                                      blurRadius: 10.0,
//                                    ),
//                                  ],
//                                  borderRadius:
//                                      BorderRadius.all(Radius.circular(1.81))),
//                              child: Column(
//                                mainAxisAlignment:
//                                    MainAxisAlignment.spaceBetween,
//                                children: <Widget>[
//                                  Padding(
//                                    padding: EdgeInsets.only(top: 30.0),
//                                    child: SvgPicture.asset(
//                                      'lib/assets/imgs/success.svg',
//                                      color: primary,
//                                    ),
//                                  ),
//                                  Text(
//                                    'Congratulations!',
//                                    style: hintSfsemiblack(),
//                                  ),
//                                  Text(
//                                    'Your mobile number verified successfull! You can now continue using Koolls online shopping',
//                                    style: hintSfMediumgrey(),
//                                    textAlign: TextAlign.center,
//                                  ),
//                                  Container(
//                                    height: 48.8,
//                                    width: 378,
//                                    decoration: new BoxDecoration(
//                                        color: primary,
//                                        borderRadius: BorderRadius.only(
//                                            bottomRight: Radius.circular(1.81),
//                                            bottomLeft: Radius.circular(1.81))),
//                                    child: RawMaterialButton(
//                                      onPressed: () {
//                                        Navigator.pushAndRemoveUntil(
//                                            context,
//                                            MaterialPageRoute(
//                                                builder:
//                                                    (BuildContext context) =>
//                                                        HomePage()),
//                                            (Route<dynamic> route) => false);
//
////                                  Navigator.push(
////                                    context,
////                                    MaterialPageRoute(
////                                      builder: (BuildContext context) => AuthenticationPage(popupType: 'login',),
////                                    ),
////                                  );
//                                      },
//                                      child: Text(
//                                        'Sign in',
//                                        style: hintSfMediumwhitesmaller(),
//                                      ),
//                                    ),
//                                  )
//                                ],
//                              ),
//                            ),
//                          ))
//                    ],
//                  ),
//                ),
//              )
//            : Container()
//      ],
//    );
//  }
//}
