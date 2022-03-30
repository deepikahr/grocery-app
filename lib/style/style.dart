import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:readymadeGroceryApp/main.dart';

class Styles {
  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    return ThemeData(
      brightness: isDarkTheme ? Brightness.dark : Brightness.light,
      cardColor: isDarkTheme ? Colors.grey[800] : Colors.white,
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: isDarkTheme ? Color(0xFF1e2024) : Colors.black,
          unselectedItemColor: greyc2,
          selectedItemColor: primarybg),
      textSelectionTheme: TextSelectionThemeData(
        selectionColor: Colors.transparent,
        selectionHandleColor: Colors.transparent,
        cursorColor: isDarkTheme ? greyb2 : darkbg,
      ),
      appBarTheme: isDarkTheme
          ? AppBarTheme(systemOverlayStyle: SystemUiOverlayStyle.dark)
          : AppBarTheme(systemOverlayStyle: SystemUiOverlayStyle.light),
    );
  }
}

final primarybg = const Color(0xFFFFCF2D);
final darkbg = const Color(0xFF10161f);
final lightbg = const Color(0xFFF4F7FA);

final blackText2 = const Color(0xFF272A3F);
final bg2 = const Color(0xFFFDFDFD);
final primaryLight2 = const Color(0xFFE6EFF7);
final border2 = const Color(0xFFD4D4E0);
final grey2 = const Color(0xFFdddddd);
final greya2 = const Color(0xFFDCDCDC);
final greyb2 = const Color(0xFF707070);
final greyc2 = const Color(0xFF8E8E93);
final darkgrey2 = const Color(0xFF708090);

final red = const Color(0xFFF34949);
final star = const Color(0xFFff8064);
final green = const Color(0xFF20C978);

dynamic primary(context) {
  if (Theme.of(context).brightness == Brightness.dark) {
    return primarybg;
  } else {
    return primarybg;
  }
}

dynamic cartCardBg(context) {
  if (Theme.of(context).brightness == Brightness.dark) {
    return Color(0xFF282b30);
  } else {
    return Color(0xFFF7F7F7);
  }
}

dynamic whiteBg(context) {
  if (Theme.of(context).brightness == Brightness.dark) {
    return greyb2;
  } else {
    return Colors.white;
  }
}

dynamic blackText(context) {
  if (Theme.of(context).brightness == Brightness.dark) {
    return Color(0xFFF4FFFA);
  } else {
    return Colors.black87;
  }
}

dynamic dark(context) {
  if (Theme.of(context).brightness == Brightness.dark) {
    return Colors.white;
  } else {
    return Colors.black;
  }
}

dynamic bg(context) {
  if (Theme.of(context).brightness == Brightness.dark) {
    return darkbg;
  } else {
    return lightbg;
  }
}

dynamic primaryLight(context) {
  if (Theme.of(context).brightness == Brightness.dark) {
    return Color(0xFF151b24);
  } else {
    return primaryLight2;
  }
}

dynamic border(context) {
  if (Theme.of(context).brightness == Brightness.dark) {
    return Color(0xFF151b24);
  } else {
    return border2;
  }
}

dynamic grey(context) {
  if (Theme.of(context).brightness == Brightness.dark) {
    return Color(0xFF9a9da1);
  } else {
    return grey2;
  }
}

dynamic greya(context) {
  if (Theme.of(context).brightness == Brightness.dark) {
    return Color(0xFF80858a);
  } else {
    return greya2;
  }
}

dynamic greyb(context) {
  if (Theme.of(context).brightness == Brightness.dark) {
    return Color(0xFF484a4d);
  } else {
    return greyb2;
  }
}

dynamic greyc(context) {
  if (Theme.of(context).brightness == Brightness.dark) {
    return Color(0xFF37393b);
  } else {
    return greyc2;
  }
}

dynamic darkgrey(context) {
  if (Theme.of(context).brightness == Brightness.dark) {
    return Color(0xFF282c30);
  } else {
    return darkgrey2;
  }
}

dynamic greyd(context) {
  if (Theme.of(context).brightness == Brightness.dark) {
    return Colors.grey;
  } else {
    return Colors.grey;
  }
}

double screenHeight(context) {
  return MediaQuery.of(context).size.height;
}

double screenWidth(context) {
  return MediaQuery.of(context).size.width;
}

//..................................sf-ui-light ....................................

TextStyle hintSfLightprimary(context) {
  return TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 28.0,
    color: primary(context),
    fontFamily: 'SfUiDLight',
  );
}

TextStyle hintSfLightsmall(context) {
  return TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 12.0,
    color: blackText(context),
    fontFamily: 'SfUiDLight',
  );
}

TextStyle subtitleBold(context) {
  return TextStyle(
    fontSize: 17.0,
    fontWeight: FontWeight.w400,
    fontFamily: 'OpenSansSemiBold',
    color: dark(context),
  );
}

TextStyle hintSfLight(context) {
  return TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 16.0,
    color: Color(0xFF6E798A),
    fontFamily: 'SfUiDLight',
  );
}

TextStyle hintSfLightsm(context) {
  return TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 13.0,
    color: Color(0xFF6E7990),
    fontFamily: 'SfUiDLight',
  );
}

