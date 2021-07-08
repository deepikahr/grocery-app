import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:readymadeGroceryApp/service/localizations.dart';
import 'package:readymadeGroceryApp/style/style.dart';
import 'package:readymadeGroceryApp/widgets/loader.dart';

Widget buttonprimary(BuildContext context, title, isLoading) {
  return Container(
    height: 55,
    margin: EdgeInsets.only(top: 10, bottom: 10),
    decoration: BoxDecoration(color: primary(context), boxShadow: [
      BoxShadow(color: dark(context).withOpacity(0.29), blurRadius: 5)
    ]),
    child: Padding(
      padding: const EdgeInsets.only(
        left: 0.0,
        right: 0.0,
      ),
      child: GFButton(
        size: GFSize.LARGE,
        color: primary(context),
        blockButton: true,
        onPressed: null,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(MyLocalizations.of(context)!.getLocalizations(title),
                style: textBarlowRegularBlack(context)),
            SizedBox(height: 10),
            isLoading ? GFLoader(type: GFLoaderType.ios) : Container()
          ],
        ),
      ),
    ),
  );
}

Widget regularbuttonPrimary(BuildContext context, title, isLoading) {
  return Container(
    height: 55,
    width: MediaQuery.of(context).size.width,
    margin: EdgeInsets.only(top: 10, bottom: 10),
    decoration: BoxDecoration(color: primary(context), boxShadow: [
      BoxShadow(color: Colors.black.withOpacity(0.29), blurRadius: 5)
    ]),
    child: Padding(
      padding: const EdgeInsets.only(left: 0.0, right: 0.0),
      child: GFButton(
        size: GFSize.LARGE,
        color: primary(context),
        blockButton: true,
        onPressed: null,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(MyLocalizations.of(context)!.getLocalizations(title),
                style: textBarlowRegularBlack(context)),
            SizedBox(height: 10),
            isLoading ? GFLoader(type: GFLoaderType.ios) : Container()
          ],
        ),
        textStyle: textBarlowRegularrBlack(context),
      ),
    ),
  );
}

Widget regularGreyButton(BuildContext context, title, isLoading) {
  return Container(
    height: 55,
    width: MediaQuery.of(context).size.width,
    margin: EdgeInsets.only(top: 10, bottom: 10),
    decoration: BoxDecoration(color: Color(0xFFF0F0F0), boxShadow: [
      BoxShadow(color: Colors.black.withOpacity(0.29), blurRadius: 5)
    ]),
    child: Padding(
      padding: const EdgeInsets.only(left: 0.0, right: 0.0),
      child: GFButton(
        size: GFSize.LARGE,
        color: cartCardBg(context),
        blockButton: true,
        onPressed: null,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(MyLocalizations.of(context)!.getLocalizations(title),
                style: textBarlowRegularBlack(context)),
            SizedBox(height: 10),
            isLoading ? GFLoader(type: GFLoaderType.ios) : Container()
          ],
        ),
        textStyle: textBarlowRegularrBlack(context),
      ),
    ),
  );
}

Widget productAddButton(BuildContext context, title, isLoading) => Container(
      height: 35,
      padding: EdgeInsets.only(left: 15, right: 15, bottom: 5),
      margin: EdgeInsets.only(top: 5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
          color: primary(context)),
      child: GFButton(
        size: GFSize.LARGE,
        color: primary(context),
        onPressed: null,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              MyLocalizations.of(context)!.getLocalizations(title),
              style: textbarlowMediumBlackm(context),
            ),
            isLoading ? GFLoader(type: GFLoaderType.ios) : Text("")
          ],
        ),
      ),
    );

Widget subscribeButton(BuildContext context, title, isLoading) {
  return Container(
    height: 35,
    padding: EdgeInsets.only(left: 8, right: 8),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        color: Color(0xFFF0F0F0)),
    child: GFButton(
      size: GFSize.LARGE,
      color: Color(0xFFF0F0F0),
      onPressed: null,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Text(
              MyLocalizations.of(context)!.getLocalizations(title),
              style: textbarlowMediumBlackm(context),
            ),
          ),
          isLoading ? GFLoader(type: GFLoaderType.ios) : Text("")
        ],
      ),
    ),
  );
}

