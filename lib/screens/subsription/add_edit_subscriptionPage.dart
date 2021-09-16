import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:readymadeGroceryApp/screens/drawer/add-address.dart';
import 'package:readymadeGroceryApp/screens/drawer/addressPick.dart';
import 'package:readymadeGroceryApp/screens/drawer/edit-address.dart';
import 'package:readymadeGroceryApp/screens/thank-you/thankyou.dart';
import 'package:readymadeGroceryApp/service/address-service.dart';
import 'package:readymadeGroceryApp/service/cart-service.dart';
import 'package:readymadeGroceryApp/service/constants.dart';
import 'package:readymadeGroceryApp/service/localizations.dart';
import 'package:readymadeGroceryApp/style/style.dart';
import 'package:readymadeGroceryApp/widgets/appBar.dart';
import 'package:readymadeGroceryApp/widgets/button.dart';
import 'package:readymadeGroceryApp/widgets/loader.dart';
import 'package:readymadeGroceryApp/widgets/normalText.dart';
import '../../service/sentry-service.dart';

SentryError sentryError = new SentryError();

class AddEditSubscriptionPage extends StatefulWidget {
  AddEditSubscriptionPage(
      {Key? key,
      this.locale,
      this.localizedValues,
      this.subProductData,
      this.productData,
      this.currency,
      this.isEdit = false})
      : super(key: key);

  final Map? localizedValues, subProductData, productData;
  final String? locale, currency;
  final bool isEdit;

  @override
  _AddEditSubscriptionPageState createState() =>
      _AddEditSubscriptionPageState();
}

