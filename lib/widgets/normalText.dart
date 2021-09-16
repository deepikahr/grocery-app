import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:getwidget/getwidget.dart';
import 'package:readymadeGroceryApp/screens/orders/orders.dart';
import 'package:readymadeGroceryApp/service/localizations.dart';
import 'package:readymadeGroceryApp/style/style.dart';
import 'package:readymadeGroceryApp/widgets/loader.dart';

Widget alertText(BuildContext context, title, Icon? icon) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
      Text(
        MyLocalizations.of(context)!.getLocalizations(title),
        style: hintSfboldBig(context),
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
        MyLocalizations.of(context)!.getLocalizations(title),
        style: textbarlowmedium(context),
      ),
    ],
  );
}

Widget walletText(BuildContext context, title, subTitle, idOrderId) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: <Widget>[
      Text(
        MyLocalizations.of(context)!.getLocalizations(title, true) +
            MyLocalizations.of(context)!.getLocalizations(subTitle),
        style: idOrderId
            ? textbarlowmedium(context)
            : textSMBarlowRegularrBlack(context),
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
            MyLocalizations.of(context)!.getLocalizations(title) + ' : ',
            style: textbarlowSemiBoldBlack(context),
          ),
          Text(
            MyLocalizations.of(context)!.getLocalizations(subTitle),
            style: textBarlowRegularBlackdl(context),
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
            MyLocalizations.of(context)!.getLocalizations(title, true),
            style: textBarlowRegularBlackdl(context),
          ),
          Text(
            MyLocalizations.of(context)!.getLocalizations(subTitle),
            style: textBarlowSemiboldGreen(context),
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
        MyLocalizations.of(context)!.getLocalizations(title, true) +
            MyLocalizations.of(context)!.getLocalizations(subTitle ?? ""),
        style: textBarlowRegularBlackdl(context),
      ),
    ],
  );
}

Widget normalTextWithOutRow(BuildContext context, title, isCenter) {
  return Text(MyLocalizations.of(context)!.getLocalizations(title ?? ""),
      textAlign: isCenter ? TextAlign.center : TextAlign.start,
      style: textBarlowRegularBlack(context));
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
              MyLocalizations.of(context)!.getLocalizations(title),
              style: textBarlowregwhitelg(context),
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
              MyLocalizations.of(context)!.getLocalizations(title),
              style: !isLogin
                  ? textBarlowregredGreen(context)
                  : textBarlowregredlg(context),
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
                  text: MyLocalizations.of(context)!
                      .getLocalizations(title, isColon),
                  style: textBarlowRegularBlack(context)),
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
              text: MyLocalizations.of(context)!.getLocalizations(title),
              style: textBarlowRegularBlack(context)),
          TextSpan(
            text: text == null ? " " : text,
            style: textBarlowMediumGreen(context),
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
          MyLocalizations.of(context)!.getLocalizations(title),
          style: textBarlowRegularBlack(context),
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
  return Text(
    MyLocalizations.of(context)!.getLocalizations(title ?? ""),
    style: textBarlowSemiBoldBlackbigg(context),
  );
}

Widget buildGFTypographyFogotPass(BuildContext context, title, isStyle) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 10.0),
    child: RichText(
      text: TextSpan(
        children: <TextSpan>[
          TextSpan(
              text: MyLocalizations.of(context)!.getLocalizations(title) + "?",
              style: isStyle
                  ? textbarlowRegularaprimary(context)
                  : textbarlowRegularBlackFont(context)),
          TextSpan(
            text: '',
            style: TextStyle(color: primary(context)),
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
      color: cartCardBg(context),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(
              top: 8.0, bottom: 9.0, left: 20.0, right: 20.0),
          child: Text(
            MyLocalizations.of(context)!.getLocalizations(title),
            style: textBarlowMediumBlack(context),
          ),
        ),
      ],
    ),
  );
}

Widget profileTextRow(BuildContext context, title, subTitle) {
  return Container(
    height: 55,
    decoration: BoxDecoration(color: cartCardBg(context)),
    child: Padding(
      padding:
          const EdgeInsets.only(top: 8.0, bottom: 9.0, left: 20.0, right: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(MyLocalizations.of(context)!.getLocalizations(title),
              style: textBarlowMediumBlack(context)),
          Text(MyLocalizations.of(context)!.getLocalizations(subTitle),
              style: textBarlowMediumBlack(context)),
        ],
      ),
    ),
  );
}

