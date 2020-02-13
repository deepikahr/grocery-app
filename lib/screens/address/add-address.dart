import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/components/appbar/gf_appbar.dart';
import 'package:getflutter/getflutter.dart';
import 'package:grocery_pro/style/style.dart';
import 'package:grocery_pro/service/sentry-service.dart';
import 'package:grocery_pro/screens/checkout/checkout.dart';
import 'package:grocery_pro/screens/profile/profile.dart';
import 'package:grocery_pro/service/address-service.dart';
import 'package:grocery_pro/service/product-service.dart';
import 'package:location/location.dart';

SentryError sentryError = new SentryError();

class AddAddress extends StatefulWidget {
  const AddAddress(
      {Key key, this.currentLocation, this.isCheckout, this.isProfile})
      : super(key: key);
  final bool isCheckout;
  final bool isProfile;
  final LocationData currentLocation;

  @override
  _AddAddressState createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List addressList = List();
  String flatNumber, landMark, pincode, locality, district, state;
  bool isLoading = false;
  bool chooseAddress = false;
  // StreamSubscription<LocationData> locationSubscription;
  LocationData currentLocation;

  // var addressData;

  addAddress() async {
    final form = _formKey.currentState;
    Map<String, dynamic> address = {
      "flatNumber": flatNumber,
      "locality": locality,
      "landMark": landMark,
      "city": district,
      "postalCode": pincode,
      "state": state
    };

    // if (chooseAddress) {
    // List data = addressData['formatted_address'].toString().split(',');
    // Map<String, dynamic> body = {
    //   "flatNumber": data[1],
    //   "landMark": data[0] + ' ,' + data[1],
    //   "locality": addressData['address_components'][0]['long_name'],
    //   "city": addressData['address_components'][2]['long_name'] +
    //       ',' +
    //       addressData['address_components'][1]['long_name'],
    //   "postalCode": addressData['address_components'][3]['long_name'],
    //   "state": addressData['address_components'][6]['long_name']
    // };
    // print();
    // await AddressService.addAddress(body).then((onValue) {
    //   try {
    //     showAlert();
    //     if (mounted) {
    //       setState(() {
    //         chooseAddress = false;
    //       });
    //     }
    //   } catch (error, stackTrace) {
    //     sentryError.reportError(error, stackTrace);
    //   }
    // }).catchError((error) {
    //   sentryError.reportError(error, null);
    // });
    // } else {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      print('address body $address');
      if (mounted) {
        setState(() {
          isLoading = true;
        });
      }
      AddressService.addAddress(address).then((onValue) {
        print(onValue);
        try {
          if (mounted) {
            if (onValue['response_code'] == 201) {
              setState(() {
                isLoading = false;
                // showAlert(onValue['response_data']['message']);
                Navigator.of(context).pop(address);
              });
            }
          }
        } catch (error, stackTrace) {
          sentryError.reportError(error, stackTrace);
        }
      }).catchError((onError) {
        sentryError.reportError(onError, null);
      });
    }
  }
  // }

  // show alert
  showAlert(String message) {
    showDialog<Null>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return new AlertDialog(
          // title: new Text('Error'),
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
                // Navigator.pop(context);

                if (widget.isCheckout == true) {
                  Navigator.of(context).pop();
                  // Navigator.of(context).pop();
                  Navigator.of(context).pop();
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

  // getGeoLocation() async {
  //   await ProductService.geoApi(
  //           currentLocation.latitude, currentLocation.longitude)
  //       .then((onValue) {
  //     try {
  //       if (mounted) {
  //         setState(() {
  //           addressData = onValue['results'][0];
  //         });
  //       }
  //     } catch (error, stackTrace) {
  //       sentryError.reportError(error, stackTrace);
  //     }
  //   }).catchError((error) {
  //     sentryError.reportError(error, null);
  //   });
  // }

  // getResult() async {
  //   currentLocation = await _location.getLocation();
  //   getGeoLocation();
  // }

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
                padding: const EdgeInsets.only(left: 18.0, bottom: 5.0),
                child: Text(
                  'House/Flat/Block number :',
                  style: regular(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                child: TextFormField(
                    // initialValue: "123456",
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
                    // obscureText: true,
                    validator: (String value) {
                      if (value.isEmpty) {
                        return "please Enter Valid value";
                      } else
                        return null;
                    },
                    onSaved: (String value) {
                      flatNumber = value;
                    }),
              ),
              SizedBox(
                height: 25,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 18.0, bottom: 5.0),
                child: Text(
                  'LandMark :',
                  style: regular(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                child: TextFormField(
                    // initialValue: "123456",
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
                    // style: textBlackOSR(),
                    // obscureText: true,
                    validator: (String value) {
                      if (value.isEmpty) {
                        return "please Enter Valid value";
                      } else
                        return null;
                    },
                    onSaved: (String value) {
                      landMark = value;
                    }),
              ),
              SizedBox(
                height: 25,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 18.0, bottom: 5.0),
                child: Text(
                  'Area :',
                  style: regular(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                child: TextFormField(
                    // initialValue: "123456",
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
                    // style: textBlackOSR(),
                    // obscureText: true,
                    validator: (String value) {
                      if (value.isEmpty) {
                        return "please Enter Valid value";
                      } else
                        return null;
                    },
                    onSaved: (String value) {
                      locality = value;
                    }),
              ),
              SizedBox(
                height: 25,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 18.0, bottom: 5.0),
                child: Text(
                  'Pincode :',
                  style: regular(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                child: TextFormField(
                    // initialValue: "123456",
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
                    // style: textBlackOSR(),
                    // obscureText: true,
                    validator: (String value) {
                      if (value.isEmpty) {
                        return "please Enter Valid value";
                      } else
                        return null;
                    },
                    onSaved: (String value) {
                      pincode = value;
                    }),
              ),
              SizedBox(
                height: 25,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 18.0, bottom: 5.0),
                child: Text(
                  'District :',
                  style: regular(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                child: TextFormField(
                    // initialValue: "123456",
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
                    // style: textBlackOSR(),
                    // obscureText: true,
                    validator: (String value) {
                      if (value.isEmpty) {
                        return "please Enter Valid value";
                      } else
                        return null;
                    },
                    onSaved: (String value) {
                      district = value;
                    }),
              ),
              SizedBox(
                height: 25,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 18.0, bottom: 5.0),
                child: Text(
                  'State :',
                  style: regular(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                child: TextFormField(
                    // initialValue: "123456",
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
                    // style: textBlackOSR(),
                    // obscureText: true,
                    validator: (String value) {
                      if (value.isEmpty) {
                        return "please Enter Valid value";
                      } else
                        return null;
                    },
                    onSaved: (String value) {
                      state = value;
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