Widget subscribeButtonWithOutExpanded(BuildContext context, title, isLoading) {
  return Container(
    height: 35,
    padding: EdgeInsets.only(left: 8, right: 8),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        color: Color(0xFFF0F0F0)),
    child: GFButton(
      size: GFSize.LARGE,
      color: Color(0xFFF0F0F0),
      onPressed: null,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            MyLocalizations.of(context)!.getLocalizations(title),
            style: textbarlowMediumBlackm(context),
          ),
          isLoading ? GFLoader(type: GFLoaderType.ios) : Text("")
        ],
      ),
    ),
  );
}

Widget subscribePrimary(BuildContext context, title, isLoading) {
  return Container(
    height: 35,
    padding: EdgeInsets.only(left: 8, right: 8),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)), color: primarybg),
    child: GFButton(
      size: GFSize.LARGE,
      color: primarybg,
      onPressed: null,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            MyLocalizations.of(context)!.getLocalizations(title),
            style: textBarlowSemiboldblack(context),
          ),
          isLoading ? GFLoader(type: GFLoaderType.ios) : Text("")
        ],
      ),
    ),
  );
}

Widget transparenttButton(BuildContext context, title, icon) {
  return Container(
    height: 35,
    child: GFButton(
      size: GFSize.LARGE,
      color: bg(context),
      onPressed: null,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            MyLocalizations.of(context)!.getLocalizations(title),
            style: hintSfboldBig(context),
          ),
          icon
        ],
      ),
    ),
  );
}

Widget editProfileButton(BuildContext context, title, isLoading) {
  return Container(
    height: 55,
    margin: EdgeInsets.only(bottom: 20),
    decoration: BoxDecoration(color: primary(context), boxShadow: [
      BoxShadow(color: dark(context).withOpacity(0.29), blurRadius: 5)
    ]),
    child: Padding(
      padding: const EdgeInsets.only(
        left: 0.0,
        right: 0.0,
      ),
      child: GFButton(
        size: GFSize.LARGE,
        color: primary(context),
        blockButton: true,
        onPressed: null,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              MyLocalizations.of(context)!.getLocalizations(title),
              style: textBarlowRegularrBlack(context),
            ),
            SizedBox(
              height: 10,
            ),
            isLoading ? GFLoader(type: GFLoaderType.ios) : Text("")
          ],
        ),
        textStyle: textBarlowRegularrBlack(context),
      ),
    ),
  );
}

Widget primaryOutlineButton(BuildContext context, title) {
  return GFButton(
    borderSide: BorderSide(color: primary(context)),
    type: GFButtonType.outline2x,
    color: primary(context),
    size: GFSize.MEDIUM,
    onPressed: null,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          MyLocalizations.of(context)!.getLocalizations(title),
          style: textbarlowRegularaPrimar(context),
        ),
      ],
    ),
  );
}

Widget primarySolidButtonSmall(BuildContext context, title) {
  return GFButton(
    borderSide: BorderSide(color: primary(context)),
    type: GFButtonType.solid,
    color: primary(context),
    size: GFSize.SMALL,
    onPressed: null,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(MyLocalizations.of(context)!.getLocalizations(title),
            style: textbarlowRegularadark(context)),
      ],
    ),
  );
}

Widget dottedBorderButton(BuildContext context, title) {
  return DottedBorder(
    color: Color(0XFFBBBBBB),
    dashPattern: [4, 2],
    strokeWidth: 2,
    padding: EdgeInsets.only(left: 10, right: 10),
    child: GFButton(
      type: GFButtonType.transparent,
      color: GFColors.LIGHT,
      // blockButton: false,
      onPressed: null,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            MyLocalizations.of(context)!.getLocalizations(title),
            style: textBarlowRegularBb(context),
          ),
        ],
      ),
    ),
  );
}

Widget dottedBorderButtonn(BuildContext context, title) {
  return Container(
    width: 193.0,
    height: 45.0,
    child: DottedBorder(
      color: Color(0XFFBBBBBB),
      dashPattern: [4, 2],
      strokeWidth: 2,
      padding: EdgeInsets.only(left: 10, right: 10),
      child: GFButton(
        type: GFButtonType.transparent,
        color: GFColors.LIGHT,
        // blockButton: false,
        onPressed: null,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              MyLocalizations.of(context)!.getLocalizations(title),
              style: textBarlowRegularBlackwithOpa(context),
            ),
            Image.asset(
              "lib/assets/images/copy.png",
              width: 19,
              height: 19,
            )
          ],
        ),
      ),
    ),
  );
}

