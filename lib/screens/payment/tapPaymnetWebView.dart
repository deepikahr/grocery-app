import 'dart:async';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:readymadeGroceryApp/screens/home/home.dart';
import 'package:readymadeGroceryApp/screens/thank-you/payment-failed.dart';
import 'package:readymadeGroceryApp/screens/thank-you/thankyou.dart';
import 'package:readymadeGroceryApp/service/localizations.dart';
import 'package:readymadeGroceryApp/service/orderSevice.dart';
import 'package:readymadeGroceryApp/style/style.dart';
import 'package:readymadeGroceryApp/widgets/appBar.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewOrderTapPay extends StatefulWidget {
  final String? orderId, tapUrl, locale;
  final Map? localizedValues;
  WebViewOrderTapPay(
      {Key? key, this.orderId, this.tapUrl, this.locale, this.localizedValues})
      : super(key: key);

  @override
  _WebViewOrderTapPayState createState() => _WebViewOrderTapPayState();
}

class _WebViewOrderTapPayState extends State<WebViewOrderTapPay> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  Timer? timer;
  paymentResponse(id) async {
    await OrderService.getPaymentStatus(id).then((onValue) {
      if (onValue['response_code'] == 200) {
        setState(() {
          if (onValue['response_data']['success'] == true) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => Thankyou(
                    locale: widget.locale,
                    localizedValues: widget.localizedValues,
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

  orderCancel() async {
    await OrderService.orderCancelApi(widget.orderId).then((onValue) {
      Navigator.pop(context);
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

  showDailodBackPress() {
    showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text(
            MyLocalizations.of(context)?.getLocalizations('ARE_YOU_SURE')),
        content: new Text(MyLocalizations.of(context)
            ?.getLocalizations('DO_YOU_WANT_TO_DISMISS_PAYMENT_PROCESS')),
        actions: <Widget>[
          GFButton(
            color: Colors.transparent,
            onPressed: () => Navigator.pop(context, false),
            child:
                new Text(MyLocalizations.of(context)?.getLocalizations('NO')),
          ),
          GFButton(
            color: Colors.transparent,
            onPressed: orderCancel,
            child:
                new Text(MyLocalizations.of(context)?.getLocalizations('YES')),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        showDailodBackPress();
        return new Future(() => false);
      },
      child: Scaffold(
        backgroundColor: bg(context),
        appBar: appBarTransparentWithBackTab(context, "PAYMENT", () {
          showDailodBackPress();
        }) as PreferredSizeWidget?,
        body: WebView(
          initialUrl: widget.tapUrl,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            _controller.complete(webViewController);
          },
        ),
      ),
    );
  }
}
