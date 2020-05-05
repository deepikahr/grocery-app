import 'package:flutter/material.dart';

class NoData extends StatefulWidget {
  final String message;
  final Widget icon;
  final double verticalPadding;
  NoData({Key key, this.message, this.icon, this.verticalPadding})
      : super(key: key);
  @override
  _NoDataState createState() => _NoDataState();
}

class _NoDataState extends State<NoData> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding:
            EdgeInsets.symmetric(vertical: widget.verticalPadding ?? 100.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              widget.icon != null
                  ? Padding(
                      padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                      child: widget.icon,
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
