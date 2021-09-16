import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:readymadeGroceryApp/service/localizations.dart';
import 'package:readymadeGroceryApp/style/style.dart';
import 'package:readymadeGroceryApp/service/sentry-service.dart';
import 'package:readymadeGroceryApp/service/address-service.dart';
import 'package:readymadeGroceryApp/widgets/appBar.dart';
import 'package:readymadeGroceryApp/widgets/button.dart';
import 'package:readymadeGroceryApp/widgets/normalText.dart';

SentryError sentryError = new SentryError();

class AddAddress extends StatefulWidget {
  const AddAddress(
      {Key? key,
      this.position,
      this.address,
      this.locale,
      this.localizedValues})
      : super(key: key);

  final LatLng? position;
  final Map? localizedValues;
  final String? locale, address;

  @override
  _AddAddressState createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool isAddAddressLoading = false;
  int? selectedAddressType = 0;
  TextEditingController addressController = TextEditingController();
  LatLng? position;

  @override
  void initState() {
    setState(() {
      addressController.text = widget.address!;
      position = widget.position;
    });

    super.initState();
  }

  List<String> addressType = ['HOME', "WORK", "OTHERS"];
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
  addAddress() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (mounted) {
        setState(() {
          isAddAddressLoading = true;
        });
      }

      var location = {
        "latitude": position?.latitude,
        "longitude": position?.longitude
      };
      address['address'] = addressController.text;
      address['location'] = location;
      address['addressType'] = addressType[selectedAddressType!];

      AddressService.addAddress(address).then((onValue) {
        if (mounted) {
          setState(() {
            showSnackbar(onValue['response_data']);
            Future.delayed(Duration(milliseconds: 1500), () {
              Navigator.pop(context);
              addressController.clear();
            });
            isAddAddressLoading = false;
          });
        }
      }).catchError((onError) {
        if (mounted) {
          setState(() {
            isAddAddressLoading = false;
          });
        }
        sentryError.reportError(onError, null);
      });
    }
  }

  setSelectedRadio(int? val) async {
    if (mounted) {
      setState(() {
        selectedAddressType = val;
      });
    }
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
      appBar: appBarPrimary(context, "ADD_NEW_ADDRESS") as PreferredSizeWidget?,
      body: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0, bottom: 5.0, right: 20.0, top: 10),
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
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return MyLocalizations.of(context)!
                              .getLocalizations("ENTER_LOCATION");
                        } else
                          return null;
                      },
                      onSaved: (String? value) {
                        address['address'] = addressController.text;
                      }),
                ),
                SizedBox(
                  height: 25,
                ),
                Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0, bottom: 5.0, right: 20.0),
                    child: addressPage(context, "HOUSE_FLAT_BLOCK_NUMBER")),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  child: TextFormField(
                    maxLength: 14,
                    style: textBarlowRegularBlack(context),
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 0,
                            color: Color(0xFFF44242),
                          ),
                        ),
                        errorStyle: TextStyle(color: Color(0xFFF44242)),
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
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return MyLocalizations.of(context)!
                            .getLocalizations("ENTER_HOUSE_FLAT_BLOCK_NUMBER");
                      } else
                        return null;
                    },
                    onSaved: (String? value) {
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
                      style: textBarlowRegularBlack(context),
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
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
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return MyLocalizations.of(context)!
                              .getLocalizations("ENTER_APARTMENT_NAME");
                        } else
                          return null;
                      },
                      onSaved: (String? value) {
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
                      style: textBarlowRegularBlack(context),
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
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
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return MyLocalizations.of(context)!
                              .getLocalizations("ENTER_LANDMARK");
                        } else
                          return null;
                      },
                      onSaved: (String? value) {
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
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return MyLocalizations.of(context)!
                              .getLocalizations("ENTER_POSTAL_CODE");
                        } else
                          return null;
                      },
                      onSaved: (String? value) {
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
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return MyLocalizations.of(context)!
                            .getLocalizations("ENTER_MOBILE_NUMBER");
                      } else
                        return null;
                    },
                    onSaved: (String? value) {
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
                  itemCount: addressType.isEmpty ? 0 : addressType.length,
                  itemBuilder: (BuildContext context, int i) {
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
                            onChanged: (dynamic value) {
                              setSelectedRadio(value);
                            },
                          ),
                          normalTextWithOutRow(context, addressType[i], false)
                        ],
                      ),
                    );
                  },
                ),
                InkWell(
                    onTap: addAddress,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child:
                          buttonprimary(context, "SUBMIT", isAddAddressLoading),
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
