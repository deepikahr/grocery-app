import 'package:flutter/material.dart';

import 'package:getflutter/getflutter.dart';
import 'package:grocery_pro/screens/product/product-details.dart';
import 'package:grocery_pro/screens/store/store.dart';
import 'package:grocery_pro/service/product-service.dart';
import 'package:grocery_pro/service/sentry-service.dart';

SentryError sentryError = new SentryError();

bool fav = false;
bool fav1 = false;
bool fav2 = false;
bool _isChecked = false;

class SubCategories extends StatefulWidget {
  // final List productDetail;
  final String catTitle;
  final String catId;

  SubCategories({Key key, this.catId, this.catTitle}) : super(key: key);
  @override
  _SubCategoriesState createState() => _SubCategoriesState();
}

class _SubCategoriesState extends State<SubCategories> {
  bool isLoadingSubProductsList = false;
  List subProductsList = List();
  @override
  void initState() {
    super.initState();
    getProductToCategory(widget.catId);
  }

  @override
  void dispose() {
    super.dispose();
  }

  getProductToCategory(id) async {
    if (mounted)
      setState(() {
        isLoadingSubProductsList = true;
      });
    await ProductService.getProductToCategoryList(id).then((onValue) {
      try {
        if (mounted)
          setState(() {
            subProductsList = onValue['response_data'];
            isLoadingSubProductsList = false;
          });
      } catch (error, stackTrace) {
        sentryError.reportError(error, stackTrace);
      }
    }).catchError((error) {
      sentryError.reportError(error, null);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GFAppBar(
        title: Text('${widget.catTitle}',
            style: TextStyle(
                color: Colors.black,
                fontSize: 17.0,
                fontWeight: FontWeight.w600)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black, size: 1.0),
      ),
      body: isLoadingSubProductsList
          ? Center(child: CircularProgressIndicator())
          : Stack(children: <Widget>[
              subProductsList.length == 0
                  ? Center(
                      child: Image.asset('lib/assets/images/no-orders.png'))
                  : GridView.builder(
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: subProductsList.length == null
                          ? 0
                          : subProductsList.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2),
                      itemBuilder: (BuildContext context, int i) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProductDetails(
                                      productDetail: subProductsList[i])),
                            );
                          },
                          child: GFCard(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0)),
                            boxFit: BoxFit.fill,
                            colorFilter: new ColorFilter.mode(
                                Colors.black.withOpacity(0.67),
                                BlendMode.darken),
                            content: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Stack(
                                  fit: StackFit.loose,
                                  children: <Widget>[
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      // mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20, top: 15.0),
                                          child: Image.network(
                                            subProductsList[i]['imageUrl'],
                                            fit: BoxFit.fill,
                                            width: 80,
                                            height: 70,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Positioned(
                                      height: 15.0,
                                      width: 60.0,
                                      // top: 4.0,
                                      // bottom: 4.0,
                                      // left: 6.0,
                                      child: GFButtonBadge(
                                        onPressed: () {},
                                        text: '25% off',
                                        color: Colors.deepOrange[300],
                                      ),
                                    ),
                                    Positioned(
                                      height: 15.0,
                                      width: 60.0,
                                      // top: 4.0,
                                      bottom: 78.0,
                                      left: 80.0,
                                      child: GFIconButton(
                                        onPressed: null,
                                        icon: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              fav = !fav;
                                            });
                                          },
                                          child: fav
                                              ? Icon(
                                                  Icons.favorite,
                                                  color: Colors.red,
                                                )
                                              : Icon(
                                                  Icons.favorite_border,
                                                  color: Colors.grey,
                                                ),
                                        ),
                                        type: GFButtonType.transparent,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 10.0),
                                          child:
                                              Text(subProductsList[i]['title']),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 2.0),
                                          child: Row(
                                            children: <Widget>[
                                              Icon(
                                                IconData(
                                                  0xe913,
                                                  fontFamily: 'icomoon',
                                                ),
                                                color: const Color(0xFF00BFA5),
                                                size: 11.0,
                                              ),
                                              Text(
                                                subProductsList[i]['price']
                                                    .toString(),
                                                style: TextStyle(
                                                    color: const Color(
                                                        0xFF00BFA5)),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    // Column(
                                    //   children: <Widget>[
                                    //     Padding(
                                    //       padding: const EdgeInsets.only(top: 5.0),
                                    //       child: GFIconButton(
                                    //         onPressed: null,
                                    //         icon: GestureDetector(
                                    //           onTap: () {
                                    //             setState(() {
                                    //               fav = !fav;
                                    //             });
                                    //           },
                                    //           child: fav
                                    //               ? Icon(
                                    //                   Icons.favorite,
                                    //                   color: Colors.red,
                                    //                 )
                                    //               : Icon(
                                    //                   Icons.favorite_border,
                                    //                   color: Colors.grey,
                                    //                 ),
                                    //         ),
                                    //         type: GFButtonType.transparent,
                                    //       ),
                                    //     ),
                                    //   ],
                                    // )
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ]),
    );
  }
}
