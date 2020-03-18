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
import 'package:grocery_pro/service/common.dart';

SentryError sentryError = new SentryError();

class Checkout extends StatefulWidget {
  final Map<String, dynamic> cartItem;
  final String buy;
  final String quantity;
  final String id;
  Checkout({Key key, this.id, this.cartItem, this.buy, this.quantity})
      : super(key: key);
  @override
  _CheckoutState createState() => _CheckoutState();
}

enum SingingCharacter { lafayette, jefferson }

class _CheckoutState extends State<Checkout> {
  // Declare this variable
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _recipientformKey = GlobalKey<FormState>();
  int selectedRadio;
  Map<String, dynamic> userInfo, address;
  Map<String, dynamic> cartItem;
  int deliveryCharges = 0;
  bool isCheckout = false;
  List locationList = List();
  List addressList = List();
  List deliverySlotList = List();

  int homeDelivery = 0;
  int pickUP = 1;
  int deliveryType = 0;
  String selectedDeliveryType;
  bool isProdcutDetailLoading = false;

  var selectedAddress;
  var selectedTime;
  var selectedDeliveryAddress;

  int cardPayment = 0;
  int cashOnDelivery = 1;
  int paymentType = 0;

  renderMonth(String i) {
    List<String> months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'June',
      'July',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    int index = int.parse(i);
    return months[index - 1];
  }

  String locationNotFound;
  bool isLoading = false;
  bool addressLoading = false;
  bool deliverySlotsLoading = false;
  int groupValue;
  int groupValue1;
  int groupValue2;
  int daySlot;
  bool deliveryAddress = false;
  var currentTime = new DateTime.now();
  int i = 0;
  bool isPlaceOrderLoading = false;
  String deliveryMessage, name, mobileNumber, cardId;
  // DateTime selectedDate;
  var selectedDate;
  var addressId;
  String token;

  @override
  void initState() {
    super.initState();
    getLocations();
    getUserInfo();
    getAddress();

    getDeliverySlot();
    getTokenApi();
    // print('cartitem at checkout ${widget.cartItem}');
    // print(widget.cartItem['_id']);
    // print(widget.quantity);
    // print(widget.id);
    // print(widget.buy);
    // print(widget.cartItem['_id'].runtimeType);
    // print(widget.cartItem['subTotal'].runtimeType);
    // print(widget.cartItem['tax'].runtimeType);
    // print(widget.cartItem['grandTotal'].runtimeType);
    // print(widget.cartItem['deliveryCharges'].runtimeType);
  }

  getTokenApi() async {
    await Common.getToken().then((onValue) {
      token = onValue;
    });
    print('token $token');
  }

  proceed() {
    if (mounted) {
      setState(() {
        name = '${userInfo['firstName']}';
        // email = '${userInfo['email']}';
      });
    }
    // print('I am here');

    placeOrder();
  }

