import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_map_picker/flutter_map_picker.dart';
import 'package:getflutter/getwidget.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:readymadeGroceryApp/screens/drawer/add-address.dart';
import 'package:readymadeGroceryApp/screens/drawer/edit-address.dart';
import 'package:readymadeGroceryApp/service/address-service.dart';
import 'package:readymadeGroceryApp/service/constants.dart';
import 'package:readymadeGroceryApp/service/localizations.dart';
import 'package:readymadeGroceryApp/screens/thank-you/thankyou.dart';
import 'package:readymadeGroceryApp/style/style.dart';
import 'package:readymadeGroceryApp/widgets/appBar.dart';
import 'package:readymadeGroceryApp/widgets/button.dart';
import 'package:readymadeGroceryApp/widgets/normalText.dart';
import '../../service/sentry-service.dart';

SentryError sentryError = new SentryError();

class SubscriptionPage extends StatefulWidget {
  SubscriptionPage(
      {Key key,
      this.locale,
      this.localizedValues,
      this.productData,
      this.currency})
      : super(key: key);

  final Map localizedValues, productData;
  final String locale, currency;

  @override
  _SubscriptionPageState createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int selectedIndex = 0, quantity = 1, selectedAddressValue;
  DateTime selectedDate = DateTime.now();
  List pickUpScheduleList = [
        'DAILY',
        'ALTERNATE',
        'EVERY_3_DAY',
        'WEEKLY',
        'MONTHLY'
      ],
      addressList;
  var selectedAddress, locationInfo;
  bool addressLoading = false;
  Location _location = new Location();
  PermissionStatus _permissionGranted;

  @override
  void initState() {
    getAddress();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.white,
        appBar: appBarPrimarynoradius(context, "SUBSCRIBE"),
        body: ListView(
          children: <Widget>[
            SizedBox(height: 20),
            buildImageView(),
            SizedBox(height: 20),
            buildPickUpSchedule(),
            buildDeliveryView()
          ],
        ),
        bottomNavigationBar: buttonprimary(context, "SUBSCRIBE", false),
      );

