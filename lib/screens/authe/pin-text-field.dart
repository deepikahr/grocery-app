import 'dart:async';
import 'package:flutter/cupertino.dart' show CupertinoTextField;
import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import '../../style/style.dart';

typedef OnDone = void Function(String text);
typedef PinBoxDecoration = BoxDecoration Function(Color borderColor);

/// class to provide some standard PinBoxDecoration such as standard box or underlined
class ProvidedPinBoxDecoration {
  /// Default BoxDecoration
  static PinBoxDecoration defaultPinBoxDecoration = (Color grey) {
    return BoxDecoration(
      border: Border.all(
        color: grey,
        width: 1.0,
      ),
      borderRadius: BorderRadius.circular(50.0),
    );
  };

  /// Underlined BoxDecoration
  static PinBoxDecoration underlinedPinBoxDecoration = (Color greyBlueb) {
    return BoxDecoration(
      border: Border(
        bottom: BorderSide(color: greyBlueb, width: 1.0),
      ),
      borderRadius: BorderRadius.circular(50.0),
    );
  };
}

class ProvidedPinBoxTextAnimation {
  /// A combination of RotationTransition, DefaultTextStyleTransition, ScaleTransition
  static AnimatedSwitcherTransitionBuilder awesomeTransition =
      (Widget child, Animation<double> animation) {
    return RotationTransition(
        child: DefaultTextStyleTransition(
          style: TextStyleTween(
                  begin: TextStyle(color: Colors.pink),
                  end: TextStyle(color: Colors.blue))
              .animate(animation),
          child: ScaleTransition(
            child: child,
            scale: animation,
          ),
        ),
        turns: animation);
  };

  /// Simple Scaling Transition
  static AnimatedSwitcherTransitionBuilder scalingTransition =
      (child, animation) {
    return ScaleTransition(
      child: child,
      scale: animation,
    );
  };

  /// No transition
  static AnimatedSwitcherTransitionBuilder defaultNoTransition =
      (Widget child, Animation<double> animation) {
    return child;
  };

  /// Rotate Transition
  static AnimatedSwitcherTransitionBuilder rotateTransition =
      (Widget child, Animation<double> animation) {
    return RotationTransition(child: child, turns: animation);
  };
}

class PinCodeTextField extends StatefulWidget {
  final bool isCupertino;
  final int maxLength;
  final TextEditingController controller;
  final bool hideCharacter;
  final bool highlight;
  final Color highlightColor;
  final Color defaultBorderColor;
  final PinBoxDecoration pinBoxDecoration;
  final String maskCharacter;
  final TextStyle pinTextStyle;
  final double pinBoxHeight;
  final double pinBoxWidth;
  final OnDone onDone;
  final bool hasError;
  final Color errorBorderColor;
  final Color hasTextBorderColor;
  final Function(String) onTextChanged;
  final bool autofocus;
  final AnimatedSwitcherTransitionBuilder pinTextAnimatedSwitcherTransition;
  final Duration pinTextAnimatedSwitcherDuration;
  final WrapAlignment wrapAlignment;
  final PinCodeTextFieldLayoutType pinCodeTextFieldLayoutType;
  final Map<String, Map<String, String>> localizedValues;
  final String locale;
  const PinCodeTextField(
      {Key key,
      this.isCupertino: false,
      this.maxLength: 4,
      this.controller,
      this.hideCharacter: false,
      this.highlight: false,
      this.highlightColor: Colors.transparent,
      this.pinBoxDecoration,
      this.maskCharacter: " ",
      this.pinBoxWidth: 78.5,
      this.pinBoxHeight: 48.8,
      this.pinTextStyle,
      this.onDone,
      this.defaultBorderColor: Colors.transparent,
      this.hasTextBorderColor: Colors.transparent,
      this.pinTextAnimatedSwitcherTransition,
      this.pinTextAnimatedSwitcherDuration: const Duration(),
      this.hasError: false,
      this.errorBorderColor: Colors.red,
      this.onTextChanged,
      this.autofocus: false,
      this.wrapAlignment: WrapAlignment.start,
      this.pinCodeTextFieldLayoutType: PinCodeTextFieldLayoutType.NORMAL,
      this.locale,
      this.localizedValues})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return PinCodeTextFieldState();
  }
}

class PinCodeTextFieldState extends State<PinCodeTextField> {
  FocusNode focusNode = new FocusNode();
  String text = "";
  int currentIndex = 0;
  List<String> strList = [];
  bool hasFocus = false;
  double pinWidth;
  double screenWidth;

