import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:readymadeGroceryApp/screens/thank-you/payment-failed.dart';
import 'package:readymadeGroceryApp/service/constants.dart';
import 'package:readymadeGroceryApp/widgets/appBar.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:readymadeGroceryApp/screens/thank-you/thankyou.dart';

class AddMoneyWebViewPage extends StatefulWidget {
  final String? sessionId, locale, userId;
  final Map? localizedValues;

  const AddMoneyWebViewPage({
    Key? key,
    this.sessionId,
    this.locale,
    this.localizedValues,
    this.userId,
  }) : super(key: key);

  @override
  _AddMoneyWebViewPageState createState() => _AddMoneyWebViewPageState();
}

class _AddMoneyWebViewPageState extends State<AddMoneyWebViewPage> {
  late WebViewController _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar:
          appBarPrimarynoradius(context, "ADD_MONEY") as PreferredSizeWidget?,
      body: WebView(
          initialUrl: initialUrl,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (controller) => _controller = controller,
          navigationDelegate: (NavigationRequest request) {
            if (request.url
                .startsWith('${Constants.baseUrl}/wallet-payment-successful')) {
              Navigator.of(context).pop();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => Thankyou(
                    locale: widget.locale,
                    localizedValues: widget.localizedValues,
                    isWallet: true,
                  ),
                ),
              );
            } else if (request.url.startsWith('${Constants.baseUrl}/home')) {
              Navigator.of(context).pop();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => PaymentFailed(
                    locale: widget.locale,
                    localizedValues: widget.localizedValues,
                  ),
                ),
              );
            }
            return NavigationDecision.navigate;
          },
          onPageFinished: (String url) {
            if (url == initialUrl) {
              _redirectToStripe();
            }
          }),
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
