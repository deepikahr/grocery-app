import 'package:flutter/material.dart';
import 'package:getflutter/components/accordian/gf_accordian.dart';
import 'package:getflutter/getflutter.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:grocery_pro/screens/payment/payment.dart';
import 'package:grocery_pro/service/coupon-service.dart';
import 'package:grocery_pro/service/localizations.dart';
import 'package:grocery_pro/service/payment-service.dart';
import 'package:grocery_pro/style/style.dart';
import 'package:grocery_pro/service/sentry-service.dart';
import 'package:grocery_pro/service/auth-service.dart';
import 'package:grocery_pro/screens/address/add-address.dart';
import 'package:grocery_pro/service/address-service.dart';
import 'package:grocery_pro/screens/address/edit-address.dart';
import 'package:grocery_pro/widgets/loader.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dotted_border/dotted_border.dart';

import '../../service/constants.dart';

SentryError sentryError = new SentryError();

class Checkout extends StatefulWidget {
  final Map<String, dynamic> cartItem;
  final String buy, quantity, locale, id;
  final Map<String, Map<String, String>> localizedValues;

  Checkout(
      {Key key,
      this.id,
      this.cartItem,
      this.buy,
      this.quantity,
      this.locale,
      this.localizedValues})
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

  List addressList, deliverySlotList;
  int selectedRadio, groupValue, groupValue1, _selectedIndex = 0;
  String selectedDeliveryType, locationNotFound, name, currency, couponCode;

