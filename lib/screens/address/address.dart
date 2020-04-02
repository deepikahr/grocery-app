import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/components/appbar/gf_appbar.dart';
import 'package:getflutter/getflutter.dart';
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
          style: TextStyle(
            color: Colors.black,
          ),
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
                        style: titleBold(),
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
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 20.0, left: 30.0),
                                    child: Text(
                                      '${addressList[index]['flatNumber']}' +
                                          ', ' +
                                          '${addressList[index]['locality']}' +
                                          ', ' +
                                          '${addressList[index]['landMark']}' +
                                          ', ' +
                                          '${addressList[index]['city']}' +
                                          ', '
                                              '${addressList[index]['postalCode']}' +
                                          ', ' +
                                          '${addressList[index]['state']}',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  buildEditDelete(addressList[index])
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
              await Navigator.push(
                context,
                new MaterialPageRoute(
                  builder: (BuildContext context) =>
                      new AddAddress(isCheckout: true),
                ),
              );
              getAddress();
            },
            text: 'Add Address',
            textStyle: TextStyle(fontSize: 17.0, color: Colors.black),
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
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditAddress(
                      updateAddressID: addressList, isCheckout: true),
                ),
              );

              getAddress();
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 18.0, right: 18.0),
              child: Text(
                "Edit",
              ),
            ),
            type: GFButtonType.outline,
            color: GFColors.WARNING,
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
                ),
              ),
              color: GFColors.WARNING,
              type: GFButtonType.outline,
            ),
          )
        ],
      ),
    );
  }
}
