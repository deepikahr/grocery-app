import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:readymadeGroceryApp/screens/thank-you/payment-failed.dart';
import 'package:readymadeGroceryApp/screens/thank-you/thankyou.dart';
import 'package:readymadeGroceryApp/service/constants.dart';
import 'package:readymadeGroceryApp/service/localizations.dart';
import 'package:readymadeGroceryApp/service/orderSevice.dart';
import 'package:readymadeGroceryApp/widgets/appBar.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentWeViewPage extends StatefulWidget {
  final String? sessionId, locale, orderId;
  final Map? localizedValues;

  const PaymentWeViewPage(
      {Key? key,
      this.sessionId,
      this.locale,
      this.localizedValues,
      this.orderId})
      : super(key: key);

  @override
  _PaymentWeViewPageState createState() => _PaymentWeViewPageState();
}

class _PaymentWeViewPageState extends State<PaymentWeViewPage> {
  late WebViewController _controller;

  Future<bool> _onWillPop() {
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text(
            MyLocalizations.of(context)!.getLocalizations("ARE_YOU_SURE")),
        content: new Text(MyLocalizations.of(context)!
            .getLocalizations("DO_YOU_WANT_TO_DISMISS_PAYMENT_PROCESS")),
        actions: <Widget>[
          GFButton(
            color: Colors.transparent,
            onPressed: () => Navigator.pop(context, false),
            child:
                new Text(MyLocalizations.of(context)!.getLocalizations("NO")),
          ),
          GFButton(
            color: Colors.transparent,
            onPressed: orderCancel,
            child:
                new Text(MyLocalizations.of(context)!.getLocalizations("YES")),
          ),
        ],
      ),
    ) as Future<bool>;
  }

  orderCancel() async {
    await OrderService.orderCancel(widget.orderId).then((onValue) {
      Navigator.pop(context);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => PaymentFailed(
                locale: widget.locale, localizedValues: widget.localizedValues),
          ),
          (Route<dynamic> route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: appBarTransparentWithoutBack(context, "PAYMENT")
            as PreferredSizeWidget?,
        body: WebView(
            initialUrl: initialUrl,
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (controller) => _controller = controller,
            navigationDelegate: (NavigationRequest request) {
              if (request.url.startsWith('${Constants.baseUrl}/thank-you')) {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => Thankyou(
                          locale: widget.locale,
                          localizedValues: widget.localizedValues),
                    ),
                    (Route<dynamic> route) => false);
              } else if (request.url.startsWith('${Constants.baseUrl}/home')) {
                orderCancel();
              }
              return NavigationDecision.navigate;
            },
            onPageFinished: (String url) {
              if (url == initialUrl) {
                _redirectToStripe();
              }
            }),
      ),
    );
  }

  String get initialUrl =>
      'data:text/html;base64,${base64Encode(Utf8Encoder().convert(kStripeHtmlPage))}';

  void _redirectToStripe() {
    final redirectToCheckoutJs = '''
var stripe = Stripe(\'${Constants.stripKey}\');
stripe.redirectToCheckout({
  sessionId: '${widget.sessionId}'
}).then(function (result) {
  result.error.message = 'Error'
});
''';
    _controller.evaluateJavascript(
        redirectToCheckoutJs); //<--- call the JS function on controller
  }
}

const kStripeHtmlPage = '''
<!DOCTYPE html>
<html>
<head><meta http-equiv="Content-Security-Policy" content="default-src *; style-src 'self' 'unsafe-inline'; script-src 'self' 'unsafe-inline' 'unsafe-eval' https://js.stripe.com/v3/ "></head>
<script src="https://js.stripe.com/v3/"></script>
<head><title>Payment</title></head>
<body>
<center>Please Wait......</center>
</body>
</html>
''';
