import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:location/location.dart';
import 'package:readymadeGroceryApp/screens/drawer/add-address.dart';
import 'package:readymadeGroceryApp/screens/drawer/edit-address.dart';
import 'package:readymadeGroceryApp/service/auth-service.dart';
import 'package:readymadeGroceryApp/service/constants.dart';
import 'package:readymadeGroceryApp/service/localizations.dart';
import 'package:readymadeGroceryApp/service/sentry-service.dart';
import 'package:readymadeGroceryApp/style/style.dart';
import 'package:readymadeGroceryApp/service/address-service.dart';
import 'package:readymadeGroceryApp/widgets/appBar.dart';
import 'package:readymadeGroceryApp/widgets/button.dart';
import 'package:readymadeGroceryApp/widgets/loader.dart';
import 'package:readymadeGroceryApp/widgets/normalText.dart';

SentryError sentryError = new SentryError();

class Address extends StatefulWidget {
  final Map? localizedValues;
  final String? locale;
  Address({Key? key, this.locale, this.localizedValues});

  @override
  _AddressState createState() => _AddressState();
}

class _AddressState extends State<Address> {
  bool addressLoading = false, isLocationLoading = false;
  List? addressList = List.empty(growable: true);
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  PickResult? pickedLocation;
  LocationData? currentLocation;
  Location _location = new Location();
  Map? locationInfo;
  PermissionStatus? _permissionGranted;
  @override
  void initState() {
    getAddress();
    getAdminLocationInfo();
    super.initState();
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
          addressList = onValue['response_data'];
          addressLoading = false;
        });
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          addressList = [];
          addressLoading = false;
        });
      }
      sentryError.reportError(error, null);
    });
  }

  getAdminLocationInfo() async {
    if (mounted) {
      setState(() {
        isLocationLoading = true;
      });
    }
    await LoginService.getLocationformation().then((onValue) {
      if (mounted) {
        setState(() {
          locationInfo = onValue['response_data'];
          isLocationLoading = false;
        });
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          locationInfo = null;
          isLocationLoading = false;
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
      if (mounted) {
        setState(() {
          addressLoading = false;
        });
      }
      sentryError.reportError(error, null);
    });
  }

  void showSnackbar(message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: Duration(milliseconds: 3000),
    );
    _scaffoldKey.currentState!.showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: bg(context),
        key: _scaffoldKey,
        appBar: appBarPrimary(context, "ADDRESS") as PreferredSizeWidget?,
        body: addressLoading || isLocationLoading
            ? SquareLoader()
            : addressList!.length == 0
                ? Center(child: noDataImage())
                : ListView(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 10.0, bottom: 10.0, left: 20.0, right: 20.0),
                        child: buildBoldText(context, "SAVED_ADDRESS"),
                      ),
                      ListView.builder(
                        physics: ScrollPhysics(),
                        shrinkWrap: true,
                        itemCount:
                            addressList!.length == null ? 0 : addressList!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              padding:
                                  const EdgeInsets.only(top: 5.0, bottom: 5.0),
                              decoration: BoxDecoration(
                                  color: Colors.white70,
                                  borderRadius: BorderRadius.circular(5.0)),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    margin:
                                        EdgeInsets.only(bottom: 100, left: 7),
                                    child: Text(
                                      (index + 1).toString() + ".",
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.9,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 10.0, left: 10.0),
                                          child: buildAddress(
                                              '${addressList![index]['flatNo']}, ${addressList![index]['apartmentName']},${addressList![index]['address']}, ${addressList![index]['landmark']} ,${addressList![index]['postalCode']}, ${addressList![index]['mobileNumber'].toString()}',
                                              null,
                                              context),
                                        ),
                                      ),
                                      SizedBox(height: 20),
                                      buildEditDelete(addressList![index])
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
        bottomNavigationBar: InkWell(
            onTap: () async {
              _permissionGranted = await _location.hasPermission();
              if (_permissionGranted == PermissionStatus.denied) {
                _permissionGranted = await _location.requestPermission();
                if (_permissionGranted != PermissionStatus.granted) {
                  Map locationLatLong = {
                    "latitude": locationInfo!['location']['latitude'],
                    "longitude": locationInfo!['location']['longitude']
                  };

                  addAddressPageMethod(locationLatLong);
                  return;
                }
              }
              currentLocation = await _location.getLocation();

              if (currentLocation != null) {
                Map locationLatLong = {
                  "latitude": currentLocation!.latitude,
                  "longitude": currentLocation!.longitude
                };
                addAddressPageMethod(locationLatLong);
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: editProfileButton(context, "ADD_NEW_ADDRESS", false),
            )));
  }

  addAddressPageMethod(locationlatlong) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                PlacePicker(
                  apiKey: Constants.googleMapApiKey,
                  initialPosition: LatLng(locationlatlong['latitude'],
                      locationlatlong['longitude']),
                  useCurrentLocation: true,
                  selectInitialPosition: true,
                  //usePlaceDetailSearch: true,
                  onPlacePicked: (result) {
                    pickedLocation = result;
                    Navigator.of(context).pop();
                    setState(() {});
                  },
                ),
                // PlacePickerScreen(
                //   googlePlacesApiKey: Constants.googleMapApiKey,
                //   initialPosition: LatLng(locationlatlong['latitude'],
                //       locationlatlong['longitude']),
                //   mainColor: primary(context),
                //   mapStrings: MapPickerStrings.english(
                //       selectAddress: MyLocalizations.of(context)
                //           .getLocalizations("SELECT_ADDRESS"),
                //       cancel: MyLocalizations.of(context)
                //           .getLocalizations("CANCEL"),
                //       address: MyLocalizations.of(context)
                //           .getLocalizations("ADDRESS")),
                //   placeAutoCompleteLanguage: 'en',
                // )
        ));
    if (pickedLocation != null) {
      setState(() {
        var result = Navigator.push(
          context,
          new MaterialPageRoute(
            builder: (BuildContext context) => new AddAddress(
              isProfile: true,
              pickedLocation: pickedLocation,
              locale: widget.locale,
              localizedValues: widget.localizedValues,
            ),
          ),
        );
        result.then((res) {
          getAdminLocationInfo();
          getAddress();
        });
      });
    }
  }

  Widget buildEditDelete(addressList) {
    return Padding(
      padding: const EdgeInsets.only(left: 37.0, right: 37.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          InkWell(
              onTap: () {
                var result = Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditAddress(
                      updateAddressID: addressList,
                      isProfile: true,
                      locale: widget.locale,
                      localizedValues: widget.localizedValues,
                    ),
                  ),
                );
                result.then((update) {
                  getAddress();
                });
              },
              child: primaryOutlineButton(context, "EDIT")),
          InkWell(
              onTap: () {
                deleteAddress(addressList['_id']);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: primaryOutlineButton(context, "DELETE"),
              )),
        ],
      ),
    );
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
}
