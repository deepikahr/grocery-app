import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';
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
        appBar: buildAppBar(context),
        body: ListView(
          children: <Widget>[
            new Flexible(
              child: searchresult.length != 0 || _controller.text.isNotEmpty
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 8.0, bottom: 8.0, left: 20.0),
                          child: Text(
                              searchresult.length.toString() + " Items Founds",
                              style: textBarlowMediumBlack()),
                        ),
                        Divider(),
                        new ListView.builder(
                          shrinkWrap: true,
                          itemCount: searchresult.length,
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
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
                                        searchresult[index]['title'].toString(),
                                        style: heading(),
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          new Text(
                                              searchresult[index]['description']
                                                      .toString() ??
                                                  "",
                                              style: TextStyle(
                                                  color:
                                                      const Color(0xFF00BFA5),
                                                  fontSize: 17.0)),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
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
                                                style: TextStyle(
                                                    color:
                                                        const Color(0xFF00BFA5),
                                                    fontSize: 17.0),
                                              ),
                                              searchresult[index]['discount'] ==
                                                      null
                                                  ? Container()
                                                  : Container(
                                                      height: 20,
                                                      decoration: BoxDecoration(
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
                                    Divider()
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    )
                  : Center(
                      child: Image.asset('lib/assets/images/no-orders.png'),
                    ),
            )
          ],
        ));
  }

  Widget buildAppBar(BuildContext context) {
    return new AppBar(
      centerTitle: true,
      title: Container(
        child: new TextField(
          controller: _controller,
          style: new TextStyle(
            color: Colors.white,
          ),
          decoration: new InputDecoration(
            prefixIcon: new Icon(Icons.search, color: Colors.white),
            hintText: "Search...",
            hintStyle: new TextStyle(color: Colors.white),
          ),
          onChanged: searchOperation,
        ),
      ),
      backgroundColor: primary,
    );
  }

  void searchOperation(String searchText) {
    searchresult.clear();
    if (_isSearching != null) {
      for (int i = 0; i < widget.productsList.length; i++) {
        Map data = widget.productsList[i];
        if (data['title'].toLowerCase().contains(searchText.toLowerCase())) {
          setState(() {
            searchresult.add(data);
          });
        }
      }
    }
  }
}
