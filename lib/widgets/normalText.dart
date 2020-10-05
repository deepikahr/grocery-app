import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:getflutter/getflutter.dart';
import 'package:readymadeGroceryApp/screens/orders/orders.dart';
import 'package:readymadeGroceryApp/service/localizations.dart';
import 'package:readymadeGroceryApp/style/style.dart';
import 'package:readymadeGroceryApp/widgets/loader.dart';

Widget alertText(BuildContext context, title, Icon icon) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
      Text(
        MyLocalizations.of(context).getLocalizations(title),
        style: hintSfboldBig(),
      ),
      icon != null ? icon : Container()
    ],
  );
}

Widget normalText(BuildContext context, title) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: <Widget>[
      Text(
        MyLocalizations.of(context).getLocalizations(title),
        style: textbarlowmedium(),
      ),
    ],
  );
}

Widget walletText(BuildContext context, title, subTitle, idOrderId) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: <Widget>[
      Text(
        MyLocalizations.of(context).getLocalizations(title, true) +
            MyLocalizations.of(context).getLocalizations(subTitle),
        style: idOrderId ? textbarlowmedium() : textSMBarlowRegularrBlack(),
      ),
    ],
  );
}

Widget walletTransaction1(BuildContext context, title, subTitle) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: <Widget>[
      Row(
        children: [
          Text(
            MyLocalizations.of(context).getLocalizations(title) + ' : ',
            style: textBarlowSemiboldblack(),
          ),
          Text(
            MyLocalizations.of(context).getLocalizations(subTitle),
            style: textBarlowRegularBlackdl(),
          ),
        ],
      ),
    ],
  );
}

Widget textTransactionAmount(BuildContext context, title, subTitle) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: <Widget>[
      Row(
        children: [
          Text(
            MyLocalizations.of(context).getLocalizations(title) + ' : ',
            style: textBarlowRegularBlackdl(),
          ),
          Text(
            MyLocalizations.of(context).getLocalizations(subTitle),
            style: textBarlowSemiboldGreen(),
          ),
        ],
      ),
    ],
  );
}

Widget walletTransaction(BuildContext context, title, subTitle) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: <Widget>[
      Text(
        MyLocalizations.of(context).getLocalizations(title) +
            ' : ' +
            MyLocalizations.of(context).getLocalizations(subTitle),
        style: textBarlowRegularBlackdl(),
      ),
    ],
  );
}

Widget normalTextWithOutRow(BuildContext context, title, isCenter) {
  return Text(MyLocalizations.of(context).getLocalizations(title),
      textAlign: isCenter ? TextAlign.center : TextAlign.start,
      style: textbarlowRegularBlack());
}