Widget transparentIconButton(BuildContext context, title, Icon icon) {
  return Container(
    height: 40,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          MyLocalizations.of(context)!.getLocalizations(title),
          style: hintSfboldBig(context),
        ),
        icon
      ],
    ),
  );
}

Widget transparentButton(BuildContext context, title) {
  return Container(
    child: GFButton(
      type: GFButtonType.transparent,
      onPressed: null,
      blockButton: false,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            MyLocalizations.of(context)!.getLocalizations(title),
            style: hintSfboldBig(context),
          ),
        ],
      ),
    ),
  );
}

Widget addToCartButton(
    BuildContext context, items, price, title, Icon icon, isLoading) {
  return Container(
      height: 55,
      decoration: BoxDecoration(
        color: primary(context),
        boxShadow: [
          BoxShadow(color: dark(context).withOpacity(0.29), blurRadius: 3)
        ],
      ),
      child: RawMaterialButton(
        onPressed: null,
        padding: EdgeInsetsDirectional.only(start: .0, end: 1.0),
        fillColor: primary(context),
        constraints: const BoxConstraints(minHeight: 44.0),
        shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(5.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: 55,
              decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(0),
                      bottomLeft: Radius.circular(0))),
              margin: EdgeInsets.only(right: 0),
              width: 120,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 8.0,
                  ),
                  RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: '$items',
                          style: textBarlowRegularWhite(context),
                        ),
                        TextSpan(
                            text: MyLocalizations.of(context)!
                                .getLocalizations("ITEMS"),
                            style: textBarlowRegularWhite(context)),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 1.0,
                  ),
                  new Text(
                    price,
                    style: textbarlowBoldWhite(context),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    isLoading ? GFLoader(type: GFLoaderType.ios) : Text(""),
                    Text(MyLocalizations.of(context)!.getLocalizations(title),
                        style: TextStyle(
                            fontSize: 16.0,
                            fontFamily: 'BarlowRegular',
                            color: Colors.black,
                            fontWeight: FontWeight.w500)),
                    SizedBox(width: 10),
                    icon,
                    SizedBox(width: 10)
                  ],
                )
              ],
            )
          ],
        ),
      ));
}

Widget checkoutButton(
    BuildContext context, total, price, title, Icon icon, isLoading) {
  return Container(
      height: 60,
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      decoration: BoxDecoration(
        color: primary(context),
        boxShadow: [
          BoxShadow(color: dark(context).withOpacity(0.29), blurRadius: 6)
        ],
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      child: RawMaterialButton(
        onPressed: null,
        padding: EdgeInsetsDirectional.only(start: .0, end: 1.0),
        fillColor: primary(context),
        constraints: const BoxConstraints(minHeight: 44.0),
        shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(5.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: 60,
              decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5),
                      bottomLeft: Radius.circular(5))),
              margin: EdgeInsets.only(right: 0),
              width: 120,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 8.0),
                  Text(MyLocalizations.of(context)!.getLocalizations(total),
                      style: textBarlowRegularWhite(context)),
                  SizedBox(height: 1.0),
                  new Text(MyLocalizations.of(context)!.getLocalizations(price),
                      style: textbarlowBoldWhite(context)),
                ],
              ),
            ),
            Container(
              // width: MediaQuery.of(context).size.width * 0.55,
              child: Row(
                children: [
                  isLoading ? GFLoader(type: GFLoaderType.ios) : Text(""),
                  Text(MyLocalizations.of(context)!.getLocalizations(title),
                      style: TextStyle(
                          fontSize: 16.0,
                          fontFamily: 'BarlowRegular',
                          color: Colors.black,
                          fontWeight: FontWeight.w500)),
                  SizedBox(width: 10),
                  icon,
                  SizedBox(width: 10)
                ],
              ),
            )
          ],
        ),
      ));
}

