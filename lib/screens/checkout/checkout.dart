import 'package:flutter/material.dart';
import 'package:getflutter/components/accordian/gf_accordian.dart';
import 'package:getflutter/getflutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:readymadeGroceryApp/screens/drawer/add-address.dart';
import 'package:readymadeGroceryApp/screens/drawer/edit-address.dart';
import 'package:readymadeGroceryApp/screens/payment/payment.dart';
import 'package:readymadeGroceryApp/service/cart-service.dart';
import 'package:readymadeGroceryApp/service/common.dart';
import 'package:readymadeGroceryApp/service/coupon-service.dart';
import 'package:readymadeGroceryApp/service/localizations.dart';
import 'package:readymadeGroceryApp/style/style.dart';
import 'package:readymadeGroceryApp/service/sentry-service.dart';
import 'package:readymadeGroceryApp/service/auth-service.dart';
import 'package:readymadeGroceryApp/service/address-service.dart';
import 'package:readymadeGroceryApp/widgets/appBar.dart';
import 'package:readymadeGroceryApp/widgets/button.dart';
import 'package:readymadeGroceryApp/widgets/loader.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:readymadeGroceryApp/widgets/normalText.dart';
import '../../service/constants.dart';
import 'package:flutter_map_picker/flutter_map_picker.dart';

SentryError sentryError = new SentryError();

class Checkout extends StatefulWidget {
  final locale, id;
  final Map localizedValues;

  Checkout({Key key, this.id, this.locale, this.localizedValues})
      : super(key: key);
  @override
  _CheckoutState createState() => _CheckoutState();
}

enum SingingCharacter { lafayette, jefferson }

class _CheckoutState extends State<Checkout> {
  // Declare this variable
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Map userInfo, address, cartItem, locationInfo;

  List addressList, deliverySlotList;
  int selecteAddressValue, dateSelectedValue = 0, selectSlot;
  String selectedDeliveryType, locationNotFound, currency, couponCode;
  var selectedAddress;
  bool isLoading = false,
      addressLoading = false,
      deliverySlotsLoading = false,
      isCouponLoading = false,
      isSelectSlot = false,
      couponApplied = false,
      deliverySlot = false,
      isLoadingCart = false,
      isDeliveryChargeLoading = false,
      isDeliveryChargeFree = false;
  LocationData currentLocation;
  Location _location = new Location();
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  PermissionStatus _permissionGranted;
  @override
  void initState() {
    Common.getCurrency().then((value) {
      currency = value;
    });
    super.initState();
    getAdminLocationInfo();
    getDeliverySlot();
    getCartItems();
  }