Widget subCatTab(BuildContext context, title, Color color) {
  return Container(
    height: 45,
    padding: EdgeInsets.only(
      left: 25,
      right: 25,
      top: 8,
    ),
    margin: EdgeInsets.only(right: 5, left: 5, bottom: 10),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.all(
        Radius.circular(4),
      ),
    ),
    child: Text(
      title,
      textAlign: TextAlign.center,
      style: textbarlowMediumBlackm(context),
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
              MyLocalizations.of(context)!.getLocalizations(subTitle),
          style: hintSfboldwhitemed(context),
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
          Text(MyLocalizations.of(context)!.getLocalizations(title ?? ""),
              style: textBarlowRegularBlack(context)),
        ],
      ),
      isDeliveryChargeLoading
          ? SquareLoader()
          : value == null
              ? Container()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                        MyLocalizations.of(context)!
                            .getLocalizations(value ?? ""),
                        style: textbarlowBoldsmBlack(context))
                  ],
                ),
    ],
  );
}

Widget buildPriceGreen(
    BuildContext context, icon, title, value, isDeliveryChargeLoading) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
      Row(
        children: [
          icon == null ? Container() : icon,
          Text(MyLocalizations.of(context)!.getLocalizations(title ?? ""),
              style: textBarlowRegularBlack(context)),
        ],
      ),
      isDeliveryChargeLoading
          ? SquareLoader()
          : value == null
              ? Container()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                        MyLocalizations.of(context)!
                            .getLocalizations(value ?? ""),
                        style: textbarlowBoldsmGreen(context))
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
          Text(title, style: textBarlowMediumBlack(context)),
        ],
      ),
      isDeliveryChargeLoading
          ? SquareLoader()
          : value == null
              ? Container()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(value, style: textBarlowMediumBlack(context))
                  ],
                ),
    ],
  );
}

Widget buildAddress(title, subTitle, context) {
  return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(MyLocalizations.of(context)!.getLocalizations(title ?? ""),
            style: textBarlowRegularBlack(context)),
        subTitle == null
            ? Container()
            : Text(
                MyLocalizations.of(context)!.getLocalizations(subTitle ?? ""),
                style: textBarlowRegularBlackdl(context)),
      ]);
}

Widget buildShippingMethodText(title, context) {
  return Text(MyLocalizations.of(context)!.getLocalizations(title ?? ""),
      style: textBarlowRegularBlack(context));
}

Widget timeZoneMessage(BuildContext context, title) {
  return Container(
    padding: EdgeInsets.only(left: 15, right: 15, bottom: 10),
    child: Text(
      MyLocalizations.of(context)!.getLocalizations(title) + " *",
      style: textbarlowRegularaddRed(context),
    ),
  );
}

Widget textWithValue(BuildContext context, title, value) {
  return Container(
    margin: EdgeInsets.only(left: 15, right: 15.0),
    child: value == null
        ? Text(
            MyLocalizations.of(context)!.getLocalizations(title, true),
            style: textBarlowMediumBlack(context),
          )
        : Text(
            MyLocalizations.of(context)!.getLocalizations(title, true) + value,
            style: textBarlowMediumBlack(context),
          ),
  );
}

Widget referText(BuildContext context, title) {
  return Container(
      child: Center(
    child: Text(
      MyLocalizations.of(context)!.getLocalizations(title),
      style: textbarlowMediumBlackmm(context),
    ),
  ));
}

Widget whiteText(BuildContext context, title) {
  return Container(
      child: Center(
    child: Text(
      MyLocalizations.of(context)!.getLocalizations(title),
      style: textbarlowMediumwhitemmDark(context),
    ),
  ));
}

Widget normallText(BuildContext context, title) {
  return Container(
    child: Text(
      MyLocalizations.of(context)!.getLocalizations(title),
      style: textbarlowMediumBlackmm(context),
    ),
  );
}

Widget addressPage(BuildContext context, title) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: <Widget>[
      Text(
        MyLocalizations.of(context)!.getLocalizations(title, true),
        style: regular(context),
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
                            color: primarybg.withOpacity(0.60)),
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
                          color: Theme.of(context).brightness == Brightness.dark
                              ? greyb2
                              : Color(0xFFF0F0F0),
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
                    MyLocalizations.of(context)!.getLocalizations(title, true),
                    style: textBarlowRegularrBlacksm(context),
                  )
                : Container(),
            Text(
              value ?? "",
              overflow: TextOverflow.ellipsis,
              style: textAddressLocation(context),
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
      style: textBarlowRegularrdark(context));
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
    title: Text(MyLocalizations.of(context)!.getLocalizations(title),
        style: style),
    icon: icon == true
        ? Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: SvgPicture.asset('lib/assets/icons/tick.svg'))
        : null,
    subTitle: Text('', style: textSMBarlowRegularrgreyb(context)),
  );
}

