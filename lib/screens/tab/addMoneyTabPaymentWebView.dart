import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:readymadeGroceryApp/screens/home/home.dart';
import 'package:readymadeGroceryApp/screens/thank-you/payment-failed.dart';
import 'package:readymadeGroceryApp/screens/thank-you/thankyou.dart';
import 'package:readymadeGroceryApp/service/orderSevice.dart';
import 'package:readymadeGroceryApp/widgets/appBar.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewAddMoneyTapPay extends StatefulWidget {
  final String? orderId, tapUrl, locale;
  final Map? localizedValues;
  WebViewAddMoneyTapPay(
      {Key? key, this.orderId, this.tapUrl, this.locale, this.localizedValues})
      : super(key: key);

  @override
  _WebViewAddMoneyTapPayState createState() => _WebViewAddMoneyTapPayState();
}

class _WebViewAddMoneyTapPayState extends State<WebViewAddMoneyTapPay> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  Timer? timer;
  paymentResponse(id) async {
    await OrderService.getPaymentStatusWallet(id).then((onValue) {
      if (onValue['response_code'] == 200) {
        setState(() {
          if (onValue['response_data']['success'] == true) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => Thankyou(
                    locale: widget.locale,
                    localizedValues: widget.localizedValues,
                    isWallet: true,
                  ),
                ),
                (Route<dynamic> route) => false);
          } else {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => PaymentFailed(
                    locale: widget.locale,
                    localizedValues: widget.localizedValues,
                    message: onValue['response_data']['message'],
                  ),
                ),
                (Route<dynamic> route) => false);
          }
        });
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
    timer = new Timer.periodic(Duration(seconds: 5), (_) {
      paymentResponse(widget.orderId);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarTransparent(context, "PAYMENT") as PreferredSizeWidget?,
      body: WebView(
        initialUrl: widget.tapUrl,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
        },
      ),
    );
  }
}
