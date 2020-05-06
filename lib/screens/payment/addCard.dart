import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:getflutter/components/appbar/gf_appbar.dart';
import 'package:getflutter/getflutter.dart';
import 'package:readymadeGroceryApp/service/localizations.dart';
import 'package:readymadeGroceryApp/service/payment-service.dart';
import 'package:readymadeGroceryApp/service/sentry-service.dart';
import 'package:readymadeGroceryApp/style/style.dart';
import 'package:intl/intl.dart';

SentryError sentryError = new SentryError();

class AddCard extends StatefulWidget {
  final Map<String, Map<String, String>> localizedValues;
  final String locale;
  AddCard({Key key, this.locale, this.localizedValues});

  @override
  _AddCardState createState() => _AddCardState();
}

class _AddCardState extends State<AddCard> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String cardHolderName, cardNumber, cvv, bank;
  int expiryYear, expiryMonth;
  bool isCardListLoading = false;

  saveCard() async {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      if (mounted) {
        setState(() {
          isCardListLoading = true;
        });
      }
      Map<String, dynamic> body = {
        "cardHolderName": cardHolderName,
        "cardNumber": cardNumber,
        "expiryMonth": expiryMonth,
        "expiryYear": expiryYear,
        "cvv": cvv,
        "bank": bank
      };
      var month = DateFormat("MM").format(DateTime.now());
      var year = DateFormat("yyyy").format(DateTime.now());
      if (expiryMonth >= int.parse(month) && expiryYear >= int.parse(year)) {
        await PaymentService.saveCard(body).then((onValue) {
          try {
            if (mounted) {
              setState(() {
                isCardListLoading = false;
              });
            }
            if (onValue['response_code'] == 201) {
              showDialog<Null>(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return new AlertDialog(
                    title: new Text(MyLocalizations.of(context).success,
                        style: hintSfsemiboldred()),
                    content: new SingleChildScrollView(
                      child: new ListBody(
                        children: <Widget>[
                          new Text(
                            '${onValue['response_data']}',
                            style: textBarlowRegularBlack(),
                          ),
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      new FlatButton(
                        child: new Text(
                          MyLocalizations.of(context).ok,
                          style: textbarlowRegularaPrimar(),
                        ),
                        onPressed: () {
                          Navigator.pop(context, onValue['data']);
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  );
                },
              );
            } else if (onValue['statusCode'] == 400) {
              String massege;
              if (onValue['message'][0]['constraints']['isCreditCard'] !=
                  null) {
                massege = onValue['message'][0]['constraints']['isCreditCard'];
              } else if (onValue['message'][0]['constraints']['min'] != null) {
                massege = onValue['message'][0]['constraints']['min'];
              } else if (onValue['message'][0]['constraints']['max'] != null) {
                massege = onValue['message'][0]['constraints']['max'];
              } else {
                massege = onValue['message'][0]['constraints'];
              }
              showSnackbar(massege);
            } else {
              showSnackbar('${onValue['response_data']}');
            }
          } catch (error) {
            if (mounted) {
              setState(() {
                isCardListLoading = false;
              });
            }
            sentryError.reportError(error, null);
          }
        }).catchError((error) {
          if (mounted) {
            setState(() {
              isCardListLoading = false;
            });
          }
          sentryError.reportError(error, null);
        });
      } else {
        if (mounted) {
          setState(() {
            isCardListLoading = false;
          });
        }
        showSnackbar(
            MyLocalizations.of(context).pleaseentercorrectexpirymonthandyear);
      }
    } else {
      if (mounted) {
        setState(() {
          isCardListLoading = false;
        });
      }
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: GFAppBar(
        title: Text(MyLocalizations.of(context).addCard,
            style: textbarlowSemiBoldBlack()),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black, size: 15.0),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: Row(
                children: <Widget>[
                  Text(
                    MyLocalizations.of(context).cardNumber,
                    style: textBarlowRegularBlack(),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 5.0, bottom: 10.0, left: 20, right: 20),
              child: Container(
                child: TextFormField(
                  maxLength: 16,
                  onSaved: (String value) {
                    cardNumber = value;
                  },
                  validator: (String value) {
                    if (value.isEmpty) {
                      return MyLocalizations.of(context).enteracardnumber;
                    } else if (value.length != 16) {
                      return MyLocalizations.of(context)
                          .pleaseenter16digitcardnumber;
                    } else
                      return null;
                  },
                  style: textBarlowRegularBlack(),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    errorBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 0, color: Color(0xFFF44242))),
                    errorStyle: TextStyle(color: Color(0xFFF44242)),
                    counterText: "",
                    contentPadding: EdgeInsets.all(10),
                    enabledBorder: const OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.grey, width: 0.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: primary),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: Row(
                children: <Widget>[
                  Text(
                    MyLocalizations.of(context).cardHolderName,
                    style: textBarlowRegularBlack(),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 5.0, bottom: 10.0, left: 20, right: 20),
              child: Container(
                child: TextFormField(
                  onSaved: (String value) {
                    cardHolderName = value;
                  },
                  validator: (String value) {
                    if (value.isEmpty) {
                      return MyLocalizations.of(context).entercardHolderName;
                    } else
                      return null;
                  },
                  style: textBarlowRegularBlack(),
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    errorBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 0, color: Color(0xFFF44242))),
                    errorStyle: TextStyle(color: Color(0xFFF44242)),
                    contentPadding: EdgeInsets.all(10),
                    enabledBorder: const OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.grey, width: 0.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: primary),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: Row(
                children: <Widget>[
                  Text(
                    MyLocalizations.of(context).bankName,
                    style: textBarlowRegularBlack(),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 5.0, bottom: 10.0, left: 20, right: 20),
              child: Container(
                child: TextFormField(
                  onSaved: (String value) {
                    bank = value;
                  },
                  validator: (String value) {
                    if (value.isEmpty) {
                      return MyLocalizations.of(context).enterbankname;
                    } else
                      return null;
                  },
                  style: textBarlowRegularBlack(),
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    errorBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 0, color: Color(0xFFF44242))),
                    errorStyle: TextStyle(color: Color(0xFFF44242)),
                    contentPadding: EdgeInsets.all(10),
                    enabledBorder: const OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.grey, width: 0.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: primary),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: Row(
                children: <Widget>[
                  Flexible(
                    flex: 3,
                    fit: FlexFit.tight,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 20.0, right: 20.0),
                          child: Row(
                            children: <Widget>[
                              Text(MyLocalizations.of(context).expiryMonth,
                                  style: textBarlowRegularBlack()),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 5.0,
                            bottom: 10.0,
                            left: 20,
                          ),
                          child: Container(
                            child: TextFormField(
                              maxLength: 2,
                              onSaved: (String value) {
                                expiryMonth = int.parse(value);
                              },
                              validator: (String value) {
                                if (value.isEmpty) {
                                  return MyLocalizations.of(context)
                                      .entercardexpiredmonth;
                                } else if (value.length != 2) {
                                  return MyLocalizations.of(context)
                                      .pleaseentera2digitcardexpiredmonth;
                                } else
                                  return null;
                              },
                              style: textBarlowRegularBlack(),
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 0, color: Color(0xFFF44242))),
                                errorStyle: TextStyle(color: Color(0xFFF44242)),
                                counterText: "",
                                contentPadding: EdgeInsets.all(10),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.grey, width: 0.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: primary),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    flex: 3,
                    fit: FlexFit.tight,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 10.0,
                            right: 10,
                          ),
                          child: Row(
                            children: <Widget>[
                              Text(MyLocalizations.of(context).expiryYear,
                                  style: textBarlowRegularBlack()),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 5.0, bottom: 10.0, left: 10, right: 10),
                          child: Container(
                            child: TextFormField(
                              maxLength: 4,
                              onSaved: (String value) {
                                expiryYear = int.parse(value);
                              },
                              validator: (String value) {
                                if (value.isEmpty) {
                                  return MyLocalizations.of(context)
                                      .enteracardexpiredyear;
                                } else if (value.length != 4) {
                                  return MyLocalizations.of(context)
                                      .pleaseentera4digitcardexpiredyear;
                                } else
                                  return null;
                              },
                              style: textBarlowRegularBlack(),
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 0, color: Color(0xFFF44242))),
                                errorStyle: TextStyle(color: Color(0xFFF44242)),
                                counterText: "",
                                contentPadding: EdgeInsets.all(10),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.grey, width: 0.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: primary),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    fit: FlexFit.tight,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 0.0, right: 20.0),
                          child: Row(
                            children: <Widget>[
                              Text(MyLocalizations.of(context).cvv,
                                  style: textBarlowRegularBlack()),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 5.0, bottom: 10.0, right: 20),
                          child: Container(
                            child: TextFormField(
                              maxLength: 3,
                              onSaved: (String value) {
                                cvv = value;
                              },
                              validator: (String value) {
                                if (value.isEmpty || value.length != 3) {
                                  return MyLocalizations.of(context)
                                      .enteracardCVV;
                                } else if (value.isEmpty || value.length != 3) {
                                  return MyLocalizations.of(context)
                                      .pleaseenter3digitcardCVV;
                                } else
                                  return null;
                              },
                              style: textBarlowRegularBlack(),
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 0, color: Color(0xFFF44242))),
                                errorStyle: TextStyle(color: Color(0xFFF44242)),
                                counterText: "",
                                contentPadding: EdgeInsets.all(10),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.grey, width: 0.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: primary),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 10),
            SizedBox(height: 10),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 55,
        margin: EdgeInsets.only(left: 18, right: 18, bottom: 20),
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.29), blurRadius: 9)
        ]),
        child: GFButton(
          color: primary,
          blockButton: true,
          onPressed: saveCard,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                MyLocalizations.of(context).save,
                style: textBarlowRegularrBlack(),
              ),
              isCardListLoading
                  ? GFLoader(
                      type: GFLoaderType.ios,
                    )
                  : Text("")
            ],
          ),
        ),
      ),
    );
  }

  void showSnackbar(message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: Duration(milliseconds: 3000),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
}
