import 'package:flutter/material.dart';
import 'package:getflutter/components/accordian/gf_accordian.dart';
import 'package:getflutter/getflutter.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:grocery_pro/screens/payment/payment.dart';
import 'package:grocery_pro/style/style.dart';
import 'package:grocery_pro/service/sentry-service.dart';
import 'package:grocery_pro/service/product-service.dart';
import 'package:grocery_pro/service/auth-service.dart';
import 'package:grocery_pro/screens/address/add-address.dart';
import 'package:grocery_pro/service/address-service.dart';
import 'package:grocery_pro/screens/address/edit-address.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  Map<String, dynamic> userInfo, address, cartItem;

  List locationList, addressList, deliverySlotList;
  int selectedRadio, groupValue, groupValue1, _selectedIndex = 0;
  String selectedDeliveryType, locationNotFound, name, currency;

  var selectedAddress, selectedTime, selectedDate;
  bool isLoading = false,
      addressLoading = false,
      deliverySlotsLoading = false,
      isPlaceOrderLoading = false,
      isSelectSlot = false;
  LocationResult _pickedLocation;
  @override
  void initState() {
    super.initState();
    getLocations();
    getUserInfo();
    getAddress();
    getDeliverySlot();
  }

  proceed() {
    if (mounted) {
      setState(() {
        name = '${userInfo['firstName']}';
      });
    }

    placeOrder();
  }

  addressRadioValueChanged(int value) async {
    if (mounted) {
      setState(() {
        groupValue1 = value;
        selectedAddress = addressList[value];
      });
    }

    return value;
  }

  setSelectedRadio(int val) async {
    if (mounted) {
      setState(() {
        selectedRadio = val;
        selectedTime = deliverySlotList[0]['timeSchedule'][val]['slot'];
      });
    }
  }

  deliveryTypeRadioValue(val) async {
    if (mounted) {
      setState(() {
        groupValue = val;
        selectedDeliveryType = val;
      });
    }
    return val;
  }

  getUserInfo() async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    currency = prefs.getString('currency');
    await LoginService.getUserInfo().then((onValue) {
      print(onValue);
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
      print(onValue);
      try {
        if (mounted) {
          setState(() {
            deliverySlotList = onValue['response_data'];

            // for (int i = 0; i < onValue['response_data'].length; i++) {
            //   if (onValue['response_data'][i]['isClosed'] == false) {
            //     deliverySlotList.add(onValue['response_data'][i]);
            //   }
            // }
            print(deliverySlotList);
            deliverySlotsLoading = false;
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
    await AddressService.deleteAddress(body).then((onValue) {
      try {
        getAddress();
        if (mounted) {
          setState(() {
            addressList = addressList;
          });
        }
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

  _onSelected(int index) {
    if (mounted) {
      setState(() => _selectedIndex = index);
    }
    selectedDate = deliverySlotList[index]['date'];
  }

  placeOrder() async {
    if (groupValue1 == null) {
      showSnackbar('Please select address first.');
    } else if (selectedDate == null) {
      selectedDate = DateFormat("dd-MM-yyyy").format(DateTime.now());
    } else if (selectedTime == null) {
      showSnackbar('Please select time slot first.');
    } else {
      Map<String, dynamic> data = {
        "deliveryType": "Home_Delivery",
        "paymentType": 'COD',
      };

      data['deliveryAddress'] = selectedAddress['_id'].toString();

      data['deliveryDate'] = selectedDate.toString();

      data['deliveryTime'] = selectedTime.toString();

      data['cart'] = widget.cartItem['cart'];

      data['cart'] = widget.cartItem['_id'].toString();
      data['cart'] = widget.id;
      if (mounted) {
        setState(() {
          isPlaceOrderLoading = true;
        });
      }
      if (mounted) {
        setState(
          () {
            isPlaceOrderLoading = false;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Payment(
                  data: data,
                  type: widget.buy,
                  grandTotal: widget.cartItem['grandTotal'],
                ),
              ),
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: GFAppBar(
        title: Text(
          'Checkout',
          style: textbarlowSemiBoldBlack(),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black, size: 1.0),
      ),
      body: addressLoading
          ? Center(child: CircularProgressIndicator())
          : deliverySlotsLoading
              ? Center(child: CircularProgressIndicator())
              : ListView(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Text('Cart summary',
                          style: textBarlowSemiBoldBlack()),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20.0, top: 10.0, bottom: 10.0, right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Text(
                                'Sub total ( ${widget.quantity} items )',
                                style: textBarlowRegularBlack(),
                              )
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Text(
                                    currency,
                                    style: regular(),
                                  ),
                                  Text(
                                    '${widget.cartItem['subTotal']}',
                                    style: textBarlowRegularBlack(),
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
                                style: textBarlowRegularBlack(),
                              )
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Text(
                                    currency,
                                    style: regular(),
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
                                style: textBarlowRegularBlack(),
                              )
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Text(
                                    currency,
                                    style: textbarlowBoldsmBlack(),
                                  ),
                                  Text(
                                    '${widget.cartItem['deliveryCharges']}',
                                    style: textbarlowBoldsmBlack(),
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
                              padding: const EdgeInsets.only(
                                  left: 18.0, right: 18.0),
                              child: Text(
                                " Enter Coupon code ",
                              ),
                            ),
                            textStyle: textBarlowRegularBlack(),
                            type: GFButtonType.outline,
                            color: GFColors.DARK,
                            size: GFSize.MEDIUM,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: GFButton(
                              onPressed: null,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0, right: 8.0),
                                child: Text(
                                  "Apply ",
                                  style: textBarlowRegularBlack(),
                                ),
                              ),
                              color: GFColors.WARNING,
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0, bottom: 10.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            new BoxShadow(
                              color: Colors.black,
                            ),
                          ],
                        ),
                        child: Padding(
                          padding:
                              const EdgeInsets.only(left: 20.0, right: 20.0),
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
                                      style: textbarlowMediumBlack(),
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
                                        padding:
                                            const EdgeInsets.only(top: 2.0),
                                        child: Text(
                                          currency,
                                          style: textBarlowBoldBlack(),
                                        ),
                                      ),
                                      Text(
                                        '${widget.cartItem['grandTotal']}',
                                        style: textBarlowBoldBlack(),
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
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Text('Delivery type',
                          style: textBarlowSemiBoldBlack()),
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
                                  style: textBarlowRegularBlack(),
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
                          textStyle: textBarlowRegularBlack(),
                          contentChild: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                new BoxShadow(
                                    color: Colors.black38,
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
                                        padding:
                                            const EdgeInsets.only(left: 18.0),
                                        child: Container(
                                          child: Column(
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
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: <Widget>[
                                                          RadioListTile(
                                                            groupValue:
                                                                groupValue1,
                                                            activeColor:
                                                                primary,
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
                                                                      '${addressList[i]['flatNo']}, ${addressList[i]['apartmentName']},${addressList[i]['address']},'),
                                                                  Text(
                                                                      " ${addressList[i]['landmark']} ,"
                                                                      '${addressList[i]['postalCode']}, ${addressList[i]['contactNumber']}'),
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
                                                                        await Navigator
                                                                            .push(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                            builder: (context) =>
                                                                                EditAddress(
                                                                              isCheckout: true,
                                                                              updateAddressID: addressList[i],
                                                                            ),
                                                                          ),
                                                                        );
                                                                        getAddress();
                                                                      },
                                                                      child:
                                                                          Padding(
                                                                        padding: const EdgeInsets.only(
                                                                            left:
                                                                                18.0,
                                                                            right:
                                                                                18.0),
                                                                        child:
                                                                            Text(
                                                                          "Edit",
                                                                          style:
                                                                              textbarlowRegularaPrimar(),
                                                                        ),
                                                                      ),
                                                                      type: GFButtonType
                                                                          .outline,
                                                                      color: GFColors
                                                                          .WARNING,
                                                                      size: GFSize
                                                                          .MEDIUM,
                                                                    ),
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                              .only(
                                                                          left:
                                                                              20.0),
                                                                      child:
                                                                          GFButton(
                                                                        onPressed:
                                                                            () {
                                                                          deleteAddress(addressList[i]
                                                                              [
                                                                              '_id']);
                                                                        },
                                                                        child:
                                                                            Padding(
                                                                          padding: const EdgeInsets.only(
                                                                              left: 8.0,
                                                                              right: 8.0),
                                                                          child:
                                                                              Text(
                                                                            "Delete",
                                                                            style:
                                                                                textbarlowRegularaPrimar(),
                                                                          ),
                                                                        ),
                                                                        color: GFColors
                                                                            .WARNING,
                                                                        type: GFButtonType
                                                                            .outline,
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
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
                                        LocationResult result =
                                            await showLocationPicker(
                                          context,
                                          "AIzaSyD6Q4UgAYOL203nuwNeBr4j_-yAd1U1gko",
                                          initialCenter:
                                              LatLng(31.1975844, 29.9598339),
                                          myLocationButtonEnabled: true,
                                          layersButtonEnabled: true,
                                        );
                                        print("result = $result");
                                        if (result != null) {
                                          setState(() {
                                            _pickedLocation = result;

                                            Navigator.push(
                                              context,
                                              new MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        new AddAddress(
                                                  isCheckout: true,
                                                  pickedLocation:
                                                      _pickedLocation,
                                                ),
                                              ),
                                            );
                                            getAddress();
                                          });
                                        }

                                        // Map<String, dynamic> address =
                                        //     await Navigator.push(
                                        //   context,
                                        //   MaterialPageRoute(
                                        //       builder: (context) => AddAddress(
                                        //             isCheckout: true,
                                        //           )),
                                        // );
                                        // if (address != null) {
                                        //   addressList.add(address);
                                        //   getAddress();
                                        // }
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8.0, right: 8.0),
                                        child: Text(
                                          "Add new address",
                                          style: textBarlowRegularBlack(),
                                        ),
                                      ),
                                      color: GFColors.DARK,
                                      type: GFButtonType.outline,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          title: addressList.length == 0
                              ? " You have not added any address yet."
                              : addressList[0]['flatNo'] +
                                  " ," +
                                  addressList[0]['apartmentName'] +
                                  '....',
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 20.0, bottom: 4.0),
                              child: Text(
                                'Choose Delivery Date and Time Slot',
                                style: textBarlowSemiBoldBlack(),
                              ),
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
                                  return deliverySlotList[index]['isClosed'] ==
                                          false
                                      ? Container(
                                          color: Colors.grey[200],
                                          width: 70,
                                          child: Row(
                                            children: <Widget>[
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 3, bottom: 3),
                                                child: Container(
                                                  width: 60,
                                                  margin: EdgeInsets.only(
                                                    left: 10,
                                                  ),
                                                  decoration: BoxDecoration(
                                                      color: _selectedIndex !=
                                                                  null &&
                                                              _selectedIndex ==
                                                                  index
                                                          ? primary
                                                          : Colors.transparent,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  child: InkWell(
                                                    onTap: () =>
                                                        _onSelected(index),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        Text(
                                                          '${deliverySlotList[index]['day'].substring(0, 3)}',
                                                          style:
                                                              textBarlowMediumBlack(),
                                                        ),
                                                        Text(
                                                          '${deliverySlotList[index]['date'][1] == "-" ? "0" + deliverySlotList[index]['date'].substring(0, 1) : deliverySlotList[index]['date'].substring(0, 2)}',
                                                          style:
                                                              textbarlowRegularBlack(),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      : Container();
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
                                itemCount: deliverySlotList[_selectedIndex]
                                                ['timeSchedule']
                                            .length ==
                                        null
                                    ? 0
                                    : deliverySlotList[_selectedIndex]
                                            ['timeSchedule']
                                        .length,
                                itemBuilder: (BuildContext context, int i) {
                                  if (deliverySlotList[_selectedIndex]
                                              ['timeSchedule'][0]['isClosed'] ==
                                          true &&
                                      deliverySlotList[_selectedIndex]
                                              ['timeSchedule'][1]['isClosed'] ==
                                          true &&
                                      deliverySlotList[_selectedIndex]
                                              ['timeSchedule'][2]['isClosed'] ==
                                          true &&
                                      deliverySlotList[_selectedIndex]
                                              ['timeSchedule'][3]['isClosed'] ==
                                          true) {
                                    return Center(
                                      child: Image.asset(
                                          'lib/assets/images/no-orders.png'),
                                    );
                                  } else {
                                    return deliverySlotList[_selectedIndex]
                                                    ['timeSchedule'][i]
                                                ['isClosed'] ==
                                            false
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              deliverySlotList.length == 0
                                                  ? Text(
                                                      'Sorry ! No Slots Available Today !!!')
                                                  : Text(
                                                      '${deliverySlotList[_selectedIndex]['timeSchedule'][i]['slot']}',
                                                      style:
                                                          textBarlowRegularBlack(),
                                                    ),
                                              Radio(
                                                value: i,
                                                groupValue: selectedRadio,
                                                activeColor: Colors.green,
                                                onChanged: (value) {
                                                  setSelectedRadio(value);
                                                },
                                              ),
                                            ],
                                          )
                                        : Container();
                                  }
                                },
                              ),
                            ),
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
            color: GFColors.WARNING,
            blockButton: true,
            onPressed: proceed,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Proceed",
                  style: textBarlowRegularrBlack(),
                ),
                isPlaceOrderLoading
                    ? Image.asset(
                        'lib/assets/images/spinner.gif',
                        width: 15.0,
                        height: 15.0,
                        color: Colors.black,
                      )
                    : Text("")
              ],
            ),
            textStyle: TextStyle(fontSize: 17.0, color: Colors.black),
          ),
        ),
      ),
    );
  }

  void showSnackbar(message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: Duration(milliseconds: 3000),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
}