  var selectedAddress, selectedTime, selectedDate;
  bool isLoading = false,
      addressLoading = false,
      deliverySlotsLoading = false,
      isPlaceOrderLoading = false,
      isCouponLoading = false,
      isSelectSlot = false,
      couponApplied = false,
      deliverySlot = false;
  LocationResult _pickedLocation;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  @override
  void initState() {
    cartItem = widget.cartItem;
    super.initState();

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
      _refreshController.refreshCompleted();

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

    await AddressService.deliverySlot(
            DateFormat('HH:mm').format(DateTime.now()),
            DateTime.now().millisecondsSinceEpoch)
        .then((onValue) {
      _refreshController.refreshCompleted();
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
  }

  getAddress() async {
    if (mounted) {
      setState(() {
        addressLoading = true;
      });
    }
    await AddressService.getAddress().then((onValue) {
      _refreshController.refreshCompleted();

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

// Changes the selected value on 'onChanged' click on each radio button

  _onSelected(int index) {
    if (mounted) {
      setState(() => _selectedIndex = index);
    }
    selectedDate = deliverySlotList[index]['date'];
  }

  placeOrder() async {
    if (selectedDate == null) {
      selectedDate = DateFormat("dd-MM-yyyy").format(DateTime.now());
    }
    if (groupValue1 == null) {
      showSnackbar(MyLocalizations.of(context).pleaseselectaddressfirst);
    } else if (selectedTime == null) {
      showSnackbar(MyLocalizations.of(context).pleaseselecttimeslotfirst);
    } else {
      Map<String, dynamic> data = {
        "deliveryType": "Home_Delivery",
        "paymentType": 'COD',
      };

      data['deliveryAddress'] = selectedAddress['_id'].toString();

      data['deliveryDate'] = selectedDate.toString();

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
        try {
          if (value['response_code'] == 200) {
            if (mounted) {
              setState(() {
                isPlaceOrderLoading = false;
              });
            }
            if (value['response_data']['deliveryDetails']['deliveryCharges']
                is int) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Payment(
                    locale: widget.locale,
                    localizedValues: widget.localizedValues,
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
                    locale: widget.locale,
                    localizedValues: widget.localizedValues,
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

  couponCodeApply(couponName, cartId) {
    if (!_formKey.currentState.validate()) {
      return;
    } else {
      _formKey.currentState.save();

      updateCoupons(couponCode, cartId);
    }
  }

  updateCoupons(data, cartId) async {
    if (mounted) {
      setState(() {
        isCouponLoading = true;
      });
    }
    await CouponService.applyCouponsCode(cartId, data).then((onValue) {
      try {
        if (onValue['response_code'] == 200) {
          if (mounted) {
            setState(() {
              cartItem = onValue['response_data'];

              couponApplied = true;
            });
          }
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

  removeCoupons(cartId) async {
    if (mounted) {
      setState(() {
        isCouponLoading = true;
      });
    }
    await CouponService.removeCoupon(cartId).then((onValue) {
      try {
        if (onValue['response_code'] == 200) {
          if (mounted) {
            setState(() {
              cartItem = onValue['response_data'];
              couponApplied = false;
            });
          }

          // showError('', 'Coupon is applied');
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
                                  MyLocalizations.of(context).ok,
                                  style: hintSfLightbig(),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
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
          MyLocalizations.of(context).checkout,
          style: textbarlowSemiBoldBlack(),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black, size: 1.0),
      ),
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: false,
        header: WaterDropHeader(),
        controller: _refreshController,
        onRefresh: () {
          getUserInfo();
          getAddress();

          getDeliverySlot();
        },
        child: addressLoading
            ? SquareLoader()
            : deliverySlotsLoading
                ? SquareLoader()
                : ListView(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(top: 15, bottom: 10),
                        margin: EdgeInsets.only(top: 10),
                        decoration: BoxDecoration(
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
                                  Text(MyLocalizations.of(context).cartsummary,
                                      style: textBarlowSemiBoldBlackbigg()),
                                  SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        MyLocalizations.of(context).subTotal +
                                            ' ( ${widget.quantity} ' +
                                            MyLocalizations.of(context).items +
                                            ')',
                                        style: textBarlowRegularBlack(),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
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
                                            MyLocalizations.of(context).tax,
                                            style: textBarlowRegularBlack(),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
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
                                  SizedBox(height: 10),
                                  Form(
                                    key: _formKey,
                                    child: Container(
                                      child: couponApplied
                                          ? Column(
                                              children: <Widget>[
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    Text(
                                                      MyLocalizations.of(
                                                                  context)
                                                              .couponApplied +
                                                          " (" +
                                                          "${cartItem['couponInfo']['couponCode']}"
                                                              ")",
                                                      style:
                                                          textBarlowRegularBlack(),
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: <Widget>[
                                                        isCouponLoading
                                                            ? SquareLoader()
                                                            : InkWell(
                                                                onTap: () {
                                                                  removeCoupons(
                                                                      cartItem[
                                                                          '_id']);
                                                                },
                                                                child: Icon(Icons
                                                                    .delete),
                                                              ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 10),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    Text(
                                                      MyLocalizations.of(
                                                              context)
                                                          .discount,
                                                      style:
                                                          textBarlowRegularBlack(),
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: <Widget>[
                                                        Text(
                                                          currency,
                                                          style:
                                                              textbarlowBoldsmBlack(),
                                                        ),
                                                        Text(
                                                          '${cartItem['couponInfo']['couponDiscountAmount']}',
                                                          style:
                                                              textbarlowBoldsmBlack(),
                                                        )
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            )
                                          : Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Container(
                                                  width: 193,
                                                  height: 44,
                                                  alignment: Alignment.center,
                                                  padding: EdgeInsets.only(
                                                      left: 0.0, bottom: 3),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: Color(0xFFD4D4E0),
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(4),
                                                    ),
                                                  ),
                                                  child: TextFormField(
                                                    textAlign: TextAlign.center,
                                                    textCapitalization:
                                                        TextCapitalization
                                                            .words,
                                                    decoration: InputDecoration(
                                                        hintText:
                                                            MyLocalizations.of(
                                                                    context)
                                                                .enterCouponCode,
                                                        hintStyle:
                                                            textBarlowRegularBlacklight(),
                                                        labelStyle: TextStyle(
                                                            color:
                                                                Colors.black),
                                                        border:
                                                            InputBorder.none),
                                                    cursorColor: primary,
                                                    validator: (String value) {
                                                      if (value.isEmpty) {
                                                        return MyLocalizations
                                                                .of(context)
                                                            .enterCouponCode;
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
                                                      couponCodeApply(
                                                          couponCode,
                                                          cartItem['_id']);
                                                    },
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 8.0),
                                                      child: Container(
                                                        height: 44,
                                                        width: 119,
                                                        child: GFButton(
                                                          onPressed: null,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 8.0,
                                                                    right: 8.0),
                                                            child: isCouponLoading
                                                                ? SquareLoader()
                                                                : Text(
                                                                    MyLocalizations.of(context)
                                                                            .apply +
                                                                        " ",
                                                                    style:
                                                                        textBarlowRegularBlack(),
                                                                  ),
                                                          ),
                                                          color: primary,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                )
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
                                        MyLocalizations.of(context).total,
                                        style: textbarlowMediumBlack(),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
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
                                  Text(
                                      MyLocalizations.of(context)
                                          .deliveryAddress,
                                      style: textBarlowSemiBoldBlackbigg()),
                                  SizedBox(height: 10),
                                  Text(
                                    MyLocalizations.of(context).homeDelivery,
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
                                                              locale:
                                                                  widget.locale,
                                                              localizedValues:
                                                                  widget
                                                                      .localizedValues,
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
                                                          MyLocalizations.of(
                                                                  context)
                                                              .edit,
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
                                                              right: 18.0,
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
                                                            MyLocalizations.of(
                                                                    context)
                                                                .delete,
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
                                          Constants.GOOGLE_API_KEY,
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
                                                  locale: widget.locale,
                                                  localizedValues:
                                                      widget.localizedValues,
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
                                      },
                                      type: GFButtonType.transparent,
                                      color: GFColors.LIGHT,
                                      child: Text(
                                        MyLocalizations.of(context)
                                            .addNewAddress,
                                        style: textBarlowRegularBb(),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Container(
                              padding: EdgeInsets.only(
                                  left: 15, right: 15, bottom: 10),
                              child: Text(
                                MyLocalizations.of(context)
                                    .chooseDeliveryDateandTimeSlot,
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
                                        return Container(
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
                                                            10),
                                                  ),
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
                                        );
                                      },
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                deliverySlotList[_selectedIndex]['timeSchedule']
                                                [0]['isClosed'] ==
                                            false &&
                                        deliverySlotList[_selectedIndex]
                                                    ['timeSchedule'][1]
                                                ['isClosed'] ==
                                            false &&
                                        deliverySlotList[_selectedIndex]
                                                    ['timeSchedule'][2]
                                                ['isClosed'] ==
                                            false &&
                                        deliverySlotList[_selectedIndex]
                                                    ['timeSchedule'][3]
                                                ['isClosed'] ==
                                            false
                                    ? Center(
                                        child: Image.asset(
                                            'lib/assets/images/no-orders.png'),
                                      )
                                    : Container(
                                        color: Color(0xFFF7F7F7),
                                        child: ListView.builder(
                                          physics: ScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: deliverySlotList[
                                                              _selectedIndex]
                                                          ['timeSchedule']
                                                      .length ==
                                                  null
                                              ? 0
                                              : deliverySlotList[_selectedIndex]
                                                      ['timeSchedule']
                                                  .length,
                                          itemBuilder:
                                              (BuildContext context, int i) {
                                            return deliverySlotList[
                                                                _selectedIndex]
                                                            ['timeSchedule'][i]
                                                        ['isClosed'] ==
                                                    true
                                                ? Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      Expanded(
                                                        child: RadioListTile(
                                                          value: i,
                                                          groupValue:
                                                              selectedRadio,
                                                          activeColor:
                                                              Colors.green,
                                                          onChanged: (value) {
                                                            setSelectedRadio(
                                                                value);
                                                          },
                                                          title: deliverySlotList
                                                                      .length ==
                                                                  0
                                                              ? Text(MyLocalizations.of(
                                                                          context)
                                                                      .sorryNoSlotsAvailableToday +
                                                                  ' !!!')
                                                              : Text(
                                                                  '${deliverySlotList[_selectedIndex]['timeSchedule'][i]['slot']}',
                                                                  style:
                                                                      textBarlowRegularBlack(),
                                                                ),
                                                        ),
                                                      )
                                                    ],
                                                  )
                                                : Container();
                                          },
                                        ),
                                      ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      SizedBox(height: 20.0),
                      Container(
                        margin:
                            EdgeInsets.only(left: 15, right: 15, bottom: 20),
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
                                    MyLocalizations.of(context).proceed,
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