  @override
  void didUpdateWidget(PinCodeTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.maxLength < widget.maxLength) {
      if (mounted) {
        setState(() {
          currentIndex = text.length;
        });
      }
      widget.controller.text = text;
      widget.controller.selection =
          TextSelection.collapsed(offset: text.length);
    } else if (oldWidget.maxLength > widget.maxLength &&
        widget.maxLength > 0 &&
        text.length > 0 &&
        text.length > widget.maxLength) {
      if (mounted) {
        setState(() {
          text = text.substring(0, widget.maxLength);
          currentIndex = text.length;
        });
      }
      widget.controller.text = text;
      widget.controller.selection =
          TextSelection.collapsed(offset: text.length);
    }
  }

  _calculateStrList() async {
//    strList.length = widget.maxLength;
    if (strList.length > widget.maxLength) {
      strList.length = widget.maxLength;
    }
    while (strList.length < widget.maxLength) {
      strList.add("");
    }
  }

  _calculatePinWidth() async {
    if (widget.pinCodeTextFieldLayoutType ==
        PinCodeTextFieldLayoutType.AUTO_ADJUST_WIDTH) {
      screenWidth = MediaQuery.of(context).size.width;
      var tempPinWidth = widget.pinBoxWidth;
      var maxLength = widget.maxLength;
      while ((tempPinWidth * maxLength) > screenWidth) {
        tempPinWidth -= 4;
      }
      tempPinWidth -= 10;
      if (mounted) {
        setState(() {
          pinWidth = tempPinWidth;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          pinWidth = widget.pinBoxWidth;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _calculateStrList();
    focusNode.addListener(() {
      if (mounted)
        setState(() {
          hasFocus = focusNode.hasFocus;
        });
    });
  }

  @override
  void dispose() {
    focusNode?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _touchPinBoxRow(),
          _fakeTextInputCupertino(),
        ],
      ),
    );
  }

  Widget _touchPinBoxRow() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (hasFocus) {
          FocusScope.of(context).requestFocus(FocusNode());
          Future.delayed(Duration(milliseconds: 100), () {
            FocusScope.of(context).requestFocus(focusNode);
          });
        } else {
          FocusScope.of(context).requestFocus(focusNode);
        }
      },
      child: _pinBoxRow(context),
    );
  }

  // Widget _fakeTextInput() {
  //   return Container(
  //     width: 0.1,
  //     height: 0.1,
  //     child: TextField(
  //       autofocus: widget.autofocus,
  //       focusNode: focusNode,
  //       controller: widget.controller,
  //       keyboardType: TextInputType.number,
  //       style: TextStyle(
  //         color: Colors.black,
  //       ),
  //       decoration: InputDecoration(
  //         border: InputBorder.none,
  //       ),
  //       cursorColor: primary,
  //       maxLength: widget.maxLength,
  //       onChanged: _onTextChanged,
  //     ),
  //   );
  // }

  Widget _fakeTextInputCupertino() {
    return Container(
      width: 0.1,
      height: 0.1,
      child: CupertinoTextField(
        autofocus: widget.autofocus,
        focusNode: focusNode,
        controller: widget.controller,
        keyboardType: TextInputType.number,
        style: TextStyle(
          color: Colors.black,
        ),
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: null,
        ),
        cursorColor: primary,
        maxLength: widget.maxLength,
        onChanged: _onTextChanged,
      ),
    );
  }

  void _onTextChanged(text) {
    if (widget.onTextChanged != null) {
      widget.onTextChanged(text);
    }
    if (mounted) {
      setState(() {
        this.text = text;
        if (text.length < currentIndex) {
          strList[text.length] = "";
        } else {
          strList[text.length - 1] = widget.hideCharacter
              ? widget.maskCharacter
              : text[text.length - 1];
        }
        currentIndex = text.length;
      });
    }
    if (text.length == widget.maxLength) {
      FocusScope.of(context).requestFocus(FocusNode());
      widget.onDone(text);
    }
  }

  Widget _pinBoxRow(BuildContext context) {
    _calculateStrList();
    _calculatePinWidth();
    List<Widget> pinCodes = List.generate(widget.maxLength, (int i) {
      return _buildPinCode(i, context);
    });
    return widget.pinCodeTextFieldLayoutType == PinCodeTextFieldLayoutType.WRAP
        ? Wrap(
            direction: Axis.horizontal,
            alignment: widget.wrapAlignment,
            verticalDirection: VerticalDirection.down,
            children: pinCodes,
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            verticalDirection: VerticalDirection.down,
            children: pinCodes);
  }

  Widget _buildPinCode(int i, BuildContext context) {
    // Color borderColor;
    // BoxDecoration boxDecoration;
    // if (widget.hasError) {
    //   borderColor = widget.errorBorderColor;
    // } else if (widget.highlight &&
    //     hasFocus &&
    //     (i == text.length ||
    //         (i == text.length - 1 && text.length == widget.maxLength))) {
    //   borderColor = widget.highlightColor;
    // } else if (i < text.length) {
    //   borderColor = widget.hasTextBorderColor;
    // } else {
    //   borderColor = widget.defaultBorderColor;
    // }

    // if (widget.pinBoxDecoration != null) {
    //   boxDecoration = widget.pinBoxDecoration(borderColor);
    // } else {
    //   boxDecoration =
    //       ProvidedPinBoxDecoration.defaultPinBoxDecoration(borderColor);
    // }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Container(
        key: ValueKey<String>("container$i"),
        height: 60.0,
        width: screenWidth * 0.18,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            border: Border.all(color: Color(0xFFD4D4E0)),
            borderRadius: BorderRadius.circular(1.81)),
        margin: EdgeInsets.only(right: 7.0, top: 25.0, bottom: 20.0),
        child: Center(child: _animatedTextBox(strList[i], i)),
      ),
    );
  }

  Widget _animatedTextBox(String text, int i) {
    if (widget.pinTextAnimatedSwitcherTransition != null) {
      return AnimatedSwitcher(
          duration: widget.pinTextAnimatedSwitcherDuration,
          transitionBuilder: widget.pinTextAnimatedSwitcherTransition ??
              (Widget child, Animation<double> animation) {
                return child;
              },
          child: Padding(
            padding: EdgeInsets.only(top: 5.0),
            child: Text(
              text,
              key: ValueKey<String>("$text$i"),
              style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w700),
            ),
          ));
    } else {
      return Text(
        text,
        key: ValueKey<String>("${strList[i]}$i"),
        style: widget.pinTextStyle,
      );
    }
  }
}

enum PinCodeTextFieldLayoutType { NORMAL, WRAP, AUTO_ADJUST_WIDTH }