  getAdminLocationInfo() async {
    await LoginService.getLocationformation().then((onValue) {
      if (mounted) {
        setState(() {
          locationInfo = onValue['response_data'];
        });
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          locationInfo = null;
        });
      }
      sentryError.reportError(error, null);
    });
  }

  getCartItems() async {
    if (mounted) {
      setState(() {
        isLoadingCart = true;
      });
    }
    await CartService.getProductToCart().then((onValue) {
      getAddress();
      _refreshController.refreshCompleted();
      if (onValue['response_data'] is Map &&
          onValue['response_data']['products'] != [] &&
          mounted) {
        setState(() {
          cartItem = onValue['response_data'];
          Common.setCartData(onValue['response_data']);
          isLoadingCart = false;
        });
      } else {
        if (mounted) {
          setState(() {
            cartItem = null;
            Common.setCartData(null);
            isLoadingCart = false;
          });
        }
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          isLoadingCart = false;
        });
      }
      sentryError.reportError(error, null);
    });
  }

  addressRadioValueChanged(int value) async {
    if (mounted) {
      setState(() {
        selecteAddressValue = value;
        selectedAddress = addressList[value];
        isDeliveryChargeLoading = true;
      });
      var body = {"deliveryAddress": selectedAddress['_id'].toString()};
      await CartService.getDeliveryChargesAndSaveAddress(body).then((value) {
        if (mounted) {
          setState(() {
            cartItem['deliveryCharges'] =
                value['response_data']['deliveryCharges'];
            cartItem['grandTotal'] = value['response_data']['grandTotal'];
            cartItem['deliveryAddress'] =
                value['response_data']['deliveryAddress'];
            if (cartItem['deliveryCharges'] == 0 &&
                cartItem['deliveryAddress'] != null) {
              setState(() {
                isDeliveryChargeFree = true;
              });
            } else {
              setState(() {
                isDeliveryChargeFree = false;
              });
            }
            isDeliveryChargeLoading = false;
          });
        }
      }).catchError((error) {
        if (mounted) {
          setState(() {
            selecteAddressValue = null;
            selectedAddress = null;
            isDeliveryChargeFree = false;
            isDeliveryChargeLoading = true;
          });
        }
        sentryError.reportError(error, null);
      });
    }
    return value;
  }

  getDeliverySlot() async {
    if (mounted) {
      setState(() {
        deliverySlotsLoading = true;
      });
    }

    await AddressService.deliverySlot().then((onValue) {
      _refreshController.refreshCompleted();

      if (mounted) {
        setState(() {
          deliverySlotList = onValue['response_data'];
          deliverySlotsLoading = false;
        });
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          deliverySlotsLoading = false;
        });
      }
      sentryError.reportError(error, null);
    });
  }

  selectedSlotSelected(val) async {
    if (mounted) {
      setState(() {
        selectSlot = val;
      });
    }
  }

  dateSelectMethod(int index) {
    if (mounted) {
      setState(() {
        selectSlot = null;
        dateSelectedValue = index;
      });
    }
  }

  getAddress() async {
    if (mounted) {
      setState(() {
        addressLoading = true;
      });
    }
    await AddressService.getAddress().then((onValue) {
      _refreshController.refreshCompleted();
      if (mounted) {
        setState(() {
          addressLoading = false;
        });
      }
      if (mounted) {
        setState(() {
          addressList = onValue['response_data'];
          if (addressList.length > 0 && cartItem['deliveryAddress'] != null) {
            for (int i = 0; i < addressList.length; i++) {
              if (addressList[i]['_id'] == cartItem['deliveryAddress']) {
                addressRadioValueChanged(i);
              }
            }
          }
        });
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          addressLoading = false;
        });
      }
      sentryError.reportError(error, null);
    });
  }

  deleteAddress(body) async {
    await AddressService.deleteAddress(body).then((onValue) {
      if (mounted) {
        setState(() {
          getAddress();
          addressList = addressList;
          showSnackbar(onValue['response_data']);
        });
      }
    }).catchError((error) {
      sentryError.reportError(error, null);
    });
  }

  placeOrder() async {
    if (selecteAddressValue == null) {
      showSnackbar(
          MyLocalizations.of(context).getLocalizations("SELECT_ADDESS_MSG"));
    } else if (selectSlot == null) {
      showSnackbar(
          MyLocalizations.of(context).getLocalizations("SELECT_TIME_MSG"));
    } else {
      Map<String, dynamic> data = {
        "deliverySlotId": deliverySlotList[dateSelectedValue]['timings']
            [selectSlot]['_id'],
        "orderFrom": "USER_APP"
      };
      var result = Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Payment(
              locale: widget.locale,
              localizedValues: widget.localizedValues,
              data: data,
              cartItems: cartItem,
              locationInfo: locationInfo),
        ),
      );
      result.then((value) {
        getCartItems();
      });
    }
  }

  couponCodeApply() async {
    if (!_formKey.currentState.validate()) {
      return;
    } else {
      _formKey.currentState.save();
      if (mounted) {
        setState(() {
          isCouponLoading = true;
        });
      }
      await CouponService.applyCouponsCode(couponCode).then((onValue) {
        if (mounted) {
          setState(() {
            cartItem = onValue['response_data'];
            couponApplied = true;
            isCouponLoading = false;
          });
        }
      }).catchError((error) {
        if (mounted) {
          setState(() {
            isCouponLoading = false;
            couponApplied = false;
          });
        }
        sentryError.reportError(error, null);
      });
    }
  }

  removeCoupons(couponCode) async {
    if (mounted) {
      setState(() {
        isCouponLoading = true;
      });
    }
    await CouponService.removeCoupon(couponCode).then((onValue) {
      if (mounted) {
        setState(() {
          cartItem = onValue['response_data'];
          isCouponLoading = false;
        });
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          isCouponLoading = false;
        });
      }
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
                                  MyLocalizations.of(context)
                                      .getLocalizations("OK"),
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

  addAddressPageMethod(locationlatlong) async {
    PlacePickerResult pickerResult = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PlacePickerScreen(
                  googlePlacesApiKey: Constants.googleMapApiKey,
                  initialPosition: LatLng(locationlatlong['latitude'],
                      locationlatlong['longitude']),
                  mainColor: primary,
                  mapStrings: MapPickerStrings.english(),
                  placeAutoCompleteLanguage: 'en',
                )));
    if (pickerResult != null) {
      setState(() {
        var result = Navigator.push(
          context,
          new MaterialPageRoute(
            builder: (BuildContext context) => new AddAddress(
              isProfile: true,
              pickedLocation: pickerResult,
              locale: widget.locale,
              localizedValues: widget.localizedValues,
            ),
          ),
        );
        result.then((res) {
          getAddress();
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFDFDFD),
      key: _scaffoldKey,
      appBar: appBarTransparent(context, "CHECKOUT"),
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: false,
        controller: _refreshController,
        onRefresh: () {
          getAdminLocationInfo();
          getDeliverySlot();
          getCartItems();
        },
        child: addressLoading || deliverySlotsLoading || isLoadingCart
            ? SquareLoader()
            : cartItem == null
                ? Center(
                    child: Image.asset('lib/assets/images/no-orders.png'),
                  )
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
                                  buildBoldText(context, "CART_SUMMARY"),
                                  SizedBox(height: 10),
                                  buildPrice(
                                      context,
                                      null,
                                      MyLocalizations.of(context)
                                              .getLocalizations("SUB_TOTAL") +
                                          ' ( ${cartItem['products'].length} ' +
                                          MyLocalizations.of(context)
                                              .getLocalizations("ITEMS") +
                                          ')',
                                      '$currency${cartItem['subTotal'].toDouble().toStringAsFixed(2)}',
                                      false),
                                  cartItem['tax'] == 0
                                      ? Container()
                                      : SizedBox(height: 10),
                                  cartItem['tax'] == 0
                                      ? Container()
                                      : buildPrice(
                                          context,
                                          Image.asset(
                                              'lib/assets/icons/sale.png'),
                                          cartItem['taxInfo'] == null
                                              ? MyLocalizations.of(context)
                                                  .getLocalizations("TAX")
                                              : MyLocalizations.of(context)
                                                      .getLocalizations("TAX") +
                                                  " (" +
                                                  cartItem['taxInfo']
                                                      ['taxName'] +
                                                  " " +
                                                  cartItem['taxInfo']['amount']
                                                      .toString() +
                                                  "%)",
                                          '$currency${cartItem['tax'].toDouble().toStringAsFixed(2)}',
                                          false),
                                  SizedBox(height: 10),
                                  Form(
                                    key: _formKey,
                                    child: Container(
                                      child: cartItem['couponCode'] != null
                                          ? Column(
                                              children: <Widget>[
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    buildPrice(
                                                        context,
                                                        null,
                                                        MyLocalizations.of(
                                                                    context)
                                                                .getLocalizations(
                                                                    "COUPON_APPLIED") +
                                                            " (" +
                                                            "${cartItem['couponCode']}"
                                                                ")",
                                                        null,
                                                        false),
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
                                                                          'couponCode']);
                                                                },
                                                                child: Icon(Icons
                                                                    .delete),
                                                              ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 10),
                                                buildPrice(
                                                    context,
                                                    null,
                                                    MyLocalizations.of(context)
                                                        .getLocalizations(
                                                            "DISCOUNT"),
                                                    '$currency${cartItem['couponAmount'].toDouble().toStringAsFixed(2)}',
                                                    false),
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
                                                        hintText: MyLocalizations
                                                                .of(context)
                                                            .getLocalizations(
                                                                "ENTER_COUPON_CODE"),
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
                                                            .getLocalizations(
                                                                "ENTER_COUPON_CODE");
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
                                                          const EdgeInsets.only(
                                                              left: 8.0),
                                                      child: applyCoupon(
                                                          context,
                                                          "APPLY",
                                                          isCouponLoading),
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
                                  isDeliveryChargeFree == true
                                      ? buildPrice(
                                          context,
                                          null,
                                          MyLocalizations.of(context)
                                              .getLocalizations(
                                                  "DELIVERY_CHARGES"),
                                          MyLocalizations.of(context)
                                              .getLocalizations("FREE"),
                                          false)
                                      : cartItem['deliveryCharges'] == 0 ||
                                              cartItem['deliveryCharges'] == '0'
                                          ? Container()
                                          : buildPrice(
                                              context,
                                              null,
                                              MyLocalizations.of(context)
                                                  .getLocalizations(
                                                      "DELIVERY_CHARGES"),
                                              '$currency${cartItem['deliveryCharges'].toDouble().toStringAsFixed(2)}',
                                              isDeliveryChargeLoading),
                                  SizedBox(height: 10),
                                  cartItem['walletAmount'] > 0
                                      ? buildPrice(
                                          context,
                                          null,
                                          MyLocalizations.of(context)
                                              .getLocalizations(
                                                  "USED_WALLET_AMOUNT"),
                                          '$currency${cartItem['walletAmount'].toDouble().toStringAsFixed(2)}',
                                          false)
                                      : Container(),
                                  cartItem['walletAmount'] > 0
                                      ? SizedBox(height: 10)
                                      : Container(),
                                  buildPrice(
                                      context,
                                      null,
                                      MyLocalizations.of(context)
                                          .getLocalizations("TOTAL"),
                                      '$currency${cartItem['grandTotal'].toDouble().toStringAsFixed(2)}',
                                      false),
                                  SizedBox(height: 20),
                                  buildBoldText(context, "DELIVERY_ADDESS"),
                                ],
                              ),
                            ),
                            GFAccordion(
                              collapsedTitlebackgroundColor: Color(0xFFF0F0F0),
                              titleborder: Border.all(color: Color(0xffD6D6D6)),
                              contentbackgroundColor: Colors.white,
                              contentPadding:
                                  EdgeInsets.only(top: 5, bottom: 5),
                              titleChild: Text(
                                selectedAddress == null
                                    ? MyLocalizations.of(context)
                                        .getLocalizations("ADDRESS_MSG")
                                    : '${selectedAddress['flatNo']}, ${selectedAddress['apartmentName']},${selectedAddress['address']}',
                                overflow: TextOverflow.clip,
                                maxLines: 1,
                                style: textBarlowRegularBlack(),
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
                                            groupValue: selecteAddressValue,
                                            activeColor: primary,
                                            value: i,
                                            title: buildAddress(
                                                '${addressList[i]['flatNo']}, ${addressList[i]['apartmentName']},${addressList[i]['address']},',
                                                "${addressList[i]['landmark']} ,'${addressList[i]['postalCode']}, ${addressList[i]['mobileNumber'].toString()}"),
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
                                                    InkWell(
                                                      onTap: () async {
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
                                                                left: 8.0),
                                                        child:
                                                            primaryOutlineButton(
                                                                context,
                                                                "EDIT"),
                                                      ),
                                                    ),
                                                    InkWell(
                                                        onTap: () {
                                                          deleteAddress(
                                                              addressList[i]
                                                                  ['_id']);
                                                        },
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      20.0),
                                                          child:
                                                              primaryOutlineButton(
                                                                  context,
                                                                  "DELETE"),
                                                        )),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: 20, right: 20),
                                            child: Divider(thickness: 1),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                  SizedBox(height: 20),
                                  InkWell(
                                      onTap: () async {
                                        _permissionGranted =
                                            await _location.hasPermission();
                                        if (_permissionGranted ==
                                            PermissionStatus.denied) {
                                          _permissionGranted = await _location
                                              .requestPermission();
                                          if (_permissionGranted !=
                                              PermissionStatus.granted) {
                                            Map locationLatLong = {
                                              "latitude":
                                                  locationInfo['location']
                                                      ['latitude'],
                                              "longitude":
                                                  locationInfo['location']
                                                      ['longitude']
                                            };

                                            addAddressPageMethod(
                                                locationLatLong);
                                            return;
                                          }
                                        }
                                        currentLocation =
                                            await _location.getLocation();

                                        if (currentLocation != null) {
                                          Map locationLatLong = {
                                            "latitude":
                                                currentLocation.latitude,
                                            "longitude":
                                                currentLocation.longitude
                                          };
                                          addAddressPageMethod(locationLatLong);
                                        }
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 80.0),
                                        child: dottedBorderButton(
                                            context, "ADD_NEW_ADDRESS"),
                                      )),
                                  SizedBox(height: 20),
                                ],
                              ),
                            ),
                            SizedBox(height: 15),
                            Constants.predefined == "true"
                                ? timeZoneMessage(context, "TIME_ZONE_MESSAGE")
                                : Container(),
                            SizedBox(height: 5),
                            Padding(
                              padding: EdgeInsets.only(left: 15, right: 15),
                              child: buildBoldText(context, "CHOOSE_DATE_TIME"),
                            ),
                            SizedBox(height: 15),
                            deliverySlotList.length > 0
                                ? Column(
                                    children: <Widget>[
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              height: 50,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: ListView.builder(
                                                shrinkWrap: true,
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemCount: deliverySlotList
                                                            .length ==
                                                        null
                                                    ? 0
                                                    : deliverySlotList.length,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  return Container(
                                                    color: Colors.grey[200],
                                                    width: 70,
                                                    child: Row(
                                                      children: <Widget>[
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 3,
                                                                  bottom: 3),
                                                          child: Container(
                                                            width: 60,
                                                            margin:
                                                                EdgeInsets.only(
                                                              left: 10,
                                                            ),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: dateSelectedValue !=
                                                                          null &&
                                                                      dateSelectedValue ==
                                                                          index
                                                                  ? primary
                                                                  : Colors
                                                                      .transparent,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                            ),
                                                            child: InkWell(
                                                                onTap: () =>
                                                                    dateSelectMethod(
                                                                        index),
                                                                child: normalTextWithOutRow(
                                                                    context,
                                                                    deliverySlotList[index]
                                                                            [
                                                                            'date']
                                                                        .split(
                                                                            ' ')
                                                                        .join(
                                                                            '\n'),
                                                                    true)),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        color: Color(0xFFF7F7F7),
                                        child: ListView.builder(
                                          physics: ScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: deliverySlotList[
                                                              dateSelectedValue]
                                                          ['timings']
                                                      .length ==
                                                  null
                                              ? 0
                                              : deliverySlotList[
                                                          dateSelectedValue]
                                                      ['timings']
                                                  .length,
                                          itemBuilder:
                                              (BuildContext context, int i) {
                                            return Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Expanded(
                                                  child: RadioListTile(
                                                      value: i,
                                                      groupValue: selectSlot,
                                                      activeColor: primary,
                                                      onChanged: (value) {
                                                        selectedSlotSelected(
                                                            value);
                                                      },
                                                      title: normalTextWithOutRow(
                                                          context,
                                                          deliverySlotList[
                                                                      dateSelectedValue]
                                                                  ['timings'][i]
                                                              ['slot'],
                                                          false)),
                                                )
                                              ],
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  )
                                : Container(),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: placeOrder,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: buttonPrimary(context, "PROCEED", false),
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