Widget buildDrawer(BuildContext context, title, icon) {
  return Container(
    margin: EdgeInsets.only(bottom: 12.0),
    child: Container(
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: ListTile(
              leading:
                  Image.asset(icon, width: 35, height: 35, color: Colors.white),
              selected: true,
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(
              MyLocalizations.of(context).getLocalizations(title),
              style: textBarlowregwhitelg(),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget buildDrawerLogOutLogin(BuildContext context, title, icon, isLogin) {
  return Container(
    margin: EdgeInsets.only(bottom: 12.0),
    child: Container(
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: ListTile(
              leading: Image.asset(icon,
                  width: 35,
                  height: 35,
                  color: !isLogin ? Colors.green : Color(0xFFF44242)),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(
              MyLocalizations.of(context).getLocalizations(title),
              style: !isLogin ? textBarlowregredGreen() : textBarlowregredlg(),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget buildGFTypography(BuildContext context, title, isStar, isColon) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 5.0),
    child: GFTypography(
      showDivider: false,
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0, bottom: 2.0),
        child: RichText(
          text: TextSpan(
            children: <TextSpan>[
              TextSpan(
                  text: MyLocalizations.of(context)
                      .getLocalizations(title, isColon),
                  style: textBarlowRegularBlack()),
              TextSpan(
                text: isStar ? " * " : ' ',
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget buildGFTypographyOtp(BuildContext context, title, text) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 5.0),
    child: RichText(
      text: TextSpan(
        children: <TextSpan>[
          TextSpan(
              text: MyLocalizations.of(context).getLocalizations(title),
              style: textBarlowRegularBlack()),
          TextSpan(
            text: text == null ? " " : text,
            style: textBarlowMediumGreen(),
          ),
        ],
      ),
    ),
  );
}

Widget buildResentOtp(BuildContext context, title, isResentOtpLoading) {
  return Row(
    children: [
      Padding(
        padding: const EdgeInsets.only(left: 20.0, top: 10.0, right: 20.0),
        child: Text(
          MyLocalizations.of(context).getLocalizations(title),
          style: textBarlowRegularBlack(),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(left: 20.0, top: 10.0, right: 20.0),
        child: isResentOtpLoading ? SquareLoader() : Container(),
      ),
    ],
  );
}

Widget buildBoldText(BuildContext context, title) {
  return GFTypography(
    showDivider: false,
    child: Expanded(
        child: Text(MyLocalizations.of(context).getLocalizations(title),
            style: textBarlowSemiBoldBlackbigg())),
  );
}

Widget buildGFTypographyFogotPass(BuildContext context, title, isStyle) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 10.0),
    child: RichText(
      text: TextSpan(
        children: <TextSpan>[
          TextSpan(
              text: MyLocalizations.of(context).getLocalizations(title) + "?",
              style: isStyle
                  ? textbarlowRegularaPrimary()
                  : textbarlowRegularBlackFont()),
          TextSpan(
            text: '',
            style: TextStyle(color: primary),
          ),
        ],
      ),
    ),
  );
}

Widget profileText(BuildContext context, title) {
  return Container(
    height: 55,
    decoration: BoxDecoration(
      color: Color(0xFFF7F7F7),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(
              top: 8.0, bottom: 9.0, left: 20.0, right: 20.0),
          child: Text(
            MyLocalizations.of(context).getLocalizations(title),
            style: textBarlowMediumBlack(),
          ),
        ),
      ],
    ),
  );
}

Widget subCatTab(BuildContext context, title, Color color) {
  return Container(
    height: 35,
    padding: EdgeInsets.only(left: 25, right: 25, top: 8),
    margin: EdgeInsets.only(right: 15),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.all(
        Radius.circular(4),
      ),
    ),
    child: Text(
      title,
      textAlign: TextAlign.center,
      style: textbarlowMediumBlackm(),
    ),
  );
}

Widget buildBadge(BuildContext context, title, subTitle) {
  return Positioned(
    child: Stack(
      children: <Widget>[
        Container(
          width: 61,
          height: 18,
          decoration: BoxDecoration(
              color: Color(0xFFFFAF72),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10))),
        ),
        Text(
          " " +
              title +
              "% " +
              MyLocalizations.of(context).getLocalizations(subTitle),
          style: hintSfboldwhitemed(),
          textAlign: TextAlign.center,
        )
      ],
    ),
  );
}

Widget buildPrice(
    BuildContext context, icon, title, value, isDeliveryChargeLoading) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
      Row(
        children: [
          icon == null ? Container() : icon,
          Text(title, style: textBarlowRegularBlack()),
        ],
      ),
      isDeliveryChargeLoading
          ? SquareLoader()
          : value == null
              ? Container()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(value, style: textbarlowBoldsmBlack())
                  ],
                ),
    ],
  );
}

Widget buildPriceBold(
    BuildContext context, icon, title, value, isDeliveryChargeLoading) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
      Row(
        children: [
          icon == null ? Container() : icon,
          Text(title, style: textbarlowMediumBlack()),
        ],
      ),
      isDeliveryChargeLoading
          ? SquareLoader()
          : value == null
              ? Container()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(value, style: textbarlowMediumBlack())
                  ],
                ),
    ],
  );
}

Widget buildAddress(title, subTitle) {
  return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(title, style: textBarlowRegularBlack()),
        subTitle == null
            ? Container()
            : Text(subTitle, style: textBarlowRegularBlackdl()),
      ]);
}

Widget timeZoneMessage(BuildContext context, title) {
  return Container(
    padding: EdgeInsets.only(left: 15, right: 15, bottom: 10),
    child: Text(
      MyLocalizations.of(context).getLocalizations(title) + " *",
      style: textbarlowRegularaddRed(),
    ),
  );
}

Widget textWithValue(BuildContext context, title, value) {
  return Container(
    margin: EdgeInsets.only(left: 15, right: 15.0),
    child: value == null
        ? Text(
            MyLocalizations.of(context).getLocalizations(title, true),
            style: textBarlowMediumBlack(),
          )
        : Text(
            MyLocalizations.of(context).getLocalizations(title, true) + value,
            style: textBarlowMediumBlack(),
          ),
  );
}

Widget addressPage(BuildContext context, title) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: <Widget>[
      Text(
        MyLocalizations.of(context).getLocalizations(title, true),
        style: regular(),
      ),
    ],
  );
}

