import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:readymadeGroceryApp/screens/chat/chatHistory.dart';
import 'package:readymadeGroceryApp/screens/chat/chatListPage.dart';
import 'package:readymadeGroceryApp/service/localizations.dart';
import 'package:readymadeGroceryApp/service/sentry-service.dart';
import 'package:readymadeGroceryApp/style/style.dart';

SentryError sentryError = new SentryError();

class NewChatAndHistoryPage extends StatefulWidget {
  final Map localizedValues;
  final String locale;
  NewChatAndHistoryPage({Key key, this.locale, this.localizedValues});

  @override
  _NewChatAndHistoryPageState createState() => _NewChatAndHistoryPageState();
}

class _NewChatAndHistoryPageState extends State<NewChatAndHistoryPage>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back, color: Colors.black),
          ),
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.chat, color: Colors.black)),
              Tab(icon: Icon(Icons.history, color: Colors.black)),
            ],
          ),
          backgroundColor: primary,
          centerTitle: true,
          title: Text(
            MyLocalizations.of(context).getLocalizations("CHAT"),
            style: textbarlowSemiBoldBlack(),
          ),
        ),
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            ChatListPage(
              locale: widget.locale,
              localizedValues: widget.localizedValues,
            ),
            ChatHistoryListPage(
              locale: widget.locale,
              localizedValues: widget.localizedValues,
            ),
          ],
        ),
      ),
    );
  }
}
