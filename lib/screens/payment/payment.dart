import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';
import 'package:grocery_pro/screens/payment/addCard.dart';
import 'package:grocery_pro/screens/thank-you/thankyou.dart';
import 'package:grocery_pro/service/payment-service.dart';
import 'package:grocery_pro/service/sentry-service.dart';
import 'package:grocery_pro/style/style.dart';
import 'package:grocery_pro/service/product-service.dart';
import 'package:shared_preferences/shared_preferences.dart';

SentryError sentryError = new SentryError();

class Payment extends StatefulWidget {
  final int quantity;
  final String type;
  final int grandTotal;
  final int currentIndex;
  final Map<String, dynamic> data;

  Payment(
      {Key key,
      this.data,
      this.quantity,
      this.currentIndex,
      this.type,
      this.grandTotal})
      : super(key: key);
  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int selectedRadio,
      cashOnDelivery = 0,
      payByCard = 1,
      groupValue = 0,
      cardValue = 0;
  String paymentType, cvv, selectedPaymentType, cardID, currency;
  bool isPlaceOrderLoading = false,
      ispaymentMethodLoading = false,
      isFirstTime = true,
      isCardDelete = false,
      isCardListLoading = false;
  var paymentMethodValue;
  List cardList;

  List<Map<String, dynamic>> paymentTypes = [
    {
      'type': 'COD',
      'icon': Icons.attach_money,
      'gateway': 'COD',
      'isSelected': true
    },
    {
      'type': 'CARD',
      'icon': Icons.credit_card,
      'gateway': 'CARD',
      'isSelected': false
    },
  ];

  @override
  void initState() {
    fetchCardInfo();
    super.initState();
  }

