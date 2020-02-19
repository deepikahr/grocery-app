import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';
import 'package:grocery_pro/screens/thank-you/thankyou.dart';


import 'package:grocery_pro/style/style.dart';

class Payment extends StatefulWidget {
  final int quantity;
  final int currentIndex;
  Payment({Key key, this.quantity, this.currentIndex}) : super(key: key);
  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  int selectedRadio;

setSelectedRadio(int val) async {
    setState(() {
      selectedRadio = val;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GFAppBar(
        title: Text('Payment',
            style: TextStyle(
                color: Colors.black,
                fontSize: 17.0,
                fontWeight: FontWeight.w600)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black, size: 15.0),
      ),
  body: ListView(
    children: <Widget>[
      Container(
        color: Colors.grey[100],
        child: Padding(
          padding: const EdgeInsets.only(top:8.0,bottom: 8.0,left: 20,right: 20),
          child: Row(
            
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
           Column(
             children: <Widget>[
               Text(
                                    'Total',
                                    style: boldHeading(),
                                  ),
             ],
           ),
                Column(
                  children: <Widget>[
                  Row(
                    children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top:4.0),
                          child: Icon(
                                      IconData(
                                        0xe913,
                                        fontFamily: 'icomoon',
                                      ),
                                      color: Colors.black,
                                      size: 15.0,
                                    ),
                        ),
                                  Text(
                                    '123',
                                    style: boldHeading(),
                                  )
                    ],
                  )
                  ],
                ) 
            ],
          ),
        ),
      ),
      SizedBox(height:10),
  Row(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Text('Yes Bank'),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 18.0, top: 10.0),
                              child: Image.asset(
                                  'lib/assets/images/mastercard.png'),
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top:25.0),
                          child: Column(
                            
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(
                                    right: 14.0, bottom: 5.0),
                                child: Text('7034xxxx xxxx xxxx'),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                // crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(left:20),
                                    width: 60.0,
                                    height: 40.0,
                                    child: TextFormField(
                                      initialValue: "CVV",
                                      style: labelStyle(),

                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                          contentPadding: EdgeInsets.all(10),
                                          enabledBorder: const OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Colors.grey, width: 0.0),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(color: primary),
                                          )),
                                      // style: textBlackOSR(),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left:20),

                                    child: GFButton(
                                    color: GFColors.WARNING,
                                    text: 'Submit', onPressed: null,
                                    textColor: Colors.black,
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                     SizedBox(height:20),
  Row(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Text('SBI'),
                              ],
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 18.0, top: 10.0),
                              child: Image.asset(
                                  'lib/assets/images/visa.png'),
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top:25.0),
                          child: Column(
                            
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(
                                    right: 14.0, bottom: 5.0),
                                child: Text('7034xxxx xxxx xxxx'),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                // crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(left:20),
                                    width: 60.0,
                                    height: 40.0,
                                    child: TextFormField(
                                      initialValue: "CVV",
                                      style: labelStyle(),

                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                          contentPadding: EdgeInsets.all(10),
                                          enabledBorder: const OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Colors.grey, width: 0.0),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(color: primary),
                                          )),
                                      // style: textBlackOSR(),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left:20),

                                    child: GFButton(
                                    color: GFColors.WARNING,
                                    text: 'Submit', onPressed: null,
                                    textColor: Colors.black,
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height:20),
                    Padding(
                      padding: const EdgeInsets.only(left:18.0,right: 18.0),
                      child: Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  // crossAxisAlignment: CrossAxisAlignment.center,
  children: <Widget>[
    Text('Cash On Delivery',style:boldHeading()),
    Padding(
      padding: const EdgeInsets.only(top:8.0),
      child: Radio(
                            value: 2,
                            groupValue: selectedRadio,
                            activeColor: Colors.green,
                            onChanged: (val) {
                              print("Radio $val");
                              setSelectedRadio(val);
                            },
                          ),
    ),

  ],
),
                    ),
                    SizedBox(height:10),
   Padding(
                      padding: const EdgeInsets.only(left:18.0,right: 18.0),
                      child: Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  // crossAxisAlignment: CrossAxisAlignment.center,
  children: <Widget>[
    Text('Credit/Debit Card',style:boldHeading()),
    Padding(
      padding: const EdgeInsets.only(top:5.0),
      child: Radio(
                            value: 2,
                            groupValue: selectedRadio,
                            activeColor: Colors.green,
                            onChanged: (val) {
                              print("Radio $val");
                              setSelectedRadio(val);
                            },
                          ),
    ),

  ],
),

                    ),
                    SizedBox(height:10),
                    Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left:20.0),
                          child: Row(
                            children: <Widget>[
                              Text('Account number'),
                            ],
                          ),
                        ),
                        Padding(
      padding: const EdgeInsets.only(top: 5.0, bottom: 10.0,left: 20,right: 20),
      child: Container(
        // color: Colors.blue,
        child: TextFormField(
          // initialValue: "user@demo.com",
          onSaved: (String value) {
          },
          validator: (String value) {
            if (value.isEmpty ||
                !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                        .hasMatch(value)) {
              return "Please Enter a Valid Email";
              // MyLocalizations.of(context).pleaseEnterValidEmail;
            } else
              return null;
          },
          style: labelStyle(),
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.all(10),
              enabledBorder: const OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.grey, width: 0.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: primary),
              )),
          // style: textBlackOSR(),
        ),
      ),
    ),
                      ],
                    ),
                    SizedBox(height:10),
              Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left:20.0),
                          child: Row(
                            children: <Widget>[
                              Text('Account Name'),
                            ],
                          ),
                        ),
                        Padding(
      padding: const EdgeInsets.only(top: 5.0, bottom: 10.0,left: 20,right: 20),
      child: Container(
        // color: Colors.blue,
        child: TextFormField(
          // initialValue: "user@demo.com",
          onSaved: (String value) {
          },
          validator: (String value) {
            if (value.isEmpty ||
                !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                        .hasMatch(value)) {
              return "Please Enter a Valid Email";
              // MyLocalizations.of(context).pleaseEnterValidEmail;
            } else
              return null;
          },
          style: labelStyle(),
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.all(10),
              enabledBorder: const OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.grey, width: 0.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: primary),
              )),
          // style: textBlackOSR(),
        ),
      ),
    ),
                      ],
                    ),
                    SizedBox(height:10),
                    Row(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                               Padding(
                          padding: const EdgeInsets.only(right:60.0,bottom: 4),
                          child: Row(
                            
                            children: <Widget>[
                              Text('Expiring On'),
                            ],
                          ),
                        ),
                               Container(
                                    margin: EdgeInsets.only(left:20),
                                    width: 160.0,
                                    height: 40.0,
                                    child: TextFormField(
                                      style: labelStyle(),

                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                          contentPadding: EdgeInsets.all(10),
                                          enabledBorder: const OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Colors.grey, width: 0.0),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(color: primary),
                                          )),
                                      // style: textBlackOSR(),
                                    ),
                                  ),
                          ],
                        ),
                               Column(
                          children: <Widget>[
                               Padding(
                          padding: const EdgeInsets.only(right:60.0,bottom: 4),
                          child: Row(
                            
                            children: <Widget>[
                              Text('CVV'),
                            ],
                          ),
                        ),
                               Container(
                                    margin: EdgeInsets.only(left:20),
                                    width: 110.0,
                                    height: 40.0,
                                    child: TextFormField(
                                      style: labelStyle(),

                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                          contentPadding: EdgeInsets.all(10),
                                          enabledBorder: const OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Colors.grey, width: 0.0),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(color: primary),
                                          )),
                                      // style: textBlackOSR(),
                                    ),
                                  ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height:30),
    ],
  ),
  bottomNavigationBar: Container(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 20.0,
            right: 20.0,
          ),
          child: GFButton(
            // color: primary,

            color: GFColor.warning,
blockButton: true,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Thankyou()),
              );
            },
            text: 'Pay Now',
            textStyle: TextStyle(fontSize: 17.0, color: Colors.black),
          ),
        ),
      ),    );
  }
}
