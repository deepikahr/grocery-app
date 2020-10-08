import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:readymadeGroceryApp/service/localizations.dart';
import 'package:readymadeGroceryApp/style/style.dart';
import 'package:readymadeGroceryApp/widgets/appBar.dart';
import 'package:readymadeGroceryApp/widgets/button.dart';

class RateDelivery extends StatefulWidget {
  final Map localizedValues;
  final String locale;
  RateDelivery({Key key, this.locale, this.localizedValues});
  @override
  _RateDeliveryState createState() => _RateDeliveryState();
}

class _RateDeliveryState extends State<RateDelivery> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarPrimary(context, "RATE_DELIVERY"),
      bottomNavigationBar: Container(
          color: Colors.transparent,
          margin: EdgeInsets.symmetric(horizontal: 18),
          child: buttonPrimary(context, "SUBMIT_FEEDBACK", false)),
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
                  MyLocalizations.of(context)
                      .getLocalizations('YOUR_ORDER_WAS_DELIVERED_BY'),
                  style: textBarlowMediumsmBlackk(),
                ),
                Flexible(
                  child: Text(
                    MyLocalizations.of(context).getLocalizations('john doe'),
                    style: textBarlowMediumsmBlackk(),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Text(
            MyLocalizations.of(context)
                .getLocalizations('PLEASE_SUBMIT_YOUR_FEEDBACK'),
            style: textBarlowRegularBlackdl(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: RatingBar(
              initialRating: 3,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: primary,
              ),
              onRatingUpdate: (rating) {
                print(rating);
              },
            ),
          ),
          Container(
            margin:
                EdgeInsets.only(top: 5.0, bottom: 10.0, left: 20, right: 20),
            child: TextFormField(
              style: textBarlowRegularBlack(),
              keyboardType: TextInputType.text,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: MyLocalizations.of(context)
                    .getLocalizations("TELL_US_YOUR_EXPERIENCE"),
                hintStyle: textbarlowRegularaddwithop(),
                errorStyle: TextStyle(color: Color(0xFFF44242)),
                fillColor: Colors.black,
                focusColor: Colors.black,
                contentPadding: EdgeInsets.only(
                  left: 15.0,
                  right: 15.0,
                  top: 10.0,
                  bottom: 10.0,
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey, width: 0.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: primary),
                ),
              ),
            ),
          )
        ]),
      ),
    );
  }
}