Widget chatMessgae(BuildContext context, message, isOwn) {
  return Padding(
    padding: const EdgeInsets.only(left: 16.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: isOwn
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(
                            top: 12.0, bottom: 14.0, left: 16.0, right: 16.0),
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.6,
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(40),
                              topRight: Radius.circular(0),
                              bottomRight: Radius.circular(40),
                              bottomLeft: Radius.circular(40),
                            ),
                            color: primary.withOpacity(0.60)),
                        child: Text(
                          message,
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(
                            top: 12.0, bottom: 14.0, left: 16.0, right: 16.0),
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.6,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(0),
                            topRight: Radius.circular(40),
                            bottomRight: Radius.circular(40),
                            bottomLeft: Radius.circular(40),
                          ),
                          color: Color(0xFFF0F0F0),
                        ),
                        child: Text(
                          message,
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ],
    ),
  );
}

Widget locationText(BuildContext context, title, value) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
      Container(
        width: MediaQuery.of(context).size.width * 0.6,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            title != null
                ? Text(
                    MyLocalizations.of(context).getLocalizations(title, true),
                    style: textBarlowRegularrBlacksm(),
                  )
                : Container(),
            Text(
              value ?? "",
              overflow: TextOverflow.ellipsis,
              style: textAddressLocation(),
            )
          ],
        ),
      ),
    ],
  );
}

Widget orderPageText(BuildContext context, title) {
  return Text(title,
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
      style: textBarlowRegularrdark());
}

Widget trackBuild(BuildContext context, title, color, style, icon, line) {
  return GFListTile(
    avatar: Column(
      children: <Widget>[
        GFAvatar(backgroundColor: color, radius: 6),
        SizedBox(height: 10),
        line ? Container() : CustomPaint(painter: LineDashedPainter()),
      ],
    ),
    title:
        Text(MyLocalizations.of(context).getLocalizations(title), style: style),
    icon: icon == true
        ? Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: SvgPicture.asset('lib/assets/icons/tick.svg'))
        : null,
    subTitle: Text('', style: textSMBarlowRegularrGreyb()),
  );
}

Widget buildOrderDetilsText(BuildContext context, title, subTitle) {
  return GFTypography(
    showDivider: false,
    child: Expanded(
        child: Text(
            MyLocalizations.of(context).getLocalizations(title, true) +
                MyLocalizations.of(context).getLocalizations(subTitle),
            style: textBarlowMediumBlack())),
  );
}

Widget buildOrderDetilsStatusText(BuildContext context, title, subTitle) {
  return GFTypography(
    showDivider: false,
    child: Expanded(
        child: Row(
      children: [
        Text(MyLocalizations.of(context).getLocalizations(title, true),
            style: textBarlowMediumBlack()),
        Text(MyLocalizations.of(context).getLocalizations(subTitle),
            style: textBarlowMediumGreen()),
      ],
    )),
  );
}

Widget textLightSmall(title) {
  return Text(title, style: textSMBarlowRegularrBlack());
}

Widget textMediumSmall(title) {
  return Text(title ?? "",
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
      style: textBarlowRegularrdark());
}

Widget priceMrpText(title, subtitle) {
  return Row(children: <Widget>[
    Text(title, style: textbarlowBoldGreen()),
    SizedBox(width: 3),
    subtitle != null
        ? Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: Text(subtitle, style: barlowregularlackstrike()),
          )
        : Container()
  ]);
}

Widget textGreenPrimary(title, style) {
  return Text(title, style: style);
}

Widget titleThreeLine(title) {
  return Text(title,
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
      style: textBarlowSemiBoldBlack());
}

Widget titleTwoLine(title) {
  return Text(title,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: textBarlowRegularBlack());
}

Widget discriptionMultipleLine(title) {
  return Text(title, style: textbarlowRegularBlack());
}

Widget searchPage(BuildContext context, title, icon) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Padding(
        padding: const EdgeInsets.only(top: 100.0),
        child: Text(
          MyLocalizations.of(context).getLocalizations(title),
          textAlign: TextAlign.center,
          style: hintSfMediumprimary(),
        ),
      ),
      SizedBox(height: 20.0),
      icon
    ],
  );
}

homePageBoldText(BuildContext context, title) {
  return Expanded(
    child: Text(MyLocalizations.of(context).getLocalizations(title),
        style: textBarlowMediumBlack()),
  );
}

