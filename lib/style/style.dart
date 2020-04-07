import 'package:flutter/material.dart';

final primary = const Color(0xFFFFCF2D);
final primaryLight = const Color(0xFFE6EFF7);

final blacktext = const Color(0xFF272A3F);

final red = const Color(0xFFF34949);

final grey = const Color(0xFFdddddd);

final darkGrey = const Color(0xFF708090);

final star = const Color(0xFFff8064);

final greya = const Color(0xFFDCDCDC);

final border = const Color(0xFFD4D4E0);

final bg = const Color(0xFFF4F7FA);

double screenHeight(context) {
  return MediaQuery.of(context).size.height;
}

double screenWidth(context) {
  return MediaQuery.of(context).size.width;
}

//..................................sf-ui-light ....................................

TextStyle hintSfLightprimary() {
  return TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 28.0,
    color: primary,
    fontFamily: 'SfUiDLight',
  );
}

TextStyle hintSfLightsmall() {
  return TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 12.0,
    color: blacktext,
    fontFamily: 'SfUiDLight',
  );
}

TextStyle subtitleBold() {
  return TextStyle(
    fontSize: 17.0,
    fontWeight: FontWeight.w400,
    fontFamily: 'OpenSansSemiBold',
    color: Colors.black,
  );
}

TextStyle hintSfLight() {
  return TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 16.0,
    color: Color(0xFF6E798A),
    fontFamily: 'SfUiDLight',
  );
}

TextStyle hintSfLightsm() {
  return TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 13.0,
    color: Color(0xFF6E7990),
    fontFamily: 'SfUiDLight',
  );
}

TextStyle hintSfLightbig() {
  return TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 16.0,
    color: blacktext,
    fontFamily: 'SfUiDLight',
  );
}

//..................................sf-ui-medium ....................................

TextStyle hintSfMediumbig() {
  return TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 28.0,
    color: blacktext,
    fontFamily: 'SfUiDMedium',
  );
}

TextStyle hintSfMediumsmall() {
  return TextStyle(
    fontWeight: FontWeight.w100,
    fontSize: 14.0,
    color: Colors.white,
    fontFamily: 'SfUiDMedium',
  );
}

TextStyle hintSfMediumblack() {
  return TextStyle(
    fontWeight: FontWeight.w100,
    fontSize: 18.0,
    color: blacktext,
    fontFamily: 'SfUiDMedium',
  );
}

TextStyle hintSmallSfMediumblack() {
  return TextStyle(
    fontWeight: FontWeight.w100,
    fontSize: 13.0,
    color: blacktext,
    fontFamily: 'SfUiDMedium',
  );
}

TextStyle hintSfMediumblackbig() {
  return TextStyle(
    fontWeight: FontWeight.w300,
    fontSize: 16.0,
    color: blacktext,
    fontFamily: 'SfUiDMedium',
  );
}

TextStyle hintSfmediumblack() {
  return TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 14.0,
    color: blacktext,
    fontFamily: 'SfUiDMedium',
  );
}

TextStyle hintSfMediumprimaryb() {
  return TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 17.0,
    color: primary,
    fontFamily: 'SfUiDMedium',
  );
}

TextStyle hintSfMediumprimarysmall() {
  return TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 14.0,
    color: primary,
    fontFamily: 'SfUiDMedium',
  );
}

TextStyle hintSfMediumgreysmall() {
  return TextStyle(
    fontWeight: FontWeight.w100,
    fontSize: 14.0,
    color: Color(0xFF6E7990),
    fontFamily: 'SfUiDMedium',
  );
}

TextStyle hintSfMediumgreyersmall() {
  return TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 16.0,
    color: blacktext,
    fontFamily: 'SfUiDMedium',
  );
}

TextStyle hintSfMediumgreyersmallLight() {
  return TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 16.0,
    color: grey,
    fontFamily: 'SfUiDMedium',
  );
}

TextStyle hintSfletterspacingMediumgreyersmall() {
  return TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 16.0,
      color: Color(0xFF272A3F),
      fontFamily: 'SfUiDMedium',
      letterSpacing: 7.0);
}

TextStyle hintSfMediumredsmall() {
  return TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 16.0,
    color: red,
    fontFamily: 'SfUiDMedium',
  );
}

TextStyle hintSfMediumgreysmaller() {
  return TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 13.0,
    color: Color(0xFF6E7990),
    fontFamily: 'SfUiDMedium',
  );
}

TextStyle hintSfMediumprimarysm() {
  return TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 11.0,
    color: primary,
    fontFamily: 'SfUiDMedium',
  );
}

