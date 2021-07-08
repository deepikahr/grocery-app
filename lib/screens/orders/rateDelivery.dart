import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:readymadeGroceryApp/service/localizations.dart';
import 'package:readymadeGroceryApp/service/orderSevice.dart';
import 'package:readymadeGroceryApp/service/sentry-service.dart';
import 'package:readymadeGroceryApp/style/style.dart';
import 'package:readymadeGroceryApp/widgets/appBar.dart';
import 'package:readymadeGroceryApp/widgets/button.dart';

SentryError sentryError = new SentryError();

class RateDelivery extends StatefulWidget {
  final Map? localizedValues, orderHistory;
  final String? locale;
  RateDelivery(
      {Key? key, this.locale, this.localizedValues, this.orderHistory});
  @override
  _RateDeliveryState createState() => _RateDeliveryState();
}

class _RateDeliveryState extends State<RateDelivery> {
  bool isRatingLoading = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKeyForLogin = GlobalKey<FormState>();
  String? discription;
  double ratingValue = 1.0;
  orderCancelMethod() async {
    final form = _formKeyForLogin.currentState!;
    if (form.validate()) {
      form.save();
      if (mounted) {
        setState(() {
          isRatingLoading = true;
        });
      }
      Map body = {
        "rate": ratingValue,
        "description": discription,
        "orderId": widget.orderHistory!['order']['_id'],
        "deliveryBoyId": widget.orderHistory!['order']["assignedToId"]
      };
      await OrderService.deliveryRating(body).then((onValue) {
        if (mounted) {
          setState(() {
            isRatingLoading = false;
            showSnackbar(onValue['response_data']);
            Future.delayed(Duration(milliseconds: 3000), () {
              Navigator.of(context).pop(true);
            });
          });
        }
      }).catchError((error) {
        if (mounted) {
          setState(() {
            isRatingLoading = false;
          });
        }
        sentryError.reportError(error, null);
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
      appBar: appBarPrimary(context, "RATE_DELIVERY") as PreferredSizeWidget?,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: InkWell(
            onTap: orderCancelMethod,
            child: buttonprimary(context, "SUBMIT_FEEDBACK", isRatingLoading)),
      ),
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 15),
            child: Image.asset('lib/assets/images/rate.png'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  MyLocalizations.of(context)!
                      .getLocalizations('YOUR_ORDER_WAS_DELIVERED_BY'),
                  style: textBarlowMediumsmBlackk(context),
                ),
                Flexible(
                  child: Text(
                    MyLocalizations.of(context)!.getLocalizations(
                        widget.orderHistory!['order']["assignedToName"]),
                    style: textBarlowMediumsmBlackk(context),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Text(
            MyLocalizations.of(context)!
                .getLocalizations('PLEASE_SUBMIT_YOUR_FEEDBACK'),
            style: textBarlowRegularBlackdl(context),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: RatingBar.builder(
              initialRating: 3,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: primary(context),
              ),
              onRatingUpdate: (rating) {
                setState(() {
                  ratingValue = rating;
                });
              },
            ),
          ),
          Form(
            key: _formKeyForLogin,
            child: Container(
              margin:
                  EdgeInsets.only(top: 5.0, bottom: 10.0, left: 20, right: 20),
              child: TextFormField(
                style: textBarlowRegularBlack(context),
                keyboardType: TextInputType.text,
                maxLines: 5,
                onSaved: (String? value) {
                  discription = value;
                },
                validator: (String? value) {
                  if (value!.isEmpty) {
                    return null;
                  } else
                    return null;
                },
                decoration: InputDecoration(
                  hintText: MyLocalizations.of(context)!
                      .getLocalizations("TELL_US_YOUR_EXPERIENCE"),
                  hintStyle: textbarlowRegularaddwithop(context),
                  errorStyle: TextStyle(color: Color(0xFFF44242)),
                  fillColor: dark(context),
                  focusColor: dark(context),
                  contentPadding: EdgeInsets.only(
                      left: 15.0, right: 15.0, top: 10.0, bottom: 10.0),
                  enabledBorder: const OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.grey, width: 0.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: primary(context)),
                  ),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
