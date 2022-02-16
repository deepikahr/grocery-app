import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:readymadeGroceryApp/screens/new-design/new-subcategories.dart';
import 'package:readymadeGroceryApp/style/style.dart';

class NewCategoryPage extends StatefulWidget {
  const NewCategoryPage({Key? key}) : super(key: key);

  @override
  _NewCategoryPageState createState() => _NewCategoryPageState();
}

class _NewCategoryPageState extends State<NewCategoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GFAppBar(
        backgroundColor: primarybg,
        automaticallyImplyLeading: false,
        elevation: 0,
        leading: Image.asset(
          'lib/assets/icons/menu.png',
          scale: 3,
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Delivery Location',
              style: textbarlowRegularsmall(context),
            ),
            Text(
              'HSR.., Bangalore',
              style: textbarlowRegularstandard(context),
            )
          ],
        ),
        actions: [
          Image.asset(
            'lib/assets/icons/bell.png',
            scale: 3,
          )
        ],
      ),
      body: Container(
        margin: EdgeInsets.all(15),
        child: ListView(
          children: [
            Text(
              'Categories',
              style: textbarlowBoldblack(context),
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => NewSubCategory()),
                    );
                  },
                  child: Column(
                    children: [
                      GFAvatar(
                          radius: 35,
                          backgroundImage: AssetImage(
                            'lib/assets/icons/cat1.png',
                          ),
                          backgroundColor: Color(0XFFfdf6df)),
                      SizedBox(height: 5),
                      Text(
                        'Fruits',
                        style: textbarlowRegularstandardblack(context),
                      )
                    ],
                  ),
                ),
                Column(
                  children: [
                    GFAvatar(
                        radius: 35,
                        backgroundImage: AssetImage(
                          'lib/assets/icons/cat1.png',
                        ),
                        backgroundColor: Color(0XFFfdf6df)),
                    SizedBox(height: 5),
                    Text(
                      'Veggies',
                      style: textbarlowRegularstandardblack(context),
                    )
                  ],
                ),
                Column(
                  children: [
                    GFAvatar(
                        radius: 35,
                        backgroundImage: AssetImage(
                          'lib/assets/icons/cat1.png',
                        ),
                        backgroundColor: Color(0XFFfdf6df)),
                    SizedBox(height: 5),
                    Text(
                      'Fruits',
                      style: textbarlowRegularstandardblack(context),
                    )
                  ],
                ),
                Column(
                  children: [
                    GFAvatar(
                        radius: 35,
                        backgroundImage: AssetImage(
                          'lib/assets/icons/cat1.png',
                        ),
                        backgroundColor: Color(0XFFfdf6df)),
                    SizedBox(height: 5),
                    Text(
                      'Fruits',
                      style: textbarlowRegularstandardblack(context),
                    )
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