TextStyle hintSfMediumblacksmaller() {
  return TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 13.0,
    color: blacktext,
    fontFamily: 'SfUiDMedium',
    // transform: TextTransform.capitalize,
  );
}

TextStyle hintSfMediumgrey() {
  return TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 14.7,
    color: Color(0xFF6E7990),
    fontFamily: 'SfUiDMedium',
  );
}

TextStyle hintSfMediumgreysml() {
  return TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 14,
    color: Color(0xFF9AA1B1),
    fontFamily: 'SfUiDMedium',
  );
}

TextStyle hintSfMediumgreysl() {
  return TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 14,
    color: Color(0xFFA0A7B7),
    fontFamily: 'SfUiDMedium',
  );
}

TextStyle hintSfMediumsmaller() {
  return TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 12.0,
    color: blacktext,
    fontFamily: 'SfUiDMedium',
  );
}

TextStyle hintSfMediumwhitesmaller() {
  return TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 14.0,
    color: Colors.white,
    fontFamily: 'SfUiDMedium',
  );
}

TextStyle hintSfMediumgreysm() {
  return TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 12.0,
    color: Color(0xFF6E7990),
    fontFamily: 'SfUiDMedium',
  );
}

TextStyle hintSfMediumprimary() {
  return TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 14.0,
    color: primary,
    fontFamily: 'SfUiDMedium',
  );
}

TextStyle hintSfMediumpsmallgrey() {
  return TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 12.0,
    color: Color(0xFF6E798A),
    fontFamily: 'SfUiDMedium',
  );
}

TextStyle hintSfMediumblck() {
  return TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 15.0,
    color: blacktext,
    fontFamily: 'SfUiDMedium',
  );
}

TextStyle hintSfMediumblckLight() {
  return TextStyle(
    fontWeight: FontWeight.w300,
    fontSize: 13.0,
    color: Colors.black45,
    fontFamily: 'SfUiDMedium',
  );
}

TextStyle hintSfmediumgreenish() {
  return TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 14.0,
    color: Color(0xFF66E8A0),
    fontFamily: 'SfUiDMedium',
  );
}

TextStyle hintSfmediumglightgrey() {
  return TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 16.0,
    color: Color(0xFFA0A7B7),
    fontFamily: 'SfUiDMedium',
  );
}

TextStyle hintSfmediumsmallestgrey() {
  return TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 10.0,
    color: Color(0xFF6E7990),
    fontFamily: 'SfUiDMedium',
  );
}

//..................................sf-ui-bold....................................

TextStyle hintSfbold() {
  return TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 30.0,
    color: blacktext,
    fontFamily: 'SfUiDBold',
  );
}

TextStyle hintSfboldsm() {
  return TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 13.0,
    color: blacktext,
    fontFamily: 'SfUiDBold',
  );
}

TextStyle hintSfboldtext() {
  return TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 18.0,
    color: blacktext,
    fontFamily: 'SfUiDBold',
  );
}

TextStyle hintSfboldprimary() {
  return TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 16.0,
    color: primary,
    fontFamily: 'SfUiDBold',
  );
}

TextStyle hintSfboldprimaryb() {
  return TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 14.0,
    color: primary,
    fontFamily: 'SfUiDBold',
  );
}

TextStyle hintSfboldblack() {
  return TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 11.0,
    color: blacktext,
    fontFamily: 'SfUiDBold',
  );
}

TextStyle hintSfboldwhitesmall() {
  return TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 9.0,
    color: Colors.white,
    fontFamily: 'SfUiDBold',
  );
}

TextStyle hintSfboldwhitemed() {
  return TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 13.0,
    color: Colors.white,
    fontFamily: 'SfUiDBold',
  );
}

TextStyle hintSfboldprimarysm() {
  return TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 11.0,
    color: primary,
    fontFamily: 'SfUiDBold',
  );
}

TextStyle hintSfboldblackbold() {
  return TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 14.0,
    color: blacktext,
    fontFamily: 'SfUiDBold',
  );
}

TextStyle hintSfboldb() {
  return TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 14.0,
    color: blacktext,
    fontFamily: 'SfUiDBold',
  );
}

TextStyle hintSfboldsmll() {
  return TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 11.0,
    color: blacktext,
    fontFamily: 'SfUiDBold',
  );
}

TextStyle hintSfboldBig() {
  return TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 16.0,
    color: blacktext,
    fontFamily: 'SfUiDBold',
  );
}