  fetchCardInfo() async {
    if (mounted) {
      setState(() {
        isCardListLoading = true;
      });
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    currency = prefs.getString('currency');
    await PaymentService.getCardList().then((onValue) {
      if (mounted) {
        setState(() {
          cardList = onValue['response_data'];
          isCardListLoading = false;
        });
      }
    });
  }

  deleteCard(id) async {
    if (mounted) {
      setState(() {
        isCardDelete = true;
      });
    }
    await PaymentService.deleteCard(id).then((onValue) {
      if (mounted) {
        setState(() {
          fetchCardInfo();
          isCardDelete = false;
          Navigator.pop(context);
        });
      }
    });
  }

  placeOrder() async {
    if (mounted) {
      setState(() {
        isPlaceOrderLoading = true;
      });
    }

    if (groupValue == null) {
      widget.data['paymentType'] = "COD";
    } else {
      widget.data['paymentType'] = paymentMethodValue.toString();
    }

    if (widget.data['paymentType'] == "CARD") {
      if (cardID == null) {
        cardID = cardList[0]['_id'];
      }
      widget.data['cardId'] = cardID.toString();

      await ProductService.placeOrderCardType(widget.data).then((onValue) {
        print(onValue);
        try {
          if (onValue['response_code'] == 201) {
            if (mounted) {
              setState(() {
                isPlaceOrderLoading = false;
              });
            }

            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => Thankyou(),
                ),
                (Route<dynamic> route) => false);
          } else {
            if (mounted) {
              setState(() {
                isPlaceOrderLoading = false;
              });
            }
          }
        } catch (error, stackTrace) {
          sentryError.reportError(error, stackTrace);
        }
      }).catchError((error) {
        sentryError.reportError(error, null);
      });
    } else {
      await ProductService.placeOrder(widget.data).then((onValue) {
        try {
          if (onValue['response_code'] == 201) {
            if (mounted) {
              setState(() {
                isPlaceOrderLoading = false;
              });
            }
            showDialog<Null>(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return Container(
                  width: 270.0,
                  child: new AlertDialog(
                    title: new Text('Thank You ...!!'),
                    content: new SingleChildScrollView(
                      child: new ListBody(
                        children: <Widget>[
                          new Text('Order Successful'),
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      new FlatButton(
                        child: new Text('ok'),
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) => Thankyou(),
                              ),
                              (Route<dynamic> route) => false);
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          } else {
            if (mounted) {
              setState(() {
                isPlaceOrderLoading = false;
              });
            }
          }
        } catch (error, stackTrace) {
          sentryError.reportError(error, stackTrace);
        }
      }).catchError((error) {
        sentryError.reportError(error, null);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isFirstTime) {
      paymentMethodValue = 'COD';
      isFirstTime = false;
    }
    Widget paymentMethod() {
      return isCardListLoading
          ? Center(child: CircularProgressIndicator())
          : Container(
              margin: EdgeInsetsDirectional.only(top: 10.0),
              decoration: BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.16), blurRadius: 4.0)
              ]),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 15.0),
                    child: new Text(
                      'Select Card',
                    ),
                  ),
                  RawMaterialButton(
                    onPressed: () {
                      var result = Navigator.push(
                          context,
                          new MaterialPageRoute(
                            builder: (BuildContext context) => new AddCard(),
                          ));

                      if (result != null) {
                        result.then((onValue) {
                          fetchCardInfo();
                          if (mounted) {
                            setState(() {
                              cardList = cardList;
                            });
                          }
                        });
                      }
                    },
                    child: new Text(
                      'Add Card',
                    ),
                  ),
                ],
              ),
            );
    }

    Widget buildSaveCardInfo() {
      return cardList.length == 0
          ? Center(
              child: Text(
                'No Saved Cards. Please add one!',
              ),
            )
          : ListView.builder(
              physics: ScrollPhysics(),
              shrinkWrap: true,
              itemCount: cardList.length,
              itemBuilder: (BuildContext context, int index) {
                return RadioListTile(
                  value: index,
                  groupValue: cardValue,
                  activeColor: primary,
                  title: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                      decoration: BoxDecoration(
                          color: Colors.blue[400],
                          borderRadius: BorderRadius.circular(5.0)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 38.0, top: 20.0),
                                child: cardList[index]['cardImage'] == null
                                    ? Image.asset(
                                        'lib/assets/icons/mastercard-logo.png')
                                    : Image.network(
                                        '${cardList[index]['cardImage']}'),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 15.0),
                                child: Text(
                                  '${cardList[index]['bank']}',
                                  style: TextStyle(
                                      fontSize: 19.0, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 15.0),
                              child: Text(
                                '************${cardList[index]['lastFourDigits']}',
                                style: TextStyle(
                                    fontSize: 19.0, color: Colors.white),
                              ),
                            ),
                          ),
                          SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Text(
                                    'Card holder',
                                    style: TextStyle(
                                        fontSize: 12.0, color: Colors.white),
                                  ),
                                  Text(
                                    '${cardList[index]['cardHolderName']}',
                                    style: TextStyle(
                                        fontSize: 12.0, color: Colors.white),
                                  ),
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  Text(
                                    'Expires',
                                    style: TextStyle(
                                        fontSize: 12.0, color: Colors.white),
                                  ),
                                  Text(
                                    '${cardList[index]['expiryMonth']}/${cardList[index]['expiryYear']}',
                                    style: TextStyle(
                                        fontSize: 12.0, color: Colors.white),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  onChanged: (int selected) {
                    if (mounted) {
                      setState(() {
                        cardValue = selected;
                        cardID = cardList[index]['_id'];
                      });
                    }
                  },
                  secondary: InkWell(
                    onTap: () {
                      showDialog<Null>(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return Container(
                            width: 270.0,
                            child: new AlertDialog(
                              title: new Text('Are You Sure?'),
                              content: new SingleChildScrollView(
                                child: new ListBody(
                                  children: <Widget>[
                                    new Text('Delete Card'),
                                  ],
                                ),
                              ),
                              actions: <Widget>[
                                new FlatButton(
                                  child: new Text('Cancel'),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                                new FlatButton(
                                  child: isCardDelete
                                      ? Image.asset(
                                          'lib/assets/images/spinner.gif',
                                          width: 10.0,
                                          height: 10.0,
                                          color: Colors.black,
                                        )
                                      : Text('ok'),
                                  onPressed: () {
                                    deleteCard(cardList[index]['_id']);
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    child: Icon(
                      Icons.delete,
                      color: primary,
                    ),
                  ),
                );
              },
            );
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: GFAppBar(
        title: Text('Payment',
            style: TextStyle(
                color: Colors.black,
                fontSize: 17.0,
                fontWeight: FontWeight.w600)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black, size: 15.0),
      ),
      body: isCardListLoading
          ? Center(child: CircularProgressIndicator())
          : ListView(
              children: <Widget>[
                Container(
                  color: Colors.grey[100],
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 8.0, bottom: 8.0, left: 20, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Text(
                              'Total',
                              style: boldHeading(),
                            ),
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Text(
                                    currency,
                                    style: boldHeading(),
                                  ),
                                ),
                                Text(
                                  '${widget.grandTotal.toString()}',
                                  style: boldHeading(),
                                ),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Column(
                  children: [
                    ListView.builder(
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      padding: EdgeInsets.only(right: 0.0),
                      itemCount: paymentTypes.length,
                      itemBuilder: (BuildContext context, int index) {
                        if (widget.grandTotal >= 50) {
                          paymentTypes[0]['isSelected'] = true;
                          paymentTypes[1]['isSelected'] = true;
                        } else {
                          paymentTypes[0]['isSelected'] = true;
                          paymentTypes[1]['isSelected'] = false;
                        }
                        return paymentTypes[index]['isSelected'] == true
                            ? Container(
                                margin: EdgeInsets.all(8.0),
                                color: Colors.white,
                                child: RadioListTile(
                                  value: index,
                                  groupValue: groupValue,
                                  selected: paymentTypes[index]['isSelected'],
                                  activeColor: primary,
                                  title: Text(
                                    paymentTypes[index]['type'],
                                    style: TextStyle(color: primary),
                                  ),
                                  onChanged: (int selected) {
                                    if (mounted) {
                                      setState(() {
                                        groupValue = selected;
                                        paymentTypes[index]['isSelected'] =
                                            !paymentTypes[index]['isSelected'];

                                        paymentMethodValue =
                                            paymentTypes[index]['type'];
                                        if (paymentTypes[index]['type'] ==
                                            "COD") {
                                          ispaymentMethodLoading = false;
                                        }
                                      });
                                    }
                                  },
                                  secondary:
                                      paymentTypes[index]['type'] == "COD"
                                          ? Icon(
                                              Icons.attach_money,
                                              color: primary,
                                              size: 16.0,
                                            )
                                          : Icon(
                                              Icons.credit_card,
                                              color: primary,
                                              size: 16.0,
                                            ),
                                ),
                              )
                            : Container();
                      },
                    ),
                  ],
                ),
                paymentMethodValue != 'COD' ? paymentMethod() : Container(),
                paymentMethodValue != 'COD' ? buildSaveCardInfo() : Container(),
              ],
            ),
      bottomNavigationBar: Container(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 20.0,
            right: 20.0,
          ),
          child: GFButton(
            color: GFColors.WARNING,
            blockButton: true,
            onPressed: placeOrder,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Pay Now"),
                isPlaceOrderLoading
                    ? Image.asset(
                        'lib/assets/images/spinner.gif',
                        width: 15.0,
                        height: 15.0,
                        color: Colors.black,
                      )
                    : Text("")
              ],
            ),
            textStyle: TextStyle(fontSize: 17.0, color: Colors.black),
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
