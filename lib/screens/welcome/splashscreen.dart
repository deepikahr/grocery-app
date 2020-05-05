import 'package:flutter/material.dart';
import 'package:readymadeGroceryApp/widgets/loader.dart';
import '../../style/style.dart';

class SpalshScreen extends StatefulWidget {
  final Map<String, Map<String, String>> localizedValues;
  final String locale;
  SpalshScreen({Key key, this.locale, this.localizedValues}) : super(key: key);

  @override
  _SpalshScreenState createState() => _SpalshScreenState();
}

class _SpalshScreenState extends State<SpalshScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: primary,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Image.asset(
                  'lib/assets/logos/logo.png',
                  scale: 5,
                ),
              ),
              Padding(
                  padding: const EdgeInsets.all(16.0), child: SquareLoader())
            ],
          ),
        ));
  }
}
