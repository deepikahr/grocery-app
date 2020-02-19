import 'package:flutter/material.dart';
import 'package:getflutter/components/accordian/gf_accordian.dart';
import 'package:getflutter/getflutter.dart';
import 'package:grocery_pro/screens/payment/payment.dart';
import 'package:grocery_pro/style/style.dart';
import 'package:grocery_pro/service/sentry-service.dart';
import 'package:grocery_pro/service/product-service.dart';
import 'package:grocery_pro/service/auth-service.dart';
import 'package:grocery_pro/screens/address/add-address.dart';
import 'package:grocery_pro/service/address-service.dart';
import 'package:grocery_pro/screens/address/edit-address.dart';
import 'package:grocery_pro/screens/home/home.dart';

SentryError sentryError = new SentryError();

class Checkout extends StatefulWidget {
  final Map<String, dynamic> cartItem;
  final String buy;
  final int quantity;
  Checkout({Key key, this.cartItem, this.buy, this.quantity}) : super(key: key);
  @override
  _CheckoutState createState() => _CheckoutState();
}

enum SingingCharacter { lafayette, jefferson }

class _CheckoutState extends State<Checkout> {
  // Declare this variable
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _recipientformKey = GlobalKey<FormState>();
  int selectedRadio;
  Map<String, dynamic> userInfo, address;
  Map<String, dynamic> cartItem;
  int deliveryCharges = 0;
  bool isCheckout = false;
  List locationList = List();
  List addressList = List();

  int homeDelivery = 0;
  int pickUP = 1;
  int deliveryType = 0;
  String selectedDeliveryType;

  var selectedAddress;
  var selectedDeliveryAddress;

  int cardPayment = 0;
  int cashOnDelivery = 1;
  int paymentType = 0;

  String locationNotFound;
  bool isLoading = false;
  bool addressLoading = false;
  int groupValue;
  bool deliveryAddress = false;
  var currentTime = new DateTime.now();
  int i = 0;
  bool isPlaceOrderLoading = false;
  String deliveryMessage, name, mobileNumber, cardId;
  DateTime selectedDate;
  var addressId;

  @override
  void initState() {
    super.initState();
    getLocations();
    getUserInfo();
    getAddress();
    print(widget.cartItem);
    print(widget.quantity);
  }

  paynow() {
    if (mounted) {
      setState(() {
        name = '${userInfo['firstName']}';
        // email = '${userInfo['email']}';
      });
    }
    // if (homeDelivery == 1) {
    //   return 'Please select home delivery';
    // }
    // if (selectedDeliveryAddress == 1) {
    //   return "Please Select Address";
    // } else if (cashOnDelivery == 1) {
    //   return 'Please select Cash On Delivery';
    // } else if (selectedDate == null) {
    //   return "please select a date";
    // } else {
    print('I am here');

    placeOrder();
  }

