import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/components/appbar/gf_appbar.dart';
import 'package:getflutter/getflutter.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:grocery_pro/screens/address/add-address.dart';
import 'package:grocery_pro/screens/address/edit-address.dart';
import 'package:grocery_pro/service/sentry-service.dart';
import 'package:grocery_pro/style/style.dart';
import 'package:grocery_pro/service/address-service.dart';

SentryError sentryError = new SentryError();

class Address extends StatefulWidget {
  @override
  _AddressState createState() => _AddressState();
}

class _AddressState extends State<Address> {
  bool isProfile = false;
  bool addressLoading = false;
  List addressList = List();
  LocationResult _pickedLocation;

  @override
  void initState() {
    getAddress();
    super.initState();
  }

  getAddress() async {
    if (mounted) {
      setState(() {
        addressLoading = true;
      });
    }

    await AddressService.getAddress().then((onValue) {
      print(onValue);
      try {
        if (mounted) {
          setState(() {
            addressList = onValue['response_data'];
            addressLoading = false;
          });
        }
      } catch (error, stackTrace) {
        sentryError.reportError(error, stackTrace);
      }
    }).catchError((error) {
      sentryError.reportError(error, null);
    });
  }

  deleteAddress(body) async {
    await AddressService.deleteAddress(body).then((onValue) {
      try {
        getAddress();
        if (mounted) {
          setState(() {
            addressList = addressList;
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GFAppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        title: Text(
          'Address',
          style: textbarlowSemiBoldBlack(),
        ),
        centerTitle: true,
        backgroundColor: primary,
      ),
      body: addressLoading
          ? Center(child: CircularProgressIndicator())
          : ListView(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 10.0, bottom: 10.0, left: 20.0),
                      child: Text(
                        'Saved Address',
                        style: textbarlowSemiBoldBlack(),
                      ),
                    ),
                  ],
                ),
                addressList.length == 0
                    ? Center(
                        child: Image.asset('lib/assets/images/no-orders.png'),
                      )
                    : ListView.builder(
                        physics: ScrollPhysics(),
                        shrinkWrap: true,
                        itemCount:
                            addressList.length == null ? 0 : addressList.length,
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
                                      child: Text('1')),
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
                                          child: Text(
                                            '${addressList[index]['flatNo']}' +
                                                ', ' +
                                                '${addressList[index]['apartmentName']}' +
                                                ', ' +
                                                '${addressList[index]['address']}' +
                                                ', ' +
                                                '${addressList[index]['landmark']}' +
                                                ', '
                                                    '${addressList[index]['postalCode'].toString()}' +
                                                ', ' +
                                                '${addressList[index]['contactNumber']}',
                                            style: textBarlowRegularBlack(),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 20),
                                      buildEditDelete(addressList[index])
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
      bottomNavigationBar: Container(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 20.0,
            right: 20.0,
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
              if (result != null) {
                setState(() {
                  _pickedLocation = result;
                  Navigator.push(
                    context,
                    new MaterialPageRoute(
                      builder: (BuildContext context) => new AddAddress(
                        isProfile: true,
                        pickedLocation: _pickedLocation,
                      ),
                    ),
                  );
                });
              }
            },
            text: 'Add New Address',
            textStyle: textBarlowRegularrBlack(),
          ),
        ),
      ),
    );
  }

  Widget buildEditDelete(addressList) {
    return Padding(
      padding: const EdgeInsets.only(left: 37.0, right: 37.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          GFButton(
            onPressed: () async {
              print("adrewsss $addressList");
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditAddress(
                      updateAddressID: addressList, isProfile: true),
                ),
              );

              getAddress();
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 18.0, right: 18.0),
              child: Text(
                "Edit",
                style: textbarlowRegularaPrimar(),
              ),
            ),
            type: GFButtonType.outline,
            color: primary,
            size: GFSize.MEDIUM,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: GFButton(
              onPressed: () {
                deleteAddress(addressList['_id']);
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: Text(
                  "Delete",
                  style: textbarlowRegularaPrimar(),
                ),
              ),
              color: primary,
              type: GFButtonType.outline,
            ),
          )
        ],
      ),
    );
  }
}