TextStyle hintSfLightbig(context) {
  return TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 16.0,
    color: blackText(context),
    fontFamily: 'SfUiDLight',
  );
}

//..................................sf-ui-medium ....................................

TextStyle hintSfMediumbig(context) {
  return TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 28.0,
    color: blackText(context),
    fontFamily: 'SfUiDMedium',
  );
}

TextStyle hintSfMediumsmall(context) {
  return TextStyle(
    fontWeight: FontWeight.w100,
    fontSize: 14.0,
    color: Colors.white,
    fontFamily: 'SfUiDMedium',
  );
}

TextStyle hintSfMediumblack(context) {
  return TextStyle(
    fontWeight: FontWeight.w100,
    fontSize: 18.0,
    color: blackText(context),
    fontFamily: 'SfUiDMedium',
  );
}

TextStyle hintSmallSfMediumblack(context) {
  return TextStyle(
    fontWeight: FontWeight.w100,
    fontSize: 13.0,
    color: blackText(context),
    fontFamily: 'SfUiDMedium',
  );
}

TextStyle hintSfMediumblackbig(context) {
  return TextStyle(
    fontWeight: FontWeight.w300,
    fontSize: 16.0,
    color: blackText(context),
    fontFamily: 'SfUiDMedium',
  );
}

TextStyle hintSfmediumblack(context) {
  return TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 14.0,
    color: blackText(context),
    fontFamily: 'SfUiDMedium',
  );
}

TextStyle hintSfMediumprimaryb(context) {
  return TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 17.0,
    color: primary(context),
    fontFamily: 'SfUiDMedium',
  );
}

TextStyle hintSfMediumprimarysmall(context) {
  return TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 14.0,
    color: primary(context),
    fontFamily: 'SfUiDMedium',
  );
}

TextStyle hintSfMediumgreysmall(context) {
  return TextStyle(
    fontWeight: FontWeight.w100,
    fontSize: 14.0,
    color: Color(0xFF6E7990),
    fontFamily: 'SfUiDMedium',
  );
}

TextStyle hintSfMediumgreyersmall(context) {
  return TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 16.0,
    color: blackText(context),
    fontFamily: 'SfUiDMedium',
  );
}

TextStyle hintSfMediumgreyersmallLight(context) {
  return TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 16.0,
    color: grey(context),
    fontFamily: 'SfUiDMedium',
  );
}

TextStyle hintSfletterspacingMediumgreyersmall(context) {
  return TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 16.0,
      color: blackText2,
      fontFamily: 'SfUiDMedium',
      letterSpacing: 7.0);
}

TextStyle hintSfMediumredsmall(context) {
  return TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 16.0,
    color: red,
    fontFamily: 'SfUiDMedium',
  );
}

TextStyle hintSfMediumgreysmaller(context) {
  return TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 13.0,
    color: Color(0xFF6E7990),
    fontFamily: 'SfUiDMedium',
  );
}

TextStyle hintSfMediumprimarysm(context) {
  return TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 11.0,
    color: primary(context),
    fontFamily: 'SfUiDMedium',
  );
}

TextStyle hintSfMediumblacksmaller(context) {
  return TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 13.0,
    color: blackText(context),
    fontFamily: 'SfUiDMedium',
  );
}

TextStyle hintSfMediumgrey(context) {
  return TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 14.7,
    color: Color(0xFF6E7990),
    fontFamily: 'SfUiDMedium',
  );
}

TextStyle hintSfMediumgreysml(context) {
  return TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 14,
    color: Color(0xFF9AA1B1),
    fontFamily: 'SfUiDMedium',
  );
}

TextStyle hintSfMediumgreysl(context) {
  return TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 14,
    color: Color(0xFFA0A7B7),
    fontFamily: 'SfUiDMedium',
  );
}

TextStyle hintSfMediumsmaller(context) {
  return TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 12.0,
    color: blackText(context),
    fontFamily: 'SfUiDMedium',
  );
}

TextStyle hintSfMediumwhitesmaller(context) {
  return TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 14.0,
    color: Colors.white,
    fontFamily: 'SfUiDMedium',
  );
}

TextStyle hintSfMediumgreysm(context) {
  return TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 12.0,
    color: Color(0xFF6E7990),
    fontFamily: 'SfUiDMedium',
  );
}

TextStyle hintSfMediumprimary(context) {
  return TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 14.0,
    color: primary(context),
    fontFamily: 'SfUiDMedium',
  );
}

TextStyle hintSfMediumpsmallgrey(context) {
  return TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 12.0,
    color: Color(0xFF6E798A),
    fontFamily: 'SfUiDMedium',
  );
}

TextStyle hintSfMediumblck(context) {
  return TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 15.0,
    color: blackText(context),
    fontFamily: 'SfUiDMedium',
  );
}

TextStyle hintSfMediumblckLight(context) {
  return TextStyle(
    fontWeight: FontWeight.w300,
    fontSize: 13.0,
    color: Colors.black45,
    fontFamily: 'SfUiDMedium',
  );
}

TextStyle hintSfmediumgreenish(context) {
  return TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 14.0,
    color: Color(0xFF66E8A0),
    fontFamily: 'SfUiDMedium',
  );
}