TextStyle hintSfboldmedium() {
  return TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 19.0,
    color: blacktext,
    fontFamily: 'SfUiDBold',
  );
}

TextStyle hintSfboldBigprimary() {
  return TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 28.0,
    color: primary,
    fontFamily: 'SfUiDBold',
  );
}

TextStyle hintSfboldsmallprimary() {
  return TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 11.0,
    color: primary,
    fontFamily: 'SfUiDBold',
  );
}

TextStyle hintSfboldblacktext() {
  return TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 15.0,
    color: blacktext,
    fontFamily: 'SfUiDBold',
  );
}
//..................................sf-ui-semibold ....................................

TextStyle hintSfsemibold() {
  return TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 15.0,
    color: blacktext,
    fontFamily: 'SfUiDSemiBold',
  );
}

TextStyle hintSfsemiboldblacktext() {
  return TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 14.0,
    color: blacktext,
    fontFamily: 'SfUiDSemiBold',
  );
}

TextStyle hintSfsemiboldwhite() {
  return TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 16.0,
    color: Colors.white,
    fontFamily: 'SfUiDSemiBold',
  );
}

TextStyle hintSfsemiboldred() {
  return TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 16.0,
    color: red,
    fontFamily: 'SfUiDSemiBold',
  );
}

TextStyle hintSfsemiwhite() {
  return TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 14.0,
    color: Colors.white,
    fontFamily: 'SfUiDSemiBold',
  );
}

TextStyle hintSfsemigreysmaller() {
  return TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 13.0,
    color: Color(0xFF6E7990),
    fontFamily: 'SfUiDSemiBold',
  );
}

TextStyle hintSfsemiblack() {
  return TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 18.0,
    color: blacktext,
    fontFamily: 'SfUiDSemiBold',
  );
}

TextStyle hintSfsemiprimarysm() {
  return TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 12.0,
    color: primary,
    fontFamily: 'SfUiDSemiBold',
  );
}

TextStyle hintSfsemiprimarySm() {
  return TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 14.0,
    color: primary,
    fontFamily: 'SfUiDSemiBold',
  );
}

TextStyle hintSfsemiboldBig() {
  return TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 29.0,
    color: blacktext,
    fontFamily: 'SfUiDSemiBold',
  );
}

TextStyle hintSfsemiboldwhitish() {
  return TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 16.0,
    color: Color(0xFFF3F4F5),
    fontFamily: 'SfUiDSemiBold',
  );
}

TextStyle hintSfsemiboldb() {
  return TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 16.0,
    color: blacktext,
    fontFamily: 'SfUiDSemiBold',
  );
}

TextStyle hintSfsemiboldwhitishgrey() {
  return TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 16.0,
    color: Color(0xFFFA0A7B7),
    fontFamily: 'SfUiDSemiBold',
  );
}

TextStyle hintSfsemiboldsmallest() {
  return TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 11.0,
    color: Color(0xFFF6E7990),
    fontFamily: 'SfUiDSemiBold',
  );
}

TextStyle hintSfsemiboldsmall() {
  return TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 12.0,
    color: Color(0xFFF6E7990),
    fontFamily: 'SfUiDSemiBold',
  );
}

TextStyle hintSfsemigrey() {
  return TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 17.0,
    color: Color(0xFFF6E7990),
    fontFamily: 'SfUiDSemiBold',
  );
}

TextStyle hintSfsemiboldsmallestwhite() {
  return TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 12.0,
    color: Colors.white,
    fontFamily: 'SfUiDSemiBold',
  );
}

TextStyle hintSfsemiboldsmalltwhite() {
  return TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 14.0,
    color: Colors.white,
    fontFamily: 'SfUiDSemiBold',
  );
}

TextStyle hintSfsemiboldblack() {
  return TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 12.0,
    color: blacktext,
    fontFamily: 'SfUiDSemiBold',
  );
}

TextStyle boldHeading() {
  return TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.w600,
    fontFamily: 'OpenSansSemiBold',
    color: Colors.black,
  );
}

TextStyle authHeader() {
  return TextStyle(
    fontSize: 22.0,
    fontWeight: FontWeight.w400,
    letterSpacing: 1.0,
    fontFamily: 'OpenSansSemiBold',
  );
}

TextStyle emailTextNormal() {
  return TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w300,
    fontFamily: 'OpenSansSemiBold',
    color: Colors.black,
  );
}

TextStyle titleBold() {
  return TextStyle(
    fontSize: 15.0,
    fontWeight: FontWeight.w500,
    fontFamily: 'OpenSansSemiBold',
    color: Colors.black,
  );
}