  buildImageView() => Container(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        decoration: BoxDecoration(color: Color(0xFFF7F7F7)),
        child: Row(
          children: [
            Flexible(
              flex: 4,
              child: (widget.productData['productImages'] != null &&
                      widget.productData['productImages'].length > 0)
                  ? CachedNetworkImage(
                      imageUrl: widget.productData['productImages'][0]
                                  ['filePath'] !=
                              null
                          ? Constants.imageUrlPath +
                              "/tr:dpr-auto,tr:w-500" +
                              widget.productData['productImages'][0]['filePath']
                          : widget.productData['productImages'][0]['imageUrl'],
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
                      imageUrl: widget.productData['filePath'] != null
                          ? Constants.imageUrlPath +
                              "/tr:dpr-auto,tr:w-500" +
                              widget.productData['filePath']
                          : widget.productData['imageUrl'],
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
                  normallText(
                    context,
                    '${widget.productData['title'][0].toUpperCase()}${widget.productData['title'].substring(1)}',
                  ),
                  SizedBox(height: 10),
                  regularTextblack87(context,
                      '${widget.productData['variant'][0]['unit'] ?? ''}'),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      regularTextatStart(context, "SUBSCRIPTION_PRICE"),
                      priceMrpText(
                          " ${widget.currency} ${widget.productData['variant'][0]['subScriptionAmount']}",
                          "",
                          context)
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
                            quantity++;
                          });
                        },
                        child: Icon(Icons.add),
                      ),
                    ),
                    Text(quantity.toString()),
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
                            if (quantity > 1) quantity--;
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
        decoration: BoxDecoration(color: Color(0xFFF7F7F7)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            regularTextblackbold(context, "PICK_SCHEDULE"),
            Container(
              height: 90,
              margin: EdgeInsets.symmetric(vertical: 10),
              child: GridView.builder(
                itemCount: pickUpScheduleList.length,
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
                      selectedIndex = index;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: (selectedIndex == index)
                            ? primary(context).withOpacity(0.3)
                            : Colors.white,
                        border: (selectedIndex == index)
                            ? Border.all(color: primary(context))
                            : Border.all(color: Colors.grey[300]),
                        borderRadius: BorderRadius.circular(17)),
                    child: Center(
                      child: Text(
                        MyLocalizations.of(context)
                            .getLocalizations(pickUpScheduleList[index]),
                        style: textbarlowRegularBlackb(context),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Divider(),
            SizedBox(height: 15),
            regularTextatStart(context, "SUBSCRIPTION_STARTS_ON"),
            SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.only(left: 2.0, right: 0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey[300]),
                    borderRadius: BorderRadius.circular(5.0)),
                child: FlatButton(
                    onPressed: () {
                      DatePicker.showDatePicker(context,
                          showTitleActions: true,
                          minTime: DateTime.now(), onConfirm: (date) {
                        if (mounted) {
                          setState(() {
                            selectedDate = date;
                          });
                        }
                      }, currentTime: DateTime.now(), locale: LocaleType.en);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(DateFormat('dd/MM/yyyy').format(selectedDate)),
                        Icon(Icons.calendar_today, color: Colors.black),
                      ],
                    )),
              ),
            ),
            SizedBox(height: 15),
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
            expandedTitlebackgroundColor:
                Theme.of(context).brightness == Brightness.dark
                    ? greyb2
                    : Color(0xFFF0F0F0),
            collapsedTitlebackgroundColor:
                Theme.of(context).brightness == Brightness.dark
                    ? greyc2
                    : Color(0xFFF0F0F0),
            titleborder: Border.all(color: Color(0xffD6D6D6)),
            contentbackgroundColor:
                Theme.of(context).brightness == Brightness.dark
                    ? greyc2
                    : Colors.white,
            contentPadding: EdgeInsets.only(top: 5, bottom: 5),
            titleChild: Text(
              selectedAddress == null
                  ? MyLocalizations.of(context).getLocalizations("ADDRESS_MSG")
                  : '${selectedAddress['flatNo']}, ${selectedAddress['apartmentName']},${selectedAddress['address']}',
              overflow: TextOverflow.clip,
              maxLines: 1,
              style: textBarlowRegularBlack(context),
            ),
            contentChild: Column(
              children: <Widget>[
                ListView.builder(
                  physics: ScrollPhysics(),
                  shrinkWrap: true,
                  itemCount:
                      addressList.length == null ? 0 : addressList.length,
                  itemBuilder: (BuildContext context, int i) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        RadioListTile(
                          groupValue: selectedAddressValue,
                          activeColor: primary(context),
                          value: i,
                          title: buildAddress(
                              '${addressList[i]['flatNo']}, ${addressList[i]['apartmentName']},${addressList[i]['address']},',
                              "${addressList[i]['landmark']} ,'${addressList[i]['postalCode']}, ${addressList[i]['mobileNumber'].toString()}",
                              context),
                          onChanged: (value) {
                            if (mounted) {
                              setState(() {
                                selectedAddressValue = value;
                                selectedAddress = addressList[value];
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
                                            isCheckout: true,
                                            updateAddressID: addressList[i],
                                          ),
                                        ),
                                      );
                                      getAddress();
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child:
                                          primaryOutlineButton(context, "EDIT"),
                                    ),
                                  ),
                                  InkWell(
                                      onTap: () {
                                        deleteAddress(addressList[i]['_id']);
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
                    );
                  },
                ),
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
                      if (currentLocation != null) {
                        Map locationLatLong = {
                          "latitude": currentLocation.latitude,
                          "longitude": currentLocation.longitude
                        };
                        addAddressPageMethod(locationLatLong);
                      }
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
    PlacePickerResult pickerResult = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PlacePickerScreen(
                  googlePlacesApiKey: Constants.googleMapApiKey,
                  initialPosition: LatLng(locationlatlong['latitude'],
                      locationlatlong['longitude']),
                  mainColor: primary(context),
                  mapStrings: MapPickerStrings.english(
                      selectAddress: MyLocalizations.of(context)
                          .getLocalizations("SELECT_ADDRESS"),
                      cancel: MyLocalizations.of(context)
                          .getLocalizations("CANCEL"),
                      address: MyLocalizations.of(context)
                          .getLocalizations("ADDRESS")),
                  placeAutoCompleteLanguage: 'en',
                )));
    if (pickerResult != null) {
      setState(() {
        var result = Navigator.push(
          context,
          new MaterialPageRoute(
            builder: (BuildContext context) => AddAddress(
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
    final snackBar = SnackBar(
      content: Text(message),
      duration: Duration(milliseconds: 3000),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
}
