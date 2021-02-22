import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map_picker/flutter_map_picker.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:readymadeGroceryApp/service/constants.dart';
import 'package:readymadeGroceryApp/service/localizations.dart';
import 'package:readymadeGroceryApp/style/style.dart';
import 'package:readymadeGroceryApp/service/sentry-service.dart';
import 'package:readymadeGroceryApp/service/address-service.dart';
import 'package:location/location.dart';
import 'package:readymadeGroceryApp/widgets/appBar.dart';
import 'package:readymadeGroceryApp/widgets/button.dart';
import 'package:readymadeGroceryApp/widgets/normalText.dart';

SentryError sentryError = new SentryError();

class EditAddress extends StatefulWidget {
  const EditAddress(
      {Key key,
      this.currentLocation,
      this.isCheckout,
      this.isProfile,
      this.updateAddressID,
      this.locale,
      this.localizedValues})
      : super(key: key);
  final bool isCheckout, isProfile;
  final Map<String, dynamic> updateAddressID;
  final LocationData currentLocation;
  final Map localizedValues;
  final String locale;

  @override
  _EditAddressState createState() => _EditAddressState();
}

class _EditAddressState extends State<EditAddress> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController addressController = TextEditingController();
  var addressData;
  LocationData currentLocation;
  bool isUpdateAddressLoading = false;
  StreamSubscription<LocationData> locationSubscription;
  PlacePickerResult _pickedLocation;
  int selectedAddressType;
  String fullAddress;
  @override
  void initState() {
    if (widget.updateAddressID['addressType'] != null) {
      addressController.text = widget.updateAddressID['address'];

      for (int i = 0; i < addressType.length; i++) {
        if (addressType[i] == widget.updateAddressID['addressType']) {
          setSelectedRadio(i);
        }
      }
    }
    super.initState();
  }

  List<String> addressType = ['HOME', "WORK", "OTHERS"];
  setSelectedRadio(int val) async {
    if (mounted) {
      setState(() {
        selectedAddressType = val;
      });
    }
  }

  Map<String, dynamic> address = {
    "location": {},
    "address": null,
    "flatNo": null,
    "apartmentName": null,
    "landmark": null,
    "postalCode": null,
    "mobileNumber": null,
    "addressType": null
  };
  updateAddress() async {
    if (_formKey.currentState.validate()) {
      if (mounted) {
        setState(() {
          isUpdateAddressLoading = true;
        });
      }
      _formKey.currentState.save();
      address['address'] = addressController.text;

      if (_pickedLocation == null) {
        address['location'] = widget.updateAddressID['location'];
      } else {
        var location = {
          "latitude": _pickedLocation.latLng.latitude,
          "longitude": _pickedLocation.latLng.longitude
        };
        address['location'] = location;
      }
      address['addressType'] = addressType[selectedAddressType];
      AddressService.updateAddress(address, widget.updateAddressID['_id'])
          .then((onValue) {
        if (mounted) {
          setState(() {
            showSnackbar(onValue['response_data']);
            Future.delayed(Duration(milliseconds: 1500), () {
              Navigator.pop(context);
              addressController.clear();
            });
            isUpdateAddressLoading = false;
          });
        }
      }).catchError((onError) {
        if (mounted) {
          setState(() {
            isUpdateAddressLoading = false;
          });
        }
        sentryError.reportError(onError, null);
      });
    } else {
      if (mounted) {
        setState(() {
          isUpdateAddressLoading = false;
        });
      }
      return;
    }
  }

  void showSnackbar(message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: Duration(milliseconds: 3000),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  @override
  void dispose() {
    if (locationSubscription != null && locationSubscription is Stream)
      locationSubscription.cancel();
    addressController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg(context),
      key: _scaffoldKey,
      appBar: appBarPrimary(context, "EDIT_ADDRESS"),
      body: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                SizedBox(height: 25),
                Padding(
                    padding: const EdgeInsets.only(
                        left: 12.0, bottom: 5.0, right: 20.0),
                    child: addressPage(context, "LOCATION")),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  child: TextFormField(
                      maxLines: 3,
                      controller: addressController,
                      style: textBarlowRegularBlack(context),
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        counterText: "",
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 0,
                            color: Color(0xFFF44242),
                          ),
                        ),
                        errorStyle: TextStyle(
                          color: Color(0xFFF44242),
                        ),
                        fillColor: dark(context),
                        focusColor: dark(context),
                        contentPadding: EdgeInsets.only(
                          left: 15.0,
                          right: 15.0,
                          top: 10.0,
                          bottom: 10.0,
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.grey, width: 0.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: primary(context)),
                        ),
                      ),
                      validator: (String value) {
                        if (value.isEmpty) {
                          return MyLocalizations.of(context)
                              .getLocalizations("ENTER_LOCATION");
                        } else
                          return null;
                      },
                      onSaved: (String value) {
                        address['address'] = addressController.text;
                      }),
                ),
                InkWell(
                  onTap: () async {
                    var lat, long;
                    if (_pickedLocation == null) {
                      lat = widget.updateAddressID['location']['latitude'];
                      long = widget.updateAddressID['location']['longitude'];
                    } else {
                      lat = _pickedLocation.latLng.latitude;
                      long = _pickedLocation.latLng.longitude;
                    }

                    PlacePickerResult pickerResult = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PlacePickerScreen(
                                  googlePlacesApiKey: Constants.googleMapApiKey,
                                  initialPosition: LatLng(lat, long),
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
                    setState(() {
                      _pickedLocation = pickerResult;
                      addressController.text = pickerResult.address.toString();
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: buttonprimary(context, "CHANGE", false),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0, bottom: 5.0, right: 20.0),
                    child: addressPage(context, "HOUSE_FLAT_BLOCK_NUMBER")),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  child: TextFormField(
                    initialValue: widget.updateAddressID['flatNo'],
                    maxLength: 14,
                    style: labelStyle(context),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        fillColor: dark(context),
                        focusColor: dark(context),
                        contentPadding: EdgeInsets.only(
                          left: 15.0,
                          right: 15.0,
                          top: 10.0,
                          bottom: 10.0,
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.grey, width: 0.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: primary(context)),
                        )),
                    validator: (String value) {
                      if (value.isEmpty) {
                        return MyLocalizations.of(context)
                            .getLocalizations("ENTER_HOUSE_FLAT_BLOCK_NUMBER");
                      } else
                        return null;
                    },
                    onSaved: (String value) {
                      address['flatNo'] = value;
                    },
                  ),
                ),
                SizedBox(height: 25),
                Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0, bottom: 5.0, right: 20.0),
                    child: addressPage(context, "APARTMENT_NAME")),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  child: TextFormField(
                      initialValue: widget.updateAddressID['apartmentName'],
                      style: labelStyle(context),
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        fillColor: dark(context),
                        focusColor: dark(context),
                        contentPadding: EdgeInsets.only(
                          left: 15.0,
                          right: 15.0,
                          top: 10.0,
                          bottom: 10.0,
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.grey, width: 0.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: primary(context)),
                        ),
                      ),
                      validator: (String value) {
                        if (value.isEmpty) {
                          return MyLocalizations.of(context)
                              .getLocalizations("ENTER_APARTMENT_NAME");
                        } else
                          return null;
                      },
                      onSaved: (String value) {
                        address['apartmentName'] = value;
                      }),
                ),
                SizedBox(height: 25),
                Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0, bottom: 5.0, right: 20.0),
                    child: addressPage(context, "LANDMARK")),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  child: TextFormField(
                      initialValue: widget.updateAddressID['landmark'],
                      style: labelStyle(context),
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        fillColor: dark(context),
                        focusColor: dark(context),
                        contentPadding: EdgeInsets.only(
                          left: 15.0,
                          right: 15.0,
                          top: 10.0,
                          bottom: 10.0,
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.grey, width: 0.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: primary(context)),
                        ),
                      ),
                      validator: (String value) {
                        if (value.isEmpty) {
                          return MyLocalizations.of(context)
                              .getLocalizations("ENTER_LANDMARK");
                        } else
                          return null;
                      },
                      onSaved: (String value) {
                        address['landmark'] = value;
                      }),
                ),
                SizedBox(height: 25),
                Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0, bottom: 5.0, right: 20.0),
                    child: addressPage(context, "POSTAL_CODE")),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  child: TextFormField(
                      initialValue:
                          widget.updateAddressID['postalCode'].toString(),
                      style: labelStyle(context),
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        fillColor: dark(context),
                        focusColor: dark(context),
                        contentPadding: EdgeInsets.only(
                          left: 15.0,
                          right: 15.0,
                          top: 10.0,
                          bottom: 10.0,
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.grey, width: 0.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: primary(context)),
                        ),
                      ),
                      validator: (String value) {
                        if (value.isEmpty) {
                          return MyLocalizations.of(context)
                              .getLocalizations("ENTER_POSTAL_CODE");
                        } else
                          return null;
                      },
                      onSaved: (String value) {
                        address['postalCode'] = value;
                      }),
                ),
                SizedBox(height: 25),
                Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0, bottom: 5.0, right: 20.0),
                    child: addressPage(context, "MOBILE_NUMBER")),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  child: TextFormField(
                    initialValue:
                        widget.updateAddressID['mobileNumber'].toString() ?? "",
                    maxLength: 15,
                    style: labelStyle(context),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        counterText: "",
                        fillColor: dark(context),
                        focusColor: dark(context),
                        contentPadding: EdgeInsets.only(
                          left: 15.0,
                          right: 15.0,
                          top: 10.0,
                          bottom: 10.0,
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.grey, width: 0.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: primary(context)),
                        )),
                    validator: (String value) {
                      if (value.isEmpty) {
                        return MyLocalizations.of(context)
                            .getLocalizations("ENTER_MOBILE_NUMBER");
                      } else
                        return null;
                    },
                    onSaved: (String value) {
                      address['mobileNumber'] = value;
                    },
                  ),
                ),
                SizedBox(height: 25),
                Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0, bottom: 5.0, right: 20.0),
                    child: addressPage(context, "ADDRESS_TYPE")),
                ListView.builder(
                  physics: ScrollPhysics(),
                  shrinkWrap: true,
                  itemCount:
                      addressType.length == null ? 0 : addressType.length,
                  itemBuilder: (BuildContext context, int i) {
                    String type;
                    if (addressType[i] == 'HOME') {
                      type =
                          MyLocalizations.of(context).getLocalizations("HOME");
                    } else if (addressType[i] == 'WORK') {
                      type =
                          MyLocalizations.of(context).getLocalizations("WORK");
                    } else if (addressType[i] == 'OTHERS') {
                      type = MyLocalizations.of(context)
                          .getLocalizations("OTHERS");
                    } else {
                      type = addressType[i];
                    }
                    return Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Radio(
                            value: i,
                            groupValue: selectedAddressType,
                            activeColor: primary(context),
                            onChanged: (value) {
                              setSelectedRadio(value);
                            },
                          ),
                          normalTextWithOutRow(context, type, false)
                        ],
                      ),
                    );
                  },
                ),
                InkWell(
                  onTap: updateAddress,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: buttonprimary(
                        context, "UPDATE", isUpdateAddressLoading),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
