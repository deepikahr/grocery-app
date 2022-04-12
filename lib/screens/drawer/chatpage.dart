import 'dart:async';
import 'package:flutter/material.dart';
import 'package:readymadeGroceryApp/service/auth-service.dart';
import 'package:readymadeGroceryApp/service/chat-service.dart';
import 'package:readymadeGroceryApp/service/localizations.dart';
import 'package:readymadeGroceryApp/service/error-service.dart';
import 'package:readymadeGroceryApp/service/socket.dart';
import 'package:readymadeGroceryApp/style/style.dart';
import 'package:readymadeGroceryApp/widgets/appBar.dart';
import 'package:readymadeGroceryApp/widgets/loader.dart';
import 'package:readymadeGroceryApp/widgets/normalText.dart';

ReportError reportError = new ReportError();

class Chat extends StatefulWidget {
  final Map? localizedValues;
  final String? locale;
  Chat({Key? key, this.locale, this.localizedValues});

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> with TickerProviderStateMixin {
  List chatList = [];
  ScrollController _scrollController = new ScrollController();
  final TextEditingController _textController = new TextEditingController();
  bool _isWriting = false, isChatLoading = false, getUserDataLoading = false;
  var userData, pageNumber = 0, chatDataLimit = 1000;
  var socketService = SocketService();
  @override
  void initState() {
    socketService.socketClear();
    getUserData();
    super.initState();
  }

  getUserData() async {
    if (mounted) {
      setState(() {
        getUserDataLoading = true;
      });
    }
    await LoginService.getUserInfo().then((onValue) {
      if (mounted) {
        setState(() {
          userData = onValue['response_data'];
          getUserDataLoading = false;
          getChatData();
        });
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          getUserDataLoading = false;
        });
      }
      reportError.reportError(error, null);
    });
  }

  getChatData() async {
    if (mounted) {
      setState(() {
        isChatLoading = true;
      });
    }
    ChatService.chatDataMethod(pageNumber, chatDataLimit).then((response) {
      if (mounted) {
        setState(() {
          chatList.addAll(response['response_data']);
          socketListenMsg();
          Timer(Duration(milliseconds: 300), () {
            Timer(
                Duration(milliseconds: 300),
                () => _scrollController
                    .jumpTo(_scrollController.position.maxScrollExtent));
          });
          isChatLoading = false;
        });
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          getUserDataLoading = false;
        });
      }
      reportError.reportError(error, null);
    });
  }

  socketListenMsg() {
    socketService.socketListenMsg(userData['_id'], (data) {
      if (data != null) {
        if (mounted) {
          setState(() {
            chatList.add(data);
            Timer(Duration(milliseconds: 300), () {
              Timer(
                  Duration(milliseconds: 300),
                  () => _scrollController
                      .jumpTo(_scrollController.position.maxScrollExtent));
            });
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: bg(context),
      appBar: appBarPrimary(context, "CHAT") as PreferredSizeWidget?,
      body: isChatLoading || getUserDataLoading
          ? SquareLoader()
          : Stack(
              fit: StackFit.expand,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Expanded(
                      child: new ListView.builder(
                        controller: _scrollController,
                        padding: new EdgeInsets.all(8.0),
                        itemCount: chatList.isEmpty ? 0 : chatList.length,
                        itemBuilder: (BuildContext context, int index) {
                          bool isOwnMessage = false;
                          if (chatList[index]['sentBy'] == 'USER') {
                            isOwnMessage = true;
                          }
                          return chatMessgae(context,
                              chatList[index]['message'], isOwnMessage);
                        },
                      ),
                    ),
                    new Divider(height: 1.0),
                    Container(
                      decoration: BoxDecoration(
                        color: greya(context),
                      ),
                      child: new IconTheme(
                        data: new IconThemeData(
                            color: Theme.of(context).colorScheme.secondary),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: new Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                new Flexible(
                                  child: new TextField(
                                    keyboardType: TextInputType.text,
                                    textInputAction: TextInputAction.done,
                                    maxLines: 1,
                                    controller: _textController,
                                    onChanged: (String txt) {
                                      if (mounted) {
                                        setState(() {
                                          _isWriting = txt.length > 0;
                                        });
                                      }
                                    },
                                    onSubmitted: _submitMsg,
                                    decoration: new InputDecoration.collapsed(
                                        hintText: MyLocalizations.of(context)!
                                            .getLocalizations(
                                                "ENTER_TEXT_HERE")),
                                  ),
                                ),
                                new Container(
                                  decoration: BoxDecoration(
                                    color: greyb2,
                                  ),
                                  child: new IconButton(
                                    icon: new Icon(
                                      Icons.send,
                                      color: primarybg,
                                      size: 30,
                                    ),
                                    onPressed: _isWriting
                                        ? () => _submitMsg(_textController.text)
                                        : null,
                                  ),
                                ),
                              ],
                            ),
                            decoration: BoxDecoration(
                              color: whiteBg(context),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
    );
  }

  void _submitMsg(String txt) async {
    if (txt.length > 0) {
      Timer(Duration(milliseconds: 300), () {
        Timer(
            Duration(milliseconds: 300),
            () => _scrollController
                .jumpTo(_scrollController.position.maxScrollExtent));
      });
      _textController.clear();
      if (mounted) {
        setState(() {
          _isWriting = false;
        });
      }
      var chatInfo = {
        "message": txt,
        "sentBy": 'USER',
        "userName": userData['firstName'],
        "userId": userData['_id']
      };
      socketService.socketSendMsg(chatInfo);
      chatList.add(chatInfo);
    }
  }
}
