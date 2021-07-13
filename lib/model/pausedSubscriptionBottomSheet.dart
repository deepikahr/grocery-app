import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:intl/intl.dart';
import 'package:readymadeGroceryApp/service/alert-service.dart';
import 'package:readymadeGroceryApp/service/localizations.dart';
import 'package:readymadeGroceryApp/service/sentry-service.dart';
import 'package:readymadeGroceryApp/style/style.dart';
import 'package:readymadeGroceryApp/widgets/button.dart';
import 'package:readymadeGroceryApp/widgets/normalText.dart';

SentryError sentryError = new SentryError();

class PausedSubscriptionBottomSheet extends StatefulWidget {
  final String? locale;
  final Map? localizedValues;
  final DateTime? subscriptionStartDate;

  PausedSubscriptionBottomSheet(
      {Key? key, this.locale, this.localizedValues, this.subscriptionStartDate})
      : super(key: key);
  @override
  _PausedSubscriptionBottomSheetState createState() =>
      _PausedSubscriptionBottomSheetState();
}

class _PausedSubscriptionBottomSheetState
    extends State<PausedSubscriptionBottomSheet> {
  DateTime? startDate, endDate;
  @override
  void initState() {
    startDate = endDate = widget.subscriptionStartDate;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: bg(context),
          boxShadow: [
            new BoxShadow(
              color: Colors.black,
              blurRadius: 1.0,
            ),
          ],
          borderRadius: new BorderRadius.only(
            topLeft: Radius.circular(40.0),
            topRight: Radius.circular(40.0),
          )),
      child: ListView(children: <Widget>[
        Container(
          height: 52,
          decoration: BoxDecoration(
            borderRadius: new BorderRadius.only(
              topLeft: Radius.circular(40.0),
              topRight: Radius.circular(40.0),
            ),
            color: bg(context),
          ),
          child: whiteText(context, "PAUSE_SUBSCRIPTION"),
        ),
        SizedBox(height: 15),
        Container(
          padding: const EdgeInsets.only(left: 15.0, right: 15),
          child: regularTextatStart(context, "FROM"),
        ),
        SizedBox(height: 5),
        Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15),
          child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: cartCardBg(context),
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(5.0)),
            child: GFButton(
                color: Colors.transparent,
                onPressed: () {
                  DatePicker.showDatePicker(context,
                      showTitleActions: true,
                      minTime: widget.subscriptionStartDate, onConfirm: (date) {
                    if (mounted) {
                      setState(() {
                        startDate = date;
                      });
                    }
                  },
                      currentTime: widget.subscriptionStartDate,
                      locale: LocaleType.en);
                },
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(DateFormat('dd/MM/yyyy').format(startDate!)),
                      Icon(Icons.calendar_today, color: dark(context)),
                    ],
                  ),
                )),
          ),
        ),
        SizedBox(height: 15),
        Container(
          padding: const EdgeInsets.only(left: 15.0, right: 15),
          child: regularTextatStart(context, "TO"),
        ),
        SizedBox(height: 5),
        Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15),
          child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: cartCardBg(context),
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(5.0)),
            child: GFButton(
                color: Colors.transparent,
                onPressed: () {
                  DatePicker.showDatePicker(context,
                      showTitleActions: true,
                      minTime: widget.subscriptionStartDate, onConfirm: (date) {
                    if (mounted) {
                      setState(() {
                        endDate = date;
                      });
                    }
                  },
                      currentTime: widget.subscriptionStartDate,
                      locale: LocaleType.en);
                },
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(DateFormat('dd/MM/yyyy').format(endDate!)),
                      Icon(Icons.calendar_today, color: dark(context)),
                    ],
                  ),
                )),
          ),
        ),
        SizedBox(height: 45),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: InkWell(
                onTap: () {
                  if (startDate!.microsecondsSinceEpoch >
                      endDate!.microsecondsSinceEpoch) {
                    AlertService().showToast(MyLocalizations.of(context)!
                        .getLocalizations("SELECT_PROPER_START_AND_END_DATE"));
                  } else {
                    Navigator.of(context).pop({
                      "pauseStartDate": startDate.toString(),
                      "pauseEndDate": endDate.toString()
                    });
                  }
                },
                child: buttonprimary(context, "SUBMIT", false))),
      ]),
    );
  }
}