  placeOrder() async {
    Map<String, dynamic> data = {
      "deliveryType": "Home_Delivery",
      "paymentType": 'COD',
    };
    data['deliveryDate'] = currentTime.millisecondsSinceEpoch;
    data['deliveryTime'] = currentTime.toString();
    data['deliveryAddress'] = selectedAddress['_id'].toString();
    if (widget.buy == null) {
      if (mounted) {
        setState(() {
          isPlaceOrderLoading = true;
        });
      }
      data['cart'] = widget.cartItem['cart']['_id'].toString();
      data['deliveryCharges'] = '${widget.cartItem['deliveryCharges']}';

      print(data);

      await ProductService.placeOrder(data).then((onValue) {
        try {
          if (onValue['response_code'] == 201) {
            if (mounted) {
              setState(() {
                isPlaceOrderLoading = false;
              });
            }
            showDialog<Null>(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return Container(
                  width: 270.0,
                  child: new AlertDialog(
                    title: new Text('Thank You ...!!'),
                    content: new SingleChildScrollView(
                      child: new ListBody(
                        children: <Widget>[
                          new Text('Order Successful'),
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      new FlatButton(
                        child: new Text('ok'),
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) => Payment(
                                        currentIndex: 0,
                                      )),
                              (Route<dynamic> route) => false);
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          } else {
            if (mounted) {
              setState(() {
                isPlaceOrderLoading = false;
              });
            }
          }
        } catch (error, stackTrace) {
          sentryError.reportError(error, stackTrace);
        }
      }).catchError((error) {
        sentryError.reportError(error, null);
      });
    } else {
      print('apple');
      print(widget.cartItem['cart']);
      data['cart'] = {
        'productId': widget.cartItem['cart'][0]['_id'],
        'quantity': 1,
        'subTotal': widget.cartItem['subTotal'],
      };
      print(data);

      print(data);

      if (mounted) {
        setState(() {
          isPlaceOrderLoading = true;
        });
      }

      await ProductService.quickBuyNow(data).then((onValue) {
        print('value of buy now$onValue');
        try {
          if (onValue['response_code'] == 201) {
            showDialog<Null>(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return Container(
                  width: 270.0,
                  child: new AlertDialog(
                    title: new Text('Thank You ...!!'),
                    content: new SingleChildScrollView(
                      child: new ListBody(
                        children: <Widget>[
                          new Text('Order Successful'),
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      new FlatButton(
                        child: new Text('ok'),
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) => Home(
                                        currentIndex: 0,
                                      )),
                              (Route<dynamic> route) => false);
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          }
        } catch (error, stackTrace) {
          sentryError.reportError(error, stackTrace);
        }
      }).catchError((error) {
        sentryError.reportError(error, null);
      });
    }
    print('order details $data');
  }

  addressRadioValueChanged(int value) async {
    if (mounted) {
      setState(() {
        groupValue = value;
        selectedAddress = addressList[value];
      });
    }
    print('selected address $selectedAddress');

    return value;
  }

  deliveryTypeRadioValue(val) async {
    if (mounted) {
      setState(() {
        groupValue = val;
        selectedDeliveryType = val;
      });
    }
    print(selectedDeliveryType);
    return val;
  }

  getUserInfo() async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }
    await LoginService.getUserInfo().then((onValue) {
      try {
        if (mounted) {
          setState(() {
            isLoading = false;
            userInfo = onValue['response_data']['userInfo'];
            // print('userinfo at checkout $userInfo ');
          });
        }
      } catch (error, stackTrace) {
        sentryError.reportError(error, stackTrace);
      }
    }).catchError((error) {
      sentryError.reportError(error, null);
    });
  }

  getAddress() async {
    if (mounted) {
      setState(() {
        addressLoading = true;
      });
    }
    await AddressService.getAddress().then((onValue) {
      // print('available address $onValue');
      try {
        if (mounted) {
          setState(() {
            addressList = onValue['response_data'];
            addressLoading = false;
          });
        }
      } catch (error, stackTrace) {
        sentryError.reportError(error, stackTrace);
      }
    }).catchError((error) {
      sentryError.reportError(error, null);
    });
  }

  deleteAddress(body) async {
    // print('id $body');
    await AddressService.deleteAddress(body).then((onValue) {
      // print('id $onValue');
      try {
        getAddress();
        if (mounted) {
          setState(() {
            addressList = addressList;
          });
        }
        // Navigator.pop(context);
      } catch (error, stackTrace) {
        sentryError.reportError(error, stackTrace);
      }
    }).catchError((error) {
      sentryError.reportError(error, null);
    });
  }

  getLocations() async {
    await ProductService.getLocationList().then((onValue) {
      try {
        if (onValue['response_code'] == 200) {
          if (mounted) {
            setState(() {
              locationList = onValue['response_data'];
            });
          }
        } else if (onValue['response_code'] == 400) {
          if (mounted) {
            setState(() {
              locationNotFound = onValue['response_data']['message'];
            });
          }
        }
      } catch (error, stackTrace) {
        sentryError.reportError(error, stackTrace);
      }
    }).catchError((error) {
      sentryError.reportError(error, null);
    });
  }

// Changes the selected value on 'onChanged' click on each radio button
  setSelectedRadio(int val) async {
    setState(() {
      selectedRadio = val;
    });
  }

  final List<String> _listViewData = [
    "rstrs",
    'hjgch',
    'hgch',
    'hgchg'
        "rstrs",
    'hjgch',
    'hgch',
    'hgchg'
  ];

  int _selectedIndex = 0;

  _onSelected(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    Widget itemCard(int i) {
      return Container(
        color: Colors.grey[200],
        // width: MediaQuery.of(context).size.width,
        width: 70,
        // height: 45,
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 3, bottom: 3),
              child: Container(
                  // color: Colors.grey,

                  width: 60,
                  margin: EdgeInsets.only(
                    left: 10,
                  ),
                  decoration: BoxDecoration(
                      color: _selectedIndex != null && _selectedIndex == i
                          ? primary
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(10)),
                  child: InkWell(
                    onTap: () => _onSelected(i),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('Mon'),
                        Text('10 Feb'),
                      ],
                    ),
                  )),
            )
          ],
        ),
      );
    }

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
            padding: const EdgeInsets.only(
                left: 20.0, top: 10.0, bottom: 10.0, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text(
                      'Sub total ( ${widget.quantity} items )',
                      style: regular(),
                    )
                  ],
                ),
                Column(
                  children: <Widget>[
                    Row(
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
                          '${widget.cartItem['subTotal']}',
                          style: regular(),
                        )
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 20.0, bottom: 10.0, right: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text(
                      'Tax',
                      style: regular(),
                    )
                  ],
                ),
                Column(
                  children: <Widget>[
                    Row(
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
                          '${widget.cartItem['tax']}',
                          style: regular(),
                        )
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, bottom: 10.0, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    Row(
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
                          '${widget.cartItem['deliveryCharges']}',
                          style: regular(),
                        )
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
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
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 22.0, top: 10.0, bottom: 10.0),
                          child: Text(
                            'Total',
                            style: boldHeading(),
                          ),
                        )
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Icon(
                                IconData(
                                  0xe913,
                                  fontFamily: 'icomoon',
                                ),
                                color: Colors.black,
                                size: 15.0,
                              ),
                            ),
                            // color: Colors.black,
                            // size: 10.0,
                            // ),
                            Text(
                              '${widget.cartItem['grandTotal']}',
                              style: boldHeading(),
                            )
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text('Delivery type', style: boldHeading()),
          ),
          Row(children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 22.0, top: 10),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        'Home Delivery',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w400),
                      ),
                    ],
                  )
                ],
              ),
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
                      Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(width: 0.0, color: Colors.grey),
                          ),
                        ),
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left: 18.0),
                              child: Container(
                                child: Column(
                                  //   children: <Widget>[
                                  // Column(
                                  children: <Widget>[
                                    Container(
                                        width:
                                            MediaQuery.of(context).size.width -
                                                125,
                                        child: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 0),
                                            child: ListView.builder(
                                                physics: ScrollPhysics(),
                                                shrinkWrap: true,
                                                itemCount:
                                                    addressList.length == null
                                                        ? 0
                                                        : addressList.length,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int i) {
                                                  return Column(children: <
                                                      Widget>[
                                                    RadioListTile(
                                                      groupValue: groupValue,
                                                      activeColor: primary,
                                                      // selected: true,
                                                      value: i,
                                                      title: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                                '${addressList[i]['flatNumber']}, ${addressList[i]['locality']},${addressList[i]['landMark']},'),
                                                            Text(
                                                                '${addressList[i]['city']}, ${addressList[i]['state']}, ${addressList[i]['postalCode']}'),
                                                          ]),
                                                      onChanged:
                                                          addressRadioValueChanged,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 0.0),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: <Widget>[
                                                              GFButton(
                                                                onPressed:
                                                                    () async {
                                                                  await Navigator
                                                                      .push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              EditAddress(
                                                                        isCheckout:
                                                                            true,
                                                                        updateAddressID:
                                                                            addressList[i],
                                                                      ),
                                                                    ),
                                                                  );
                                                                  // print(
                                                                  // address);

                                                                  getAddress();
                                                                },
                                                                child: Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      left:
                                                                          18.0,
                                                                      right:
                                                                          18.0),
                                                                  child: Text(
                                                                    "Edit",
                                                                  ),
                                                                ),
                                                                type:
                                                                    GFButtonType
                                                                        .outline,
                                                                color: GFColor
                                                                    .warning,
                                                                size: GFSize
                                                                    .medium,
                                                                // blockButton: true,
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            20.0),
                                                                child: GFButton(
                                                                  onPressed:
                                                                      () {
                                                                    deleteAddress(
                                                                        addressList[i]
                                                                            [
                                                                            '_id']);
                                                                  },
                                                                  child:
                                                                      Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            8.0,
                                                                        right:
                                                                            8.0),
                                                                    child: Text(
                                                                      "Delete",
                                                                    ),
                                                                  ),
                                                                  color: GFColor
                                                                      .warning,
                                                                  type: GFButtonType
                                                                      .outline,
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ]);
                                                }))),
                                  ],
                                ),
                                //   ],
                                // ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding:
                              const EdgeInsets.only(top: 10.0, bottom: 10.0),
                          child: GFButton(
                            onPressed: () async {
                              Map<String, dynamic> address =
                                  await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddAddress(
                                          isCheckout: true,
                                        )),
                              );
                              // print(address);
                              if (address != null) {
                                addressList.add(address);
                                getAddress();
                              }
                            },
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

                title: addressList[0]['flatNumber'] +
                    ', ' +
                    addressList[0]['locality'] +
                    '....', // collapsedIcon: Icon(Icons.location_on),
              ),
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.only(left: 20.0),
          //   child: Text('Payment type', style: boldHeading()),
          // ),
          // Row(children: <Widget>[
          //   Padding(
          //     padding: const EdgeInsets.only(left: 22.0),
          //     child: Column(
          //       children: <Widget>[
          //         Row(
          //           children: <Widget>[
          //             Text('Credit/Debit Card'),
          //             Radio(
          //               value: 1,
          //               groupValue: selectedRadio,
          //               activeColor: Colors.green,
          //               onChanged: (val) {
          //                 print("Radio $val");
          //                 setSelectedRadio(val);
          //               },
          //             ),
          //           ],
          //         )
          //       ],
          //     ),
          //   ),
          //   Column(
          //     children: <Widget>[
          //       Row(
          //         children: <Widget>[
          //           Text('Cash On Delivery'),
          //           Radio(
          //             value: 2,
          //             groupValue: selectedRadio,
          //             activeColor: Colors.green,
          //             onChanged: (val) {
          //               print("Radio $val");
          //               setSelectedRadio(val);
          //             },
          //           ),
          //         ],
          //       )
          //     ],
          //   ),
          // ]),
          // Padding(
          //   padding: const EdgeInsets.only(left: 10.0, right: 10.0),
          //   child: GFAccordion(
          //     title: 'Saved Cards',
          //     collapsedTitlebackgroundColor: Colors.grey[300],
          //     contentChild: Container(
          //       decoration: BoxDecoration(
          //         color: Colors.white,
          //         boxShadow: [
          //           new BoxShadow(
          //               color: Colors.black38,
          //               // blurRadius: 1.0,
          //               offset: Offset(0.0, 0.50)),
          //         ],
          //       ),
          //       child: Column(
          //         children: <Widget>[
          //           Row(
          //             children: <Widget>[
          //               Column(
          //                 children: <Widget>[
          //                   Padding(
          //                     padding:
          //                         const EdgeInsets.only(left: 18.0, top: 10.0),
          //                     child: Image.asset(
          //                         'lib/assets/images/mastercard.png'),
          //                   )
          //                 ],
          //               ),
          //               Column(
          //                 children: <Widget>[
          //                   Padding(
          //                     padding: const EdgeInsets.only(
          //                         left: 8.0, top: 10.0, bottom: 5.0),
          //                     child: Text('7034xxxx xxxx xxxx'),
          //                   ),
          //                   Container(
          //                     width: 70.0,
          //                     height: 50.0,
          //                     child: TextFormField(
          //                       initialValue: "CVV",
          //                       style: labelStyle(),

          //                       keyboardType: TextInputType.number,
          //                       decoration: InputDecoration(
          //                           contentPadding: EdgeInsets.all(10),
          //                           enabledBorder: const OutlineInputBorder(
          //                             borderSide: const BorderSide(
          //                                 color: Colors.grey, width: 0.0),
          //                           ),
          //                           focusedBorder: OutlineInputBorder(
          //                             borderSide: BorderSide(color: primary),
          //                           )),
          //                       // style: textBlackOSR(),
          //                     ),
          //                   ),
          //                 ],
          //               ),
          //             ],
          //           ),
          //           Center(
          //             child: Padding(
          //               padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
          //               child: GFButton(
          //                 onPressed: null,
          //                 icon: Icon(Icons.add),
          //                 child: Padding(
          //                   padding: const EdgeInsets.only(right: 8.0),
          //                   child: Text(
          //                     "Add Card",
          //                   ),
          //                 ),
          //                 color: GFColor.dark,
          //                 type: GFButtonType.outline,
          //               ),
          //             ),
          //           ),
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 30.0, bottom: 4.0),
                    child: Text('Choose Delivery slot', style: boldHeading()),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: <Widget>[
                  Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: _listViewData.length,
                      itemBuilder: (BuildContext context, int index) =>
                          Container(
                        // height: 50,

                        child: itemCard(index),
                      ),
                    ),
                  )
                ],
              ),
              Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text('10 Am to 12 Pm'),
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
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text('1 Pm to 4 Pm '),
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text('5 Pm to 9 Pm '),
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
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
                ],
              )

              // Center(
              //   child: Container(
              //     width: 300,
              //     decoration: BoxDecoration(
              //         border: Border.all(color: Colors.grey),
              //         borderRadius: BorderRadius.circular(10.0)),
              //     child: FlatButton(
              //         onPressed: () {
              //           DatePicker.showDatePicker(context,
              //               showTitleActions: true,
              //               minTime: DateTime(2010, 3, 5),
              //               maxTime: DateTime(2019, 6, 7), onChanged: (date) {
              //             print('change $date');
              //           }, onConfirm: (date) {
              //             print('confirm $date');
              //           }, currentTime: DateTime.now(), locale: LocaleType.en);
              //         },
              //         child: Row(
              //           mainAxisAlignment: MainAxisAlignment.start,
              //           children: <Widget>[
              //             Text(
              //               'DD/MM/YYYY',
              //               style: TextStyle(color: Colors.grey),
              //             ),
              //             Padding(
              //               padding: const EdgeInsets.only(left: 148.0),
              //               child:
              //                   Icon(Icons.calendar_today, color: Colors.grey),
              //             )
              //           ],
              //         )),
              //   ),
              // ),
            ],
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: <Widget>[
          //     Column(
          //       children: <Widget>[
          //         Row(
          //           children: <Widget>[
          //             Text('BreakFast'),
          //             Radio(
          //               value: 2,
          //               groupValue: selectedRadio,
          //               activeColor: Colors.green,
          //               onChanged: (val) {
          //                 print("Radio $val");
          //                 setSelectedRadio(val);
          //               },
          //             ),
          //           ],
          //         )
          //       ],
          //     ),
          //     Column(
          //       children: <Widget>[
          //         Row(
          //           children: <Widget>[
          //             Text('Lunch'),
          //             Radio(
          //               value: 2,
          //               groupValue: selectedRadio,
          //               activeColor: Colors.green,
          //               onChanged: (val) {
          //                 print("Radio $val");
          //                 setSelectedRadio(val);
          //               },
          //             ),
          //           ],
          //         )
          //       ],
          //     ),
          //     Column(
          //       children: <Widget>[
          //         Row(
          //           children: <Widget>[
          //             Text('Dinner'),
          //             Radio(
          //               value: 2,
          //               groupValue: selectedRadio,
          //               activeColor: Colors.green,
          //               onChanged: (val) {
          //                 print("Radio $val");
          //                 setSelectedRadio(val);
          //               },
          //             ),
          //           ],
          //         )
          //       ],
          //     ),
          //   ],
          // ),
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
            blockButton: true,
            onPressed: paynow,
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => Payment()),
            // );
            // },
            text: 'Proceed',
            textStyle: TextStyle(fontSize: 17.0, color: Colors.black),
          ),
        ),
      ),
    );
  }
}
