import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:getflutter/components/accordian/gf_accordian.dart';

import 'package:getflutter/getflutter.dart';
import 'package:grocery_pro/style/style.dart';
// import 'package:flutter_datetime_picker/flutter_datetime_picker.dart'

class Checkout extends StatefulWidget {
  @override
  _CheckoutState createState() => _CheckoutState();
}

enum SingingCharacter { lafayette, jefferson }

// ...

// SingingCharacter _character = SingingCharacter.lafayette;
// bool _isRadioSelected = false;

class _CheckoutState extends State<Checkout> {
  // Declare this variable
  int selectedRadio;

  @override
  void initState() {
    super.initState();
    selectedRadio = 0;
  }

// Changes the selected value on 'onChanged' click on each radio button
  setSelectedRadio(int val) {
    setState(() {
      selectedRadio = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GFAppBar(
        title: Text('Checkout',
            style: TextStyle(
                color: Colors.black,
                fontSize: 17.0,
                fontWeight: FontWeight.w600)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black, size: 1.0),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text('Cart summary', style: boldHeading()),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 22.0, top: 10.0, bottom: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text(
                      'Sub total ( 2 items )',
                      style: regular(),
                    )
                  ],
                ),
                Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 170.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Icon(
                            IconData(
                              0xe913,
                              fontFamily: 'icomoon',
                            ),
                            color: Colors.black,
                            size: 10.0,
                          ),
                          Text(
                            '123',
                            style: regular(),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 22.0, bottom: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text(
                      'Discount',
                      style: regular(),
                    )
                  ],
                ),
                Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 230.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Icon(
                            IconData(
                              0xe913,
                              fontFamily: 'icomoon',
                            ),
                            color: Colors.black,
                            size: 10.0,
                          ),
                          Text(
                            '123',
                            style: regular(),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 22.0, bottom: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text(
                      'Delivery charges',
                      style: regular(),
                    )
                  ],
                ),
                Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 187.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Icon(
                            IconData(
                              0xe913,
                              fontFamily: 'icomoon',
                            ),
                            color: Colors.black,
                            size: 10.0,
                          ),
                          Text(
                            '123',
                            style: regular(),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 40.0),
            child: Row(
              children: <Widget>[
                GFButton(
                  onPressed: null,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 18.0, right: 18.0),
                    child: Text(
                      " Enter Coupon code ",
                    ),
                  ),
                  type: GFButtonType.outline,
                  color: GFColor.dark,
                  size: GFSize.medium,
                  // blockButton: true,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: GFButton(
                    onPressed: null,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Text(
                        "Apply ",
                      ),
                    ),
                    color: GFColor.warning,
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15.0, bottom: 10.0),
            child: Container(
              // color: Colors.grey[100],
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  new BoxShadow(
                    color: Colors.black,
                    // blurRadius: 1.0,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 22.0, top: 10.0, bottom: 10.0),
                        child: Text(
                          'Total',
                          style: titleBold(),
                        ),
                      )
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 250.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Icon(
                              IconData(
                                0xe913,
                                fontFamily: 'icomoon',
                              ),
                              color: Colors.black,
                              size: 10.0,
                            ),
                            Text(
                              '',
                              style: boldHeading(),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text('Delivery type', style: boldHeading()),
          ),
          Row(children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 22.0),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text('Home Delivery'),
                      Radio(
                        value: 1,
                        groupValue: selectedRadio,
                        activeColor: Colors.green,
                        onChanged: (val) {
                          print("Radio $val");
                          setSelectedRadio(val);
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
            Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text('Pick Up'),
                    Radio(
                      value: 2,
                      groupValue: selectedRadio,
                      activeColor: Colors.green,
                      onChanged: (val) {
                        print("Radio $val");
                        setSelectedRadio(val);
                      },
                    ),
                  ],
                )
              ],
            ),
          ]),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: GFAccordion(
                collapsedTitlebackgroundColor: Colors.grey[300],
                contentChild: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      new BoxShadow(
                          color: Colors.black38,
                          // blurRadius: 1.0,
                          offset: Offset(0.0, 0.50)),
                    ],
                  ),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 18.0),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom:
                                  BorderSide(width: 0.0, color: Colors.grey),
                            ),
                          ),
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
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  Container(
                                    width: 250.0,
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(left: 18.0),
                                      child: Text(
                                        'HSR Layout , Agara, Bengaluru, Karnataka 560102, India',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 0.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
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
                                          padding:
                                              const EdgeInsets.only(left: 20.0),
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
                      Padding(
                        padding: const EdgeInsets.only(left: 18.0),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom:
                                  BorderSide(width: 0.0, color: Colors.grey),
                            ),
                          ),
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
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  Container(
                                    width: 250.0,
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(left: 18.0),
                                      child: Text(
                                        'HSR Layout , Agara, Bengaluru, Karnataka 560102, India',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 0.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
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
                                          padding:
                                              const EdgeInsets.only(left: 20.0),
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
                          padding:
                              const EdgeInsets.only(top: 10.0, bottom: 10.0),
                          child: GFButton(
                            onPressed: null,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 8.0, right: 8.0),
                              child: Text(
                                "Add new address",
                              ),
                            ),
                            color: GFColor.dark,
                            type: GFButtonType.outline,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                title: 'HSR Layout , Agara...',
                // collapsedIcon: Icon(Icons.location_on),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text('Payment type', style: boldHeading()),
          ),
          Row(children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 22.0),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text('Credit/Debit Card'),
                      Radio(
                        value: 1,
                        groupValue: selectedRadio,
                        activeColor: Colors.green,
                        onChanged: (val) {
                          print("Radio $val");
                          setSelectedRadio(val);
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
            Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text('Cash On Delivery'),
                    Radio(
                      value: 2,
                      groupValue: selectedRadio,
                      activeColor: Colors.green,
                      onChanged: (val) {
                        print("Radio $val");
                        setSelectedRadio(val);
                      },
                    ),
                  ],
                )
              ],
            ),
          ]),
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: GFAccordion(
              title: 'Saved Cards',
              collapsedTitlebackgroundColor: Colors.grey[300],
              contentChild: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    new BoxShadow(
                        color: Colors.black38,
                        // blurRadius: 1.0,
                        offset: Offset(0.0, 0.50)),
                  ],
                ),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 18.0, top: 10.0),
                              child: Image.asset(
                                  'lib/assets/images/mastercard.png'),
                            )
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 8.0, top: 10.0, bottom: 5.0),
                              child: Text('7034xxxx xxxx xxxx'),
                            ),
                            Container(
                              width: 70.0,
                              height: 50.0,
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
                          ],
                        ),
                      ],
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                        child: GFButton(
                          onPressed: null,
                          icon: Icon(Icons.add),
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Text(
                              "Add Card",
                            ),
                          ),
                          color: GFColor.dark,
                          type: GFButtonType.outline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 30.0, bottom: 4.0),
                    child: Text('Pick Up Date'),
                  ),
                ],
              ),
              Center(
                child: Container(
                  width: 300,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10.0)),
                  child: FlatButton(
                      onPressed: () {
                        DatePicker.showDatePicker(context,
                            showTitleActions: true,
                            minTime: DateTime(2010, 3, 5),
                            maxTime: DateTime(2019, 6, 7), onChanged: (date) {
                          print('change $date');
                        }, onConfirm: (date) {
                          print('confirm $date');
                        }, currentTime: DateTime.now(), locale: LocaleType.en);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'DD/MM/YYYY',
                            style: TextStyle(color: Colors.grey),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 148.0),
                            child:
                                Icon(Icons.calendar_today, color: Colors.grey),
                          )
                        ],
                      )),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text('BreakFast'),
                      Radio(
                        value: 2,
                        groupValue: selectedRadio,
                        activeColor: Colors.green,
                        onChanged: (val) {
                          print("Radio $val");
                          setSelectedRadio(val);
                        },
                      ),
                    ],
                  )
                ],
              ),
              Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text('Lunch'),
                      Radio(
                        value: 2,
                        groupValue: selectedRadio,
                        activeColor: Colors.green,
                        onChanged: (val) {
                          print("Radio $val");
                          setSelectedRadio(val);
                        },
                      ),
                    ],
                  )
                ],
              ),
              Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text('Dinner'),
                      Radio(
                        value: 2,
                        groupValue: selectedRadio,
                        activeColor: Colors.green,
                        onChanged: (val) {
                          print("Radio $val");
                          setSelectedRadio(val);
                        },
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
          SizedBox(height: 20.0)
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

            onPressed: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => Otp()),
              // );
            },
            text: 'Submit',
            textStyle: TextStyle(fontSize: 17.0, color: Colors.black),
          ),
        ),
      ),
    );
  }
}
// _buildExpandableContent(Vehicle vehicle) {
//   List<Widget> columnContent = [];

//   for (String content in vehicle.contents)
//     columnContent.add(
//       new ListTile(
//         title: new Text(
//           content,
//           style: new TextStyle(fontSize: 18.0),
//         ),
//         leading: new Icon(vehicle.icon),
//       ),
//     );

//   return columnContent;
// }

// class Vehicle {
//   final String title;
//   List<String> contents = [];
//   final IconData icon;

//   Vehicle(this.title, this.contents, this.icon);
// }

// List<Vehicle> vehicles = [
//   new Vehicle(
//     'Bike',
//     ['Vehicle no. 1', 'Vehicle no. 2', 'Vehicle no. 7', 'Vehicle no. 10'],
//     Icons.motorcycle,
//   ),
//   new Vehicle(
//     'Cars',
//     ['Vehicle no. 3', 'Vehicle no. 4', 'Vehicle no. 6'],
//     Icons.directions_car,
//   ),
// ];
