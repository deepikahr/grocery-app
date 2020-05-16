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

final bg2 = const Color(0xFFFDFDFD);
final green = const Color(0xFF20C978);
final greyb = const Color(0xFF707070);

final greyc = const Color(0xFF8E8E93);

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

//////barlowmedium///////////

TextStyle textbarlowmedium() {
  return TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w600,
    fontFamily: 'BarlowMedium',
    color: Colors.black.withOpacity(0.60),
  );
}

TextStyle textbarlowmediumwhite() {
  return TextStyle(
      fontSize: 10.0,
      fontWeight: FontWeight.w500,
      fontFamily: 'BarlowMedium',
      color: Colors.white);
}

TextStyle textbarlowmediumwhitedull() {
  return TextStyle(
      fontSize: 10.0,
      fontWeight: FontWeight.w500,
      fontFamily: 'BarlowMedium',
      color: Colors.white.withOpacity(0.60));
}

TextStyle textbarlowmediumwred() {
  return TextStyle(
      fontSize: 30.0,
      fontWeight: FontWeight.w500,
      fontFamily: 'BarlowMedium',
      color: Color(0xFFF44242));
}

TextStyle textbarlowmediumwblack() {
  return TextStyle(
      fontSize: 16.0,
      fontWeight: FontWeight.w500,
      fontFamily: 'BarlowMedium',
      color: Colors.black);
}

TextStyle textbarlowmediumwprimary() {
  return TextStyle(
      fontSize: 16.0,
      fontWeight: FontWeight.w500,
      fontFamily: 'BarlowMedium',
      color: primary);
}
//////futuraBold//////

TextStyle textbarlowBoldWhitebig() {
  return TextStyle(
    fontSize: 25.0,
    fontWeight: FontWeight.bold,
    fontFamily: 'FuturaBold',
    color: Colors.white,
  );
}

//////barlowBold//////

TextStyle textbarlowBoldBlack() {
  return TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.bold,
    fontFamily: 'BarlowBold',
    color: Colors.black,
  );
}

TextStyle textbarlowBoldGreen() {
  return TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.bold,
    fontFamily: 'BarlowBold',
    color: Color(0xFF00BFA5),
  );
}

TextStyle textbarlowBoldgreen() {
  return TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.bold,
    fontFamily: 'BarlowBold',
    color: Color(0xFF20C978),
  );
}

TextStyle textbarlowBoldWhite() {
  return TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.bold,
    fontFamily: 'BarlowBold',
    color: Colors.white,
  );
}

TextStyle textBarlowBoldBlack() {
  return TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.bold,
    fontFamily: 'BarlowBold',
    color: Colors.black,
  );
}

TextStyle textBarlowBoldPrimary() {
  return TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.bold,
    fontFamily: 'BarlowBold',
    color: primary,
  );
}

TextStyle textbarlowBoldsmBlack() {
  return TextStyle(
    fontSize: 15.0,
    fontWeight: FontWeight.bold,
    fontFamily: 'BarlowBold',
    color: Colors.black,
  );
}

TextStyle textbarlowBoldwhite() {
  return TextStyle(
    fontSize: 30.0,
    fontWeight: FontWeight.bold,
    fontFamily: 'BarlowBold',
    color: Colors.white,
  );
}

////barlow semibold/////

TextStyle textbarlowSemiBoldBlack() {
  return TextStyle(
    fontSize: 17.0,
    fontFamily: 'BarlowSemiBold',
    color: Colors.black,
    fontWeight: FontWeight.w700,
  );
}

TextStyle textBarlowSemiBoldBlack() {
  return TextStyle(
//////barlowBold//////
    fontSize: 20.0,
    fontWeight: FontWeight.bold,
    fontFamily: 'BarlowSemiBold',
    color: Colors.black,
  );
}

