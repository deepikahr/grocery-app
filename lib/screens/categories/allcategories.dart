import 'package:flutter/material.dart';
import 'package:readymadeGroceryApp/screens/categories/subcategories.dart';
import 'package:readymadeGroceryApp/service/product-service.dart';
import 'package:readymadeGroceryApp/service/sentry-service.dart';
import 'package:readymadeGroceryApp/widgets/appBar.dart';
import 'package:readymadeGroceryApp/widgets/categoryBlock.dart';
import 'package:readymadeGroceryApp/widgets/loader.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

SentryError sentryError = new SentryError();

class AllCategories extends StatefulWidget {
  final Map localizedValues;
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
      _refreshController.refreshCompleted();
      if (mounted) {
        setState(() {
          categoryList = onValue['response_data'];
          isLoadingcategoryList = false;
        });
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
      appBar: appBarTransparent(context, "ALL_CATEGROIES"),
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
                      child: CategoryBlock(
                          image: categoryList[index]['filePath'] == null
                              ? categoryList[index]['imageUrl']
                              : categoryList[index]['filePath'],
                          title: categoryList[index]['title'],
                          isPath: categoryList[index]['filePath'] == null
                              ? false
                              : true,
                          isHome: false),
                    );
                  },
                ),
              ),
      ),
    );
  }
}
