import 'package:flutter/material.dart';
import 'package:getflutter/components/appbar/gf_appbar.dart';
import 'package:getflutter/getflutter.dart';
import 'package:readymadeGroceryApp/screens/categories/subcategories.dart';
import 'package:readymadeGroceryApp/service/constants.dart';
import 'package:readymadeGroceryApp/service/localizations.dart';

import 'package:readymadeGroceryApp/service/product-service.dart';
import 'package:readymadeGroceryApp/service/sentry-service.dart';
import 'package:readymadeGroceryApp/style/style.dart';
import 'package:readymadeGroceryApp/widgets/loader.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

SentryError sentryError = new SentryError();

class AllCategories extends StatefulWidget {
  final Map<String, Map<String, String>> localizedValues;
  final String locale;
  final bool getTokenValue;
  AllCategories(
      {Key key, this.locale, this.localizedValues, this.getTokenValue});

  @override
  _AllCategoriesState createState() => _AllCategoriesState();
}

class _AllCategoriesState extends State<AllCategories>
    with TickerProviderStateMixin {
  TabController tabController;
  bool isLoadingProductsList = false, isLoadingcategoryList = false;
  List categoryList, productsList;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 4, vsync: this);
    getCategoryList();
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
        _refreshController.refreshCompleted();
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
              isLoadingcategoryList = false;
            });
          }
        }
      } catch (error, stackTrace) {
        if (mounted) {
          setState(() {
            categoryList = [];
            isLoadingcategoryList = false;
          });
        }
        sentryError.reportError(error, stackTrace);
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          categoryList = [];
          isLoadingcategoryList = false;
        });
      }
      sentryError.reportError(error, null);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GFAppBar(
        title: Text(MyLocalizations.of(context).allCategories,
            style: textbarlowSemiBoldBlack()),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black, size: 15.0),
      ),
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: false,
        controller: _refreshController,
        onRefresh: () {
          getCategoryList();
        },
        child: isLoadingcategoryList
            ? SquareLoader()
            : Container(
                child: GridView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  physics: ScrollPhysics(),
                  shrinkWrap: true,
                  itemCount:
                      categoryList.length == null ? 0 : categoryList.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: MediaQuery.of(context).size.width / 420,
                      crossAxisSpacing: 0,
                      mainAxisSpacing: 0),
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => SubCategories(
                                locale: widget.locale,
                                localizedValues: widget.localizedValues,
                                catId: categoryList[index]['_id'],
                                catTitle:
                                    '${categoryList[index]['title'][0].toUpperCase()}${categoryList[index]['title'].substring(1)}',
                                token: widget.getTokenValue),
                          ),
                        );
                      },
                      child: Container(
                        width: 96,
                        padding: EdgeInsets.only(right: 16),
                        child: Column(
                          children: <Widget>[
                            Container(
                              width: 85,
                              height: 85,
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                                border: Border.all(
                                    color: Colors.black.withOpacity(0.20)),
                              ),
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                                child: Image.network(
                                  categoryList[index]['filePath'] == null
                                      ? categoryList[index]['imageUrl']
                                      : Constants.IMAGE_URL_PATH +
                                          "tr:dpr-auto,tr:w-500" +
                                          categoryList[index]['filePath'],
                                  scale: 5,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Text(
                              categoryList[index]['title'],
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: textBarlowRegularrdarkdull(),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
      ),
    );
  }
}