TextStyle textBarlowSemiBoldBlackbigg() {
  return TextStyle(
    fontSize: 22.0,
    fontWeight: FontWeight.bold,
    fontFamily: 'BarlowSemiBold',
    color: Colors.black,
  );
}

TextStyle textBarlowSemiBoldwhite() {
  return TextStyle(
    fontSize: 22.0,
    fontWeight: FontWeight.w600,
    fontFamily: 'BarlowSemiBold',
    color: Colors.white,
  );
}

TextStyle textBarlowSemiBoldBlackbig() {
  return TextStyle(
    fontSize: 22.0,
    fontWeight: FontWeight.bold,
    fontFamily: 'BarlowSemiBold',
    color: Colors.black,
  );
}

TextStyle textAddressLocation() {
  return TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.bold,
    fontFamily: 'BarlowSemiBold',
    color: Colors.black,
  );
}

TextStyle textBarlowSemiBoldwbig() {
  return TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.bold,
    fontFamily: 'BarlowSemiBold',
    color: Colors.white,
  );
}

///barlow medium///

TextStyle textbarlowMediumBlack() {
  return TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.w400,
    fontFamily: 'BarlowMedium',
    color: Colors.black,
  );
}

TextStyle textbarlowMediumPrimary() {
  return TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.w400,
    fontFamily: 'BarlowMedium',
    color: primary,
  );
}

TextStyle textbarlowMediumBlackm() {
  return TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w400,
    fontFamily: 'BarlowMedium',
    color: Colors.black,
  );
}

TextStyle textbarlowMediumlgBlack() {
  return TextStyle(
    fontSize: 45.0,
    fontWeight: FontWeight.w400,
    fontFamily: 'BarlowMedium',
    color: Colors.black,
  );
}

TextStyle textBarlowMediumBlack() {
  return TextStyle(
    fontSize: 17.0,
    fontWeight: FontWeight.w500,
    fontFamily: 'BarlowMedium',
    color: Colors.black,
  );
}

TextStyle textBarlowMediumPrimary() {
  return TextStyle(
    fontSize: 15.0,
    fontWeight: FontWeight.w400,
    fontFamily: 'BarlowMedium',
    color: primary,
  );
}

TextStyle textBarlowMediumGreen() {
  return TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w400,
    fontFamily: 'BarlowMedium',
    color: Color(0xFF20C978),
  );
}

TextStyle textBarlowMediumsmBlack() {
  return TextStyle(
    fontSize: 10.0,
    fontWeight: FontWeight.w400,
    fontFamily: 'BarlowMedium',
    color: Colors.black,
  );
}

TextStyle textBarlowMediumsmWhite() {
  return TextStyle(
    fontSize: 10.0,
    fontWeight: FontWeight.w400,
    fontFamily: 'BarlowMedium',
    color: Color(0xFF8E8E93),
  );
}

TextStyle textBarlowMediumsmallWhite() {
  return TextStyle(
    fontSize: 19.0,
    fontWeight: FontWeight.w400,
    fontFamily: 'BarlowMedium',
    color: Colors.white,
  );
}

TextStyle textBarlowmediumsmallWhite() {
  return TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.w400,
    fontFamily: 'BarlowMedium',
    color: Colors.white,
  );
}

TextStyle textBarlowmediumLink() {
  return TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.w400,
    fontFamily: 'BarlowMedium',
    color: Color(0xFF3783DA),
  );
}

///barlow regular /////
///
TextStyle barlowregularlackstrike() {
  return TextStyle(
    fontSize: 10.0,
    color: Colors.black.withOpacity(0.60),
    decoration: TextDecoration.lineThrough,
    fontFamily: 'BarlowRegular',
  );
}

TextStyle barlowregularlack() {
  return TextStyle(
    fontSize: 10.0,
    color: Colors.black.withOpacity(0.60),
    fontFamily: 'BarlowRegular',
  );
}