TextStyle hintSfmediumglightgrey(context) {
  return TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 16.0,
    color: Color(0xFFA0A7B7),
    fontFamily: 'SfUiDMedium',
  );
}

TextStyle hintSfmediumsmallestgrey(context) {
  return TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 10.0,
    color: Color(0xFF6E7990),
    fontFamily: 'SfUiDMedium',
  );
}

//..................................sf-ui-bold....................................

TextStyle hintSfbold(context) {
  return TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 30.0,
    color: blackText(context),
    fontFamily: 'SfUiDBold',
  );
}

TextStyle hintSfboldsm(context) {
  return TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 13.0,
    color: blackText(context),
    fontFamily: 'SfUiDBold',
  );
}

TextStyle hintSfboldtext(context) {
  return TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 18.0,
    color: blackText(context),
    fontFamily: 'SfUiDBold',
  );
}

TextStyle hintSfboldprimary(context) {
  return TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 16.0,
    color: primary(context),
    fontFamily: 'SfUiDBold',
  );
}

TextStyle hintSfboldprimaryb(context) {
  return TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 14.0,
    color: primary(context),
    fontFamily: 'SfUiDBold',
  );
}

TextStyle hintSfboldblack(context) {
  return TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 11.0,
    color: blackText(context),
    fontFamily: 'SfUiDBold',
  );
}

TextStyle hintSfboldwhitesmall(context) {
  return TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 9.0,
    color: Colors.white,
    fontFamily: 'SfUiDBold',
  );
}

TextStyle hintSfboldwhitemed(context) {
  return TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 13.0,
    color: Colors.white,
    fontFamily: 'SfUiDBold',
  );
}

TextStyle hintSfboldprimarysm(context) {
  return TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 11.0,
    color: primary(context),
    fontFamily: 'SfUiDBold',
  );
}

TextStyle hintSfboldblackbold(context) {
  return TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 14.0,
    color: blackText(context),
    fontFamily: 'SfUiDBold',
  );
}

TextStyle hintSfboldb(context) {
  return TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 14.0,
    color: blackText(context),
    fontFamily: 'SfUiDBold',
  );
}

TextStyle hintSfboldsmll(context) {
  return TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 11.0,
    color: blackText(context),
    fontFamily: 'SfUiDBold',
  );
}

TextStyle hintSfboldBig(context) {
  return TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 16.0,
    color: blackText(context),
    fontFamily: 'SfUiDBold',
  );
}

TextStyle hintSfboldmedium(context) {
  return TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 19.0,
    color: blackText(context),
    fontFamily: 'SfUiDBold',
  );
}

TextStyle hintSfboldBigprimary(context) {
  return TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 28.0,
    color: primary(context),
    fontFamily: 'SfUiDBold',
  );
}

TextStyle hintSfboldsmallprimary(context) {
  return TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 11.0,
    color: primary(context),
    fontFamily: 'SfUiDBold',
  );
}

TextStyle hintSfboldblackText(context) {
  return TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 15.0,
    color: blackText(context),
    fontFamily: 'SfUiDBold',
  );
}
//..................................sf-ui-semibold ....................................

TextStyle hintSfsemibold(context) {
  return TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 15.0,
    color: blackText(context),
    fontFamily: 'SfUiDSemiBold',
  );
}

TextStyle hintSfsemiboldblackText(context) {
  return TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 14.0,
    color: blackText(context),
    fontFamily: 'SfUiDSemiBold',
  );
}

TextStyle hintSfsemiboldwhite(context) {
  return TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 16.0,
    color: Colors.white,
    fontFamily: 'SfUiDSemiBold',
  );
}

TextStyle hintSfsemiboldred(context) {
  return TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 16.0,
    color: red,
    fontFamily: 'SfUiDSemiBold',
  );
}

TextStyle hintSfsemiwhite(context) {
  return TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 14.0,
    color: Colors.white,
    fontFamily: 'SfUiDSemiBold',
  );
}

TextStyle hintSfsemigreysmaller(context) {
  return TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 13.0,
    color: Color(0xFF6E7990),
    fontFamily: 'SfUiDSemiBold',
  );
}

TextStyle hintSfsemiblack(context) {
  return TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 18.0,
    color: blackText(context),
    fontFamily: 'SfUiDSemiBold',
  );
}

TextStyle hintSfsemiprimarysm(context) {
  return TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 12.0,
    color: primary(context),
    fontFamily: 'SfUiDSemiBold',
  );
}

TextStyle hintSfsemiprimarySm(context) {
  return TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 14.0,
    color: primary(context),
    fontFamily: 'SfUiDSemiBold',
  );
}

TextStyle hintSfsemiboldBig(context) {
  return TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 29.0,
    color: blackText(context),
    fontFamily: 'SfUiDSemiBold',
  );
}

TextStyle hintSfsemiboldwhitish(context) {
  return TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 16.0,
    color: Color(0xFFF3F4F5),
    fontFamily: 'SfUiDSemiBold',
  );
}

TextStyle hintSfsemiboldb(context) {
  return TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 16.0,
    color: blackText(context),
    fontFamily: 'SfUiDSemiBold',
  );
}