TextStyle subtitleBoldgreen() {
  return TextStyle(
    fontSize: 17.0,
    fontWeight: FontWeight.w400,
    fontFamily: 'OpenSansSemiBold',
    color: Color(0xFF20C978),
  );
}

TextStyle descriptionSemibold() {
  return TextStyle(
      fontSize: 11.0,
      fontWeight: FontWeight.w300,
      fontFamily: 'OpenSansSemiBold',
      color: Colors.black,
      letterSpacing: 0.7);
}

TextStyle comments() {
  return TextStyle(
    fontSize: 17.0,
    fontWeight: FontWeight.w500,
    fontFamily: 'OpenSansSemiBold',
    color: Colors.black,
  );
}

TextStyle regular() {
  return TextStyle(
    fontSize: 13.0,
    fontWeight: FontWeight.w300,
    fontFamily: 'OpenSansSemiBold',
    color: Colors.black,
  );
}

TextStyle categoryHeading() {
  return TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.w500,
    fontFamily: 'OpenSansSemiBold',
    color: Colors.white,
  );
}

TextStyle profiledetails() {
  return TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.w300,
    fontFamily: 'OpenSansSemiBold',
    color: Colors.black,
  );
}

TextStyle heading() {
  return TextStyle(
      fontSize: 17.0,
      fontWeight: FontWeight.w400,
      fontFamily: 'OpenSansSemiBold',
      decoration: TextDecoration.none,
      color: Colors.black,
      letterSpacing: 0.5);
}

TextStyle labelStyle() {
  return TextStyle(
      fontSize: 15.0,
      fontWeight: FontWeight.w300,
      fontFamily: 'OpenSansSemiBold',
      color: Colors.black,
      letterSpacing: 0.5);
}

TextStyle drawertext() {
  return TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w300,
    fontFamily: 'OpenSansSemiBold',
    color: Colors.white,
  );
}

TextStyle textSemibold() {
  return TextStyle(
      fontSize: 11.0,
      fontWeight: FontWeight.w500,
      fontFamily: 'OpenSansSemiBold',
      color: Colors.black,
      letterSpacing: 0.7);
}

//////barlowBold//////

TextStyle textbarlowBoldBlack() {
  return TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
      fontFamily: 'BarlowBold',
      color: Colors.black,
      letterSpacing: 0.1);
}

TextStyle textbarlowBoldGreen() {
  return TextStyle(
      fontSize: 18.0,
      fontWeight: FontWeight.bold,
      fontFamily: 'BarlowBold',
      color: Color(0xFF00BFA5),
      letterSpacing: 0.1);
}

TextStyle textbarlowBoldWhite() {
  return TextStyle(
      fontSize: 16.0,
      fontWeight: FontWeight.bold,
      fontFamily: 'BarlowBold',
      color: Colors.white,
      letterSpacing: 0.1);
}

TextStyle textBarlowBoldBlack() {
  return TextStyle(
      fontSize: 18.0,
      fontWeight: FontWeight.bold,
      fontFamily: 'BarlowBold',
      color: Colors.black,
      letterSpacing: 0.1);
}

TextStyle textBarlowBoldPrimary() {
  return TextStyle(
      fontSize: 18.0,
      fontWeight: FontWeight.bold,
      fontFamily: 'BarlowBold',
      color: primary,
      letterSpacing: 0.1);
}

TextStyle textbarlowBoldsmBlack() {
  return TextStyle(
      fontSize: 15.0,
      fontWeight: FontWeight.bold,
      fontFamily: 'BarlowBold',
      color: Colors.black,
      letterSpacing: 0.1);
}

////barlow semibold/////

TextStyle textbarlowSemiBoldBlack() {
  return TextStyle(
      fontSize: 18.0,
      fontWeight: FontWeight.bold,
      fontFamily: 'BarlowSemiBold',
      color: Colors.black,
      letterSpacing: 0.1);
}

TextStyle textBarlowSemiBoldBlack() {
  return TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
      fontFamily: 'BarlowSemiBold',
      color: Colors.black,
      letterSpacing: 0.1);
}

///barlow medium///

TextStyle textbarlowMediumBlack() {
  return TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.w400,
      fontFamily: 'BarlowMedium',
      color: Colors.black,
      letterSpacing: 0.1);
}

TextStyle textbarlowMediumlgBlack() {
  return TextStyle(
      fontSize: 45.0,
      fontWeight: FontWeight.w400,
      fontFamily: 'BarlowMedium',
      color: Colors.black,
      letterSpacing: 0.1);
}

