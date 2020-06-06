import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map_picker/flutter_map_picker.dart';
import 'package:getflutter/components/appbar/gf_appbar.dart';
import 'package:getflutter/getflutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:readymadeGroceryApp/service/constants.dart';
import 'package:readymadeGroceryApp/service/localizations.dart';
import 'package:readymadeGroceryApp/style/style.dart';
import 'package:readymadeGroceryApp/service/sentry-service.dart';
import 'package:readymadeGroceryApp/service/address-service.dart';
import 'package:location/location.dart';

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

  var addressData;
  LocationData currentLocation;
  bool chooseAddress = false, isUpdateAddress = false;
  StreamSubscription<LocationData> locationSubscription;
  PlacePickerResult _pickedLocation;
  int selectedRadio = 0, selectedRadioFirst;
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
      AddressService.updateAddress(address, widget.updateAddressID['_id'])
          .then((onValue) {
        try {
          if (mounted) {
            setState(() {
              isUpdateAddress = false;
            });
          }
          if (onValue['response_code'] == 200) {
            if (mounted) {
              setState(() {
                Navigator.pop(context);
              });
            }
          }
        } catch (error, stackTrace) {
          if (mounted) {
            setState(() {
              isUpdateAddress = false;
            });
          }
          sentryError.reportError(error, stackTrace);
        }
      }).catchError((onError) {
        if (mounted) {
          setState(() {
            isUpdateAddress = false;
          });
        }
        sentryError.reportError(onError, null);
      });
    } else {
      if (mounted) {
        setState(() {
          isUpdateAddress = false;
        });
      }
      return;
    }
  }

  @override
  void dispose() {
    if (locationSubscription != null && locationSubscription is Stream)
      locationSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GFAppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        title: Text(
          MyLocalizations.of(context).editAddress,
          style: textbarlowSemiBoldBlack(),
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
                  padding: const EdgeInsets.only(
                      left: 12.0, bottom: 5.0, right: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        MyLocalizations.of(context).location,
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
                  margin:
                      EdgeInsets.only(left: 12, right: 12, top: 15, bottom: 15),
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.33), blurRadius: 6)
                  ]),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 0.0,
                      right: 0.0,
                    ),
                    child: GFButton(
                        color: primary,
                        blockButton: true,
                        onPressed: () async {
                          var lat, long;
                          if (_pickedLocation == null) {
                            lat = widget.updateAddressID['location']['lat'];
                            long = widget.updateAddressID['location']['long'];
                          } else {
                            lat = _pickedLocation.latLng.latitude;
                            long = _pickedLocation.latLng.longitude;
                          }

                          PlacePickerResult pickerResult = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PlacePickerScreen(
                                        googlePlacesApiKey:
                                            Constants.GOOGLE_API_KEY,
                                        initialPosition: LatLng(lat, long),
                                        mainColor: primary,
                                        mapStrings: MapPickerStrings.english(),
                                        placeAutoCompleteLanguage: 'en',
                                      )));
                          setState(() {
                            _pickedLocation = pickerResult;
                            fullAddress = pickerResult.address.toString();
                          });
                        },
                        text: MyLocalizations.of(context).updateAddress,
                        textStyle: textBarlowRegularBlack()),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20.0, bottom: 5.0, right: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        MyLocalizations.of(context).houseFlatBlocknumber + " :",
                        style: regular(),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  child: TextFormField(
                    initialValue: widget.updateAddressID['flatNo'],
                    maxLength: 14,
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
                        return MyLocalizations.of(context)
                            .pleaseenterhouseflatblocknumber;
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
                  padding: const EdgeInsets.only(
                      left: 20.0, bottom: 5.0, right: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        MyLocalizations.of(context).apartmentName + " :",
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
                          return MyLocalizations.of(context)
                              .pleaseenterapartmentname;
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
                  padding: const EdgeInsets.only(
                      left: 20.0, bottom: 5.0, right: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        MyLocalizations.of(context).landMark + " :",
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
                          return MyLocalizations.of(context)
                              .pleaseenterlandmark;
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
                  padding: const EdgeInsets.only(
                      left: 20.0, bottom: 5.0, right: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        MyLocalizations.of(context).postalCode + " :",
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
                          return MyLocalizations.of(context)
                              .pleaseenterpostalcode;
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
                  padding: const EdgeInsets.only(
                      left: 20.0, bottom: 5.0, right: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        MyLocalizations.of(context).contactNumber + " :",
                        style: regular(),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  child: TextFormField(
                    initialValue: widget.updateAddressID['contactNumber'],
                    maxLength: 15,
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
                      if (value.isEmpty) {
                        return MyLocalizations.of(context)
                            .pleaseentercontactnumber;
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
                  padding: const EdgeInsets.only(
                      left: 20.0, bottom: 5.0, right: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        MyLocalizations.of(context).addressType,
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
                  height: 45,
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.33), blurRadius: 6)
                  ]),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 0.0, right: 0.0),
                    child: GFButton(
                      onPressed: updateAddress,
                      textStyle: textBarlowRegularBlack(),
                      color: primary,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(MyLocalizations.of(context).update),
                          SizedBox(
                            height: 10,
                          ),
                          isUpdateAddress
                              ? GFLoader(
                                  type: GFLoaderType.ios,
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