TextStyle hintSfsemiboldwhitishgrey(context) {
  return TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 16.0,
    color: Color(0xFFFA0A7B7),
    fontFamily: 'SfUiDSemiBold',
  );
}

TextStyle hintSfsemiboldsmallest(context) {
  return TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 11.0,
    color: Color(0xFFF6E7990),
    fontFamily: 'SfUiDSemiBold',
  );
}

TextStyle hintSfsemiboldsmall(context) {
  return TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 12.0,
    color: Color(0xFFF6E7990),
    fontFamily: 'SfUiDSemiBold',
  );
}

TextStyle hintSfsemigrey(context) {
  return TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 17.0,
    color: Color(0xFFF6E7990),
    fontFamily: 'SfUiDSemiBold',
  );
}

TextStyle hintSfsemiboldsmallestwhite(context) {
  return TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 12.0,
    color: Colors.white,
    fontFamily: 'SfUiDSemiBold',
  );
}

TextStyle hintSfsemiboldsmalltwhite(context) {
  return TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 14.0,
    color: Colors.white,
    fontFamily: 'SfUiDSemiBold',
  );
}

TextStyle hintSfsemiboldblack(context) {
  return TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 12.0,
    color: blackText(context),
    fontFamily: 'SfUiDSemiBold',
  );
}

TextStyle boldHeading(context) {
  return TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.w600,
    fontFamily: 'OpenSansSemiBold',
    color: dark(context),
  );
}

TextStyle authHeader(context) {
  return TextStyle(
    fontSize: 22.0,
    fontWeight: FontWeight.w400,
    letterSpacing: 1.0,
    fontFamily: 'OpenSansSemiBold',
  );
}

TextStyle emailTextNormal(context) {
  return TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w300,
    fontFamily: 'OpenSansSemiBold',
    color: dark(context),
  );
}

TextStyle titleBold(context) {
  return TextStyle(
    fontSize: 15.0,
    fontWeight: FontWeight.w500,
    fontFamily: 'OpenSansSemiBold',
    color: dark(context),
  );
}

TextStyle subtitleBoldgreen(context) {
  return TextStyle(
    fontSize: 17.0,
    fontWeight: FontWeight.w400,
    fontFamily: 'OpenSansSemiBold',
    color: Color(0xFF20C978),
  );
}

TextStyle descriptionSemibold(context) {
  return TextStyle(
      fontSize: 11.0,
      fontWeight: FontWeight.w300,
      fontFamily: 'OpenSansSemiBold',
      color: dark(context),
      letterSpacing: 0.7);
}

TextStyle comments(context) {
  return TextStyle(
    fontSize: 17.0,
    fontWeight: FontWeight.w500,
    fontFamily: 'OpenSansSemiBold',
    color: dark(context),
  );
}

TextStyle regular(context) {
  return TextStyle(
    fontSize: 13.0,
    fontWeight: FontWeight.w300,
    fontFamily: 'OpenSansSemiBold',
    color: dark(context),
  );
}

TextStyle categoryHeading(context) {
  return TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.w500,
    fontFamily: 'OpenSansSemiBold',
    color: Colors.white,
  );
}

TextStyle profiledetails(context) {
  return TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.w300,
    fontFamily: 'OpenSansSemiBold',
    color: dark(context),
  );
}

TextStyle heading(context) {
  return TextStyle(
      fontSize: 17.0,
      fontWeight: FontWeight.w400,
      fontFamily: 'OpenSansSemiBold',
      decoration: TextDecoration.none,
      color: dark(context),
      letterSpacing: 0.5);
}

TextStyle labelStyle(context) {
  return TextStyle(
      fontSize: 15.0,
      fontWeight: FontWeight.w300,
      fontFamily: 'OpenSansSemiBold',
      color: dark(context),
      letterSpacing: 0.5);
}

TextStyle drawertext(context) {
  return TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w300,
    fontFamily: 'OpenSansSemiBold',
    color: Colors.white,
  );
}

TextStyle textSemibold(context) {
  return TextStyle(
      fontSize: 11.0,
      fontWeight: FontWeight.w500,
      fontFamily: 'OpenSansSemiBold',
      color: dark(context),
      letterSpacing: 0.7);
}

//////barlowmedium///////////

TextStyle textbarlowmedium(context) {
  return TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w600,
    fontFamily: 'BarlowMedium',
    color: dark(context).withOpacity(0.60),
  );
}

TextStyle textbarlowmediumwhite(context) {
  return TextStyle(
      fontSize: 10.0,
      fontWeight: FontWeight.w500,
      fontFamily: 'BarlowMedium',
      color: Colors.white);
}

TextStyle textbarlowmediumwhitee(context) {
  return TextStyle(
      fontSize: 16.0,
      fontWeight: FontWeight.w500,
      fontFamily: 'BarlowMedium',
      color: Colors.white);
}

TextStyle textbarlowmediumwhitedull(context) {
  return TextStyle(
      fontSize: 10.0,
      fontWeight: FontWeight.w500,
      fontFamily: 'BarlowMedium',
      color: Colors.white.withOpacity(0.60));
}

TextStyle textbarlowmediumwred(context) {
  return TextStyle(
      fontSize: 30.0,
      fontWeight: FontWeight.w500,
      fontFamily: 'BarlowMedium',
      color: Color(0xFFF44242));
}

