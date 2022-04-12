import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:readymadeGroceryApp/screens/drawer/add-address.dart';
import 'package:readymadeGroceryApp/screens/drawer/addressPick.dart';
import 'package:readymadeGroceryApp/screens/drawer/edit-address.dart';
import 'package:readymadeGroceryApp/service/auth-service.dart';
import 'package:readymadeGroceryApp/service/localizations.dart';
import 'package:readymadeGroceryApp/service/locationService.dart';
import 'package:readymadeGroceryApp/service/error-service.dart';
import 'package:readymadeGroceryApp/style/style.dart';
import 'package:readymadeGroceryApp/service/address-service.dart';
import 'package:readymadeGroceryApp/widgets/appBar.dart';
import 'package:readymadeGroceryApp/widgets/button.dart';
import 'package:readymadeGroceryApp/widgets/loader.dart';
import 'package:readymadeGroceryApp/widgets/normalText.dart';

ReportError reportError = new ReportError();

class Address extends StatefulWidget {
  final Map? localizedValues;
  final String? locale;
  Address({Key? key, this.locale, this.localizedValues});

  @override
  _AddressState createState() => _AddressState();
}

class _AddressState extends State<Address> {
  bool addressLoading = false, isLocationLoading = false;
  List? addressList = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Map? locationInfo;
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
      reportError.reportError(error, null);
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
      reportError.reportError(error, null);
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
      reportError.reportError(error, null);
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
                    Divider(),
                    ListView.separated(
                      separatorBuilder: (__, _) {
                        return Divider();
                      },
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: addressList!.isEmpty ? 0 : addressList!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          leading: Text(
                            (index + 1).toString() + ".",
                          ),
                          title: buildAddress(
                              '${addressList?[index]['flatNo']}, ${addressList?[index]['apartmentName']},${addressList?[index]['address']}, ${addressList?[index]['landmark']} ,${addressList?[index]['postalCode']}, ${addressList?[index]['mobileNumber'].toString()}',
                              null,
                              context),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: buildEditDelete(addressList?[index]),
                          ),
                        );
                      },
                    ),
                  ],
                ),
      bottomNavigationBar: addressLoading || isLocationLoading
          ? Container(height: 1)
          : InkWell(
              onTap: () async {
                bool? permission = await LocationUtils().locationPermission();

                if (permission) {
                  Position position = await LocationUtils().currentLocation();
                  Map locationLatLong = {
                    "latitude": position.latitude,
                    "longitude": position.longitude
                  };
                  addAddressPageMethod(locationLatLong);
                } else {
                  Map locationLatLong = {
                    "latitude": locationInfo!['location']['latitude'],
                    "longitude": locationInfo!['location']['longitude']
                  };
                  addAddressPageMethod(locationLatLong);
                }
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: editProfileButton(context, "ADD_NEW_ADDRESS", false),
              ),
            ),
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
          getAdminLocationInfo();
          getAddress();
        });
      }
    });
  }

  Widget buildEditDelete(addressList) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        InkWell(
            onTap: () {
              var result = Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditAddress(
                    updateAddressID: addressList,
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