  showSnackbar(message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: Duration(milliseconds: 3000),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  addressRadioValueChanged(int value) async {
    if (mounted) {
      setState(() {
        groupValue1 = value;
        selectedAddress = addressList[value];
      });
    }
    // print('selected address $selectedAddress');

    return value;
  }

  setSelectedRadio(int val) async {
    setState(() {
      selectedRadio = val;
      print(deliverySlotList[0]['timeSchedule'][val]['slot']);
      selectedTime = deliverySlotList[0]['timeSchedule'][val]['slot'];
    });
  }

  deliveryTypeRadioValue(val) async {
    if (mounted) {
      setState(() {
        groupValue = val;
        selectedDeliveryType = val;
      });
    }
    // print(selectedDeliveryType);
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
          });
        }
      } catch (error, stackTrace) {
        sentryError.reportError(error, stackTrace);
      }
    }).catchError((error) {
      sentryError.reportError(error, null);
    });
  }

  getDeliverySlot() async {
    if (mounted) {
      setState(() {
        deliverySlotsLoading = true;
      });
    }
    await AddressService.deliverySlot().then((onValue) {
      // print(onValue);
      try {
        if (mounted) {
          setState(() {
            deliverySlotList = onValue['response_data'];
            deliverySlotsLoading = false;
          });
        }
      } catch (error, stackTrace) {
        sentryError.reportError(error, stackTrace);
      }
    }).catchError((error) {
      sentryError.reportError(error, null);
    });
    // print('List of the slots');
    print('deliverySlotList ${deliverySlotList[0]['timeSchedule']}');
    // print(deliverySlotList[0]['day'].runtimeType);
    // print(deliverySlotList[0]['timeSchedule'][0]['slot']);
    // print(deliverySlotList[0]['timeSchedule'][0]['slot'].runtimeType);
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
    // print('addressList ${addressList.length}');
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

  int _selectedIndex = 0;

  _onSelected(int index) {
    setState(() => _selectedIndex = index);
    print('selected date $_selectedIndex');
    print(deliverySlotList[index]['day']);
    print(deliverySlotList[index]['date']);
    selectedDate = deliverySlotList[index]['date'];
  }

  placeOrder() async {
    Map<String, dynamic> data = {
      "deliveryType": "Home_Delivery",
      "paymentType": 'COD',
    };
    // data['deliveryDate'] = currentTime.millisecondsSinceEpoch;
    // data['deliveryTime'] = currentTime.toString();
    // if (selectedAddress['id'] == null) {
    // showSnackbar('Please select an address.');
    // } else {
    data['deliveryAddress'] = selectedAddress['_id'].toString();
    // }
    // if (selectedAddress['id'] == null) {
    //   showSnackbar('Please select the delivery date.');
    // } else {
    data['deliveryDate'] = selectedDate.toString();
    // }
    // if (selectedAddress['id'] == null) {
    //   showSnackbar('Please select a delivery time.');
    // } else {
    data['deliveryTime'] = selectedTime.toString();
    // }
    // data['cart'] = {
    //   'productId': widget.cartItem['cart'][0]['_id'],
    //   'quantity': 1,
    //   'subTotal': widget.cartItem['subTotal'],
    //   'grandTotal': widget.cartItem['grandTotal'],
    // };
    data['cart'] = widget.cartItem['cart'];
    data['cart'] = widget.cartItem['_id'].toString();
    data['cart'] = widget.id;
    if (mounted) {
      setState(() {
        isPlaceOrderLoading = true;
      });
    }
    print(data['deliveryAddress']);
    print(data['deliveryDate']);
    print(data['deliveryTime']);
    if (mounted) {
      setState(() {
        isPlaceOrderLoading = false;
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Payment(data: data, type: widget.buy)),
        );
      });
    }

    print('apple at the data house');
    print(data);
    // }
  }
  // Navigator.push(
  //   context,
  //   MaterialPageRoute(
  //       builder: (context) => Payment(data: data, type: widget.buy)),
  // );

  // await ProductService.placeOrder(data).then((onValue) {
  //   try {
  //     if (onValue['response_code'] == 201) {
  //       if (mounted) {
  //         setState(() {
  //           isPlaceOrderLoading = false;
  //         });
  //       }
  //       showDialog<Null>(
  //         context: context,
  //         barrierDismissible: false,
  //         builder: (BuildContext context) {
  //           return Container(
  //             width: 270.0,
  //             child: new AlertDialog(
  //               title: new Text('Thank You ...!!'),
  //               content: new SingleChildScrollView(
  //                 child: new ListBody(
  //                   children: <Widget>[
  //                     new Text('Order Successful'),
  //                   ],
  //                 ),
  //               ),
  //               actions: <Widget>[
  //                 new FlatButton(
  //                   child: new Text('ok'),
  //                   onPressed: () {
  //                     Navigator.pushAndRemoveUntil(
  //                         context,
  //                         MaterialPageRoute(
  //                             builder: (BuildContext context) => Payment(
  //                                   currentIndex: 0,
  //                                 )),
  //                         (Route<dynamic> route) => false);
  //                   },
  //                 ),
  //               ],
  //             ),
  //           );
  //         },
  //       );
  //     } else {
  //       if (mounted) {
  //         setState(() {
  //           isPlaceOrderLoading = false;
  //         });
  //       }
  //     }
  //   } catch (error, stackTrace) {
  //     sentryError.reportError(error, stackTrace);
  //   }
  // }).catchError((error) {
  //   sentryError.reportError(error, null);
  // });
  // } else {
  // print(widget.cartItem['cart']);
  // data['cart'] = {
  //   'productId': widget.cartItem['cart'][0]['_id'],
  //   'quantity': 1,
  //   'subTotal': widget.cartItem['subTotal'],
  //   'grandTotal': widget.cartItem['grandTotal'],
  // };
  // data['buyType'] = 'buy';
  // print('ajgar......boa');
  // print(data);

  // if (mounted) {
  //   setState(() {
  //     isPlaceOrderLoading = false;
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //           builder: (context) => Payment(data: data, type: widget.buy)),
  //     );
  //   });
  // }

  // await ProductService.quickBuyNow(data).then((onValue) {
  //   print('value of buy now$onValue');
  //   try {
  //     if (onValue['response_code'] == 201) {
  //       showDialog<Null>(
  //         context: context,
  //         barrierDismissible: false,
  //         builder: (BuildContext context) {
  //           return Container(
  //             width: 270.0,
  //             child: new AlertDialog(
  //               title: new Text('Thank You ...!!'),
  //               content: new SingleChildScrollView(
  //                 child: new ListBody(
  //                   children: <Widget>[
  //                     new Text('Order Successful'),
  //                   ],
  //                 ),
  //               ),
  //               actions: <Widget>[
  //                 new FlatButton(
  //                   child: new Text('ok'),
  //                   onPressed: () {
  //                     Navigator.pushAndRemoveUntil(
  //                         context,
  //                         MaterialPageRoute(
  //                             builder: (BuildContext context) => Home(
  //                                   currentIndex: 0,
  //                                 )),
  //                         (Route<dynamic> route) => false);
  //                   },
  //                 ),
  //               ],
  //             ),
  //           );
  //         },
  //       );
  //     }
  //   } catch (error, stackTrace) {
  //     sentryError.reportError(error, stackTrace);
  //   }
  // }).catchError((error) {
  //   sentryError.reportError(error, null);
  // });
  // }
  // print('order details $data');
  // }

  @override
  Widget build(BuildContext context) {
    // Widget itemCard(int i) {
    //   return Container(
    //     color: Colors.grey[200],
    //     // width: MediaQuery.of(context).size.width,
    //     width: 70,
    //     // height: 45,
    //     child: Row(
    //       children: <Widget>[
    //         Padding(
    //           padding: const EdgeInsets.only(top: 3, bottom: 3),
    //           child: Container(
    //             // color: Colors.grey,

    //             width: 60,
    //             margin: EdgeInsets.only(
    //               left: 10,
    //             ),
    //             decoration: BoxDecoration(
    //                 color: _selectedIndex != null && _selectedIndex == i
    //                     ? primary
    //                     : Colors.transparent,
    //                 borderRadius: BorderRadius.circular(10)),
    //             child: InkWell(
    //               onTap: () => _onSelected(i),
    //               child: Column(
    //                 mainAxisAlignment: MainAxisAlignment.center,
    //                 children: <Widget>[
    //                   Text('Mon'),
    //                   Text('10 Feb'),
    //                 ],
    //               ),
    //             ),
    //           ),
    //         )
    //       ],
    //     ),
    //   );
    // }

    return Scaffold(
      key: _scaffoldKey,
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
      body: addressLoading
          ? Center(child: CircularProgressIndicator())
          : ListView(
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
                  padding: const EdgeInsets.only(
                      left: 20.0, bottom: 10.0, right: 20.0),
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
                  padding: const EdgeInsets.only(
                      left: 20.0, bottom: 10.0, right: 20),
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
                          padding:
                              const EdgeInsets.only(left: 18.0, right: 18.0),
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
                            padding:
                                const EdgeInsets.only(left: 8.0, right: 8.0),
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
                                  bottom: BorderSide(
                                      width: 0.0, color: Colors.grey),
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
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  125,
                                              child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 0),
                                                  child: ListView.builder(
                                                      physics: ScrollPhysics(),
                                                      shrinkWrap: true,
                                                      itemCount: addressList
                                                                  .length ==
                                                              null
                                                          ? 0
                                                          : addressList.length,
                                                      itemBuilder:
                                                          (BuildContext context,
                                                              int i) {
                                                        return Column(
                                                            children: <Widget>[
                                                              RadioListTile(
                                                                groupValue:
                                                                    groupValue1,
                                                                activeColor:
                                                                    primary,
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
                                                                children: <
                                                                    Widget>[
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            0.0),
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      children: <
                                                                          Widget>[
                                                                        GFButton(
                                                                          onPressed:
                                                                              () async {
                                                                            await Navigator.push(
                                                                              context,
                                                                              MaterialPageRoute(
                                                                                builder: (context) => EditAddress(
                                                                                  isCheckout: true,
                                                                                  updateAddressID: addressList[i],
                                                                                ),
                                                                              ),
                                                                            );
                                                                            // print(
                                                                            // address);

                                                                            getAddress();
                                                                          },
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                const EdgeInsets.only(left: 18.0, right: 18.0),
                                                                            child:
                                                                                Text(
                                                                              "Edit",
                                                                            ),
                                                                          ),
                                                                          type:
                                                                              GFButtonType.outline,
                                                                          color:
                                                                              GFColor.warning,
                                                                          size:
                                                                              GFSize.medium,
                                                                          // blockButton: true,
                                                                        ),
                                                                        Padding(
                                                                          padding:
                                                                              const EdgeInsets.only(left: 20.0),
                                                                          child:
                                                                              GFButton(
                                                                            onPressed:
                                                                                () {
                                                                              deleteAddress(addressList[i]['_id']);
                                                                            },
                                                                            child:
                                                                                Padding(
                                                                              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                                                                              child: Text(
                                                                                "Delete",
                                                                              ),
                                                                            ),
                                                                            color:
                                                                                GFColor.warning,
                                                                            type:
                                                                                GFButtonType.outline,
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
                                padding: const EdgeInsets.only(
                                    top: 10.0, bottom: 10.0),
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
                                    padding: const EdgeInsets.only(
                                        left: 8.0, right: 8.0),
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
                      title: addressList.length == 0
                          ? " You have not added any address yet."
                          : addressList[0]['flatNumber'] +
                              ', ' +
                              addressList[0]['locality'] +
                              '....', // collapsedIcon: Icon(Icons.location_on),
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
                          padding:
                              const EdgeInsets.only(left: 30.0, bottom: 4.0),
                          child: Text('Choose Delivery slot',
                              style: boldHeading()),
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
                            itemCount: deliverySlotList.length == null
                                ? 0
                                : deliverySlotList.length,
                            itemBuilder: (BuildContext context, int index) {
                              // Container(
                              // height: 50,

                              // child: itemCard(index),

                              // ),
                              return Container(
                                color: Colors.grey[200],
                                // width: MediaQuery.of(context).size.width,
                                width: 70,
                                // height: 45,
                                child: Row(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 3, bottom: 3),
                                      child: Container(
                                        // color: Colors.grey,

                                        width: 60,
                                        margin: EdgeInsets.only(
                                          left: 10,
                                        ),
                                        decoration: BoxDecoration(
                                            color: _selectedIndex != null &&
                                                    _selectedIndex == index
                                                ? primary
                                                : Colors.transparent,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: InkWell(
                                          onTap: () => _onSelected(index),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Text(
                                                  '${deliverySlotList[index]['day'].substring(0, 3)}'),
                                              Text('0' +
                                                      '${deliverySlotList[index]['date'].substring(0, 1)}' //  +
                                                  // ' ' +
                                                  // "" +
                                                  // renderMonth(
                                                  //     deliverySlotList[index]
                                                  //             ['date']
                                                  //         .substring(2, 3)),
                                                  ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        Container(
                          color: Colors.white54,
                          child: ListView.builder(
                            physics: ScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: deliverySlotList[0]['timeSchedule']
                                        .length ==
                                    null
                                ? 0
                                : deliverySlotList[0]['timeSchedule'].length,
                            itemBuilder: (BuildContext context, int i) {
                              return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    deliverySlotList.length == 0
                                        ? Text(
                                            'Sorry ! No Slots Available Today !!!')
                                        : Text(
                                            '${deliverySlotList[0]['timeSchedule'][i]['slot']}'),
                                    Radio(
                                      value: i,
                                      groupValue: selectedRadio,
                                      activeColor: Colors.green,
                                      onChanged: (value) {
                                        setSelectedRadio(value);
                                      },
                                    ),
                                  ]);
                              // children: <Widget>[
                              //   RadioListTile(
                              //     groupValue: groupValue2,
                              //     activeColor: Colors.green,
                              //     value: i,
                              //     title: Column(
                              //         crossAxisAlignment:
                              //             CrossAxisAlignment.center,
                              //         mainAxisAlignment:
                              //             MainAxisAlignment.spaceEvenly,
                              //         children: [
                              //           deliverySlotList.length == 0
                              //               ? Text(
                              //                   'Sorry ! No Slots Available Today !!!')
                              //               : Text(
                              //                   '${deliverySlotList[0]['timeSchedule'][i]['slot']}'),
                              //         ]),
                              //     onChanged: setSelectedRadio,
                              //   ),
                              // ],
                              //       );
                            },
                          ),
                        ),

                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        //   crossAxisAlignment: CrossAxisAlignment.center,
                        //   children: <Widget>[
                        //     Text('1 Pm to 4 Pm '),
                        //     Padding(
                        //       padding: const EdgeInsets.only(left: 12.0),
                        //       child: Radio(
                        //         value: 2,
                        //         groupValue: selectedRadio,
                        //         activeColor: Colors.green,
                        //         onChanged: (val) {
                        //           print("Radio $val");
                        //           setSelectedRadio(val);
                        //         },
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        //   crossAxisAlignment: CrossAxisAlignment.center,
                        //   children: <Widget>[
                        //     Text('5 Pm to 9 Pm '),
                        //     Padding(
                        //       padding: const EdgeInsets.only(left: 12.0),
                        //       child: Radio(
                        //         value: 2,
                        //         groupValue: selectedRadio,
                        //         activeColor: Colors.green,
                        //         onChanged: (val) {
                        //           print("Radio $val");
                        //           setSelectedRadio(val);
                        //         },
                        //       ),
                        //     ),
                        //   ],
                        // ),
                      ],
                    )
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
            blockButton: true,
            onPressed: proceed,
            text: 'Proceed',
            textStyle: TextStyle(fontSize: 17.0, color: Colors.black),
          ),
        ),
      ),
    );
  }
}