TextStyle textbarlowmediumwblack(context) {
  return TextStyle(
      fontSize: 16.0,
      fontWeight: FontWeight.w500,
      fontFamily: 'BarlowMedium',
      color: dark(context));
}

TextStyle textbarlowmediumwprimary(context) {
  return TextStyle(
      fontSize: 16.0,
      fontWeight: FontWeight.w500,
      fontFamily: 'BarlowMedium',
      color: primary(context));
}
//////futuraBold//////

TextStyle textbarlowBoldWhitebig(context) {
  return TextStyle(
    fontSize: 25.0,
    fontWeight: FontWeight.bold,
    fontFamily: 'FuturaBold',
    color: Colors.white,
  );
}

//////barlowBold//////

TextStyle textbarlowBoldBlack(context) {
  return TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.bold,
    fontFamily: 'BarlowBold',
    color: dark(context),
  );
}

TextStyle textbarlowBoldGreen(context) {
  return TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.bold,
    fontFamily: 'BarlowBold',
    color: Color(0xFF00BFA5),
  );
}

TextStyle textbarlowBoldgreen(context) {
  return TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.bold,
    fontFamily: 'BarlowBold',
    color: Color(0xFF20C978),
  );
}

TextStyle textbarlowBoldWhite(context) {
  return TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.bold,
    fontFamily: 'BarlowBold',
    color: Colors.white,
  );
}

TextStyle textBarlowBoldBlack(context) {
  return TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.bold,
    fontFamily: 'BarlowBold',
    color: dark(context),
  );
}

TextStyle textBarlowBoldprimary(context) {
  return TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.bold,
    fontFamily: 'BarlowBold',
    color: primary(context),
  );
}

TextStyle textbarlowBoldsmBlack(context) {
  return TextStyle(
    fontSize: 15.0,
    fontWeight: FontWeight.bold,
    fontFamily: 'BarlowBold',
    color: dark(context),
  );
}

TextStyle textbarlowBoldsmGreen(context) {
  return TextStyle(
    fontSize: 15.0,
    fontWeight: FontWeight.bold,
    fontFamily: 'BarlowBold',
    color: green,
  );
}

TextStyle textbarlowBoldwhite(context) {
  return TextStyle(
    fontSize: 30.0,
    fontWeight: FontWeight.bold,
    fontFamily: 'BarlowBold',
    color: Colors.white,
  );
}

////barlow semibold/////

TextStyle appbarText(context) {
  return TextStyle(
    fontSize: 17.0,
    fontFamily: 'BarlowSemiBold',
    color: dark(context),
    fontWeight: FontWeight.w700,
  );
}

TextStyle textbarlowSemiBoldBlack(context) {
  return TextStyle(
    fontSize: 17.0,
    fontFamily: 'BarlowSemiBold',
    color: dark(context),
    fontWeight: FontWeight.w700,
  );
}

TextStyle textBarlowSemiBoldBlack(context) {
  return TextStyle(
//////barlowBold//////
    fontSize: 20.0,
    fontWeight: FontWeight.bold,
    fontFamily: 'BarlowSemiBold',
    color: dark(context),
  );
}

TextStyle textBarlowSemiBoldBlackbigg(context) {
  return TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.bold,
    fontFamily: 'BarlowSemiBold',
    color: dark(context),
  );
}

TextStyle textBarlowSemiBoldwhite(context) {
  return TextStyle(
    fontSize: 22.0,
    fontWeight: FontWeight.w600,
    fontFamily: 'BarlowSemiBold',
    color: Colors.white,
  );
}

TextStyle textBarlowSemiBoldBlackbig(context) {
  return TextStyle(
    fontSize: 22.0,
    fontWeight: FontWeight.bold,
    fontFamily: 'BarlowSemiBold',
    color: dark(context),
  );
}

TextStyle textAddressLocation(context) {
  final themeChange = Provider.of<DarkThemeProvider>(context);
  return TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.bold,
    fontFamily: 'BarlowSemiBold',
    color: themeChange.darkTheme ? Colors.white : whiteBg(context),
  );
}

TextStyle textBarlowSemiBoldwbig(context) {
  return TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.bold,
    fontFamily: 'BarlowSemiBold',
    color: Colors.white,
  );
}

TextStyle textBarlowSemiboldGreen(context) {
  return TextStyle(
    fontSize: 14.0,
    fontFamily: 'BarlowSemiBold',
    color: Color(0xFF20C978),
  );
}

TextStyle textBarlowSemiboldprimary(context) {
  return TextStyle(
    fontSize: 14.0,
    fontFamily: 'BarlowSemiBold',
    color: primary(context),
  );
}

TextStyle textBarlowSemiboldprimaryy(context) {
  return TextStyle(
    fontSize: 16.0,
    fontFamily: 'BarlowSemiBold',
    color: primary(context),
  );
}

TextStyle textBarlowSemiboldblack(context) {
  return TextStyle(
      fontSize: 14.0, fontFamily: 'BarlowSemiBold', color: dark(context));
}

///barlow medium///

