import 'package:flutter/material.dart';
import 'package:getflutter/components/appbar/gf_appbar.dart';
import 'package:getflutter/getflutter.dart';
import 'package:grocery_pro/screens/categories/subcategories.dart';

import 'package:grocery_pro/style/style.dart';
import 'package:grocery_pro/service/product-service.dart';
import 'package:grocery_pro/service/sentry-service.dart';

SentryError sentryError = new SentryError();

class AllCategories extends StatefulWidget {
  @override
  _AllCategoriesState createState() => _AllCategoriesState();
}

class _AllCategoriesState extends State<AllCategories>
    with TickerProviderStateMixin {
  TabController tabController;
  bool isLoadingProductsList = false;
  bool isLoadingcategoryList = false;
  List categoryList = List();
  List productsList = List();

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 4, vsync: this);
    getCategoryList();
    // getProductsList();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  getCategoryList() async {
    if (mounted) {
      setState(() {
        isLoadingcategoryList = true;
      });
    }
    await ProductService.getCategoryList().then((onValue) {
      try {
        if (onValue['response_code'] == 200) {
          if (mounted) {
            setState(() {
              categoryList = onValue['response_data'];
              isLoadingcategoryList = false;
            });
          }
        } else {
          if (mounted) {
            setState(() {
              categoryList = [];
            });
          }
        }
      } catch (error, stackTrace) {
        sentryError.reportError(error, stackTrace);
      }
    }).catchError((error) {
      sentryError.reportError(error, null);
    });
  }

  getProductToCategory(id, title) async {
    if (mounted)
      setState(() {
        isLoadingProductsList = true;
      });
    await ProductService.getProductToCategoryList(id).then((onValue) {
      try {
        if (mounted)
          setState(() {
            productsList = onValue['response_data'];
            isLoadingProductsList = false;
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
          title: Text('All Categories',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 17.0,
                  fontWeight: FontWeight.w600)),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black, size: 15.0),
        ),
        body: isLoadingProductsList && isLoadingcategoryList
            ? Center(child: CircularProgressIndicator())
            : Container(
                child: GridView.builder(
                    physics: ScrollPhysics(),
                    shrinkWrap: true,
                    // scrollDirection: Axis.horizontal,
                    itemCount:
                        categoryList.length == null ? 0 : categoryList.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3),
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) => SubCategories(
                                      catId: categoryList[index]['_id'],
                                      catTitle:
                                          '${categoryList[index]['title'][0].toUpperCase()}${categoryList[index]['title'].substring(1)}')),
                            );
                          },
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(color:Colors.grey[300]),
                                                               borderRadius: BorderRadius.circular(10),

                                      ),
                                      child: Column(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Container(
                                              width: 80,
                                              height: 80,
                                                                            decoration: BoxDecoration(
                      // border: Border.all(color:Colors.grey),
                       borderRadius: BorderRadius.circular(10),
            image: new DecorationImage(
                              fit: BoxFit.fill,
                              image: new NetworkImage(categoryList[index]['imageUrl']),
                     
                    ),),
                                              // child: Column(
                                              //   children: <Widget>[
                                              //     Padding(
                                              //         padding: const EdgeInsets.only(
                                              //             bottom: 10.0),
                                              //         child: Image.network(
                                              //           categoryList[index]['imageUrl'],
                                              //           width: 80,
                                              //           fit: BoxFit.fill,
                                              //           height: 80,
                                              //         )),
                                              //   ],
                                              // ),
                                            ),
                                          ),
                                          
                                        ],
                                      ),
                                    ),
                                    SizedBox(height:2),
                                    Text(
                                            categoryList[index]['title'],
                                            maxLines: 2,
                                          )
                                  ],
                                ),
                              ]));
                    }),
              ));
  }
}
