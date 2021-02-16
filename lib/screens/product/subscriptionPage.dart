import 'package:flutter/material.dart';
import 'package:getflutter/getwidget.dart';
import 'package:readymadeGroceryApp/service/localizations.dart';
import 'package:readymadeGroceryApp/screens/thank-you/thankyou.dart';
import 'package:readymadeGroceryApp/style/style.dart';
import 'package:readymadeGroceryApp/widgets/appBar.dart';
import 'package:readymadeGroceryApp/widgets/button.dart';
import 'package:readymadeGroceryApp/widgets/normalText.dart';
import '../../service/sentry-service.dart';

SentryError sentryError = new SentryError();

class SubscriptionPage extends StatefulWidget {
  SubscriptionPage({Key key, this.locale, this.localizedValues})
      : super(key: key);

  final Map localizedValues;
  final String locale;

  @override
  _SubscriptionPageState createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  bool isSelected = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBarPrimarynoradius(context, "SUBSCRIBE"),
      body: ListView(
        children: <Widget>[
          SizedBox(height: 20),
          Container(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            decoration: BoxDecoration(color: Color(0xFFF7F7F7)),
            child: Row(
              children: [
                Flexible(
                    flex: 4,
                    child: Image.asset(
                      "lib/assets/images/product.png",
                      width: 117,
                      height: 113,
                      fit: BoxFit.cover,
                    )),
                SizedBox(width: 5),
                Flexible(
                  flex: 6,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      normallText(context, "Nandini"),
                      SizedBox(height: 5),
                      regularTextatStart(context,
                          "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium"),
                      SizedBox(height: 10),
                      regularTextblack87(context, "500ml"),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          regularTextatStart(context, "SUBSCRIPTION_PRICE"),
                          priceMrpText("\$89", "",context)
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 5),
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: Container(
                    height: 110,
                    width: 43,
                    decoration: BoxDecoration(
                      color: Color(0xFFF0F0F0),
                      borderRadius: BorderRadius.all(
                        Radius.circular(22),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: primary(context),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: InkWell(
                            child: Icon(Icons.add),
                          ),
                        ),
                        Text('0'),
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: InkWell(
                            child: Icon(Icons.remove, color: primary(context)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Container(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
            decoration: BoxDecoration(color: Color(0xFFF7F7F7)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                regularTextblackbold(context, "PICK_SCHEDULE"),
                Container(
                  height: 90,
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: GridView.builder(
                    itemCount: 5,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio:
                            MediaQuery.of(context).size.width / 120,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10),
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {
                          setState(() {
                            isSelected = !isSelected;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: isSelected
                                  ? primary(context).withOpacity(0.3)
                                  : Colors.white,
                              border: isSelected
                                  ? Border.all(color: primary(context))
                                  : Border.all(color: Colors.grey[300]),
                              borderRadius: BorderRadius.circular(17)),
                          child: Center(
                            child: new Text(
                              "Daily",
                              style: textbarlowRegularBlackb(context),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Divider(),
                SizedBox(height: 15),
                regularTextatStart(context, "SUBSCRIPTION_STARTS_ON"),
                SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.only(left: 2.0, right: 0),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey[300]),
                        borderRadius: BorderRadius.circular(5.0)),
                    child: FlatButton(
                        onPressed: () {},
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('12/12/1234'),
                              Icon(Icons.calendar_today, color: Colors.black),
                            ],
                          ),
                        )),
                  ),
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buildProductTitle("SERVICE_CHARGES",context),
                    buildProductTitle("\$1",context),
                  ],
                ),
                SizedBox(height: 15),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: regularTextblackbold(context, "COUPON_CODE"),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: 193,
                  height: 44,
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(left: 0.0, bottom: 3),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Color(0xFFD4D4E0),
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(4),
                    ),
                  ),
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                        hintText: MyLocalizations.of(context)
                            .getLocalizations("ENTER_COUPON_CODE"),
                        hintStyle: textBarlowRegularBlacklight(context),
                        labelStyle: TextStyle(color: Colors.black),
                        border: InputBorder.none),
                    cursorColor: primary(context),
                    style: textBarlowRegularBlacklight(context),
                  ),
                ),
                Flexible(
                  flex: 3,
                  fit: FlexFit.tight,
                  child: InkWell(
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: applyCoupon(context, "APPLY", false),
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: regularTextblackbold(context, "DELIVERY_ADDRESS"),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 3),
            child: GFAccordion(
              collapsedTitlebackgroundColor: Color(0xFFF0F0F0),
              titleborder: Border.all(color: Color(0xffD6D6D6)),
              contentbackgroundColor: Colors.white,
              contentPadding: EdgeInsets.only(top: 5, bottom: 5),
              titleChild: Row(
                children: [
                  Image.asset("lib/assets/icons/map.png",
                      width: 16, height: 23),
                  SizedBox(width: 5),
                  Text(
                    MyLocalizations.of(context).getLocalizations("ADDRESS_MSG"),
                    overflow: TextOverflow.clip,
                    maxLines: 1,
                    style: textBarlowRegularBlack(context),
                  ),
                ],
              ),
              contentChild: Column(
                children: <Widget>[
                  ListView.builder(
                    physics: ScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: 2,
                    itemBuilder: (BuildContext context, int i) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          RadioListTile(
                            groupValue: 0,
                            activeColor: primary(context),
                            value: i,
                            title: Text(
                                "braja nagar ,2nd lane , berhampur , odisha "),
                            onChanged: (int value) {},
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(left: 0.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    InkWell(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: primaryOutlineButton(
                                            context, "EDIT"),
                                      ),
                                    ),
                                    InkWell(
                                        child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20.0),
                                      child: primaryOutlineButton(
                                          context, "DELETE"),
                                    )),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 20, right: 20),
                            child: Divider(thickness: 1),
                          ),
                        ],
                      );
                    },
                  ),
                  SizedBox(height: 20),
                  InkWell(
                      child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 80.0),
                    child: dottedBorderButton(context, "ADD_NEW_ADDRESS"),
                  )),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 100.0,
        color: Colors.transparent,
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 14),
        child: Column(
          children: [
            InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Thankyou()),
                  );
                },
                child: regularbuttonPrimary(context, "Suscribe(\$210/month)")),
            SizedBox(height: 4),
            regularTextblack87(context, "DEBIT_MSG"),
            SizedBox(height: 4),
          ],
        ),
      ),
    );
  }
}
