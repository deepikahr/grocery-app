import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/components/appbar/gf_appbar.dart';
import 'package:getflutter/getflutter.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:grocery_pro/style/style.dart';
import 'package:grocery_pro/service/sentry-service.dart';
import 'package:grocery_pro/service/address-service.dart';
import 'package:grocery_pro/service/product-service.dart';
import 'package:location/location.dart';

SentryError sentryError = new SentryError();

class EditAddress extends StatefulWidget {
  const EditAddress(
      {Key key,
      this.currentLocation,
      this.isCheckout,
      this.isProfile,
      this.updateAddressID})
      : super(key: key);
  final bool isCheckout;
  final bool isProfile;
  final Map<String, dynamic> updateAddressID;
  final LocationData currentLocation;

  @override
  _EditAddressState createState() => _EditAddressState();
}

class _EditAddressState extends State<EditAddress> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  var addressData;
  LocationData currentLocation;
  Location _location = new Location();
  bool chooseAddress = false, isUpdateAddress = false;
  StreamSubscription<LocationData> locationSubscription;
  int selectedRadio = 0;
  int selectedRadioFirst;
  LocationResult _pickedLocation;
  String fullAddress;
  @override
  void initState() {
    super.initState();
  }

  List<String> addressType = ['Home', "Work", "Others"];
  setSelectedRadio(int val) async {
    if (mounted) {
      setState(() {
        selectedRadioFirst = val;
      });
    }
  }

  Map<String, dynamic> address = {
    "location": {},
    "address": null,
    "flatNo": null,
    "apartmentame": null,
    "landmark": null,
    "postalCode": null,
    "contactNumber": null,
    "addressType": null
  };
  updateAddress() async {
    if (_formKey.currentState.validate()) {
      if (mounted) {
        setState(() {
          isUpdateAddress = true;
        });
      }
      _formKey.currentState.save();

      if (_pickedLocation == null) {
        address['address'] = fullAddress == null
            ? widget.updateAddressID['address']
            : fullAddress;
        address['location'] = widget.updateAddressID['location'];
      } else {
        address['address'] = _pickedLocation.address;
        var location = {
          "lat": _pickedLocation.latLng.latitude,
          "long": _pickedLocation.latLng.longitude
        };
        address['location'] = location;
      }

      address['addressType'] = addressType[
          selectedRadioFirst == null ? selectedRadio : selectedRadioFirst];
      print(address);
      AddressService.updateAddress(address, widget.updateAddressID['_id'])
          .then((onValue) {
        print(onValue);
        try {
          if (mounted) {
            setState(() {
              isUpdateAddress = false;
              showAlert(onValue['response_data']);
            });
          }
        } catch (error, stackTrace) {
          sentryError.reportError(error, stackTrace);
        }
      }).catchError((onError) {
        sentryError.reportError(onError, null);
      });
    } else {
      return;
    }
  }

  // show alert
  showAlert(message) {
    showDialog<Null>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return new AlertDialog(
          content: new SingleChildScrollView(
            child: new ListBody(
              children: <Widget>[
                new Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text('OK'),
              onPressed: () {
                if (widget.isProfile == true) {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop(address);
                } else {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  getGeoLocation() async {
    await ProductService.geoApi(
            currentLocation.latitude, currentLocation.longitude)
        .then((onValue) {
      try {
        if (mounted) {
          setState(() {
            addressData = onValue['results'][0];
          });
        }
      } catch (error, stackTrace) {
        sentryError.reportError(error, stackTrace);
      }
    }).catchError((error) {
      sentryError.reportError(error, null);
    });
  }

  @override
  void dispose() {
    if (locationSubscription != null && locationSubscription is Stream)
      locationSubscription.cancel();
    super.dispose();
  }

  getResult() async {
    currentLocation = await _location.getLocation();
    getGeoLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GFAppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        title: Text(
          'Edit Address',
          style: textbarlowSemiBoldBlack()
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: primary,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12.0, bottom: 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Loaction :',
                        style: regular(),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 15.0, right: 15.0, bottom: 5.0),
                  child: Text(
                    fullAddress == null
                        ? widget.updateAddressID['address'].toString()
                        : fullAddress,
                    style: labelStyle(),
                  ),
                ),
                Container(
                  height: 45,
                  margin: EdgeInsets.only(left:12, right:12, top:15, bottom: 15),
                  decoration:BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.33),
                        blurRadius: 6
                      )
                    ]
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 0.0,
                      right: 0.0,
                    ),
                    child: GFButton(
                      color: primary,
                      blockButton: true,
                      onPressed: () async {
                        LocationResult result = await showLocationPicker(
                          context,
                          "AIzaSyD6Q4UgAYOL203nuwNeBr4j_-yAd1U1gko",
                          initialCenter: LatLng(31.1975844, 29.9598339),
                          myLocationButtonEnabled: true,
                          layersButtonEnabled: true,
                        );
                        setState(() {
                          _pickedLocation = result;
                          fullAddress = result.address.toString();
                        });
                      },
                      text: 'Update Address',
                      textStyle: TextStyle(fontSize: 17.0, color: Colors.black),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, bottom: 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'House/Flat/Block number :',
                        style: regular(),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  child: TextFormField(
                    initialValue: widget.updateAddressID['flatNo'],
                    style: labelStyle(),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        fillColor: Colors.black,
                        focusColor: Colors.black,
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
                          borderSide: BorderSide(color: primary),
                        )),
                    validator: (String value) {
                      if (value.isEmpty) {
                        return "please Enter Valid value";
                      } else
                        return null;
                    },
                    onSaved: (String value) {
                      address['flatNo'] = value;
                    },
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, bottom: 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Apartment Name :',
                        style: regular(),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  child: TextFormField(
                      initialValue: widget.updateAddressID['apartmentName'],
                      style: labelStyle(),
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        fillColor: Colors.black,
                        focusColor: Colors.black,
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
                          borderSide: BorderSide(color: primary),
                        ),
                      ),
                      validator: (String value) {
                        if (value.isEmpty) {
                          return "please Enter Valid value";
                        } else
                          return null;
                      },
                      onSaved: (String value) {
                        address['apartmentName'] = value;
                      }),
                ),
                SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, bottom: 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Land Mark :',
                        style: regular(),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  child: TextFormField(
                      initialValue: widget.updateAddressID['landmark'],
                      style: labelStyle(),
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        fillColor: Colors.black,
                        focusColor: Colors.black,
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
                          borderSide: BorderSide(color: primary),
                        ),
                      ),
                      validator: (String value) {
                        if (value.isEmpty) {
                          return "please Enter Valid value";
                        } else
                          return null;
                      },
                      onSaved: (String value) {
                        address['landmark'] = value;
                      }),
                ),
                SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, bottom: 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Postel Code :',
                        style: regular(),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  child: TextFormField(
                      initialValue:
                          widget.updateAddressID['postalCode'].toString(),
                      style: labelStyle(),
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        fillColor: Colors.black,
                        focusColor: Colors.black,
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
                          borderSide: BorderSide(color: primary),
                        ),
                      ),
                      validator: (String value) {
                        if (value.isEmpty) {
                          return "please Enter Valid value";
                        } else
                          return null;
                      },
                      onSaved: (String value) {
                        address['postalCode'] = value;
                      }),
                ),
                SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, bottom: 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Contact Number :',
                        style: regular(),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  child: TextFormField(
                    initialValue: widget.updateAddressID['contactNumber'],
                    maxLength: 10,
                    style: labelStyle(),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        counterText: "",
                        fillColor: Colors.black,
                        focusColor: Colors.black,
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
                          borderSide: BorderSide(color: primary),
                        )),
                    validator: (String value) {
                      if (value.isEmpty || value.length != 10) {
                        return "please Enter Valid value";
                      } else
                        return null;
                    },
                    onSaved: (String value) {
                      address['contactNumber'] = value;
                    },
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, bottom: 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Address Type (Home, Work, Others etc.):',
                        style: regular(),
                      ),
                    ],
                  ),
                ),
                ListView.builder(
                  physics: ScrollPhysics(),
                  shrinkWrap: true,
                  itemCount:
                      addressType.length == null ? 0 : addressType.length,
                  itemBuilder: (BuildContext context, int i) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Radio(
                            value: i,
                            groupValue: selectedRadioFirst == null
                                ? selectedRadio
                                : selectedRadioFirst,
                            activeColor: Colors.green,
                            onChanged: (value) {
                              setSelectedRadio(value);
                            },
                          ),
                          Text('${addressType[i]}'),
                        ],
                      ),
                    );
                  },
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  height:45,
                  decoration:BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.33),
                            blurRadius: 6
                        )
                      ]
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 0.0, right: 0.0),
                    child: GFButton(
                      onPressed: updateAddress,
                      color: primary,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("Update"),
                          isUpdateAddress
                              ? Image.asset(
                                  'lib/assets/images/spinner.gif',
                                  width: 15.0,
                                  height: 15.0,
                                  color: Colors.black,
                                )
                              : Text("")
                        ],
                      ),
                      textColor: Colors.black,
                      blockButton: true,
                    ),
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