TextStyle textbarlowRegularBlack() {
  return TextStyle(
    fontSize: 15.0,
    fontFamily: 'BarlowRegular',
    color: Colors.black,
  );
}

TextStyle textbarlowRegularBlackb() {
  return TextStyle(
    fontSize: 13.0,
    fontFamily: 'BarlowRegular',
    color: Colors.black,
  );
}

TextStyle textbarlowRegularBlackd() {
  return TextStyle(
    fontSize: 16.0,
    fontFamily: 'BarlowRegular',
    color: Colors.black.withOpacity(0.60),
  );
}

TextStyle textbarlowRegulardull() {
  return TextStyle(
      fontSize: 13.0, fontFamily: 'BarlowRegular', color: Color(0xFFBBBBBB));
}

TextStyle textbarlowRegularBlackdull() {
  return TextStyle(
    fontSize: 15.0,
    fontFamily: 'BarlowRegular',
    color: Colors.black.withOpacity(0.60),
  );
}

TextStyle textbarlowRegularaPrimary() {
  return TextStyle(
    fontSize: 16.0,
    fontFamily: 'BarlowRegular',
    fontWeight: FontWeight.w600,
    color: primary,
  );
}

TextStyle textbarlowRegularaPrimar() {
  return TextStyle(
    fontSize: 16.0,
    fontFamily: 'BarlowRegular',
    color: primary,
  );
}

TextStyle textbarlowRegularad() {
  return TextStyle(
    fontSize: 16.0,
    fontFamily: 'BarlowRegular',
    color: Colors.black.withOpacity(0.50),
  );
}

TextStyle textbarlowRegularadd() {
  return TextStyle(
    fontSize: 16.0,
    fontFamily: 'BarlowRegular',
    color: Colors.black.withOpacity(0.60),
  );
}

TextStyle textBarlowRegularBlack() {
  return TextStyle(
      fontSize: 16.0,
      fontFamily: 'BarlowRegular',
      color: Colors.black,
      fontWeight: FontWeight.w500);
}

TextStyle textBarlowRegularBb() {
  return TextStyle(
      fontSize: 13.0,
      fontFamily: 'BarlowRegular',
      color: Color(0xFFBBBBBB),
      fontWeight: FontWeight.w500);
}

TextStyle textBarlowRegularBlackdl() {
  return TextStyle(
      fontSize: 14.0,
      fontFamily: 'BarlowRegular',
      color: Colors.black.withOpacity(0.60),
      fontWeight: FontWeight.w500);
}

TextStyle textBarlowRegularBlacklight() {
  return TextStyle(
      fontSize: 16.0,
      fontFamily: 'BarlowRegular',
      color: Colors.black.withOpacity(0.20),
      fontWeight: FontWeight.w500);
}

TextStyle textBarlowRegularBlackwithOpacity() {
  return TextStyle(
    fontSize: 16.0,
    fontFamily: 'BarlowRegular',
    color: Colors.black.withOpacity(0.30),
  );
}

TextStyle textBarlowRegularBlackwithOpa() {
  return TextStyle(
    fontSize: 16.0,
    fontFamily: 'BarlowRegular',
    color: Colors.black.withOpacity(0.50),
  );
}

TextStyle textBarlowRegularWhite() {
  return TextStyle(
    fontSize: 16.0,
    fontFamily: 'BarlowRegular',
    color: Colors.white,
  );
}

TextStyle textBarlowRegularWhit() {
  return TextStyle(
    fontSize: 15.0,
    fontFamily: 'BarlowRegular',
    color: Colors.white,
  );
}

TextStyle textBarlowregbkck() {
  return TextStyle(
    fontSize: 20.0,
    fontFamily: 'BarlowRegular',
    color: Colors.black,
  );
}

TextStyle textBarlowregwhite() {
  return TextStyle(
    fontSize: 11.0,
    fontFamily: 'BarlowRegular',
    color: Colors.white,
  );
}

