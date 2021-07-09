import 'package:flutter/material.dart';
import 'package:readymadeGroceryApp/screens/tab/add_money_web_view.dart';
import 'package:readymadeGroceryApp/service/common.dart';
import 'package:readymadeGroceryApp/service/localizations.dart';
import 'package:readymadeGroceryApp/service/orderSevice.dart';
import 'package:readymadeGroceryApp/service/sentry-service.dart';
import 'package:readymadeGroceryApp/style/style.dart';
import 'package:readymadeGroceryApp/widgets/appBar.dart';
import 'package:readymadeGroceryApp/widgets/button.dart';
import 'package:readymadeGroceryApp/widgets/normalText.dart';

SentryError sentryError = new SentryError();

class AddMoney extends StatefulWidget {
  final Map? localizedValues;
  final String? locale;

  AddMoney({Key? key, this.locale, this.localizedValues});

  @override
  _AddMoneyState createState() => _AddMoneyState();
}

class _AddMoneyState extends State<AddMoney> {
  String currency = "";
  double? walletAmmount;
  bool isAddMoneyLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    Common.getCurrency().then((value) => setState(() => currency = value));
    super.initState();
  }

  addMoney() async {
    final form = _formKey.currentState!;
    if (form.validate()) {
      form.save();
      setState(() {
        isAddMoneyLoading = true;
      });
      Map body = {"amount": walletAmmount};
      await OrderService.addMoneyApi(body).then((onValue) {
        if (mounted) {
          setState(() {
            isAddMoneyLoading = false;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => AddMoneyWebViewPage(
                    locale: widget.locale,
                    localizedValues: widget.localizedValues,
                    sessionId: onValue['response_data']['sessionId'],
                    userId: onValue['response_data']['userId']),
              ),
            );
          });
        }
      }).catchError((error) {
        if (mounted) {
          setState(() {
            isAddMoneyLoading = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar:
            appBarPrimarynoradius(context, "ADD_MONEY") as PreferredSizeWidget?,
        body: InkWell(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 14),
            child: Form(
              key: _formKey,
              child: ListView(
                shrinkWrap: true,
                children: [
                  SizedBox(height: 40),
                  buildImageView(),
                  buildAddMoneyTextDescription(),
                  buildLabelText(),
                  buildTextField(),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: Container(
          height: 80.0,
          color: Colors.transparent,
          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 14),
          child: Column(
            children: [
              InkWell(
                  onTap: addMoney,
                  child: regularbuttonPrimary(
                      context, "ADD_MONEY", isAddMoneyLoading)),
              SizedBox(height: 4),
            ],
          ),
        ),
      );

  Widget buildLabelText() {
    return buildGFTypography(context, "AMOUNT", false, false);
  }

  Widget buildTextField() {
    return Container(
      margin: EdgeInsets.only(top: 5.0, bottom: 10.0),
      child: TextFormField(
        onSaved: (String? value) {
          if (value!.length > 0) {
            walletAmmount = double.parse(value);
          }
        },
        validator: (String? value) {
          double enteredVal;
          if (value!.isEmpty) {
            return MyLocalizations.of(context)!
                .getLocalizations("ENTER_ADD_VALID_AMOUNT");
          } else {
            try {
              enteredVal = double.parse(value);
            } catch (e) {
              try {
                enteredVal = int.parse(value).toDouble();
              } catch (e) {
                return MyLocalizations.of(context)!
                    .getLocalizations("ENTER_ADD_VALID_AMOUNT");
              }
            }
            if (value.isEmpty || enteredVal < 0) {
              return MyLocalizations.of(context)!
                  .getLocalizations("ENTER_ADD_VALID_AMOUNT");
            }
            return null;
          }
        },
        style: textBarlowRegularBlack(context),
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 0,
              color: Color(0xFFF44242),
            ),
          ),
          errorStyle: TextStyle(color: Color(0xFFF44242)),
          fillColor: Colors.black,
          focusColor: Colors.black,
          contentPadding:
              EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0, bottom: 10.0),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(top: 15.0, bottom: 15, left: 12),
            child: Text(
              MyLocalizations.of(context)!.getLocalizations(currency, true),
              style: textbarlowmediumwblack(context),
            ),
          ),
          hintText: "00.00",
          enabledBorder: const OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey, width: 0.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: primary(context)),
          ),
        ),
      ),
    );
  }

  buildImageView() =>
      Image.asset('lib/assets/images/addMoney.png', height: 300);

  buildAddMoneyTextDescription() => Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Text(
          MyLocalizations.of(context)!.getLocalizations(
              "PLEASE_ENTER_THE_AMOUNT_YOU_WANT_TO_ADD_IN_THE_WALLET"),
          style: textBarlowRegularBlack(context),
          textAlign: TextAlign.center,
        ),
      );
}
