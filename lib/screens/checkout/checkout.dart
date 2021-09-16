import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:readymadeGroceryApp/screens/drawer/add-address.dart';
import 'package:readymadeGroceryApp/screens/drawer/addressPick.dart';
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

SentryError sentryError = new SentryError();

class Checkout extends StatefulWidget {
  final locale, id;
  final Map? localizedValues;

  Checkout({Key? key, this.id, this.locale, this.localizedValues})
      : super(key: key);
  @override
  _CheckoutState createState() => _CheckoutState();
}

enum SingingCharacter { lafayette, jefferson }

class _CheckoutState extends State<Checkout> {
  // Declare this variable
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Map? userInfo, address, cartItem, locationInfo;

  List? addressList, deliverySlotList, shippingMethodsList;
  int? selecteAddressValue,
      dateSelectedValue = 0,
      selectSlot,
      shippingMethodValue = 0;
  String? selectedDeliveryType,
      locationNotFound,
      currency,
      couponCode,
      storeAddress;
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
      isDeliveryChargeFree = false,
      isGetShippingLoading = false,
      isUpdateShippingMethodLoading = false;
  LocationData? currentLocation;
  Location _location = new Location();
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  TextEditingController instructionController = TextEditingController();
  PermissionStatus? _permissionGranted;
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
          shippingMethodsList = locationInfo!['shippingMethod'] ?? [];
          storeAddress = locationInfo!['storeAddress']['address'] ?? "";
        });
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          locationInfo = null;
          shippingMethodsList = [];
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
          if (cartItem!['shipping_method'] == "DELIVERY") {
            for (int i = 0; i < shippingMethodsList!.length; i++) {
              if (shippingMethodsList![i] == cartItem!['shipping_method']) {
                setState(() {
                  shippingMethodValue = i;
                });
              }
            }
          }
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

  addressRadioValueChanged(int? value) async {
    if (mounted) {
      setState(() {
        selecteAddressValue = value;
        selectedAddress = addressList![value!];
        isDeliveryChargeLoading = true;
      });
      var body = {"deliveryAddress": selectedAddress['_id'].toString()};
      await CartService.getDeliveryChargesAndSaveAddress(body).then((value) {
        if (mounted) {
          setState(() {
            cartItem!['deliveryCharges'] =
                value['response_data']['deliveryCharges'];
            cartItem!['grandTotal'] = value['response_data']['grandTotal'];
            cartItem!['deliveryAddress'] =
                value['response_data']['deliveryAddress'];
            if (cartItem!['deliveryCharges'] == 0 &&
                cartItem!['deliveryAddress'] != null) {
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

  shippingMethodRadioValueChanged(int? value) async {
    if (mounted) {
      setState(() {
        shippingMethodValue = value;
        isUpdateShippingMethodLoading = true;
      });
      var body = {"shippingMethod": shippingMethodsList![value!]};
      await CartService.getShippingMethodAndSave(body).then((value) {
        if (mounted) {
          setState(() {
            cartItem = value['response_data'];
            isUpdateShippingMethodLoading = false;
            if (shippingMethodsList![shippingMethodValue!] == "DELIVERY") {
              if (addressList!.length > 0) {
                addressRadioValueChanged(0);
              }
            } else {
              selecteAddressValue = null;
              selectedAddress = null;
            }
          });
        }
      }).catchError((error) {
        if (mounted) {
          setState(() {
            shippingMethodValue = 0;
            isUpdateShippingMethodLoading = false;
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
          if (shippingMethodsList!.length > 0 &&
              cartItem!['shippingMethod'] != null) {
            for (int i = 0; i < shippingMethodsList!.length; i++) {
              if (shippingMethodsList![i] == cartItem!['shippingMethod']) {
                shippingMethodRadioValueChanged(i);
              }
            }
          } else if (shippingMethodsList!.length > 0 &&
              cartItem!['shippingMethod'] == null) {
            shippingMethodRadioValueChanged(0);
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
    if (shippingMethodValue == null) {
      showSnackbar(MyLocalizations.of(context)!
          .getLocalizations("SELECT_SHIPPING_METHOD"));
    } else if (selecteAddressValue == null &&
        shippingMethodsList![shippingMethodValue!] != "PICK_UP") {
      showSnackbar(
          MyLocalizations.of(context)!.getLocalizations("SELECT_ADDESS_MSG"));
    } else if (selectSlot == null) {
      showSnackbar(
          MyLocalizations.of(context)!.getLocalizations("SELECT_TIME_MSG"));
    } else {
      Map<String, dynamic> data = {
        "deliverySlotId": deliverySlotList![dateSelectedValue!]['timings']
            [selectSlot]['_id'],
        "orderFrom": Constants.orderFrom,
        "shippingMethod": shippingMethodsList![shippingMethodValue!],
      };
      var result = Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Payment(
              locale: widget.locale,
              localizedValues: widget.localizedValues,
              data: data,
              cartItems: cartItem,
              locationInfo: locationInfo,
              instruction: instructionController.text),
        ),
      );
      result.then((value) {
        getCartItems();
      });
    }
  }

  couponCodeApply() async {
    if (!_formKey.currentState!.validate()) {
      return;
    } else {
      _formKey.currentState!.save();
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
            style: hintSfsemiboldb(context),
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
                    style: hintSfLightsm(context),
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
                                  MyLocalizations.of(context)!
                                      .getLocalizations("OK"),
                                  style: hintSfLightbig(context),
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
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddressPickPage(
          locale: widget.locale,
          localizedValues: widget.localizedValues,
          initialLocation: LatLng(
            locationlatlong['latitude'],
            locationlatlong['longitude'],
          ),
        ),
      ),
    ).then((value) {
      if (value != null && value['initialLocation'] != null) {
        addAddressPageMethod(value['initialLocation']);
      } else if (value != null) {
        var result = Navigator.push(
          context,
          new MaterialPageRoute(
            builder: (BuildContext context) => new AddAddress(
              address: value['address'],
              position: value['location'],
              locale: widget.locale,
              localizedValues: widget.localizedValues,
            ),
          ),
        );
        result.then((res) {
          getAddress();
        });
      }
    });
  }

  Widget buildInstructionTextField() {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0, bottom: 10.0),
      child: Container(
        child: TextFormField(
          controller: instructionController,
          maxLength: 100,
          maxLines: 5,
          onSaved: (String? value) {
            instructionController.text = value!;
          },
          style: textBarlowRegularBlack(context),
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            counterText: "",
            errorBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 0, color: Color(0xFFF44242))),
            errorStyle: TextStyle(color: Color(0xFFF44242)),
            contentPadding: EdgeInsets.all(10),
            enabledBorder: const OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.grey, width: 0.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: primary(context)),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: bg(context),
      key: _scaffoldKey,
      appBar: appBarTransparent(context, "CHECKOUT") as PreferredSizeWidget?,
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
                ? noDataImage()
                : ListView(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(top: 25, bottom: 10),
                        // margin: EdgeInsets.only(top: 10),
                        decoration: BoxDecoration(
                          color: bg(context),
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
                                      MyLocalizations.of(context)!
                                              .getLocalizations("SUB_TOTAL") +
                                          ' ( ${cartItem!['products'].length} ' +
                                          MyLocalizations.of(context)!
                                              .getLocalizations("ITEMS") +
                                          ')',
                                      '$currency${cartItem!['subTotal'].toDouble().toStringAsFixed(2)}',
                                      false),
                                  cartItem!['tax'] == 0
                                      ? Container()
                                      : SizedBox(height: 10),
                                  cartItem!['tax'] == 0
                                      ? Container()
                                      : buildPrice(
                                          context,
                                          null,
                                          cartItem!['taxInfo'] == null
                                              ? MyLocalizations.of(context)!
                                                  .getLocalizations("TAX")
                                              : MyLocalizations.of(context)!
                                                      .getLocalizations("TAX") +
                                                  " (" +
                                                  cartItem!['taxInfo']
                                                      ['taxName'] +
                                                  " " +
                                                  cartItem!['taxInfo']['amount']
                                                      .toString() +
                                                  "%)",
                                          '$currency${cartItem!['tax'].toDouble().toStringAsFixed(2)}',
                                          false),
                                  SizedBox(height: 10),
                                  Form(
                                    key: _formKey,
                                    child: Container(
                                      child: cartItem!['couponCode'] != null
                                          ? Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Row(
                                                  children: [
                                                    buildPrice(
                                                        context,
                                                        null,
                                                        MyLocalizations.of(
                                                                    context)!
                                                                .getLocalizations(
                                                                    "COUPON_DISCOUNT") +
                                                            " (" +
                                                            "${cartItem!['couponCode']}"
                                                                ")",
                                                        null,
                                                        false),
                                                    SizedBox(width: 5),
                                                    isCouponLoading
                                                        ? SquareLoader()
                                                        : InkWell(
                                                            onTap: () {
                                                              removeCoupons(
                                                                  cartItem![
                                                                      'couponCode']);
                                                            },
                                                            child: Icon(
                                                                Icons.delete),
                                                          ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: <Widget>[
                                                    buildPrice(
                                                        context,
                                                        null,
                                                        "",
                                                        '-$currency${cartItem!['couponAmount'].toDouble().toStringAsFixed(2)}',
                                                        false),
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
                                                        hintText: MyLocalizations
                                                                .of(context)!
                                                            .getLocalizations(
                                                                "ENTER_COUPON_CODE"),
                                                        hintStyle:
                                                            textBarlowRegularBlacklight(
                                                                context),
                                                        labelStyle: TextStyle(
                                                            color:
                                                                dark(context)),
                                                        border:
                                                            InputBorder.none),
                                                    cursorColor: primarybg,
                                                    validator: (String? value) {
                                                      if (value!.isEmpty) {
                                                        return MyLocalizations
                                                                .of(context)!
                                                            .getLocalizations(
                                                                "ENTER_COUPON_CODE");
                                                      } else {
                                                        return null;
                                                      }
                                                    },
                                                    style:
                                                        textBarlowRegularBlacklight(
                                                            context),
                                                    onSaved: (String? value) {
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
                                      color:
                                          Color(0xFF707070).withOpacity(0.20),
                                      thickness: 1),
                                  SizedBox(height: 10),
                                  isDeliveryChargeFree == true
                                      ? buildPrice(
                                          context,
                                          null,
                                          MyLocalizations.of(context)!
                                              .getLocalizations(
                                                  "DELIVERY_CHARGES"),
                                          MyLocalizations.of(context)!
                                              .getLocalizations("FREE"),
                                          false)
                                      : cartItem!['deliveryCharges'] == 0 ||
                                              cartItem!['deliveryCharges'] ==
                                                  '0'
                                          ? Container()
                                          : buildPrice(
                                              context,
                                              null,
                                              MyLocalizations.of(context)!
                                                  .getLocalizations(
                                                      "DELIVERY_CHARGES"),
                                              '$currency${cartItem!['deliveryCharges'].toDouble().toStringAsFixed(2)}',
                                              isDeliveryChargeLoading),
                                  SizedBox(height: 10),
                                  cartItem!['walletAmount'] > 0
                                      ? buildPrice(
                                          context,
                                          null,
                                          MyLocalizations.of(context)!
                                              .getLocalizations(
                                                  "PAID_FORM_WALLET"),
                                          '-$currency${cartItem!['walletAmount'].toDouble().toStringAsFixed(2)}',
                                          false)
                                      : Container(),
                                  cartItem!['walletAmount'] > 0
                                      ? SizedBox(height: 10)
                                      : Container(),
                                  Divider(
                                      color:
                                          Color(0xFF707070).withOpacity(0.20),
                                      thickness: 1),
                                  buildPrice(
                                      context,
                                      null,
                                      MyLocalizations.of(context)!
                                          .getLocalizations("PAYABLE_AMOUNT"),
                                      '$currency${cartItem!['grandTotal'].toDouble().toStringAsFixed(2)}',
                                      false),
                                  Divider(
                                      color:
                                          Color(0xFF707070).withOpacity(0.20),
                                      thickness: 1),
                                  SizedBox(height: 5),
                                  shippingMethodsList!.length == 0
                                      ? Container()
                                      : buildBoldText(
                                          context, "SHIPPING_METHOD"),
                                  shippingMethodsList!.length == 0
                                      ? Container()
                                      : SizedBox(height: 10),
                                  shippingMethodsList!.length == 0
                                      ? Container()
                                      : Container(
                                          height: 60,
                                          child: ListView.builder(
                                            physics: ScrollPhysics(),
                                            shrinkWrap: true,
                                            scrollDirection: Axis.horizontal,
                                            itemCount: shippingMethodsList!
                                                    .isEmpty
                                                ? 0
                                                : shippingMethodsList!.length,
                                            itemBuilder:
                                                (BuildContext context, int i) {
                                              return InkWell(
                                                  onTap: () {
                                                    shippingMethodRadioValueChanged(
                                                        i);
                                                  },
                                                  child: Row(children: [
                                                    Radio(
                                                        value: i,
                                                        activeColor:
                                                            primary(context),
                                                        groupValue:
                                                            shippingMethodValue,
                                                        onChanged:
                                                            shippingMethodRadioValueChanged),
                                                    buildShippingMethodText(
                                                        shippingMethodsList![
                                                                i] ??
                                                            "",
                                                        context),
                                                  ]));
                                            },
                                          ),
                                        ),
                                  isUpdateShippingMethodLoading
                                      ? SquareLoader()
                                      : Container(),
                                  shippingMethodsList!.length == 0
                                      ? Container()
                                      : shippingMethodsList![
                                                  shippingMethodValue!] ==
                                              "PICK_UP"
                                          ? Column(
                                              children: [
                                                buildBoldText(
                                                    context, "ADDRESS"),
                                                SizedBox(height: 10),
                                                buildAddress(
                                                    storeAddress, "", context),
                                              ],
                                            )
                                          : buildBoldText(
                                              context, "DELIVERY_ADDESS"),
                                ],
                              ),
                            ),
                            shippingMethodsList!.length == 0
                                ? Container()
                                : shippingMethodsList![shippingMethodValue!] ==
                                            "PICK_UP" ||
                                        isUpdateShippingMethodLoading
                                    ? Container()
                                    : GFAccordion(
                                        expandedTitleBackgroundColor:
                                            Theme.of(context).brightness ==
                                                    Brightness.dark
                                                ? greyb2
                                                : Color(0xFFF0F0F0),
                                        collapsedTitleBackgroundColor:
                                            Theme.of(context).brightness ==
                                                    Brightness.dark
                                                ? greyc2
                                                : Color(0xFFF0F0F0),
                                        titleBorder: Border.all(
                                            color: Color(0xffD6D6D6)),
                                        contentBackgroundColor:
                                            Theme.of(context).brightness ==
                                                    Brightness.dark
                                                ? greyc2
                                                : Colors.white,
                                        contentPadding:
                                            EdgeInsets.only(top: 5, bottom: 5),
                                        titleChild: Text(
                                          selectedAddress == null
                                              ? MyLocalizations.of(context)!
                                                  .getLocalizations(
                                                      "ADDRESS_MSG")
                                              : '${selectedAddress['flatNo']}, ${selectedAddress['apartmentName']},${selectedAddress['address']}',
                                          overflow: TextOverflow.clip,
                                          maxLines: 1,
                                          style:
                                              textBarlowRegularBlack(context),
                                        ),
                                        contentChild: Column(
                                          children: <Widget>[
                                            ListView.builder(
                                              physics: ScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount: addressList!.isEmpty
                                                  ? 0
                                                  : addressList!.length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int i) {
                                                return Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: <Widget>[
                                                    RadioListTile(
                                                      groupValue:
                                                          selecteAddressValue,
                                                      activeColor:
                                                          primary(context),
                                                      value: i,
                                                      title: buildAddress(
                                                          '${addressList![i]['flatNo']}, ${addressList![i]['apartmentName']},${addressList![i]['address']},',
                                                          "${addressList![i]['landmark']} ,'${addressList![i]['postalCode']}, ${addressList![i]['mobileNumber'].toString()}",
                                                          context),
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
                                                              InkWell(
                                                                onTap:
                                                                    () async {
                                                                  await Navigator
                                                                      .push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              EditAddress(
                                                                        locale:
                                                                            widget.locale,
                                                                        localizedValues:
                                                                            widget.localizedValues,
                                                                        updateAddressID:
                                                                            addressList![i],
                                                                      ),
                                                                    ),
                                                                  );
                                                                  getAddress();
                                                                },
                                                                child: Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      left:
                                                                          8.0),
                                                                  child: primaryOutlineButton(
                                                                      context,
                                                                      "EDIT"),
                                                                ),
                                                              ),
                                                              InkWell(
                                                                  onTap: () {
                                                                    deleteAddress(
                                                                        addressList![i]
                                                                            [
                                                                            '_id']);
                                                                  },
                                                                  child:
                                                                      Padding(
                                                                    padding: const EdgeInsets
                                                                            .symmetric(
                                                                        horizontal:
                                                                            20.0),
                                                                    child: primaryOutlineButton(
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
                                                      child:
                                                          Divider(thickness: 1),
                                                    ),
                                                  ],
                                                );
                                              },
                                            ),
                                            SizedBox(height: 20),
                                            InkWell(
                                                onTap: () async {
                                                  _permissionGranted =
                                                      await _location
                                                          .hasPermission();
                                                  if (_permissionGranted ==
                                                      PermissionStatus.denied) {
                                                    _permissionGranted =
                                                        await _location
                                                            .requestPermission();
                                                    if (_permissionGranted !=
                                                        PermissionStatus
                                                            .granted) {
                                                      Map locationLatLong = {
                                                        "latitude":
                                                            locationInfo![
                                                                    'location']
                                                                ['latitude'],
                                                        "longitude":
                                                            locationInfo![
                                                                    'location']
                                                                ['longitude']
                                                      };

                                                      addAddressPageMethod(
                                                          locationLatLong);
                                                      return;
                                                    }
                                                  }
                                                  currentLocation =
                                                      await _location
                                                          .getLocation();
                                                  if (currentLocation != null) {
                                                    Map locationLatLong = {
                                                      "latitude":
                                                          currentLocation!
                                                              .latitude,
                                                      "longitude":
                                                          currentLocation!
                                                              .longitude
                                                    };
                                                    addAddressPageMethod(
                                                        locationLatLong);
                                                  }
                                                },
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 80.0),
                                                  child: dottedBorderButton(
                                                      context,
                                                      "ADD_NEW_ADDRESS"),
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
                            deliverySlotList!.length > 0
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
                                                itemCount: deliverySlotList!
                                                        .isEmpty
                                                    ? 0
                                                    : deliverySlotList!.length,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  return Container(
                                                    color: Theme.of(context)
                                                                .brightness ==
                                                            Brightness.dark
                                                        ? greyc2
                                                        : Colors.grey[200],
                                                    width: 110,
                                                    child: Row(
                                                      children: <Widget>[
                                                        Container(
                                                          width: 90,
                                                          height: 40,
                                                          margin:
                                                              EdgeInsets.only(
                                                                  left: 10,
                                                                  right: 10),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: dateSelectedValue !=
                                                                        null &&
                                                                    dateSelectedValue ==
                                                                        index
                                                                ? primarybg
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
                                                              child: Center(
                                                                  child: normalTextWithOutRow(
                                                                      context,
                                                                      deliverySlotList![index]
                                                                              [
                                                                              'date']
                                                                          .split(
                                                                              ' ')
                                                                          .join(
                                                                              '\n'),
                                                                      true))),
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
                                        color: cartCardBg(context),
                                        child: ListView.builder(
                                          physics: ScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: deliverySlotList![
                                                              dateSelectedValue!]
                                                          ['timings']
                                                      .length ==
                                                  null
                                              ? 0
                                              : deliverySlotList![
                                                          dateSelectedValue!]
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
                                                      activeColor: primarybg,
                                                      onChanged:
                                                          (dynamic value) {
                                                        selectedSlotSelected(
                                                            value);
                                                      },
                                                      title: normalTextWithOutRow(
                                                          context,
                                                          deliverySlotList![
                                                                      dateSelectedValue!]
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
                      Padding(
                        padding: EdgeInsets.only(left: 15, right: 15),
                        child: buildBoldText(context, "INSTRUCTION"),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 15, right: 15),
                        child: buildInstructionTextField(),
                      ),
                      InkWell(
                        onTap: placeOrder,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: buttonprimary(context, "PROCEED", false),
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }

  void showSnackbar(message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(milliseconds: 3000),
      ),
    );
  }
}
