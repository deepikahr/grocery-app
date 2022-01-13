import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:readymadeGroceryApp/screens/home/home.dart';
import 'package:readymadeGroceryApp/screens/thank-you/payment-failed.dart';
import 'package:readymadeGroceryApp/screens/thank-you/thankyou.dart';
import 'package:readymadeGroceryApp/service/localizations.dart';
import 'package:readymadeGroceryApp/service/orderSevice.dart';
import 'package:readymadeGroceryApp/widgets/appBar.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewFlutterTapPay extends StatefulWidget {
  final String? orderId, tapUrl, locale;
  final Map? localizedValues;
  WebViewFlutterTapPay(
      {Key? key, this.orderId, this.tapUrl, this.locale, this.localizedValues})
      : super(key: key);

  @override
  _WebViewFlutterTapPayState createState() => _WebViewFlutterTapPayState();
}

class _WebViewFlutterTapPayState extends State<WebViewFlutterTapPay> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  var payData;
  Timer? timer;
  String? selectedUrl, transectionStatus;
  bool isLoading = false;
  paymentResponse(id) async {
    print("jjjjjjjjjjjjjjjjjjjjjjj");
    print("jjjjjjjjjjjjjjjjjjjjjjj");
    print("jjjjjjjjjjjjjjjjjjjjjjj");
    print("jjjjjjjjjjjjjjjjjjjjjjj");
    print("jjjjjjjjjjjjjjjjjjjjjjj");
    print("jjjjjjjjjjjjjjjjjjjjjjj");
    print("jjjjjjjjjjjjjjjjjjjjjjj");
    print("jjjjjjjjjjjjjjjjjjjjjjj");
    print("jjjjjjjjjjjjjjjjjjjjjjj");
    print("jjjjjjjjjjjjjjjjjjjjjjj");
    print("jjjjjjjjjjjjjjjjjjjjjjj");
    print("jjjjjjjjjjjjjjjjjjjjjjj");
    print("jjjjjjjjjjjjjjjjjjjjjjj");
    print("jjjjjjjjjjjjjjjjjjjjjjj");
    print("jjjjjjjjjjjjjjjjjjjjjjj");
    print("jjjjjjjjjjjjjjjjjjjjjjj");
    print("jjjjjjjjjjjjjjjjjjjjjjj");
    print("jjjjjjjjjjjjjjjjjjjjjjj");
    print("jjjjjjjjjjjjjjjjjjjjjjj");
    print("jjjjjjjjjjjjjjjjjjjjjjj");
    print("jjjjjjjjjjjjjjjjjjjjjjj");
    print("jjjjjjjjjjjjjjjjjjjjjjj");
    print("jjjjjjjjjjjjjjjjjjjjjjj");
    print("jjjjjjjjjjjjjjjjjjjjjjj");
    print("jjjjjjjjjjjjjjjjjjjjjjj");
    print("jjjjjjjjjjjjjjjjjjjjjjj");
    print("jjjjjjjjjjjjjjjjjjjjjjj");
    print("jjjjjjjjjjjjjjjjjjjjjjj");
    print("jjjjjjjjjjjjjjjjjjjjjjj");
    print("jjjjjjjjjjjjjjjjjjjjjjj");
    print("jjjjjjjjjjjjjjjjjjjjjjj");
    print("jjjjjjjjjjjjjjjjjjjjjjj");
    print("jjjjjjjjjjjjjjjjjjjjjjj");
    print("jjjjjjjjjjjjjjjjjjjjjjj");
    print("jjjjjjjjjjjjjjjjjjjjjjj");
    print("jjjjjjjjjjjjjjjjjjjjjjj");
    print("jjjjjjjjjjjjjjjjjjjjjjj");
    print("jjjjjjjjjjjjjjjjjjjjjjj");
    print("jjjjjjjjjjjjjjjjjjjjjjj");
    print("jjjjjjjjjjjjjjjjjjjjjjj");
    print("jjjjjjjjjjjjjjjjjjjjjjj");
    print("jjjjjjjjjjjjjjjjjjjjjjj");
    print("jjjjjjjjjjjjjjjjjjjjjjj");
    await OrderService.getPaymentStatus(id).then((onValue) {
      print(onValue);
      try {
        if (onValue['response_code'] == 200) {
          setState(() {
            if (timer != null) {
              timer?.cancel();
            }
            transectionStatus = "Success";
            selectedUrl = onValue['response_data']['url'];
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => Thankyou(
                    locale: widget.locale,
                    localizedValues: widget.localizedValues,
                  ),
                ),
                (Route<dynamic> route) => false);
          });
        } else if (onValue['response_code'] == 402) {
          setState(() {
            transectionStatus = "Faild";
            selectedUrl = onValue['response_data']['url'];
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => PaymentFailed(
                    locale: widget.locale,
                    localizedValues: widget.localizedValues,
                    message: onValue['response_data']['msg'],
                  ),
                ),
                (Route<dynamic> route) => false);
            if (timer != null) {
              timer?.cancel();
            }
          });
        } else {
          setState(() {
            transectionStatus = null;
          });
        }
      } catch (error, stackTrace) {
        sentryError.reportError(error, stackTrace);
      }
    }).catchError((error) {
      sentryError.reportError(error, null);
    });
  }

  orderCancel() async {
    await OrderService.orderCancelApi(widget.orderId).then((onValue) {
      Navigator.pop(context);
      try {
        if (timer != null) {
          timer?.cancel();
        }
        if (onValue['response_code'] == 200) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => Home(
                  locale: widget.locale,
                  localizedValues: widget.localizedValues,
                  currentIndex: 0,
                ),
              ),
              (Route<dynamic> route) => false);
        }
      } catch (error, stackTrace) {
        sentryError.reportError(error, stackTrace);
      }
    }).catchError((error) {
      sentryError.reportError(error, null);
    });
  }

  @override
  void dispose() {
    if (timer != null) {
      timer?.cancel();
    }
    super.dispose();
  }

  @override
  void initState() {
    timer = new Timer.periodic(Duration(seconds: 3), (_) {
      paymentResponse(widget.orderId);
    });
    selectedUrl = widget.tapUrl.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        transectionStatus == "Faild"
            ? Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => PaymentFailed(
                    locale: widget.locale,
                    localizedValues: widget.localizedValues,
                  ),
                ),
                (Route<dynamic> route) => false)
            : transectionStatus == "Success"
                ? Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => Thankyou(
                        locale: widget.locale,
                        localizedValues: widget.localizedValues,
                      ),
                    ),
                    (Route<dynamic> route) => false)
                : showDialog(
                    context: context,
                    builder: (context) => new AlertDialog(
                      title: new Text(MyLocalizations.of(context)
                          ?.getLocalizations('ARE_YOU_SURE')),
                      content: new Text(MyLocalizations.of(context)
                          ?.getLocalizations(
                              'DO_YOU_WANT_TO_DISMISS_PAYMENT_PROCESS')),
                      actions: <Widget>[
                        GFButton(
                          color: Colors.transparent,
                          onPressed: () => Navigator.pop(context, false),
                          child: new Text(MyLocalizations.of(context)
                              ?.getLocalizations('NO')),
                        ),
                        GFButton(
                          color: Colors.transparent,
                          onPressed: orderCancel,
                          child: new Text(MyLocalizations.of(context)
                              ?.getLocalizations('YES')),
                        ),
                      ],
                    ),
                  );
        return new Future(() => false);
      },
      child: Scaffold(
        appBar: appBarTransparentWithOutBack(context, "PAYMENT")
            as PreferredSizeWidget?,
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