Widget buildOrderDetilsText(BuildContext context, title, subTitle) {
  return GFTypography(
    showDivider: false,
    child: Expanded(
        child: Text(
            MyLocalizations.of(context)!.getLocalizations(title, true) +
                MyLocalizations.of(context)!.getLocalizations(subTitle),
            style: textBarlowMediumBlack(context))),
  );
}

Widget buildOrderDetilsNormalText(BuildContext context, title) {
  return Text(MyLocalizations.of(context)!.getLocalizations(title ?? ""),
      style: textBarlowMediumGreen(context));
}

Widget buildOrderDetilsStatusText(BuildContext context, title, subTitle) {
  return GFTypography(
    showDivider: false,
    child: Expanded(
        child: Row(
      children: [
        Text(MyLocalizations.of(context)!.getLocalizations(title, true),
            style: textBarlowMediumBlack(context)),
        Text(MyLocalizations.of(context)!.getLocalizations(subTitle),
            style: textBarlowMediumGreen(context)),
      ],
    )),
  );
}

Widget textLightSmall(title, context) {
  return Text(MyLocalizations.of(context)!.getLocalizations(title ?? ""),
      style: textSMBarlowRegularrBlack(context));
}

Widget textMediumSmall(title, context) {
  return Text(title ?? "",
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
      style: textBarlowRegularrGreen(context));
}

Widget textMediumSmallGreen(title, context) {
  return Text(MyLocalizations.of(context)!.getLocalizations(title ?? ""),
      style: textBarlowRegularrGreenS(context));
}

Widget priceMrpText(title, subtitle, context) {
  return Row(children: <Widget>[
    Text(title, style: textbarlowBoldGreen(context)),
    SizedBox(width: 6),
    subtitle != null
        ? Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: Text(subtitle, style: barlowregularlackstrike(context)),
          )
        : Container()
  ]);
}

Widget textGreenprimary(BuildContext context, title, style) {
  return Text(MyLocalizations.of(context)!.getLocalizations(title ?? ""),
      style: style);
}

Widget titleThreeLine(title, context) {
  return Text(title,
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
      style: textbarlowSemiBoldBlack(context));
}

Widget titleTwoLine(title, context) {
  return Text(title,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
          fontSize: 16.0,
          fontFamily: 'BarlowRegular',
          color: Colors.black,
          fontWeight: FontWeight.w500));
}

Widget discriptionMultipleLine(title, context) {
  return Text(title, style: textBarlowRegularBlack(context));
}

Widget searchPage(BuildContext context, title, icon) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Padding(
        padding: const EdgeInsets.only(top: 100.0),
        child: Text(
          MyLocalizations.of(context)!.getLocalizations(title),
          textAlign: TextAlign.center,
          style: hintSfMediumprimary(context),
        ),
      ),
      SizedBox(height: 20.0),
      icon
    ],
  );
}

homePageBoldText(BuildContext context, title) {
  return Expanded(
    child: Text(MyLocalizations.of(context)!.getLocalizations(title),
        style: textBarlowMediumBlack(context)),
  );
}

viewAllBoldText(BuildContext context, title, {valueKey}) {
  return Text(MyLocalizations.of(context)!.getLocalizations(title),
      key: valueKey, style: textbarlowMediumprimary(context));
}

bannerTitle(title, context) {
  return Text(title,
      overflow: TextOverflow.ellipsis,
      maxLines: 2,
      style: textbarlowBoldWhite(context));
}

orderNow(BuildContext context, title) {
  return Row(
    children: <Widget>[
      Text(MyLocalizations.of(context)!.getLocalizations(title)),
      Icon(Icons.arrow_right)
    ],
  );
}

