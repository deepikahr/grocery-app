import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:readymadeGroceryApp/screens/home/home.dart';
import 'package:readymadeGroceryApp/screens/thank-you/thankyou.dart';
import 'package:readymadeGroceryApp/service/localizations.dart';
import 'package:readymadeGroceryApp/service/payment-service.dart';
import 'package:readymadeGroceryApp/widgets/appBar.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentWebView extends StatefulWidget {
  final String orderId, paymentURL, locale;
  final Map localizedValues;
  PaymentWebView(
      {Key key,
      this.orderId,
      this.paymentURL,
      this.locale,
      this.localizedValues})
      : super(key: key);

  @override
  _PaymentWebViewState createState() => _PaymentWebViewState();
}

class _PaymentWebViewState extends State<PaymentWebView> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  Timer timer;
  String selectedUrl, transectionStatus;
  bool isLoading = false;
  paymentResponse(id) async {
    await PaymentService.getPaymentStatus(id).then((onValue) {
      if (onValue['response_code'] == 200) {
        setState(() {
          if (timer != null) {
            timer.cancel();
          }
          transectionStatus = "Success";
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => Thankyou(
                    locale: widget.locale,
                    localizedValues: widget.localizedValues,
                    isPaymentFailed: false),
              ),
              (Route<dynamic> route) => false);
        });
      } else if (onValue['response_code'] == 402) {
        setState(() {
          transectionStatus = "Faild";
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => Thankyou(
                    locale: widget.locale,
                    localizedValues: widget.localizedValues,
                    isPaymentFailed: true),
              ),
              (Route<dynamic> route) => false);
          if (timer != null) {
            timer.cancel();
          }
        });
      } else {
        setState(() {
          transectionStatus = null;
        });
      }
    }).catchError((error) {
      setState(() {
        transectionStatus = null;
      });
      sentryError.reportError(error, null);
    });
  }

  orderCancel() async {
    await PaymentService.orderCancelApi(widget.orderId).then((onValue) {
      Navigator.pop(context);
      if (timer != null) {
        timer.cancel();
      }
      if (onValue['response_data'] != null) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => Home(
                  locale: widget.locale,
                  localizedValues: widget.localizedValues,
                  currentIndex: 0),
            ),
            (Route<dynamic> route) => false);
      }
    }).catchError((error) {
      sentryError.reportError(error, null);
    });
  }

  @override
  void dispose() {
    if (timer != null) {
      timer.cancel();
    }
    super.dispose();
  }

  @override
  void initState() {
    timer = new Timer.periodic(Duration(seconds: 5), (_) {
      paymentResponse(widget.orderId);
    });
    selectedUrl = widget.paymentURL.toString();
    super.initState();
  }

  Future<bool> _onWillPop() {
    return transectionStatus == "Faild"
        ? Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => Thankyou(
                  locale: widget.locale,
                  localizedValues: widget.localizedValues,
                  isPaymentFailed: true),
            ),
            (Route<dynamic> route) => false)
        : transectionStatus == "Success"
            ? Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => Thankyou(
                      locale: widget.locale,
                      localizedValues: widget.localizedValues,
                      isPaymentFailed: false),
                ),
                (Route<dynamic> route) => false)
            : showDialog(
                  context: context,
                  builder: (context) => new AlertDialog(
                    title: new Text(MyLocalizations.of(context)
                        .getLocalizations("ARE_YOU_SURE")),
                    content: new Text(MyLocalizations.of(context)
                        .getLocalizations(
                            "DO_YOU_WANT_TO_DISMISS_PAYMENT_PROCESS")),
                    actions: <Widget>[
                      new FlatButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: new Text(
                            MyLocalizations.of(context).getLocalizations("NO")),
                      ),
                      new FlatButton(
                        onPressed: orderCancel,
                        child: new Text(MyLocalizations.of(context)
                            .getLocalizations("YES")),
                      ),
                    ],
                  ),
                ) ??
                false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: appBarTransparent(context, "PAYMENT"),
        body: WebView(
          initialUrl: selectedUrl,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            _controller.complete(webViewController);
          },
        ),
      ),
    );
  }
}
