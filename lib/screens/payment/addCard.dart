import 'package:flutter/material.dart';
import 'package:getflutter/components/appbar/gf_appbar.dart';
import 'package:getflutter/getflutter.dart';
import 'package:grocery_pro/service/payment-service.dart';
import 'package:grocery_pro/service/sentry-service.dart';
import 'package:grocery_pro/style/style.dart';
import 'package:intl/intl.dart';

SentryError sentryError = new SentryError();

class AddCard extends StatefulWidget {
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
                    title: new Text('Success'),
                    content: new SingleChildScrollView(
                      child: new ListBody(
                        children: <Widget>[
                          new Text('${onValue['response_data']}'),
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      new FlatButton(
                        child: new Text('OK'),
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
            sentryError.reportError(error, null);
          }
        }).catchError((error) {
          print('Error at 2');
          sentryError.reportError(error, null);
        });
      } else {
        if (mounted) {
          setState(() {
            isCardListLoading = false;
          });
        }
        showSnackbar("Please Enter Correct Expiry Month and Year");
      }
    } else {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: GFAppBar(
        title: Text('Add Card',
            style: TextStyle(
                color: Colors.black,
                fontSize: 17.0,
                fontWeight: FontWeight.w600)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black, size: 15.0),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Row(
                    children: <Widget>[
                      Text('Card Number'),
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
                        if (value.isEmpty || value.length != 16) {
                          return "Please Enter a Card Number";
                        } else
                          return null;
                      },
                      style: labelStyle(),
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
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
              ],
            ),
            SizedBox(height: 10),
            Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Row(
                    children: <Widget>[
                      Text('Card Holder Name'),
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
                          return "Please Enter a Card holder name";
                        } else
                          return null;
                      },
                      style: labelStyle(),
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
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
              ],
            ),
            SizedBox(height: 10),
            Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Row(
                    children: <Widget>[
                      Text('Card Bank Name'),
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
                          return "Please Enter a Card Bank name";
                        } else
                          return null;
                      },
                      style: labelStyle(),
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
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
              ],
            ),
            SizedBox(height: 10),
            Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Row(
                    children: <Widget>[
                      Text('Card Expire Month'),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 5.0, bottom: 10.0, left: 20, right: 200),
                  child: Container(
                    child: TextFormField(
                      maxLength: 2,
                      onSaved: (String value) {
                        expiryMonth = int.parse(value);
                      },
                      validator: (String value) {
                        if (value.isEmpty || value.length != 2) {
                          return "Please Enter a Card Correct Card Expired Month";
                        } else
                          return null;
                      },
                      style: labelStyle(),
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
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
              ],
            ),
            SizedBox(height: 10),
            Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Row(
                    children: <Widget>[
                      Text('Card Expire Year'),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 5.0, bottom: 10.0, left: 20, right: 200),
                  child: Container(
                    child: TextFormField(
                      maxLength: 4,
                      onSaved: (String value) {
                        expiryYear = int.parse(value);
                      },
                      validator: (String value) {
                        if (value.isEmpty || value.length != 4) {
                          return "Please Enter a Card Correct Card Expired Year";
                        } else
                          return null;
                      },
                      style: labelStyle(),
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
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
              ],
            ),
            SizedBox(height: 10),
            Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Row(
                    children: <Widget>[
                      Text('Card Expire CVV'),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 5.0, bottom: 10.0, left: 20, right: 200),
                  child: Container(
                    child: TextFormField(
                      maxLength: 3,
                      onSaved: (String value) {
                        cvv = value;
                      },
                      validator: (String value) {
                        if (value.isEmpty || value.length != 3) {
                          return "Please Enter a Card Correct Card CVV";
                        } else
                          return null;
                      },
                      style: labelStyle(),
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
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
              ],
            ),
          ],
        ),
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
            onPressed: saveCard,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Save"),
                isCardListLoading
                    ? Image.asset(
                        'lib/assets/images/spinner.gif',
                        width: 15.0,
                        height: 15.0,
                        color: Colors.black,
                      )
                    : Text("")
              ],
            ),
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