class _AddEditSubscriptionPageState extends State<AddEditSubscriptionPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int? selectedPickSecheduleIndex = 0, selectedAddressValue, quantity = 1;
  DateTime selectedDate = DateTime.now();
  List? pickUpScheduleList = [
        'DAILY',
        'ALTERNATE',
        'EVERY_3_DAY',
        'WEEKLY',
        'MONTHLY'
      ],
      addressList;
  var selectedAddress, locationInfo;
  bool addressLoading = false, isSubscriptionLoading = false;
  Location _location = new Location();
  PermissionStatus? _permissionGranted;
  @override
  void initState() {
    getAddress();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        key: _scaffoldKey,
        backgroundColor: bg(context),
        appBar: appBarPrimarynoradius(
                context, widget.isEdit ? "UPDATE_SUBSCRIPTION" : "SUBSCRIBE")
            as PreferredSizeWidget?,
        body: addressLoading
            ? SquareLoader()
            : ListView(
                children: <Widget>[
                  SizedBox(height: 20),
                  buildImageView(),
                  SizedBox(height: 20),
                  buildPickUpSchedule(),
                  buildDeliveryView()
                ],
              ),
        bottomNavigationBar: addressLoading
            ? Container(height: 1)
            : InkWell(
                onTap: widget.isEdit ? updateSubscription : doSubscription,
                child: Padding(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: buttonprimary(
                      context,
                      widget.isEdit ? "UPDATE_CHANGES" : "SUBSCRIBE",
                      isSubscriptionLoading),
                ),
              ),
      );

  buildImageView() => Container(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        decoration: BoxDecoration(color: cartCardBg(context)),
        child: Row(
          children: [
            Flexible(
              flex: 4,
              child: (widget.productData!['productImages'] != null &&
                      widget.productData!['productImages'].length > 0)
                  ? CachedNetworkImage(
                      imageUrl: widget.productData!['productImages'][0]
                                  ['filePath'] !=
                              null
                          ? Constants.imageUrlPath! +
                              "/tr:dpr-auto,tr:w-500" +
                              widget.productData!['productImages'][0]
                                  ['filePath']
                          : widget.productData!['productImages'][0]['imageUrl'],
                      imageBuilder: (context, imageProvider) => Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        height: 95,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: imageProvider, fit: BoxFit.cover),
                        ),
                      ),
                      placeholder: (context, url) => Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          height: 95,
                          child: noDataImage()),
                      errorWidget: (context, url, error) => Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          height: 95,
                          child: noDataImage()),
                    )
                  : CachedNetworkImage(
                      imageUrl: widget.productData!['filePath'] != null
                          ? Constants.imageUrlPath! +
                              "/tr:dpr-auto,tr:w-500" +
                              widget.productData!['filePath']
                          : widget.productData!['imageUrl'],
                      imageBuilder: (context, imageProvider) => Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        height: 95,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: imageProvider, fit: BoxFit.cover),
                        ),
                      ),
                      placeholder: (context, url) => Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          height: 95,
                          child: noDataImage()),
                      errorWidget: (context, url, error) => Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          height: 95,
                          child: noDataImage()),
                    ),
            ),
            SizedBox(width: 5),
            Flexible(
              flex: 6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${widget.subProductData!['products'][0]['productName'][0].toUpperCase()}${widget.subProductData!['products'][0]['productName'].substring(1)}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 16.0,
                        fontFamily: 'BarlowRegular',
                        color: blackText(context),
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 10),
                  textLightSmall(
                      '${widget.subProductData!['products'][0]['unit'] ?? ''}',
                      context),
                  SizedBox(height: 10),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      regularTextatStart(context, "SUBSCRIPTION_PRICE"),
                      priceMrpText(
                          "${widget.currency}${widget.subProductData!['products'][0]['subscriptionTotal']}  (${quantity.toString()}*${widget.currency}${widget.subProductData!['products'][0]['subScriptionAmount']})",
                          "",
                          context),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: 5),
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Container(
                height: 110,
                width: 43,
                decoration: BoxDecoration(
                  color: Color(0xFFF0F0F0),
                  borderRadius: BorderRadius.all(
                    Radius.circular(22),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: primary(context),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            quantity = quantity! + 1;

                            widget.subProductData!['products'][0]
                                    ["subscriptionTotal"] =
                                widget.subProductData!['products'][0]
                                        ['subScriptionAmount'] *
                                    quantity;
                          });
                        },
                        child: Icon(Icons.add),
                      ),
                    ),
                    titleTwoLine(quantity.toString(), context),
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            if (quantity! > 1) {
                              quantity = quantity! - 1;
                              widget.subProductData!['products'][0]
                                      ["subscriptionTotal"] =
                                  widget.subProductData!['products'][0]
                                          ['subScriptionAmount'] *
                                      quantity;
                            }
                          });
                        },
                        child: Icon(Icons.remove, color: primary(context)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );

  buildPickUpSchedule() => Container(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        decoration: BoxDecoration(color: cartCardBg(context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            regularTextblackbold(context, "PICK_SCHEDULE"),
            Container(
              height: 90,
              margin: EdgeInsets.symmetric(vertical: 10),
              child: GridView.builder(
                itemCount: pickUpScheduleList!.length,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: MediaQuery.of(context).size.width / 120,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10),
                itemBuilder: (BuildContext context, int index) => InkWell(
                  onTap: () {
                    setState(() {
                      selectedPickSecheduleIndex = index;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        border: (selectedPickSecheduleIndex == index)
                            ? Border.all(color: primary(context))
                            : Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(17)),
                    child: Center(
                      child: Text(
                        MyLocalizations.of(context)!
                            .getLocalizations(pickUpScheduleList![index]),
                        style: textbarlowRegularBlackb(context),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            widget.isEdit
                ? Container()
                : Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Divider(),
                      SizedBox(height: 15),
                      regularTextblackbold(context, "SUBSCRIPTION_STARTS_ON"),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.only(left: 2.0, right: 0),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: cartCardBg(context),
                              border: Border.all(color: Colors.grey[300]!),
                              borderRadius: BorderRadius.circular(5.0)),
                          child: GFButton(
                              color: Colors.transparent,
                              onPressed: () {
                                DatePicker.showDatePicker(context,
                                    showTitleActions: true,
                                    minTime: DateTime.now(), onConfirm: (date) {
                                  if (mounted) {
                                    setState(() {
                                      selectedDate = date;
                                    });
                                  }
                                },
                                    currentTime: DateTime.now(),
                                    locale: LocaleType.en);
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(DateFormat('dd/MM/yyyy')
                                      .format(selectedDate)),
                                  Icon(Icons.calendar_today,
                                      color: dark(context)),
                                ],
                              )),
                        ),
                      ),
                      SizedBox(height: 15),
                    ],
                  )
          ],
        ),
      );

  buildDeliveryView() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: regularTextblackbold(context, "DELIVERY_ADDRESS"),
          ),
          GFAccordion(
            expandedTitleBackgroundColor:
                Theme.of(context).brightness == Brightness.dark
                    ? greyb2
                    : Color(0xFFF0F0F0),
            collapsedTitleBackgroundColor:
                Theme.of(context).brightness == Brightness.dark
                    ? greyc2
                    : Color(0xFFF0F0F0),
            titleBorder: Border.all(color: Color(0xffD6D6D6)),
            contentBackgroundColor:
                Theme.of(context).brightness == Brightness.dark
                    ? greyc2
                    : Colors.white,
            contentPadding: EdgeInsets.only(top: 5, bottom: 5),
            titleChild: Text(
              selectedAddress == null
                  ? MyLocalizations.of(context)!.getLocalizations("ADDRESS_MSG")
                  : '${selectedAddress['flatNo']}, ${selectedAddress['apartmentName']},${selectedAddress['address']}',
              overflow: TextOverflow.clip,
              maxLines: 1,
              style: textBarlowRegularBlack(context),
            ),
            contentChild: Column(
              children: <Widget>[
                ((addressList?.length ?? 0) > 0)
                    ? ListView.builder(
                        physics: ScrollPhysics(),
                        shrinkWrap: true,
                        itemCount:
                            addressList!.isEmpty ? 0 : addressList!.length,
                        itemBuilder: (BuildContext context, int i) => Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            RadioListTile(
                              groupValue: selectedAddressValue,
                              activeColor: primary(context),
                              value: i,
                              title: buildAddress(
                                  '${addressList![i]['flatNo']}, ${addressList![i]['apartmentName']},${addressList![i]['address']},',
                                  "${addressList![i]['landmark']} ,'${addressList![i]['postalCode']}, ${addressList![i]['mobileNumber'].toString()}",
                                  context),
                              onChanged: (dynamic value) {
                                if (mounted) {
                                  setState(() {
                                    selectedAddressValue = value;
                                    selectedAddress = addressList![value];
                                  });
                                }
                              },
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(left: 0.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      InkWell(
                                        onTap: () async {
                                          await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => EditAddress(
                                                locale: widget.locale,
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
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: primaryOutlineButton(
                                              context, "EDIT"),
                                        ),
                                      ),
                                      InkWell(
                                          onTap: () {
                                            deleteAddress(
                                                addressList![i]['_id']);
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20.0),
                                            child: primaryOutlineButton(
                                                context, "DELETE"),
                                          )),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 20, right: 20),
                              child: Divider(thickness: 1),
                            ),
                          ],
                        ),
                      )
                    : Container(),
                SizedBox(height: 20),
                InkWell(
                    onTap: () async {
                      _permissionGranted = await _location.hasPermission();
                      if (_permissionGranted == PermissionStatus.denied) {
                        _permissionGranted =
                            await _location.requestPermission();
                        if (_permissionGranted != PermissionStatus.granted) {
                          Map locationLatLong = {
                            "latitude": locationInfo['location']['latitude'],
                            "longitude": locationInfo['location']['longitude']
                          };
                          addAddressPageMethod(locationLatLong);
                          return;
                        }
                      }
                      final currentLocation = await _location.getLocation();

                      Map locationLatLong = {
                        "latitude": currentLocation.latitude,
                        "longitude": currentLocation.longitude
                      };
                      addAddressPageMethod(locationLatLong);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 80.0),
                      child: dottedBorderButton(context, "ADD_NEW_ADDRESS"),
                    )),
                SizedBox(height: 20),
              ],
            ),
          )
        ],
      );

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

  getAddress() async {
    if (mounted) {
      setState(() {
        addressLoading = true;
      });
    }
    await AddressService.getAddress().then((onValue) {
      if (mounted) {
        setState(() {
          addressLoading = false;
        });
      }
      if (mounted) {
        setState(() {
          addressList = onValue['response_data'];
          if (widget.isEdit) {
            for (int i = 0; i < pickUpScheduleList!.length; i++) {
              if (widget.subProductData!['schedule'] ==
                  pickUpScheduleList![i]) {
                selectedPickSecheduleIndex = i;
              }
            }
          }
          if (widget.isEdit) {
            quantity = widget.subProductData!['products'][0]["quantity"];
          }
          if ((addressList?.length ?? 0) > 0) {
            if (widget.isEdit) {
              for (int j = 0; j < addressList!.length; j++) {
                if (widget.subProductData!['address']['_id'] ==
                    addressList![j]['_id']) {
                  selectedAddress = addressList![j];
                  selectedAddressValue = j;
                }
              }
            } else {
              selectedAddress = addressList!.first;
              selectedAddressValue = 0;
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

  void showSnackbar(message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(milliseconds: 3000),
      ),
    );
  }

  void updateSubscription() {
    if (selectedAddress != null) {
      Map updateSubscriptionBody = {
        "address": selectedAddress['_id'],
        "quantity": quantity,
        "schedule": pickUpScheduleList![selectedPickSecheduleIndex!],
      };
      setState(() {
        isSubscriptionLoading = true;
      });
      widget.subProductData!['products'][0]["quantity"] = quantity;
      widget.subProductData!['products'][0]["subscriptionTotal"] =
          widget.subProductData!['products'][0]["subScriptionAmount"] *
              quantity;
      widget.subProductData!['grandTotal'] =
          widget.subProductData!['products'][0]["subscriptionTotal"];
      widget.subProductData!["address"] = selectedAddress;
      widget.subProductData!["schedule"] =
          pickUpScheduleList![selectedPickSecheduleIndex!];

      CartService.subscribeProductUpdate(
              updateSubscriptionBody, widget.subProductData!['_id'])
          .then((value) {
        setState(() {
          isSubscriptionLoading = false;
          showSnackbar(value['response_data']);
          Future.delayed(Duration(milliseconds: 1500), () {
            Navigator.of(context).pop(widget.subProductData);
          });
        });
      }).catchError((onError) {
        setState(() {
          isSubscriptionLoading = false;
        });
      });
    } else {
      showSnackbar(
          MyLocalizations.of(context)!.getLocalizations("SELECT_ADDESS_MSG"));
    }
  }

  void doSubscription() {
    if (selectedAddress != null) {
      widget.subProductData!['products'][0]["quantity"] = quantity;
      widget.subProductData!['grandTotal'] =
          widget.subProductData!['products'][0]["subscriptionTotal"];
      widget.subProductData!["address"] = selectedAddress['_id'];
      widget.subProductData!["schedule"] =
          pickUpScheduleList![selectedPickSecheduleIndex!];
      widget.subProductData!["subscriptionStartDate"] =
          selectedDate.millisecondsSinceEpoch;
      widget.subProductData!["orderFrom"] = Constants.orderFrom;
      setState(() {
        isSubscriptionLoading = true;
      });
      CartService.subscribeProductAdd(widget.subProductData).then((value) {
        setState(() {
          isSubscriptionLoading = false;
        });
        Navigator.of(context).pop();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => Thankyou(
              locale: widget.locale,
              localizedValues: widget.localizedValues,
              isSubscription: true,
            ),
          ),
        );
      }).catchError((onError) {
        setState(() {
          isSubscriptionLoading = false;
        });
      });
    } else {
      showSnackbar(
          MyLocalizations.of(context)!.getLocalizations("SELECT_ADDESS_MSG"));
    }
  }
}
