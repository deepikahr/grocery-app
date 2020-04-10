import 'package:flutter/material.dart';
import 'package:getflutter/components/accordian/gf_accordian.dart';
import 'package:getflutter/getflutter.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:grocery_pro/screens/payment/payment.dart';
import 'package:grocery_pro/service/coupon-service.dart';
import 'package:grocery_pro/service/payment-service.dart';
import 'package:grocery_pro/style/style.dart';
import 'package:grocery_pro/service/sentry-service.dart';
import 'package:grocery_pro/service/product-service.dart';
import 'package:grocery_pro/service/auth-service.dart';
import 'package:grocery_pro/screens/address/add-address.dart';
import 'package:grocery_pro/service/address-service.dart';
import 'package:grocery_pro/screens/address/edit-address.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dotted_border/dotted_border.dart';

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
  Map<String, dynamic> userInfo, address, cartItem;

  List locationList, addressList, deliverySlotList, couponList;
  int selectedRadio, groupValue, groupValue1, _selectedIndex = 0;
  String selectedDeliveryType, locationNotFound, name, currency, couponCode;

  var selectedAddress, selectedTime, selectedDate;
  bool isLoading = false,
      addressLoading = false,
      deliverySlotsLoading = false,
      isPlaceOrderLoading = false,
      isCouponLoading = false,
      isSelectSlot = false,
      couponApplied = false;
  LocationResult _pickedLocation;
  @override
  void initState() {
    cartItem = widget.cartItem;
    super.initState();
    getLocations();
    getUserInfo();
    getAddress();
    getCoupons();
    getDeliverySlot();
  }

  getCoupons() async {
    if (mounted) {
      setState(() {
        isCouponLoading = true;
      });
    }
    await CouponService.getCoupons().then((onValue) {
      try {
        if (mounted) {
          setState(() {
            couponList = onValue['response_data'];
            isCouponLoading = false;
          });
        }
      } catch (error, stackTrace) {
        sentryError.reportError(error, stackTrace);
      }
    }).catchError((error) {
      sentryError.reportError(error, null);
    });
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
      try {
        if (mounted) {
          setState(() {
            deliverySlotList = onValue['response_data'];

            // for (int i = 0; i < onValue['response_data'].length; i++) {
            //   if (onValue['response_data'][i]['isClosed'] == false) {
            //     deliverySlotList.add(onValue['response_data'][i]);
            //   }
            // }
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
    print(selectedDate);
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
      print(selectedDate);

      data['deliveryTime'] = selectedTime.toString();

      data['cart'] = cartItem['cart'];

      data['cart'] = cartItem['_id'].toString();
      data['cart'] = widget.id;
      var body = {
        "latitude": selectedAddress['location']['lat'],
        "longitude": selectedAddress['location']['long'],
        "cartId": data['cart']
      };
      if (mounted) {
        setState(() {
          isPlaceOrderLoading = true;
        });
      }
      PaymentService.getDeliveryCharges(body).then((value) {
        print(value);
        try {
          if (value['response_code'] == 200) {
            if (mounted) {
              setState(() {
                isPlaceOrderLoading = false;
              });
            }
            if (value['response_data']['deliveryDetails']['deliveryCharges']
                is int) {
              print("kk");
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Payment(
                    data: data,
                    type: widget.buy,
                    grandTotals: null,
                    grandTotal: value['response_data']['cartData']
                        ['grandTotal'],
                    deliveryCharges: null,
                    deliveryCharge: value['response_data']['deliveryDetails']
                        ['deliveryCharges'],
                  ),
                ),
              );
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Payment(
                    data: data,
                    type: widget.buy,
                    grandTotal: null,
                    grandTotals: value['response_data']['cartData']
                        ['grandTotal'],
                    deliveryCharges: value['response_data']['deliveryDetails']
                        ['deliveryCharges'],
                    deliveryCharge: null,
                  ),
                ),
              );
            }
          }
        } catch (error, stackTrace) {
          sentryError.reportError(error, stackTrace);
        }
      }).catchError((error) {
        sentryError.reportError(error, null);
      });
    }
  }

  couponCodeApply() {
    if (!_formKey.currentState.validate()) {
      return;
    } else {
      _formKey.currentState.save();
      for (int i = 0; i < couponList.length; i++) {
        if (couponCode.toLowerCase() ==
            couponList[i]['couponCode'].toString().toLowerCase()) {
          if (mounted) {
            setState(() {
              updateCoupons(couponCode);
            });
          }
        } else {}
      }
    }
  }

  updateCoupons(data) async {
    if (mounted) {
      setState(() {
        isCouponLoading = true;
      });
    }
    await CouponService.applyCoupons(data).then((onValue) {
      try {
        if (onValue['response_code'] == 200) {
          if (mounted) {
            setState(() {
              cartItem = onValue['response_data'];

              couponApplied = true;
            });
          }

          showError('', 'Coupon is applied');
        } else if (onValue['response_code'] == 400) {
          showSnackbar('${onValue['response_data']}');
        } else {
          showSnackbar('${onValue['response_data']}');
        }
        if (mounted) {
          setState(() {
            isCouponLoading = false;
          });
        }
      } catch (error, stackTrace) {
        sentryError.reportError(error, stackTrace);
      }
    }).catchError((error) {
      sentryError.reportError(error, null);
    });
  }

  showError(error, message) async {
    showDialog<Null>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.only(
            top: 10.0,
          ),
          title: new Text(
            "$error",
            style: hintSfsemiboldb(),
            textAlign: TextAlign.center,
          ),
          content: Container(
            height: 100.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14.0),
                  child: new Text(
                    "$message",
                    style: hintSfLightsm(),
                    textAlign: TextAlign.center,
                  ),
                ),
                Column(
                  children: <Widget>[
                    Divider(),
                    IntrinsicHeight(
                        child: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Expanded(
                            child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(bottom: 12.0),
                            height: 30.0,
                            decoration: BoxDecoration(),
                            child: Text(
                              'OK',
                              style: hintSfLightbig(),
                            ),
                          ),
                        ))
                      ],
                    ))
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFDFDFD),
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
                    Container(
                      padding: EdgeInsets.only(top: 15, bottom: 10),
                      margin: EdgeInsets.only(top: 10),
                      decoration: BoxDecoration(
//                      color: Colors.red,
                        color: Color(0xFFF7F7F7),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(left: 15, right: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text('Cart summary',
                                    style: textBarlowSemiBoldBlackbigg()),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      'Sub total ( ${widget.quantity} items )',
                                      style: textBarlowRegularBlack(),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        Text(
                                          currency,
                                          style: textbarlowBoldsmBlack(),
                                        ),
                                        Text(
                                          '${cartItem['subTotal']}',
                                          style: textbarlowBoldsmBlack(),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Image.asset(
                                            'lib/assets/icons/sale.png'),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          'Discount',
                                          style: textBarlowRegularBlack(),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        Text(
                                          currency,
                                          style: textbarlowBoldsmBlack(),
                                        ),
                                        Text(
                                          '${cartItem['tax']}',
                                          style: textbarlowBoldsmBlack(),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20),
                                Form(
                                  key: _formKey,
                                  child: Container(
                                    child: couponApplied
                                        ? Padding(
                                            padding: EdgeInsets.only(left: 5.0),
                                            child: Text(
                                              "Coupon Applied",
                                              style: textbarlowRegularBlack(),
                                            ))
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Container(
                                                width: 193,
                                                height: 44,
                                                alignment: Alignment.center,
                                                padding: EdgeInsets.only(
                                                    left: 0.0, bottom: 3),
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color:
                                                            Color(0xFFD4D4E0)),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                4))),
                                                child: TextFormField(
                                                  textAlign: TextAlign.center,
                                                  decoration: InputDecoration(
                                                      hintText:
                                                          'Enter Coupon Code',
                                                      hintStyle:
                                                          textBarlowRegularBlacklight(),
                                                      border: InputBorder.none),
                                                  cursorColor: primary,
                                                  validator: (String value) {
                                                    if (value.isEmpty) {
                                                      return null;
                                                    } else {
                                                      return null;
                                                    }
                                                  },
                                                  style:
                                                      textBarlowRegularBlacklight(),
                                                  onSaved: (String value) {
                                                    couponCode = value;
                                                  },
                                                ),
                                              ),
                                              Flexible(
                                                  flex: 3,
                                                  fit: FlexFit.tight,
                                                  child: InkWell(
                                                    onTap: () {
                                                      couponCodeApply();
                                                    },
                                                    child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 8.0),
                                                        child: Container(
//                                                alignment: Alignment.topRight,
                                                          height: 44,
                                                          width: 119,
                                                          child: GFButton(
                                                            onPressed: null,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 8.0,
                                                                      right:
                                                                          8.0),
                                                              child: Text(
                                                                "Apply ",
                                                                style:
                                                                    textBarlowRegularBlack(),
                                                              ),
                                                            ),
                                                            color: primary,
                                                          ),
                                                        )),
                                                  ))
                                            ],
                                          ),
                                  ),
                                ),
                                SizedBox(height: 20),
                                Divider(
                                  color: Color(0xFF707070).withOpacity(0.20),
                                  thickness: 1,
                                ),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      'Total',
                                      style: textbarlowMediumBlack(),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        Text(
                                          currency,
                                          style: textBarlowBoldBlack(),
                                        ),
                                        Text(
                                          '${cartItem['grandTotal']}',
                                          style: textBarlowBoldBlack(),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20),
                                Text('Delivery Address',
                                    style: textBarlowSemiBoldBlackbigg()),
                                SizedBox(height: 10),
                                Text(
                                  'Home Delivery',
                                  style: textBarlowRegularBlack(),
                                ),
                              ],
                            ),
                          ),
                          GFAccordion(
                              collapsedTitlebackgroundColor: Color(0xFFF0F0F0),
                              titleborder: Border.all(color: Color(0xffD6D6D6)),
                              contentbackgroundColor: Colors.white,
                              contentPadding:
                                  EdgeInsets.only(top: 5, bottom: 5),
                              titleChild: Row(
                                children: <Widget>[
                                  Icon(Icons.location_on),
                                  Text(
                                    selectedAddress == null
                                        ? addressList.length == 0
                                            ? " You have not added any address yet."
                                            : addressList[0]['flatNo'] +
                                                " ," +
                                                addressList[0]
                                                    ['apartmentName'] +
                                                '....'
                                        : selectedAddress['flatNo'] +
                                            " ," +
                                            selectedAddress['apartmentName'] +
                                            '....',
                                    style: textBarlowRegularBlack(),
                                  )
                                ],
                              ),
                              contentChild: Column(
                                children: <Widget>[
                                  ListView.builder(
                                    physics: ScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: addressList.length == null
                                        ? 0
                                        : addressList.length,
                                    itemBuilder: (BuildContext context, int i) {
                                      return Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          RadioListTile(
                                            groupValue: groupValue1,
                                            activeColor: primary,
                                            value: i,
                                            title: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    '${addressList[i]['flatNo']}, ${addressList[i]['apartmentName']},${addressList[i]['address']},',
                                                    style:
                                                        textBarlowRegularBlack(),
                                                  ),
                                                  Text(
                                                    "${addressList[i]['landmark']} ,"
                                                    '${addressList[i]['postalCode']}, ${addressList[i]['contactNumber']}',
                                                    style:
                                                        textBarlowRegularBlackdl(),
                                                  ),
                                                ]),
                                            onChanged: addressRadioValueChanged,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 0.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: <Widget>[
                                                    GFButton(
                                                      onPressed: () async {
                                                        await Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    EditAddress(
                                                              isCheckout: true,
                                                              updateAddressID:
                                                                  addressList[
                                                                      i],
                                                            ),
                                                          ),
                                                        );
                                                        getAddress();
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 18.0,
                                                                right: 18.0),
                                                        child: Text(
                                                          "Edit",
                                                          style:
                                                              textbarlowRegularaPrimar(),
                                                        ),
                                                      ),
                                                      type:
                                                          GFButtonType.outline,
                                                      color: GFColors.WARNING,
                                                      size: GFSize.MEDIUM,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 20.0),
                                                      child: GFButton(
                                                        onPressed: () {
                                                          deleteAddress(
                                                              addressList[i]
                                                                  ['_id']);
                                                        },
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 8.0,
                                                                  right: 8.0),
                                                          child: Text(
                                                            "Delete",
                                                            style:
                                                                textbarlowRegularaPrimar(),
                                                          ),
                                                        ),
                                                        color: GFColors.WARNING,
                                                        type: GFButtonType
                                                            .outline,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: 20, right: 20),
                                            child: Divider(
                                              thickness: 1,
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  DottedBorder(
                                    color: Color(0XFFBBBBBB),
                                    dashPattern: [4, 2],
                                    strokeWidth: 2,
                                    padding:
                                        EdgeInsets.only(left: 10, right: 10),
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
                                        if (result != null) {
                                          setState(() async {
                                            _pickedLocation = result;

                                            Map address = await Navigator.push(
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

                                            if (address != null) {
                                              getAddress();
                                            } else {
                                              getAddress();
                                            }
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
                                      type: GFButtonType.transparent,
                                      color: GFColors.LIGHT,
                                      child: Text(
                                        'Add new address',
                                        style: textBarlowRegularBb(),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                ],
                              )),
                          SizedBox(
                            height: 15,
                          ),
                          Container(
                            padding: EdgeInsets.only(
                                left: 15, right: 15, bottom: 10),
                            child: Text(
                              'Choose Delivery Date and Time Slot',
                              style: textbarlowRegularadd(),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  height: 50,
                                  width: MediaQuery.of(context).size.width,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: deliverySlotList.length == null
                                        ? 0
                                        : deliverySlotList.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return deliverySlotList[index]
                                                  ['isClosed'] ==
                                              false
                                          ? Container(
                                              color: Colors.grey[200],
                                              width: 70,
                                              child: Row(
                                                children: <Widget>[
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
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
                                                              : Colors
                                                                  .transparent,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
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
                              )
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              Container(
                                color: Color(0xFFF7F7F7),
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
                                                    ['timeSchedule'][0]
                                                ['isClosed'] ==
                                            true &&
                                        deliverySlotList[_selectedIndex]
                                                    ['timeSchedule'][1]
                                                ['isClosed'] ==
                                            true &&
                                        deliverySlotList[_selectedIndex]
                                                    ['timeSchedule'][2]
                                                ['isClosed'] ==
                                            true &&
                                        deliverySlotList[_selectedIndex]
                                                    ['timeSchedule'][3]
                                                ['isClosed'] ==
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
//                                          mainAxisAlignment:
//                                          MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
//                                          SizedBox(width: 15),
                                                Expanded(
                                                  child: RadioListTile(
                                                    value: i,
                                                    groupValue: selectedRadio,
                                                    activeColor: Colors.green,
                                                    onChanged: (value) {
                                                      setSelectedRadio(value);
                                                    },
                                                    title: deliverySlotList
                                                                .length ==
                                                            0
                                                        ? Text(
                                                            'Sorry ! No Slots Available Today !!!')
                                                        : Text(
                                                            '${deliverySlotList[_selectedIndex]['timeSchedule'][i]['slot']}',
                                                            style:
                                                                textBarlowRegularBlack(),
                                                          ),
                                                  ),
                                                )
//                                          Expanded(
//                                            child: deliverySlotList
//                                                .length ==
//                                                0
//                                                ? Text(
//                                                'Sorry ! No Slots Available Today !!!')
//                                                : Text(
//                                              '${deliverySlotList[_selectedIndex]['timeSchedule'][i]['slot']}',
//                                              style:
//                                              textBarlowRegularBlack(),
//                                            ),
//                                          ),
//                                          Expanded(
//                                              child: Row(
//                                                mainAxisAlignment:
//                                                MainAxisAlignment.end,
//                                                children: <Widget>[
//                                                  Radio(
//                                                    value: i,
//                                                    groupValue:
//                                                    selectedRadio,
//                                                    activeColor:
//                                                    Colors.green,
//                                                    onChanged: (value) {
//                                                      setSelectedRadio(
//                                                          value);
//                                                    },
//                                                  ),
//                                                ],
//                                              ))
                                              ],
                                            )
                                          : Container();
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
//                    Container(
//                      padding: EdgeInsets.only(top: 20),
//                      decoration: BoxDecoration(
////                      color: Colors.red,
//                          color: Color(0xFFFDFDFD),
//                          boxShadow: [
////                          BoxShadow(
////                              color: Colors.black.withOpacity(0.29),
////                              blurRadius: 20
////                          )
//                            BoxShadow(
//                                color: Color(0xFF0000000A).withOpacity(0.10),
//                                blurRadius: 5)
//                          ]),
//                      child: Column(
//                        crossAxisAlignment: CrossAxisAlignment.start,
//                        children: <Widget>[
//                          Padding(
//                            padding: const EdgeInsets.only(left: 20.0),
//                            child: Text('Delivery type',
//                                style: textBarlowSemiBoldBlack()),
//                          ),
//                          Row(children: <Widget>[
//                            Padding(
//                              padding:
//                                  const EdgeInsets.only(left: 22.0, top: 10),
//                              child: Column(
//                                children: <Widget>[
//                                  Row(
//                                    children: <Widget>[
//                                      Text(
//                                        'Home Delivery',
//                                        style: textBarlowRegularBlack(),
//                                      ),
//                                    ],
//                                  )
//                                ],
//                              ),
//                            ),
//                          ]),
//                          Padding(
//                            padding:
//                                const EdgeInsets.only(left: 8.0, right: 8.0),
//                            child: Container(
//                              decoration: BoxDecoration(
//                                borderRadius: BorderRadius.circular(20.0),
//                              ),
//                              child: GFAccordion(
//                                collapsedTitlebackgroundColor: Colors.grey[300],
//                                textStyle: textBarlowRegularBlack(),
//                                contentChild: Container(
//                                  decoration: BoxDecoration(
//                                    color: Colors.white,
//                                    boxShadow: [
//                                      new BoxShadow(
//                                          color: Colors.black38,
//                                          offset: Offset(0.0, 0.50)),
//                                    ],
//                                  ),
//                                  child: Column(
//                                    children: <Widget>[
//                                      Container(
//                                        decoration: BoxDecoration(
//                                          border: Border(
//                                            bottom: BorderSide(
//                                                width: 0.0, color: Colors.grey),
//                                          ),
//                                        ),
//                                        child: Column(
//                                          children: <Widget>[
//                                            Padding(
//                                              padding: const EdgeInsets.only(
//                                                  left: 0.0),
//                                              child: Container(
//                                                child: Column(
//                                                  children: <Widget>[
//                                                    Container(
//                                                      width:
//                                                          MediaQuery.of(context)
//                                                              .size
//                                                              .width,
//                                                      child: Padding(
//                                                        padding:
//                                                            const EdgeInsets
//                                                                .only(left: 0),
//                                                        child: ListView.builder(
//                                                          physics:
//                                                              ScrollPhysics(),
//                                                          shrinkWrap: true,
//                                                          itemCount: addressList
//                                                                      .length ==
//                                                                  null
//                                                              ? 0
//                                                              : addressList
//                                                                  .length,
//                                                          itemBuilder:
//                                                              (BuildContext
//                                                                      context,
//                                                                  int i) {
//                                                            return Column(
//                                                              mainAxisAlignment:
//                                                                  MainAxisAlignment
//                                                                      .start,
//                                                              children: <
//                                                                  Widget>[
//                                                                RadioListTile(
//                                                                  groupValue:
//                                                                      groupValue1,
//                                                                  activeColor:
//                                                                      primary,
//                                                                  value: i,
//                                                                  title: Column(
//                                                                      crossAxisAlignment:
//                                                                          CrossAxisAlignment
//                                                                              .start,
//                                                                      mainAxisAlignment:
//                                                                          MainAxisAlignment
//                                                                              .start,
//                                                                      children: [
//                                                                        Text(
//                                                                          '${addressList[i]['flatNo']}, ${addressList[i]['apartmentName']},${addressList[i]['address']},',
//                                                                          style:
//                                                                              textbarlowRegularBlackd(),
//                                                                        ),
//                                                                        Text(
//                                                                          " ${addressList[i]['landmark']} ,"
//                                                                          '${addressList[i]['postalCode']}, ${addressList[i]['contactNumber']}',
//                                                                          style:
//                                                                              textbarlowRegularBlackd(),
//                                                                        ),
//                                                                      ]),
//                                                                  onChanged:
//                                                                      addressRadioValueChanged,
//                                                                ),
//                                                                Row(
//                                                                  mainAxisAlignment:
//                                                                      MainAxisAlignment
//                                                                          .center,
//                                                                  children: <
//                                                                      Widget>[
//                                                                    Padding(
//                                                                      padding: const EdgeInsets
//                                                                              .only(
//                                                                          left:
//                                                                              0.0),
//                                                                      child:
//                                                                          Row(
//                                                                        mainAxisAlignment:
//                                                                            MainAxisAlignment.start,
//                                                                        children: <
//                                                                            Widget>[
//                                                                          GFButton(
//                                                                            onPressed:
//                                                                                () async {
//                                                                              await Navigator.push(
//                                                                                context,
//                                                                                MaterialPageRoute(
//                                                                                  builder: (context) => EditAddress(
//                                                                                    isCheckout: true,
//                                                                                    updateAddressID: addressList[i],
//                                                                                  ),
//                                                                                ),
//                                                                              );
//                                                                              getAddress();
//                                                                            },
//                                                                            child:
//                                                                                Padding(
//                                                                              padding: const EdgeInsets.only(left: 18.0, right: 18.0),
//                                                                              child: Text(
//                                                                                "Edit",
//                                                                                style: textbarlowRegularaPrimar(),
//                                                                              ),
//                                                                            ),
//                                                                            type:
//                                                                                GFButtonType.outline,
//                                                                            color:
//                                                                                GFColors.WARNING,
//                                                                            size:
//                                                                                GFSize.MEDIUM,
//                                                                          ),
//                                                                          Padding(
//                                                                            padding:
//                                                                                const EdgeInsets.only(left: 20.0),
//                                                                            child:
//                                                                                GFButton(
//                                                                              onPressed: () {
//                                                                                deleteAddress(addressList[i]['_id']);
//                                                                              },
//                                                                              child: Padding(
//                                                                                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
//                                                                                child: Text(
//                                                                                  "Delete",
//                                                                                  style: textbarlowRegularaPrimar(),
//                                                                                ),
//                                                                              ),
//                                                                              color: GFColors.WARNING,
//                                                                              type: GFButtonType.outline,
//                                                                            ),
//                                                                          )
//                                                                        ],
//                                                                      ),
//                                                                    ),
//                                                                  ],
//                                                                ),
//                                                              ],
//                                                            );
//                                                          },
//                                                        ),
//                                                      ),
//                                                    ),
//                                                  ],
//                                                ),
//                                              ),
//                                            ),
//                                          ],
//                                        ),
//                                      ),
//                                      Container(
//                                        margin: EdgeInsets.only(
//                                            top: 20, bottom: 20),
//                                        child: Padding(
//                                          padding: const EdgeInsets.only(
//                                              top: 3.0, bottom: 0.0),
//                                          child: GFButton(
//                                            onPressed: () async {
//                                              LocationResult result =
//                                                  await showLocationPicker(
//                                                context,
//                                                "AIzaSyD6Q4UgAYOL203nuwNeBr4j_-yAd1U1gko",
//                                                initialCenter: LatLng(
//                                                    31.1975844, 29.9598339),
//                                                myLocationButtonEnabled: true,
//                                                layersButtonEnabled: true,
//                                              );
//                                              if (result != null) {
//                                                setState(() async {
//                                                  _pickedLocation = result;
//
//                                                  Map address =
//                                                      await Navigator.push(
//                                                    context,
//                                                    new MaterialPageRoute(
//                                                      builder: (BuildContext
//                                                              context) =>
//                                                          new AddAddress(
//                                                        isCheckout: true,
//                                                        pickedLocation:
//                                                            _pickedLocation,
//                                                      ),
//                                                    ),
//                                                  );
//
//                                                  if (address != null) {
//                                                    getAddress();
//                                                  } else {
//                                                    getAddress();
//                                                  }
//                                                });
//                                              }
//
//                                              // Map<String, dynamic> address =
//                                              //     await Navigator.push(
//                                              //   context,
//                                              //   MaterialPageRoute(
//                                              //       builder: (context) => AddAddress(
//                                              //             isCheckout: true,
//                                              //           )),
//                                              // );
//                                              // if (address != null) {
//                                              //   addressList.add(address);
//                                              //   getAddress();
//                                              // }
//                                            },
//
//                                            child: Container(
//                                              height: 140,
//
////                                            width:130,
//
//                                              child: DottedBorder(
//                                                color: Color(0xFFBBBBBB),
//                                                borderType: BorderType.Rect,
//                                                radius: Radius.circular(3),
//                                                padding: EdgeInsets.all(6),
//                                                child: ClipRRect(
//                                                  borderRadius:
//                                                      BorderRadius.all(
//                                                          Radius.circular(12)),
//                                                  child: Text(
//                                                    "Add new address",
//                                                    style:
//                                                        textbarlowRegulardull(),
//                                                  ),
//                                                ),
//                                              ),
//                                            ),
////                                          child: Padding(
////                                            padding: const EdgeInsets.only(
////                                                left: 8.0, right: 8.0),
////                                            child: Text(
////                                              "Add new address",
////                                              style: textBarlowRegularBlack(),
////                                            ),
////                                          ),
//                                            color: GFColors.TRANSPARENT,
//                                          ),
//                                        ),
//                                      )
//                                    ],
//                                  ),
//                                ),
//                                title: addressList.length == 0
//                                    ? " You have not added any address yet."
//                                    : addressList[0]['flatNo'] +
//                                        " ," +
//                                        addressList[0]['apartmentName'] +
//                                        '....',
//                              ),
//                            ),
//                          ),
//                          SizedBox(height: 10),
//                          Column(
//                            mainAxisAlignment: MainAxisAlignment.center,
//                            children: <Widget>[
//                              Row(
//                                mainAxisAlignment: MainAxisAlignment.start,
//                                children: <Widget>[
//                                  Padding(
//                                    padding: const EdgeInsets.only(
//                                        left: 20.0, bottom: 4.0),
//                                    child: Text(
//                                      'Choose Delivery Date and Time Slot',
//                                      style: textBarlowSemiBoldBlack(),
//                                    ),
//                                  ),
//                                ],
//                              ),
//                              SizedBox(height: 10),
//                              Row(
//                                children: <Widget>[
//                                  Container(
//                                    height: 50,
//                                    width: MediaQuery.of(context).size.width,
//                                    child: ListView.builder(
//                                      shrinkWrap: true,
//                                      scrollDirection: Axis.horizontal,
//                                      itemCount: deliverySlotList.length == null
//                                          ? 0
//                                          : deliverySlotList.length,
//                                      itemBuilder:
//                                          (BuildContext context, int index) {
//                                        return deliverySlotList[index]
//                                                    ['isClosed'] ==
//                                                false
//                                            ? Container(
//                                                color: Colors.grey[200],
//                                                width: 70,
//                                                child: Row(
//                                                  children: <Widget>[
//                                                    Padding(
//                                                      padding:
//                                                          const EdgeInsets.only(
//                                                              top: 3,
//                                                              bottom: 3),
//                                                      child: Container(
//                                                        width: 60,
//                                                        margin: EdgeInsets.only(
//                                                          left: 10,
//                                                        ),
//                                                        decoration: BoxDecoration(
//                                                            color: _selectedIndex !=
//                                                                        null &&
//                                                                    _selectedIndex ==
//                                                                        index
//                                                                ? primary
//                                                                : Colors
//                                                                    .transparent,
//                                                            borderRadius:
//                                                                BorderRadius
//                                                                    .circular(
//                                                                        10)),
//                                                        child: InkWell(
//                                                          onTap: () =>
//                                                              _onSelected(
//                                                                  index),
//                                                          child: Column(
//                                                            mainAxisAlignment:
//                                                                MainAxisAlignment
//                                                                    .center,
//                                                            children: <Widget>[
//                                                              Text(
//                                                                '${deliverySlotList[index]['day'].substring(0, 3)}',
//                                                                style:
//                                                                    textBarlowMediumBlack(),
//                                                              ),
//                                                              Text(
//                                                                '${deliverySlotList[index]['date'][1] == "-" ? "0" + deliverySlotList[index]['date'].substring(0, 1) : deliverySlotList[index]['date'].substring(0, 2)}',
//                                                                style:
//                                                                    textbarlowRegularBlack(),
//                                                              ),
//                                                            ],
//                                                          ),
//                                                        ),
//                                                      ),
//                                                    ),
//                                                  ],
//                                                ),
//                                              )
//                                            : Container();
//                                      },
//                                    ),
//                                  ),
//                                ],
//                              ),
//                              Column(
//                                children: <Widget>[
//                                  Container(
//                                    color: Colors.white54,
//                                    child: ListView.builder(
//                                      physics: ScrollPhysics(),
//                                      shrinkWrap: true,
//                                      itemCount:
//                                          deliverySlotList[_selectedIndex]
//                                                          ['timeSchedule']
//                                                      .length ==
//                                                  null
//                                              ? 0
//                                              : deliverySlotList[_selectedIndex]
//                                                      ['timeSchedule']
//                                                  .length,
//                                      itemBuilder:
//                                          (BuildContext context, int i) {
//                                        if (deliverySlotList[_selectedIndex]
//                                                        ['timeSchedule'][0]
//                                                    ['isClosed'] ==
//                                                true &&
//                                            deliverySlotList[_selectedIndex]
//                                                        ['timeSchedule'][1]
//                                                    ['isClosed'] ==
//                                                true &&
//                                            deliverySlotList[_selectedIndex]
//                                                        ['timeSchedule'][2]
//                                                    ['isClosed'] ==
//                                                true &&
//                                            deliverySlotList[_selectedIndex]
//                                                        ['timeSchedule'][3]
//                                                    ['isClosed'] ==
//                                                true) {
//                                          return Center(
//                                            child: Image.asset(
//                                                'lib/assets/images/no-orders.png'),
//                                          );
//                                        } else {
//                                          return deliverySlotList[
//                                                              _selectedIndex]
//                                                          ['timeSchedule'][i]
//                                                      ['isClosed'] ==
//                                                  false
//                                              ? Row(
////                                          mainAxisAlignment:
////                                          MainAxisAlignment.center,
//                                                  crossAxisAlignment:
//                                                      CrossAxisAlignment.center,
//                                                  children: <Widget>[
//                                                    SizedBox(width: 15),
//                                                    Expanded(
//                                                      child: deliverySlotList
//                                                                  .length ==
//                                                              0
//                                                          ? Text(
//                                                              'Sorry ! No Slots Available Today !!!')
//                                                          : Text(
//                                                              '${deliverySlotList[_selectedIndex]['timeSchedule'][i]['slot']}',
//                                                              style:
//                                                                  textBarlowRegularBlack(),
//                                                            ),
//                                                    ),
//                                                    Expanded(
//                                                        child: Row(
//                                                      mainAxisAlignment:
//                                                          MainAxisAlignment.end,
//                                                      children: <Widget>[
//                                                        Radio(
//                                                          value: i,
//                                                          groupValue:
//                                                              selectedRadio,
//                                                          activeColor:
//                                                              Colors.green,
//                                                          onChanged: (value) {
//                                                            setSelectedRadio(
//                                                                value);
//                                                          },
//                                                        ),
//                                                      ],
//                                                    ))
//                                                  ],
//                                                )
//                                              : Container();
//                                        }
//                                      },
//                                    ),
//                                  ),
//                                ],
//                              )
//                            ],
//                          ),
//                        ],
//                      ),
//                    ),
                    SizedBox(height: 20.0),
                    Container(
                      margin: EdgeInsets.only(left: 15, right: 15, bottom: 20),
                      height: 55,
                      decoration: BoxDecoration(boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.33),
                            blurRadius: 6)
                      ]),
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 0.0,
                          right: 0.0,
                        ),
                        child: GFButton(
                            color: primary,
                            blockButton: true,
                            onPressed: proceed,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "Proceed",
                                  style: textBarlowRegularBlack(),
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
                            textStyle: textBarlowregbkck()),
                      ),
                    ),
                  ],
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
