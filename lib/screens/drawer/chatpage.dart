import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:readymadeGroceryApp/service/auth-service.dart';
import 'package:readymadeGroceryApp/service/chat-service.dart';
import 'package:readymadeGroceryApp/service/constants.dart';
import 'package:readymadeGroceryApp/service/localizations.dart';
import 'package:readymadeGroceryApp/service/sentry-service.dart';
import 'package:readymadeGroceryApp/style/style.dart';
import 'package:readymadeGroceryApp/widgets/appBar.dart';
import 'package:readymadeGroceryApp/widgets/loader.dart';
import 'package:readymadeGroceryApp/widgets/normalText.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

SentryError sentryError = new SentryError();

class Chat extends StatefulWidget {
  final Map? localizedValues, userDetail, chatDetails;
  final String? locale;
  Chat(
      {Key? key,
      this.locale,
      this.localizedValues,
      this.userDetail,
      this.chatDetails});

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> with TickerProviderStateMixin {
  List chatList = [];
  ScrollController _scrollController = new ScrollController();
  final TextEditingController _textController = new TextEditingController();
  bool _isWriting = false, isChatLoading = false, getUserDataLoading = false;

  dynamic userData, pageNumber = 0, chatDataLimit = 100;
  Timer? chatTimer;
  var socket = io.io(Constants.apiUrl, <String, dynamic>{
    'transports': ['websocket']
  });
  @override
  void initState() {
    getUserData();
    getChatData();

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
          socketInt();
        });
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          getUserDataLoading = false;
        });
      }
      sentryError.reportError(error, null);
    });
  }

  //fetchres info
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
      sentryError.reportError(error, null);
    });
  }

  socketInt() {
    socket.on('connect', (data) {
      print('connect ');
    });
    setState(() {
      getUserDataLoading = false;
    });
    socket.on('disconnect', (_) {
      print('disconnect');
    });

    socket.on('message-user-${userData['_id']}', (data) {
      if (data != null && mounted) {
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
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => new Scaffold(
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
                              color: Theme.of(context).accentColor),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: new Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  new Flexible(
                                    child: new TextField(
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
                                          ? () =>
                                              _submitMsg(_textController.text)
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

  void _submitMsg(String txt) async {
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
    socket.emit('message-user-to-store', chatInfo);

    chatList.add(chatInfo);
  }
}
