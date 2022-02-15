import 'package:flutter/material.dart';
import 'package:readymadeGroceryApp/screens/authe/login.dart';
import 'package:readymadeGroceryApp/service/common.dart';
import 'package:readymadeGroceryApp/service/localizations.dart';
import 'package:readymadeGroceryApp/service/sentry-service.dart';
import 'package:readymadeGroceryApp/style/style.dart';
import 'package:readymadeGroceryApp/widgets/button.dart';
import 'package:readymadeGroceryApp/widgets/normalText.dart';

SentryError sentryError = new SentryError();

class SubsCriptionBottomSheet extends StatefulWidget {
  final List? variantsList;
  final String? currency, locale;
  final Map? localizedValues;
  final Map<String, dynamic>? productData;

  SubsCriptionBottomSheet(
      {Key? key,
      this.variantsList,
      this.productData,
      this.currency,
      this.locale,
      this.localizedValues})
      : super(key: key);
  @override
  _SubsCriptionBottomSheetState createState() =>
      _SubsCriptionBottomSheetState();
}

class _SubsCriptionBottomSheetState extends State<SubsCriptionBottomSheet> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int? groupValue = 0;
  bool selectVariant = false, getTokenValue = false;

  @override
  void initState() {
    super.initState();
  }

  getToken() async {
    await Common.getToken().then((onValue) {
      if (onValue != null) {
        if (mounted) {
          setState(() {
            getTokenValue = true;
            Map subProduct = {
              "products": [
                {
                  "productId": widget.productData!['_id'],
                  "productName": widget.productData!['title'],
                  "variantId": widget.productData!['variant'][groupValue]
                      ['_id'],
                  "unit": widget.productData!['variant'][groupValue]['unit'],
                  "subScriptionAmount": widget.productData!['variant']
                      [groupValue]['subScriptionAmount'],
                  "productDescription": widget.productData!['description']
                },
              ],
            };
            subProduct['products'][0]["subscriptionTotal"] =
                subProduct['products'][0]['subScriptionAmount'] * 1;
            Navigator.of(context).pop(subProduct);
          });
        }
      } else {
        if (mounted) {
          setState(() {
            getTokenValue = false;
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => Login(
                  locale: widget.locale,
                  localizedValues: widget.localizedValues,
                  isBottomSheet: true,
                ),
              ),
            );
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: bg(context),
        key: _scaffoldKey,
        body: ListView.builder(
            physics: ScrollPhysics(),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            padding: EdgeInsets.only(right: 0.0),
            itemCount: widget.variantsList!.length,
            itemBuilder: (BuildContext context, int index) {
              return new RadioListTile(
                value: index,
                groupValue: groupValue,
                selected: selectVariant,
                onChanged: (int? selected) {
                  if (mounted) {
                    setState(() {
                      groupValue = selected;
                      selectVariant = !selectVariant;
                    });
                  }
                },
                activeColor: primary(context),
                secondary: textGreenprimary(
                    context,
                    '${widget.variantsList![index]['unit']} ',
                    textbarlowBoldGreen(context)),
                title: priceMrpText(
                    '${widget.currency}${(widget.variantsList![index]['price']).toStringAsFixed(2)}',
                    null,
                    context),
                subtitle: priceMrpText(
                    "${MyLocalizations.of(context)!.getLocalizations("SUBSCRIBE")} @${widget.currency}${widget.productData!['variant'][index]['subScriptionAmount']}",
                    null,
                    context),
              );
            }),
        bottomNavigationBar: InkWell(
          onTap: getToken,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: productAddButton(context, "ADD", false),
          ),
        ));
  }

  void showSnackbar(message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(milliseconds: 3000),
      ),
    );
  }
}