viewAllBoldText(BuildContext context, title, {valueKey}) {
  return Text(MyLocalizations.of(context).getLocalizations(title),
      key: valueKey, style: textBarlowMediumPrimary());
}

bannerTitle(title) {
  return Text(title,
      overflow: TextOverflow.ellipsis,
      maxLines: 2,
      style: textbarlowBoldwhite());
}

orderNow(BuildContext context, title) {
  return Row(
    children: <Widget>[
      Text(MyLocalizations.of(context).getLocalizations(title)),
      Icon(Icons.arrow_right)
    ],
  );
}

Widget buildIcon(BuildContext context, iconData, cartData) {
  return Padding(
    padding: const EdgeInsets.only(top: 8.0),
    child: GFIconBadge(
      child: new Icon(
        iconData,
      ),
      counterChild: (cartData == null || cartData == 0)
          ? Container()
          : GFBadge(
              child: Text(
                '${cartData.toString()}',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white, fontFamily: "bold", fontSize: 11),
              ),
              shape: GFBadgeShape.circle,
              color: Colors.red,
              size: 25,
            ),
    ),
  );
}

topDeals(title, subTitle) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.end,
    children: <Widget>[
      Text(title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: textBarlowSemiBoldwbig()),
      Text(subTitle, style: textBarlowRegularrwhsm())
    ],
  );
}

todayDeal(title, subTitle) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.end,
    children: <Widget>[
      Text(title, style: textoswaldboldwhite()),
      SizedBox(
        height: 5,
      ),
      Text(
        subTitle,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: textBarlowmediumsmallWhite(),
      )
    ],
  );
}

noDataImage() {
  return Center(
    child: Image.asset('lib/assets/images/no-orders.png'),
  );
}

outOfStck(BuildContext context, title, subTtile) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Text(
        MyLocalizations.of(context).getLocalizations(title),
        style: textBarlowSemiBoldwhite(),
      ),
      Text(
        MyLocalizations.of(context).getLocalizations(subTtile),
        style: textBarlowSemiBoldwhite(),
      ),
    ],
  );
}

buildCatTitle(title, isCenter, style) {
  return Text(title,
      overflow: TextOverflow.ellipsis,
      style: style,
      textAlign: isCenter ? TextAlign.center : TextAlign.start);
}

buildProductTitle(title) {
  return Text(title,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: textbarlowRegularBlackb());
}

thankyouText(BuildContext context, title) {
  return Text(
    MyLocalizations.of(context).getLocalizations(title),
    textAlign: TextAlign.center,
    style: textbarlowMediumlgBlack(),
  );
}

orderPlaceText(BuildContext context, title) {
  return Text(
    MyLocalizations.of(context).getLocalizations(title),
    textAlign: TextAlign.center,
    style: textbarlowMediumBlack(),
  );
}

thankuImage() {
  return Image.asset('lib/assets/images/thank-you.png');
}

walletImage() {
  return Image.asset('lib/assets/images/wallet.png');
}

// walletIcon() {
//   return Image.asset(
//     'lib/assets/images/walleticon.png',
//     width: 38,
//     height: 36,
//   );
// }

walletCard1(BuildContext context, title, subtitle, price, Image image) {
  return Container(
    padding: EdgeInsets.all(15),
    decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black54, blurRadius: 0)]),
    child: Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              MyLocalizations.of(context).getLocalizations(title),
              style: textbarlowRegularBlackd(),
            ),
            Text(
              MyLocalizations.of(context).getLocalizations(subtitle) + ' : ',
              style: textbarlowRegularBlackd(),
            ),
            SizedBox(height: 5),
            Text(
              MyLocalizations.of(context).getLocalizations(price),
              style: textBarlowSemiboldGreen(),
            ),
          ],
        ),
        SizedBox(width: 30),
        image
      ],
    ),
  );
}

walletCard2(BuildContext context, title, subtitle, text, Image image) {
  return Container(
    padding: EdgeInsets.all(15),
    decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black54, blurRadius: 0)]),
    child: Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'RECENT',
              style: textbarlowRegularBlackd(),
            ),
            Text(
              'TRANSACTIONS',
              style: textbarlowRegularBlackd(),
            ),
            SizedBox(height: 5),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'VIEW',
                  style: textBarlowSemiboldPrimary(),
                ),
                Icon(
                  Icons.keyboard_arrow_right,
                  color: primary,
                  size: 15,
                )
              ],
            ),
          ],
        ),
        SizedBox(width: 17),
        image
      ],
    ),
  );
}