TextStyle textbarlowMediumBlack(context) {
  return TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.w400,
    fontFamily: 'BarlowMedium',
    color: dark(context),
  );
}

TextStyle textbarlowmediumpri(context) {
  return TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w600,
    fontFamily: 'BarlowMedium',
    color: primary(context),
  );
}

TextStyle textbarlowMediumprimary(context) {
  return TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.w400,
    fontFamily: 'BarlowMedium',
    color: primary(context),
  );
}

TextStyle textbarlowMediumBlackm(context) {
  return TextStyle(
      fontSize: 14.0,
      fontWeight: FontWeight.w400,
      fontFamily: 'BarlowMedium',
      color: Colors.black);
}

TextStyle textbarlowMediumlgBlack(context) {
  return TextStyle(
    fontSize: 45.0,
    fontWeight: FontWeight.w400,
    fontFamily: 'BarlowMedium',
    color: dark(context),
  );
}

TextStyle textBarlowMediumBlack(context) {
  return TextStyle(
    fontSize: 17.0,
    fontWeight: FontWeight.w500,
    fontFamily: 'BarlowMedium',
    color: dark(context),
  );
}

TextStyle textBarlowMediumprimary(context) {
  return TextStyle(
    fontSize: 15.0,
    fontWeight: FontWeight.w400,
    fontFamily: 'BarlowMedium',
    color: primary(context),
  );
}

TextStyle textBarlowMediumGreen(context) {
  return TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w400,
    fontFamily: 'BarlowMedium',
    color: Color(0xFF20C978),
  );
}

TextStyle textBarlowMediumsmBlack(context) {
  return TextStyle(
    fontSize: 10.0,
    fontWeight: FontWeight.w400,
    fontFamily: 'BarlowMedium',
    color: dark(context),
  );
}

TextStyle textBarlowMediumsmBlackk(context) {
  return TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w400,
    fontFamily: 'BarlowMedium',
    color: dark(context).withOpacity(0.87),
  );
}

TextStyle textBarlowMediumsmWhite(context) {
  return TextStyle(
    fontSize: 10.0,
    fontWeight: FontWeight.w400,
    fontFamily: 'BarlowMedium',
    color: greyc2,
  );
}

TextStyle textBarlowMediumsmallWhite(context) {
  return TextStyle(
    fontSize: 19.0,
    fontWeight: FontWeight.w400,
    fontFamily: 'BarlowMedium',
    color: Colors.white,
  );
}

TextStyle textBarlowmediumsmallWhite(context) {
  return TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.w400,
    fontFamily: 'BarlowMedium',
    color: Colors.white,
  );
}

TextStyle textBarlowmediumLink(context) {
  return TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.w400,
    fontFamily: 'BarlowMedium',
    color: Color(0xFF3783DA),
  );
}

///barlow regular /////
///
TextStyle barlowregularlackstrike(context) {
  return TextStyle(
    fontSize: 10.0,
    color: dark(context).withOpacity(0.60),
    decoration: TextDecoration.lineThrough,
    fontFamily: 'BarlowRegular',
  );
}

TextStyle barlowregularlack(context) {
  return TextStyle(
    fontSize: 10.0,
    color: dark(context).withOpacity(0.60),
    fontFamily: 'BarlowRegular',
  );
}

TextStyle textbarlowRegularBlack(context) {
  return TextStyle(
    fontSize: 15.0,
    fontFamily: 'BarlowRegular',
    color: dark(context),
  );
}

TextStyle textbarlowRegularBlackbold(context) {
  return TextStyle(
    fontSize: 15.0,
    fontWeight: FontWeight.bold,
    fontFamily: 'BarlowRegular',
    color: dark(context),
  );
}

TextStyle textbarlowRegularBlackb(context) {
  return TextStyle(
    fontSize: 13.0,
    fontFamily: 'BarlowRegular',
    color: dark(context),
  );
}

TextStyle textbarlowRegularBlackd(context) {
  return TextStyle(
    fontSize: 12.0,
    fontFamily: 'BarlowRegular',
    color: dark(context).withOpacity(0.60),
  );
}

TextStyle textbarlowRegularBlackFont(context) {
  return TextStyle(
    fontSize: 15.0,
    fontFamily: 'BarlowRegular',
    color: dark(context).withOpacity(0.60),
  );
}

TextStyle textbarlowRegulardull(context) {
  return TextStyle(
      fontSize: 13.0, fontFamily: 'BarlowRegular', color: Color(0xFFBBBBBB));
}

TextStyle textbarlowRegularBlackdull(context) {
  return TextStyle(
    fontSize: 15.0,
    fontFamily: 'BarlowRegular',
    color: dark(context).withOpacity(0.60),
  );
}

TextStyle textbarlowRegularaprimary(context) {
  return TextStyle(
    fontSize: 16.0,
    fontFamily: 'BarlowRegular',
    fontWeight: FontWeight.w600,
    color: primary(context),
  );
}

TextStyle textbarlowRegularaPrimar(context) {
  return TextStyle(
    fontSize: 16.0,
    fontFamily: 'BarlowRegular',
    color: primary(context),
  );
}

TextStyle textbarlowRegularaDark(context) {
  return TextStyle(
    fontSize: 16.0,
    fontFamily: 'BarlowRegular',
    color: dark(context),
  );
}

