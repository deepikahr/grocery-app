import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/components/appbar/gf_appbar.dart';
import 'package:getflutter/getflutter.dart';
import 'package:grocery_pro/style/style.dart';
import 'package:grocery_pro/service/sentry-service.dart';
import 'package:grocery_pro/service/address-service.dart';
import 'package:grocery_pro/service/product-service.dart';
import 'package:location/location.dart';

SentryError sentryError = new SentryError();

class AddAddress extends StatefulWidget {
  const AddAddress(
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
  _AddAddressState createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  var addressData;
  LocationData currentLocation;
  Location _location = new Location();
  bool chooseAddress = false, isLoading = false;
  StreamSubscription<LocationData> locationSubscription;
  // String flatName, flatNo, street, locality, city, pincode;

  @override
  void initState() {
    super.initState();
  }

  // var addressData;
  Map<String, dynamic> address = {
    "flatNumber": null,
    "locality": null,
    "landMark": null,
    "city": null,
    "postalCode": null,
    "state": null
  };
  addAddress() async {
    if (chooseAddress && widget.updateAddressID == null) {
      List data = addressData['formatted_address'].toString().split(',');
      Map<String, dynamic> body = {
        "flatNumber": data[0],
        "landMark": addressData['address_components'][0]['long_name'],
        "locality": addressData['address_components'][2]['long_name'] +
            ',' +
            addressData['address_components'][1]['long_name'],
        "city": addressData['address_components'][3]['long_name'],
        "postalCode": addressData['address_components'][6]['long_name'],
        "state": addressData['address_components'][3]['long_name'],
      };
      await AddressService.addAddress(body).then((onValue) {
        try {
          showAlert();
          if (mounted) {
            setState(() {
              chooseAddress = false;
            });
          }
        } catch (error, stackTrace) {
          sentryError.reportError(error, stackTrace);
        }
      }).catchError((error) {
        sentryError.reportError(error, null);
      });
    } else if (!chooseAddress && widget.updateAddressID == null) {
      if (_formKey.currentState.validate()) {
        if (mounted) {
          setState(() {
            isLoading = true;
          });
        }
        _formKey.currentState.save();
        AddressService.addAddress(address).then((onValue) {
          try {
            if (mounted) {
              setState(() {
                isLoading = false;
                showAlert();
              });
            }
          } catch (error, stackTrace) {
            sentryError.reportError(error, stackTrace);
          }
        }).catchError((onError) {
          sentryError.reportError(onError, null);
        });
      }
    } else if (widget.updateAddressID != null) {}
  }

  // show alert
  showAlert() {
    showDialog<Null>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return new AlertDialog(
          content: new SingleChildScrollView(
            child: new ListBody(
              children: <Widget>[
                new Text('addressAdded'),
              ],
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text('OK'),
              onPressed: () {
                if (widget.isCheckout == true) {
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
            'Add Address',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          centerTitle: true,
          backgroundColor: primary,
        ),
        body: Form(
          key: _formKey,
          child: ListView(children: <Widget>[
            Column(children: <Widget>[
              SizedBox(
                height: 25,
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
                    // initialValue: widget.updateAddressID['flatNumber'] != null
                    //     ? widget.updateAddressID['flatNumber']
                    //     : "#123",
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
                        )),
                    validator: (String value) {
                      if (value.isEmpty) {
                        return "please Enter Valid value";
                      } else
                        return null;
                    },
                    onSaved: (String value) {
                      address['flatNumber'] = value;
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
                      'LandMark :',
                      style: regular(),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                child: TextFormField(
                    // initialValue: widget.updateAddressID['flatNumber'] == null
                    //     ? ""
                    //     : widget.updateAddressID['flatNumber'],
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
                        )),
                    validator: (String value) {
                      if (value.isEmpty) {
                        return "please Enter Valid value";
                      } else
                        return null;
                    },
                    onSaved: (String value) {
                      address['landMark'] = value;
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
                      'Area :',
                      style: regular(),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                child: TextFormField(
                    // initialValue: widget.updateAddressID['flatNumber'] == null
                    //     ? ""
                    //     : widget.updateAddressID['flatNumber'],
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
                        )),
                    validator: (String value) {
                      if (value.isEmpty) {
                        return "please Enter Valid value";
                      } else
                        return null;
                    },
                    onSaved: (String value) {
                      address['locality'] = value;
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
                      'Pincode :',
                      style: regular(),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                child: TextFormField(
                    // initialValue: widget.updateAddressID['flatNumber'] == null
                    //     ? ""
                    //     : widget.updateAddressID['flatNumber'],
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
                        )),
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
                      'City :',
                      style: regular(),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                child: TextFormField(
                    // initialValue: widget.updateAddressID['flatNumber'] == null
                    //     ? ""
                    //     : widget.updateAddressID['flatNumber'],
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
                        )),
                    validator: (String value) {
                      if (value.isEmpty) {
                        return "please Enter Valid value";
                      } else
                        return null;
                    },
                    onSaved: (String value) {
                      address['city'] = value;
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
                      'State :',
                      style: regular(),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                child: TextFormField(
                    // initialValue: widget.updateAddressID['flatNumber'] == null
                    //     ? ""
                    //     : widget.updateAddressID['flatNumber'],
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
                        )),
                    validator: (String value) {
                      if (value.isEmpty) {
                        return "please Enter Valid value";
                      } else
                        return null;
                    },
                    onSaved: (String value) {
                      address['state'] = value;
                    }),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                child: Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  child: GFButton(
                    onPressed: addAddress,
                    color: primary,
                    text: 'Save',
                    textColor: Colors.black,
                    blockButton: true,
                  ),
                ),
              ),
            ]),
          ]),
        ));
  }
}