TextStyle textSMBarlowRegularrBlack() {
  return TextStyle(
      fontSize: 13.0,
      fontFamily: 'BarlowRegular',
      fontWeight: FontWeight.w400,
      color: Colors.black.withOpacity(0.6),
      letterSpacing: 0.1);
}

TextStyle textSMBarlowRegularrGreyb() {
  return TextStyle(
      fontSize: 13.0,
      fontFamily: 'BarlowRegular',
      fontWeight: FontWeight.w400,
      color: greyb,
      letterSpacing: 0.1);
}

TextStyle titleLargeSegoeBlack() {
  return TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
      fontFamily: 'BarlowBold',
      color: Colors.black.withOpacity(0.6),
      letterSpacing: 0.1);
}

TextStyle titleSegoeGreen() {
  return TextStyle(
      fontSize: 16.0,
      fontFamily: 'BarlowRegular',
      fontWeight: FontWeight.w500,
      color: green,
      letterSpacing: 0.1);
}

TextStyle titleSegoeGrey() {
  return TextStyle(
      fontSize: 16.0,
      fontFamily: 'BarlowRegular',
      fontWeight: FontWeight.w500,
      color: greyb.withOpacity(0.5),
      letterSpacing: 0.1);
}

TextStyle appbarTitle() {
  return TextStyle(
    fontSize: 17.0,
    fontFamily: 'BarlowSemiBold',
    fontWeight: FontWeight.w500,
    color: Colors.black,
  );
}

TextStyle textBarlowRegularrBlack() {
  return TextStyle(
    fontSize: 20.0,
    fontFamily: 'BarlowRegular',
    fontWeight: FontWeight.w400,
    color: Colors.black,
  );
}

TextStyle textBarlowRegularrWhite() {
  return TextStyle(
    fontSize: 18.0,
    fontFamily: 'BarlowRegular',
    fontWeight: FontWeight.w300,
    color: Colors.white,
  );
}

TextStyle textBarlowRegularrdark() {
  return TextStyle(
    fontSize: 18.0,
    fontFamily: 'BarlowRegular',
    fontWeight: FontWeight.w300,
    color: Colors.black,
  );
}

TextStyle textBarlowRegularrdarkdull() {
  return TextStyle(
    fontSize: 15.0,
    fontFamily: 'BarlowRegular',
    fontWeight: FontWeight.w400,
    color: Colors.black.withOpacity(0.40),
  );
}

TextStyle textBarlowRegularGreen() {
  return TextStyle(
    fontSize: 16.0,
    fontFamily: 'BarlowRegular',
    color: Color(0xFF20C978),
  );
}

TextStyle textBarlowRegularrBlacksm() {
  return TextStyle(
    fontSize: 12.0,
    fontFamily: 'BarlowRegular',
    fontWeight: FontWeight.w400,
    color: Colors.black.withOpacity(0.6),
  );
}

TextStyle textBarlowRegularrwhsm() {
  return TextStyle(
    fontSize: 10.0,
    fontFamily: 'BarlowRegular',
    fontWeight: FontWeight.w400,
    color: Colors.white.withOpacity(0.87),
  );
}

TextStyle textBarlowregwhitelg() {
  return TextStyle(
    fontSize: 20.0,
    fontFamily: 'BarlowRegular',
    color: Colors.white.withOpacity(0.70),
  );
}

TextStyle textBarlowregredlg() {
  return TextStyle(
    fontSize: 20.0,
    fontFamily: 'BarlowRegular',
    color: Color(0xFFF44242),
  );
}

TextStyle textBarlowregredGreen() {
  return TextStyle(
    fontSize: 20.0,
    fontFamily: 'BarlowRegular',
    color: Colors.green,
  );
}

////////////////////////oswald bold//////////////////
TextStyle textoswaldboldwhite() {
  return TextStyle(
    fontSize: 20.0,
    fontFamily: 'OswaldBold',
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
}