TextStyle textbarlowRegularad(context) {
  return TextStyle(
    fontSize: 16.0,
    fontFamily: 'BarlowRegular',
    color: dark(context).withOpacity(0.50),
  );
}

TextStyle textbarlowRegularaddwithop(context) {
  return TextStyle(
    fontSize: 16.0,
    fontFamily: 'BarlowRegular',
    color: dark(context).withOpacity(0.37),
  );
}

TextStyle textbarlowRegularadark(context) {
  return TextStyle(
    fontSize: 16.0,
    fontFamily: 'BarlowRegular',
    color: dark(context),
  );
}

TextStyle textbarlowRegularadd(context) {
  return TextStyle(
    fontSize: 16.0,
    fontFamily: 'BarlowRegular',
    color: dark(context).withOpacity(0.60),
  );
}

TextStyle textBarlowRegularBlack(context) {
  return TextStyle(
      fontSize: 16.0,
      fontFamily: 'BarlowRegular',
      color: dark(context),
      fontWeight: FontWeight.w500);
}

TextStyle textBarlowRegularBb(context) {
  return TextStyle(
      fontSize: 13.0,
      fontFamily: 'BarlowRegular',
      color: Color(0xFFBBBBBB),
      fontWeight: FontWeight.w500);
}

TextStyle textBarlowRegularBlackdl(context) {
  return TextStyle(
      fontSize: 14.0,
      fontFamily: 'BarlowRegular',
      color: dark(context).withOpacity(0.60),
      fontWeight: FontWeight.w500);
}

TextStyle textBarlowRegularBlacklight(context) {
  return TextStyle(
      fontSize: 16.0,
      fontFamily: 'BarlowRegular',
      color: Theme.of(context).brightness == Brightness.dark
          ? Colors.white70
          : Colors.black.withOpacity(0.20),
      fontWeight: FontWeight.w500);
}

TextStyle textBarlowRegularBlackwithOpacity(context) {
  return TextStyle(
    fontSize: 16.0,
    fontFamily: 'BarlowRegular',
    color: dark(context).withOpacity(0.30),
  );
}

TextStyle textBarlowRegularBlackwithOpa(context) {
  return TextStyle(
    fontSize: 16.0,
    fontFamily: 'BarlowRegular',
    color: dark(context).withOpacity(0.50),
  );
}

TextStyle textBarlowRegularWhite(context) {
  return TextStyle(
    fontSize: 16.0,
    fontFamily: 'BarlowRegular',
    color: Colors.white,
  );
}

TextStyle textBarlowRegularWhit(context) {
  return TextStyle(
    fontSize: 15.0,
    fontFamily: 'BarlowRegular',
    color: Colors.white,
  );
}

TextStyle textBarlowregbkck(context) {
  return TextStyle(
    fontSize: 20.0,
    fontFamily: 'BarlowRegular',
    color: dark(context),
  );
}

TextStyle textBarlowregwhite(context) {
  return TextStyle(
    fontSize: 11.0,
    fontFamily: 'BarlowRegular',
    color: Colors.white,
  );
}

TextStyle textSMBarlowRegularrBlack(context) {
  return TextStyle(
      fontSize: 13.0,
      fontFamily: 'BarlowRegular',
      fontWeight: FontWeight.w400,
      color: dark(context).withOpacity(0.6),
      letterSpacing: 0.1);
}

TextStyle textSMBarlowRegularrgreyb(context) {
  return TextStyle(
      fontSize: 13.0,
      fontFamily: 'BarlowRegular',
      fontWeight: FontWeight.w400,
      color: greyb(context),
      letterSpacing: 0.1);
}

TextStyle titleLargeSegoeBlack(context) {
  return TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
      fontFamily: 'BarlowBold',
      color: dark(context).withOpacity(0.6),
      letterSpacing: 0.1);
}

TextStyle titleSegoeGreen(context) {
  return TextStyle(
      fontSize: 16.0,
      fontFamily: 'BarlowRegular',
      fontWeight: FontWeight.w500,
      color: green,
      letterSpacing: 0.1);
}

TextStyle titleSegoegrey(context) {
  return TextStyle(
      fontSize: 16.0,
      fontFamily: 'BarlowRegular',
      fontWeight: FontWeight.w500,
      color: greyb(context).withOpacity(0.5),
      letterSpacing: 0.1);
}

TextStyle appbarTitle(context) {
  return TextStyle(
    fontSize: 17.0,
    fontFamily: 'BarlowSemiBold',
    fontWeight: FontWeight.w500,
    color: dark(context),
  );
}

TextStyle textBarlowRegularrBlack(context) {
  return TextStyle(
    fontSize: 20.0,
    fontFamily: 'BarlowRegular',
    fontWeight: FontWeight.w400,
    color: dark(context),
  );
}

TextStyle textBarlowRegularrWhite(context) {
  return TextStyle(
    fontSize: 18.0,
    fontFamily: 'BarlowRegular',
    fontWeight: FontWeight.w300,
    color: Colors.white,
  );
}

TextStyle textBarlowRegularrdark(context) {
  return TextStyle(
    fontSize: 18.0,
    fontFamily: 'BarlowRegular',
    fontWeight: FontWeight.w300,
    color: dark(context),
  );
}