orderNowPrimary(BuildContext context, title) {
  return Row(
    children: <Widget>[
      Text(MyLocalizations.of(context)!.getLocalizations(title),style:textbarlowRegularaPrimar(context)),
      Icon(Icons.arrow_right,color:primary(context))
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

topDeals(title, subTitle, context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.end,
    children: <Widget>[
      Text(title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: textBarlowSemiBoldwbig(context)),
      Text(subTitle, style: textBarlowRegularrwhsm(context))
    ],
  );
}

todayDeal(title, subTitle, context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.end,
    children: <Widget>[
      Text(title, style: textoswaldboldwhite(context)),
      SizedBox(
        height: 5,
      ),
      Text(
        subTitle,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: textBarlowmediumsmallWhite(context),
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
        MyLocalizations.of(context)!.getLocalizations(title),
        style: textBarlowSemiBoldwhite(context),
      ),
      Text(
        MyLocalizations.of(context)!.getLocalizations(subTtile),
        style: textBarlowSemiBoldwhite(context),
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

buildProductTitle(title, context) {
  return Text(title,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: textbarlowRegularBlackb(context));
}

thankyouText(BuildContext context, title) {
  return Text(
    MyLocalizations.of(context)!.getLocalizations(title),
    textAlign: TextAlign.center,
    style: textbarlowMediumlgBlack(context),
  );
}

orderPlaceText(BuildContext context, title) {
  return Text(
    MyLocalizations.of(context)!.getLocalizations(title),
    textAlign: TextAlign.center,
    style: textBarlowMediumBlack(context),
  );
}

thankuImage() {
  return Image.asset('lib/assets/images/thank-you.png');
}

failedImage() {
  return Image.asset('lib/assets/images/failed.png');
}

walletImage() {
  return Image.asset('lib/assets/images/wallet.png');
}

thankuImageWallet() {
  return Image.asset('lib/assets/images/walletImage.png');
}
// walletIcon() {
//   return Image.asset(
//     'lib/assets/images/walleticon.png',
//     width: 38,
//     height: 36,
//   );
// }

walletCard1(BuildContext context, title, subtitle, price) {
  return Container(
    padding: EdgeInsets.all(15),
    decoration: BoxDecoration(
        color: whiteBg(context),
        boxShadow: [BoxShadow(color: Colors.black54, blurRadius: 0)]),
    child: Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              MyLocalizations.of(context)!.getLocalizations(title),
              style: textbarlowRegularBlackd(context),
            ),
            Text(
              MyLocalizations.of(context)!.getLocalizations(subtitle) + ' : ',
              style: textbarlowRegularBlackd(context),
            ),
            SizedBox(height: 5),
            Text(
              MyLocalizations.of(context)!.getLocalizations(price),
              style: textBarlowSemiboldGreen(context),
            ),
          ],
        ),
        SizedBox(width: 30),
        Image.asset('lib/assets/images/walleticon.png', width: 38, height: 36)
      ],
    ),
  );
}

walletCard2(BuildContext context, title, subtitle, subtitle1) {
  return Container(
    padding: EdgeInsets.all(15),
    decoration: BoxDecoration(
        color: whiteBg(context),
        boxShadow: [BoxShadow(color: Colors.black54, blurRadius: 0)]),
    child: Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(MyLocalizations.of(context)!.getLocalizations(title),
                style: textbarlowRegularBlackd(context)),
            Text(MyLocalizations.of(context)!.getLocalizations(subtitle),
                style: textbarlowRegularBlackd(context)),
            SizedBox(height: 5),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(MyLocalizations.of(context)!.getLocalizations(subtitle1),
                    style: textBarlowSemiboldprimary(context)),
                Icon(Icons.keyboard_arrow_right,
                    color: primary(context), size: 15)
              ],
            ),
          ],
        ),
        SizedBox(width: 17),
        Image.asset('lib/assets/images/walleticon.png', width: 38, height: 36)
      ],
    ),
  );
}

Widget textGreenPrimary(context, title, style) {
  return Text(MyLocalizations.of(context)!.getLocalizations(title ?? ""),
      style: style);
}

regularText(BuildContext context, title) {
  return Text(
    MyLocalizations.of(context)!.getLocalizations(title),
    textAlign: TextAlign.center,
    style: textbarlowRegularBlackFont14(context),
  );
}

regularTextatStart(BuildContext context, title) {
  return Text(
    MyLocalizations.of(context)!.getLocalizations(title),
    style: textbarlowRegularBlackd(context),
  );
}

regularTextblack87(BuildContext context, title) {
  return Text(
    MyLocalizations.of(context)!.getLocalizations(title),
    textAlign: TextAlign.center,
    style: textbarlowRegularBlack87Font14(context),
  );
}

regularTextblackbold(BuildContext context, title) {
  return Text(
    MyLocalizations.of(context)!.getLocalizations(title),
    textAlign: TextAlign.start,
    style: textbarlowmediumwblack(context),
  );
}

builddTextbarlowmediumwblack(BuildContext context, title) {
  return Text(
    MyLocalizations.of(context)!.getLocalizations(title),
    style: textbarlowmediumwblack(context),
  );
}

builddTextbarlowRegularBlackFont14(BuildContext context, title) {
  return Text(
    MyLocalizations.of(context)!.getLocalizations(title),
    style: textbarlowRegularBlackFont14(context),
  );
}

Widget locationTile(BuildContext context, String address) {
  return Column(
    children: [
      ListTile(
        title: Text(address, style: hintSmallSfMediumblack(context)),
        trailing: Icon(Icons.arrow_forward_ios),
      ),
      Divider(color: dark(context))
    ],
  );
}
