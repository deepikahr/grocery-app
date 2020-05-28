import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:getflutter/components/appbar/gf_appbar.dart';
import 'package:getflutter/getflutter.dart';
import 'package:readymadeGroceryApp/screens/orders/ordersDetails.dart';
import 'package:readymadeGroceryApp/screens/tab/mycart.dart';
import 'package:readymadeGroceryApp/service/cart-service.dart';
import 'package:readymadeGroceryApp/service/common.dart';
import 'package:readymadeGroceryApp/service/constants.dart';
import 'package:readymadeGroceryApp/service/localizations.dart';
import 'package:readymadeGroceryApp/service/sentry-service.dart';
import 'package:readymadeGroceryApp/style/style.dart';
import 'package:readymadeGroceryApp/service/product-service.dart';
import 'package:readymadeGroceryApp/widgets/loader.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../style/style.dart';

SentryError sentryError = new SentryError();

class Orders extends StatefulWidget {
  final String userID, locale;
  final Map localizedValues;

  Orders({Key key, this.userID, this.locale, this.localizedValues})
      : super(key: key);

  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  bool isLoading = false,
      isLoadingSubProductsList = false,
      showRating = false,
      showblur = false;
  List subProductsList = List();
  List<dynamic> orderList;
  double rating;
  var orderedTime;
  String currency;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  @override
  void initState() {
    getOrderByUserID();
    super.initState();
  }