TextStyle textBarlowRegularrGreen(context) {
  return TextStyle(
    fontSize: 18.0,
    fontFamily: 'BarlowRegular',
    fontWeight: FontWeight.w300,
    color: green,
  );
}

TextStyle textBarlowRegularrGreenS(context) {
  return TextStyle(
    fontSize: 13.0,
    fontFamily: 'BarlowRegular',
    fontWeight: FontWeight.w300,
    color: green,
  );
}

TextStyle textBarlowRegularrdarkdull(context) {
  final themeChange = Provider.of<DarkThemeProvider>(context);
  return TextStyle(
    fontSize: 15.0,
    fontFamily: 'BarlowRegular',
    fontWeight: FontWeight.w500,
    color: themeChange.darkTheme
        ? Colors.white.withOpacity(0.9)
        : dark(context).withOpacity(0.50),
  );
}

TextStyle textBarlowRegularGreen(context) {
  return TextStyle(
    fontSize: 16.0,
    fontFamily: 'BarlowRegular',
    color: Color(0xFF20C978),
  );
}

TextStyle textBarlowRegularrBlacksm(context) {
  final themeChange = Provider.of<DarkThemeProvider>(context);
  return TextStyle(
    fontSize: 12.0,
    fontFamily: 'BarlowRegular',
    fontWeight: FontWeight.w400,
    color: themeChange.darkTheme ? Colors.white : whiteBg(context),
  );
}

TextStyle textBarlowRegularrwhsm(context) {
  return TextStyle(
    fontSize: 10.0,
    fontFamily: 'BarlowRegular',
    fontWeight: FontWeight.w400,
    color: Colors.white.withOpacity(0.87),
  );
}

TextStyle textbarlowMediumwhitemm(context) {
  return TextStyle(
    fontSize: 17.0,
    fontFamily: 'BarlowMedium',
    color: Colors.white,
  );
}

TextStyle textbarlowMediumwhitemmDark(context) {
  return TextStyle(
    fontSize: 17.0,
    fontFamily: 'BarlowMedium',
    color: dark(context),
  );
}

TextStyle textbarlowMediumBlackmm(context) {
  return TextStyle(
    fontSize: 16.0,
    fontFamily: 'BarlowMedium',
    color: Colors.black87,
  );
}

TextStyle textbarlowmedium12(context) {
  return TextStyle(
      fontSize: 12.0,
      fontWeight: FontWeight.w300,
      fontFamily: 'BarlowMedium',
      color: green);
}

TextStyle textbarlowmedium12Orange(context) {
  return TextStyle(
      fontSize: 12.0,
      fontWeight: FontWeight.w300,
      fontFamily: 'BarlowMedium',
      color: Colors.orange);
}

TextStyle textbarlowMediumPrimary(context) {
  return TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.w400,
    fontFamily: 'BarlowMedium',
    color: primary(context),
  );
}

TextStyle textbarlowmedium12star(context) {
  return TextStyle(
      fontSize: 12.0,
      fontWeight: FontWeight.w300,
      fontFamily: 'BarlowMedium',
      color: star);
}

TextStyle textbarlowRegularBlackFont14(context) {
  return TextStyle(
    fontSize: 14.0,
    fontFamily: 'BarlowRegular',
    color: dark(context).withOpacity(0.60),
  );
}

TextStyle textbarlowRegularBlack87Font14(context) {
  return TextStyle(
    fontSize: 14.0,
    fontFamily: 'BarlowRegular',
    color: Colors.black.withOpacity(0.87),
  );
}

TextStyle textBarlowregwhitelg(context) {
  final themeChange = Provider.of<DarkThemeProvider>(context);
  return TextStyle(
    fontSize: 20.0,
    fontFamily: 'BarlowRegular',
    color:
        themeChange.darkTheme ? Colors.white.withOpacity(0.70) : Colors.black,
  );
}

TextStyle textBarlowregredlg(context) {
  return TextStyle(
    fontSize: 20.0,
    fontFamily: 'BarlowRegular',
    color: Color(0xFFF44242),
  );
}

TextStyle textBarlowregredGreen(context) {
  return TextStyle(
    fontSize: 20.0,
    fontFamily: 'BarlowRegular',
    color: Colors.green,
  );
}

////////////////////////oswald bold//////////////////
TextStyle textoswaldboldwhite(context) {
  return TextStyle(
    fontSize: 20.0,
    fontFamily: 'OswaldBold',
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
}

TextStyle textBarlowMediumBlackRed(context) {
  return TextStyle(
    fontSize: 17.0,
    fontWeight: FontWeight.w500,
    fontFamily: 'BarlowMedium',
    color: Colors.red,
  );
}

TextStyle textbarlowRegularaddRed(context) {
  return TextStyle(
    fontSize: 16.0,
    fontFamily: 'BarlowRegular',
    color: Colors.red,
  );
}

TextStyle textAddressLocationLow(context) {
  return TextStyle(
    fontSize: 20.0,
    fontFamily: 'BarlowRegular',
    fontWeight: FontWeight.w400,
    color: dark(context).withOpacity(0.6),
  );
}
