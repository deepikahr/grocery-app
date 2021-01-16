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

class ModifySubscription extends StatefulWidget {
  ModifySubscription({Key key, this.locale, this.localizedValues})
      : super(key: key);

  final Map localizedValues;
  final String locale;

  @override
  _ModifySubscriptionState createState() => _ModifySubscriptionState();
}

class _ModifySubscriptionState extends State<ModifySubscription> {
  bool isSelected = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBarPrimary(context, "MODIFY"),
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
                          priceMrpText("\$89", "")
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
                            color: primary,
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
                            child: Icon(Icons.remove, color: primary),
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
                                  ? primary.withOpacity(0.3)
                                  : Colors.white,
                              border: isSelected
                                  ? Border.all(color: primary)
                                  : Border.all(color: Colors.grey[300]),
                              borderRadius: BorderRadius.circular(17)),
                          child: Center(
                            child: new Text(
                              "Daily",
                              style: textbarlowRegularBlackb(),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 15),
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
                    style: textBarlowRegularBlack(),
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
                            activeColor: primary,
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
        height: 155.0,
        color: Colors.transparent,
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 14),
        child: Column(
          children: [
            regularGreyButton(context, "CANCEL_SUBSCRIPTION"),
            InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Thankyou()),
                  );
                },
                child: regularbuttonPrimary(context, "UPDATE_CHANGES")),
            SizedBox(height: 4),
          ],
        ),
      ),
    );
  }
}