  getOrderByUserID() async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }
    await Common.getCurrency().then((value) {
      currency = value;
    });
    await ProductService.getOrderByUserID(widget.userID).then((onValue) {
      try {
        _refreshController.refreshCompleted();

        if (onValue['response_code'] == 200) {
          if (mounted) {
            setState(() {
              orderList = onValue['response_data'];
              isLoading = false;
            });
          }
        }
      } catch (error, stackTrace) {
        if (mounted) {
          setState(() {
            orderList = [];
            isLoading = false;
          });
        }
        sentryError.reportError(error, stackTrace);
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          orderList = [];
          isLoading = false;
        });
      }
      sentryError.reportError(error, null);
    });
  }

  addToCart(data, length, loopIndex) async {
    Map<String, dynamic> buyNowProduct = {
      'productId': data['productId'].toString(),
      'quantity': data['quantity'],
      "price": data['price'],
      "unit": data['unit']
    };

    await CartService.addProductToCart(buyNowProduct).then((onValue) {
      try {
        if (onValue['response_code'] == 200) {
          if (length - 1 == loopIndex) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => MyCart(
                  locale: widget.locale,
                  localizedValues: widget.localizedValues,
                ),
              ),
            );
          }
        }
      } catch (error, stackTrace) {
        sentryError.reportError(error, stackTrace);
      }
    }).catchError((error) {
      sentryError.reportError(error, null);
    });
  }

  orderRating(orderId, rating) async {
    var body = {"rating": rating};

    await ProductService.orderRating(body, orderId).then((onValue) {
      try {
        if (onValue['response_code'] == 200) {
          Navigator.pop(context);
          getOrderByUserID();
        }
      } catch (error, stackTrace) {
        sentryError.reportError(error, stackTrace);
      }
    }).catchError((error) {
      sentryError.reportError(error, null);
    });
  }

  ratingAlert(orderId) {
    return showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: Container(
            margin: const EdgeInsets.only(
                top: 250.0, bottom: 170.0, left: 20.0, right: 20.0),
            decoration: new BoxDecoration(
              color: Colors.white,
              borderRadius: new BorderRadius.all(
                new Radius.circular(32.0),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 25.0),
                  child: Text(
                    MyLocalizations.of(context).rateProduct,
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 20,
                        decoration: TextDecoration.none),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: RatingBar(
                        initialRating: 3,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemSize: 30.0,
                        itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.red,
                          size: 15.0,
                        ),
                        onRatingUpdate: (rate) {
                          setState(() {
                            rating = rate;
                          });
                        },
                      ),
                    )
                  ],
                ),
                SizedBox(height: 50),
                Center(
                  child: GFButton(
                    onPressed: () {
                      if (rating == null) {
                        rating = 3.0;
                      }
                      orderRating(orderId, rating);
                    },
                    text: MyLocalizations.of(context).submit,
                    textColor: Colors.black,
                    color: primary,
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFDFDFD),
      appBar: GFAppBar(
        title: Text(
          MyLocalizations.of(context).myOrders,
          style: textbarlowSemiBoldBlack(),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: primary,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: false,
        controller: _refreshController,
        onRefresh: () {
          getOrderByUserID();
        },
        child: isLoading
            ? SquareLoader()
            : orderList.length == 0
                ? Center(
                    child: Image.asset('lib/assets/images/no-orders.png'),
                  )
                : ListView(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 20, bottom: 10),
                        child: ListView.builder(
                          physics: ScrollPhysics(),
                          shrinkWrap: true,
                          itemCount:
                              orderList.length == null ? 0 : orderList.length,
                          itemBuilder: (BuildContext context, int i) {
                            return orderList[i]['cart'] == null
                                ? Container()
                                : InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => OrderDetails(
                                            locale: widget.locale,
                                            localizedValues:
                                                widget.localizedValues,
                                            orderId: orderList[i]["_id"],
                                          ),
                                        ),
                                      );
                                    },
                                    child: Column(
                                      children: <Widget>[
                                        product(orderList[i]),
                                        orderList[i]['orderStatus'] !=
                                                    "Cancelled" &&
                                                orderList[i]['orderStatus'] !=
                                                    "DELIVERED" &&
                                                orderList[i]['orderStatus'] !=
                                                    "Pending"
                                            ? orderTrack(orderList[i])
                                            : Container(),
                                        SizedBox(
                                          height: 20,
                                        )
                                      ],
                                    ),
                                  );
                          },
                        ),
                      ),
                      SizedBox(height: 30)
                    ],
                  ),
      ),
    );
  }

  product(orderDetails) {
    return Container(
      color: Color(0xFFF7F7F7),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      child: Row(
        children: <Widget>[
          Container(
            height: 70,
            width: 99,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              boxShadow: [
                BoxShadow(color: Color(0xFF0000000A), blurRadius: 0.40)
              ],
              image: DecorationImage(
                  image: orderDetails['cart']['cart'][0]['filePath'] == null &&
                          orderDetails['cart']['cart'][0]['imageUrl'] == null
                      ? AssetImage('lib/assets/images/no-orders.png')
                      : NetworkImage(
                          orderDetails['cart']['cart'][0]['filePath'] == null
                              ? orderDetails['cart']['cart'][0]['imageUrl']
                              : Constants.IMAGE_URL_PATH +
                                  "tr:dpr-auto,tr:w-500" +
                                  orderDetails['cart']['cart'][0]['filePath'],
                        ),
                  fit: BoxFit.cover),
            ),
          ),
          SizedBox(width: 17),
          Container(
            width: MediaQuery.of(context).size.width - 146,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '${orderDetails['cart']['cart'][0]['title']}' ?? "",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: textBarlowRegularrdark(),
                ),
                orderDetails['cart']['cart'].length == 1
                    ? Container()
                    : SizedBox(height: 5),
                orderDetails['cart']['cart'].length == 1
                    ? Container()
                    : Text(
                        MyLocalizations.of(context).and +
                            ' ${(orderDetails['cart']['cart'].length - 1)} ' +
                            MyLocalizations.of(context).moreitems,
                        style: textSMBarlowRegularrBlack(),
                      ),
                SizedBox(height: 10),
                Text(
                  '$currency${orderDetails['grandTotal'].toStringAsFixed(2)}',
                  style: titleLargeSegoeBlack(),
                ),
                SizedBox(height: 10),
                Text(
                  MyLocalizations.of(context).ordered +
                          ' : ' +
                          DateFormat('dd/MM/yyyy, hh:mm a').format(
                            DateTime.fromMillisecondsSinceEpoch(
                                orderDetails['appTimestamp']),
                          ) ??
                      "",
                  style: textSMBarlowRegularrBlack(),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  orderTrack(orderDetails) {
    return Container(
      color: Color(0xFFF7F7F7),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          GFListTile(
            avatar: Column(
              children: <Widget>[
                GFAvatar(
                  backgroundColor:
                      (orderDetails['orderStatus'] == "Confirmed" ||
                              orderDetails['orderStatus'] == "Out for delivery")
                          ? green
                          : greyb.withOpacity(0.5),
                  radius: 6,
                ),
                SizedBox(
                  height: 10,
                ),
                CustomPaint(painter: LineDashedPainter()),
              ],
            ),
            title: Text(
              MyLocalizations.of(context).orderConfirmed,
              style: orderDetails['orderStatus'] == "Confirmed" ||
                      orderDetails['orderStatus'] == "Out for delivery"
                  ? titleSegoeGreen()
                  : titleSegoeGrey(),
            ),
            icon: Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: SvgPicture.asset('lib/assets/icons/tick.svg'),
            ),
            subTitle: Text(
              '',
              style: textSMBarlowRegularrGreyb(),
            ),
          ),
          GFListTile(
            avatar: Column(
              children: <Widget>[
                GFAvatar(
                  backgroundColor:
                      orderDetails['orderStatus'] == "Out for delivery"
                          ? green
                          : greyb.withOpacity(0.5),
                  radius: 6,
                ),
                SizedBox(
                  height: 10,
                ),
                CustomPaint(painter: LineDashedPainter()),
              ],
            ),
            title: Text(
              MyLocalizations.of(context).outfordelivery,
              style: orderDetails['orderStatus'] == "Out for delivery"
                  ? titleSegoeGreen()
                  : titleSegoeGrey(),
            ),
            icon: orderDetails['orderStatus'] == "Out for delivery"
                ? Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: SvgPicture.asset('lib/assets/icons/tick.svg'),
                  )
                : null,
            subTitle: Text(
              '',
              style: textSMBarlowRegularrGreyb(),
            ),
          ),
          GFListTile(
            avatar: Column(
              children: <Widget>[
                GFAvatar(
                  backgroundColor: greyb.withOpacity(0.5),
                  radius: 6,
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
            title: Text(
              MyLocalizations.of(context).orderdelivered,
              style: titleSegoeGrey(),
            ),
            icon: orderDetails['orderStatus'] == "DELIVERED"
                ? Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: SvgPicture.asset('lib/assets/icons/tick.svg'),
                  )
                : null,
            subTitle: Text(
              '',
              style: textSMBarlowRegularrGreyb(),
            ),
          ),
        ],
      ),
    );
  }

  reorder(orderDetails) {
    return Container(
      color: Color(0xFFF7F7F7),
      padding: EdgeInsets.only(bottom: 20),
      child: Row(
        children: <Widget>[
          Expanded(
              child: Container(
            height: 48,
            margin: EdgeInsets.only(left: 20, right: 15),
            child: GFButton(
              onPressed: () {
                for (int j = 0; j < orderDetails['cart']['cart'].length; j++) {
                  addToCart(orderDetails['cart']['cart'][j],
                      orderDetails['cart']['cart'].length, j);
                }
              },
              text: MyLocalizations.of(context).reorder,
              color: primary,
              textStyle: textbarlowmediumwblack(),
            ),
          )),
          Expanded(
              child: Container(
            height: 48,
            margin: EdgeInsets.only(right: 20, left: 20.0),
            child: GFButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrderDetails(
                      locale: widget.locale,
                      localizedValues: widget.localizedValues,
                      orderId: orderDetails["_id"],
                    ),
                  ),
                );
              },
              text: MyLocalizations.of(context).view,
              type: GFButtonType.outline,
              color: primary,
              textStyle: textbarlowmediumwprimary(),
            ),
          )),
          SizedBox(
            height: 20.0,
          ),
        ],
      ),
    );
  }
}

class LineDashedPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()..strokeWidth = 1;
    var max = 55;
    var dashWidth = 3;
    var dashSpace = 4;
    double startY = 0;
    while (max >= 0) {
      canvas.drawLine(Offset(0, startY), Offset(0, startY + dashWidth), paint);
      final space = (dashSpace + dashWidth);
      startY += space;
      max -= space;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