TextStyle textBarlowMediumBlack() {
  return TextStyle(
      fontSize: 17.0,
      fontWeight: FontWeight.w400,
      fontFamily: 'BarlowMedium',
      color: Colors.black,
      letterSpacing: 0.1);
}

TextStyle textBarlowMediumPrimary() {
  return TextStyle(
      fontSize: 15.0,
      fontWeight: FontWeight.w400,
      fontFamily: 'BarlowMedium',
      color: primary,
      letterSpacing: 0.1);
}

TextStyle textBarlowMediumGreen() {
  return TextStyle(
      fontSize: 16.0,
      fontWeight: FontWeight.w400,
      fontFamily: 'BarlowMedium',
      color: Color(0xFF20C978),
      letterSpacing: 0.1);
}

TextStyle textBarlowMediumsmBlack() {
  return TextStyle(
      fontSize: 10.0,
      fontWeight: FontWeight.w400,
      fontFamily: 'BarlowMedium',
      color: Colors.black,
      letterSpacing: 0.1);
}

TextStyle textBarlowMediumsmWhite() {
  return TextStyle(
      fontSize: 10.0,
      fontWeight: FontWeight.w400,
      fontFamily: 'BarlowMedium',
      color: Color(0xFF8E8E93),
      letterSpacing: 0.1);
}

TextStyle textBarlowMediumsmallWhite() {
  return TextStyle(
      fontSize: 19.0,
      fontWeight: FontWeight.w400,
      fontFamily: 'BarlowMedium',
      color: Colors.white,
      letterSpacing: 0.1);
}

///barlow regular /////
TextStyle textbarlowRegularBlack() {
  return TextStyle(
      fontSize: 15.0,
      fontFamily: 'BarlowRegular',
      color: Colors.black,
      letterSpacing: 0.1);
}

TextStyle textbarlowRegularaPrimary() {
  return TextStyle(
      fontSize: 16.0,
      fontFamily: 'BarlowRegular',
      fontWeight: FontWeight.w600,
      color: primary,
      letterSpacing: 0.1);
}

TextStyle textbarlowRegularaPrimar() {
  return TextStyle(
      fontSize: 16.0,
      fontFamily: 'BarlowRegular',
      color: primary,
      letterSpacing: 0.1);
}

TextStyle textBarlowRegularBlack() {
  return TextStyle(
      fontSize: 16.0,
      fontFamily: 'BarlowRegular',
      color: Colors.black,
      letterSpacing: 0.1);
}

TextStyle textBarlowRegularBlackwithOpacity() {
  return TextStyle(
      fontSize: 16.0,
      fontFamily: 'BarlowRegular',
      color: Colors.black.withOpacity(0.30),
      letterSpacing: 0.1);
}

TextStyle textBarlowRegularBlackwithOpa() {
  return TextStyle(
      fontSize: 16.0,
      fontFamily: 'BarlowRegular',
      color: Colors.black.withOpacity(0.50),
      letterSpacing: 0.1);
    
}


TextStyle textBarlowRegularWhite() {
  return TextStyle(
      fontSize: 16.0,
      fontFamily: 'BarlowRegular',
      color: Colors.white,
      letterSpacing: 0.1);
}

TextStyle textBarlowRegularWhit() {
  return TextStyle(
      fontSize: 15.0,
      fontFamily: 'BarlowRegular',
      color: Colors.white,
      letterSpacing: 0.1);
}

TextStyle textBarlowRegularrBlack() {
  return TextStyle(
      fontSize: 20.0,
      fontFamily: 'BarlowRegular',
      fontWeight: FontWeight.w400,
      color: Colors.black,
      letterSpacing: 0.1);
}

TextStyle textBarlowRegularrWhite() {
  return TextStyle(
      fontSize: 18.0,
      fontFamily: 'BarlowRegular',
      fontWeight: FontWeight.w300,
      color: Colors.white,
      letterSpacing: 0.1);
}


TextStyle textBarlowRegularGreen() {
  return TextStyle(
      fontSize: 16.0,
      fontFamily: 'BarlowRegular',
      color: Color(0xFF20C978),
      letterSpacing: 0.1);
}

TextStyle textBarlowRegularrBlacksm() {
  return TextStyle(
      fontSize: 12.0,
      fontFamily: 'BarlowRegular',
      fontWeight: FontWeight.w400,
      color: Colors.black.withOpacity(0.6),
      letterSpacing: 0.1);
}