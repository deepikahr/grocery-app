import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';
import 'package:grocery_pro/screens/home/home.dart';
import 'package:grocery_pro/screens/product/product-details.dart';
import 'package:grocery_pro/style/style.dart';

class SearchItem extends StatefulWidget {
  const SearchItem({
    Key key,
    this.productsList,
    this.favProductList,
    this.currency,
  }) : super(key: key);
  final List productsList, favProductList;
  final String currency;
  @override
  _SearchItemState createState() => _SearchItemState();
}

bool monVal = false;
bool tuVal = false;
bool wedVal = false;
bool _isChecked = false;

class _SearchItemState extends State<SearchItem> {
  Widget appBarTitle = new Text(
    "Search Example",
    style: new TextStyle(color: Colors.white),
  );
  Icon icon = new Icon(
    Icons.search,
    color: Colors.white,
  );
  final globalKey = new GlobalKey<ScaffoldState>();
  final TextEditingController _controller = new TextEditingController();
  bool _isSearching;
  String _searchText = "";
  List searchresult = new List();

  @override
  void initState() {
    print(widget.productsList);
    super.initState();
    _isSearching = false;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: globalKey,
        body: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                child: new TextField(
                  controller: _controller,
                  style: new TextStyle(
                    color: Colors.black,
                  ),
                  decoration: new InputDecoration(
                    prefixIcon: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: new Icon(Icons.arrow_back, color: Colors.black),
                    ),
                    hintText: "What are you buying today?",
                    fillColor: Colors.black,
                    focusColor: Colors.black,
                    contentPadding: EdgeInsets.only(
                      left: 15.0,
                      right: 15.0,
                      top: 10.0,
                      bottom: 10.0,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: primary, width: 0.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: primary),
                    ),
                  ),
                  onChanged: searchOperation,
                ),
              ),
            ),
            new Flexible(
              child: searchresult.length > 0 ||
                      searchresult.length != 0 ||
                      _controller.text.length > 3
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 18.0, bottom: 10.0, left: 20.0, right: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                  searchresult.length.toString() +
                                      " Items Founds",
                                  style: textBarlowMediumBlack()),
                              // InkWell(
                              //     onTap: () {
                              //       Navigator.push(
                              //         context,
                              //         MaterialPageRoute(
                              //           builder: (context) => Home(),
                              //         ),
                              //       );
                              //     },
                              //     child: Text('Show More',
                              //         style: textBarlowMediumPrimary()))
                            ],
                          ),
                        ),
                        // Divider(),
                        new ListView.builder(
                          shrinkWrap: true,
                          itemCount: searchresult.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              margin: EdgeInsets.only(bottom: 20),
                              color: Colors.white,
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProductDetails(
                                          productDetail: searchresult[index],
                                          favProductList:
                                              widget.favProductList == null
                                                  ? null
                                                  : widget.favProductList),
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: <Widget>[
                                      new ListTile(
                                        leading: Image(
                                          height: 60,
                                          width: 90,
                                          image: NetworkImage(
                                              searchresult[index]['imageUrl']),
                                        ),
                                        title: new Text(
                                          searchresult[index]['title']
                                              .toString(),
                                          style: textbarlowRegularBlack(),
                                        ),
                                        subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            new Text(
                                                searchresult[index]
                                                            ['description']
                                                        .toString() ??
                                                    "",
                                                style:
                                                    textBarlowRegularrBlacksm()),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                new Text(
                                                  widget.currency +
                                                      searchresult[index]
                                                                  ['variant'][0]
                                                              ['price']
                                                          .toString() +
                                                      "/" +
                                                      searchresult[index]
                                                                  ['variant'][0]
                                                              ['unit']
                                                          .toString(),
                                                  style:
                                                      textBarlowMediumGreen(),
                                                ),
                                                searchresult[index]
                                                            ['discount'] ==
                                                        null
                                                    ? Container()
                                                    : Container(
                                                        height: 20,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    20),
                                                            bottomRight:
                                                                Radius.circular(
                                                                    20),
                                                          ),
                                                        ),
                                                        child: GFButtonBadge(
                                                          text:
                                                              "${searchresult[index]['discount']}% off",
                                                          onPressed: null,
                                                          color: Colors
                                                              .deepOrange[300],
                                                        ),
                                                      )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      // Divider()
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    )
                  : Center(
                      child: Container(
                        child: Image.asset('lib/assets/images/no-orders.png'),
                      ),
                    ),
            )
          ],
        ));
  }

  Widget buildAppBar(BuildContext context) {
    return new AppBar(
      centerTitle: true,
      elevation: 0.0,
      title: Container(
        width: 343,
        height: 45,
        margin: EdgeInsets.only(top: 10),
        child: new TextField(
          controller: _controller,
          style: textBarlowRegularBlackwithOpa(),
          decoration: new InputDecoration(
            contentPadding: EdgeInsets.only(top: 5),
            prefixIcon: new Icon(Icons.arrow_back, color: Colors.black54),
            hintText: "What are you buying today?",
            hintStyle: textBarlowRegularBlackwithOpa(),
            enabledBorder: const OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.grey, width: 0.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: primary),
            ),
          ),
          onChanged: searchOperation,
        ),
      ),
      backgroundColor: Colors.transparent,
      iconTheme: IconThemeData(color: Colors.black54),
      automaticallyImplyLeading: false,
    );
  }

  void searchOperation(String searchText) {
    searchresult.clear();
    if (_isSearching != null && searchText.length > 3) {
      for (int i = 0; i < widget.productsList.length; i++) {
        if (widget.productsList[i]['title']
            .toLowerCase()
            .contains(searchText.toLowerCase())) {
          setState(() {
            searchresult.add(widget.productsList[i]);
          });
        }
      }
    } else if (searchText.length == 0 || searchText.length < 3) {
      setState(() {
        searchresult.clear();
      });
    }
  }
}
