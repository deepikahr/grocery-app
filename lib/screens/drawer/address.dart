import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/components/appbar/gf_appbar.dart';
import 'package:getflutter/getflutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:readymadeGroceryApp/screens/drawer/add-address.dart';
import 'package:readymadeGroceryApp/screens/drawer/edit-address.dart';
import 'package:readymadeGroceryApp/service/constants.dart';
import 'package:readymadeGroceryApp/service/localizations.dart';
import 'package:readymadeGroceryApp/service/sentry-service.dart';
import 'package:readymadeGroceryApp/style/style.dart';
import 'package:readymadeGroceryApp/service/address-service.dart';
import 'package:readymadeGroceryApp/widgets/loader.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_map_picker/flutter_map_picker.dart';

SentryError sentryError = new SentryError();

class Address extends StatefulWidget {
  final Map localizedValues;
  final String locale;
  Address({Key key, this.locale, this.localizedValues});

  @override
  _AddressState createState() => _AddressState();
}

class _AddressState extends State<Address> {
  bool isProfile = false, addressLoading = false;
  List addressList = List();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  PlacePickerResult pickedLocation;
  LocationData currentLocation;
  Location _location = new Location();
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
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
      try {
        _refreshController.refreshCompleted();

        if (mounted) {
          setState(() {
            addressLoading = false;
          });
        }
        if (onValue['response_code'] == 200) {
          if (mounted) {
            setState(() {
              addressList = onValue['response_data'];
            });
          }
        } else {
          if (mounted) {
            setState(() {
              addressList = [];
            });
          }
        }
      } catch (error, stackTrace) {
        if (mounted) {
          setState(() {
            addressList = [];
            addressLoading = false;
          });
        }
        sentryError.reportError(error, stackTrace);
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

  deleteAddress(body) async {
    await AddressService.deleteAddress(body).then((onValue) {
      try {
        if (onValue['response_code'] == 200) {
          if (mounted) {
            setState(() {
              getAddress();
              addressList = addressList;
              showSnackbar(onValue['response_data']);
            });
          }
        }
      } catch (error, stackTrace) {
        if (mounted) {
          setState(() {
            addressLoading = false;
          });
        }
        sentryError.reportError(error, stackTrace);
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
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: GFAppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        title: Text(
          MyLocalizations.of(context).address,
          style: textbarlowSemiBoldBlack(),
        ),
        centerTitle: true,
        backgroundColor: primary,
      ),
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: false,
        controller: _refreshController,
        onRefresh: () {
          getAddress();
        },
        child: addressLoading
            ? SquareLoader()
            : ListView(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 10.0, bottom: 10.0, left: 20.0, right: 20.0),
                        child: Text(
                          MyLocalizations.of(context).savedAddress,
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
                          itemCount: addressList.length == null
                              ? 0
                              : addressList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                padding: const EdgeInsets.only(
                                    top: 5.0, bottom: 5.0),
                                decoration: BoxDecoration(
                                    color: Colors.white70,
                                    borderRadius: BorderRadius.circular(5.0)),
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      margin:
                                          EdgeInsets.only(bottom: 100, left: 7),
                                      child: Text(
                                        (index + 1).toString(),
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
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
      ),
      bottomNavigationBar: Container(
        height: 55,
        margin: EdgeInsets.only(top: 30, bottom: 20, right: 20, left: 20),
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.29), blurRadius: 5)
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
              currentLocation = await _location.getLocation();
              if (currentLocation != null) {
                PlacePickerResult pickerResult = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PlacePickerScreen(
                              googlePlacesApiKey: Constants.GOOGLE_API_KEY,
                              initialPosition: LatLng(currentLocation.latitude,
                                  currentLocation.longitude),
                              mainColor: primary,
                              mapStrings: MapPickerStrings.english(),
                              placeAutoCompleteLanguage: 'en',
                            )));
                if (pickerResult != null) {
                  setState(() {
                    var result = Navigator.push(
                      context,
                      new MaterialPageRoute(
                        builder: (BuildContext context) => new AddAddress(
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
              } else {
                showError(
                    MyLocalizations.of(context).enableTogetlocation,
                    MyLocalizations.of(context)
                        .thereisproblemusingyourdevicelocationPleasecheckyourGPSsettings);
              }
            },
            text: MyLocalizations.of(context).addNewAddress,
            textStyle: textBarlowRegularBlack(),
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
            onPressed: () {
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
            child: Padding(
              padding: const EdgeInsets.only(left: 3.0, right: 3.0),
              child: Text(
                MyLocalizations.of(context).edit,
                style: textbarlowRegularaPrimar(),
              ),
            ),
            type: GFButtonType.outline,
            color: primary,
            size: GFSize.MEDIUM,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: GFButton(
              onPressed: () {
                deleteAddress(addressList['_id']);
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 3.0, right: 3.0),
                child: Text(
                  MyLocalizations.of(context).delete,
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
            style: hintSfsemiboldb(),
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
                    style: hintSfLightsm(),
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
                                  MyLocalizations.of(context).ok,
                                  style: hintSfLightbig(),
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