Widget applyCoupon(BuildContext context, title, isLoading) {
  return Container(
    height: 44,
    width: 119,
    child: GFButton(
      onPressed: null,
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
        child: isLoading
            ? SquareLoader()
            : Text(
                MyLocalizations.of(context)!.getLocalizations(title) + " ",
                style: textBarlowRegularBlack(context),
              ),
      ),
      color: primarybg,
    ),
  );
}

Widget alertSubmitButton(BuildContext context, title) {
  return Container(
    color: primary(context),
    height: 35,
    margin: EdgeInsets.symmetric(vertical: 5),
    child: GFButton(
      onPressed: null,
      text: MyLocalizations.of(context)!.getLocalizations(title),
      color: primary(context),
      size: GFSize.SMALL,
      textStyle: textBarlowRegularrWhite(context),
    ),
  );
}

Widget defaultButton(BuildContext context, title, color) {
  return Container(
    height: 36,
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(5),
    ),
    child: GFButton(
      onPressed: null,
      color: dark(context),
      child: Text(
        MyLocalizations.of(context)!.getLocalizations(title),
        style: textbarlowMediumprimary(context),
      ),
    ),
  );
}

Widget iconButton(BuildContext context, Icon icon, isLoading) {
  return Container(
    height: 50.0,
    width: 50.0,
    decoration: BoxDecoration(boxShadow: [
      new BoxShadow(
        color: dark(context).withOpacity(0.29),
        blurRadius: 6.0,
      ),
    ], color: Colors.white, borderRadius: BorderRadius.circular(50.0)),
    child: GFIconButton(
      onPressed: null,
      icon: GestureDetector(
          child: Stack(
        children: [
          Center(child: icon),
          isLoading ? GFLoader(type: GFLoaderType.ios) : Text(""),
        ],
      )),
      type: GFButtonType.transparent,
    ),
  );
}

Widget mdPillsButton(BuildContext context, color, title, Map order) {
  return Container(
    height: 35,
    decoration:
        BoxDecoration(color: color, borderRadius: BorderRadius.circular(25)),
    child: GFButton(
      shape: GFButtonShape.pills,
      onPressed: null,
      color: color,
      child: order["isRated"] == true && order["rating"] != null
          ? Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(
                  order["rating"].toString(),
                ),
                Icon(
                  Icons.star,
                  color: Colors.white,
                  size: 20,
                ),
              ],
            )
          : Text(
              MyLocalizations.of(context)!.getLocalizations(title),
              overflow: TextOverflow.ellipsis,
            ),
    ),
  );
}

Widget addsubQuantityButton(BuildContext context, color, Map order, isLoading) {
  return Container(
    width: 32,
    height: 32,
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.all(Radius.circular(5)),
    ),
    child: InkWell(
        onTap: null,
        child: order.isNotEmpty
            ? Stack(
                children: [
                  isLoading ? GFLoader(type: GFLoaderType.ios) : Text(""),
                ],
              )
            : Container()),
  );
}

Widget cartInfoButton(BuildContext context, Map cartData, currency) {
  return Container(
    height: 55.0,
    padding: EdgeInsets.only(right: 20),
    decoration: BoxDecoration(color: primary(context), boxShadow: [
      BoxShadow(color: dark(context).withOpacity(0.29), blurRadius: 5)
    ]),
    child: Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              color: Colors.black,
              width: MediaQuery.of(context).size.width * 0.35,
              height: 55,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 7),
                  new Text(
                    '(${cartData['products'].length})  ' +
                        MyLocalizations.of(context)!.getLocalizations("ITEMS"),
                    style: textBarlowRegularWhite(context),
                  ),
                  new Text(
                    "$currency${cartData['subTotal'].toStringAsFixed(2)}",
                    style: textbarlowBoldWhite(context),
                  ),
                ],
              ),
            ),
            Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    new Text(
                      MyLocalizations.of(context)!
                          .getLocalizations("GO_TO_CART"),
                      style: TextStyle(
                          fontSize: 16.0,
                          fontFamily: 'BarlowRegular',
                          color: Colors.black,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(width: 4),
                    Icon(
                      const IconData(
                        0xe911,
                        fontFamily: 'icomoon',
                      ),
                      color: Colors.black,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  );
}
