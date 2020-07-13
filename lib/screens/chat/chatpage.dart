import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:readymadeGroceryApp/service/auth-service.dart';
import 'package:readymadeGroceryApp/service/constants.dart';
import 'package:readymadeGroceryApp/service/localizations.dart';
import 'package:readymadeGroceryApp/service/sentry-service.dart';
import 'package:readymadeGroceryApp/style/style.dart';
import 'package:readymadeGroceryApp/widgets/loader.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

SentryError sentryError = new SentryError();

class Chat extends StatefulWidget {
  final Map localizedValues, userDetail, chatDetails;
  final String locale;
  Chat(
      {Key key,
      this.locale,
      this.localizedValues,
      this.userDetail,
      this.chatDetails});

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> with TickerProviderStateMixin {
  List chatList = List();
  final ScrollController _scrollController = new ScrollController();
  final TextEditingController _textController = new TextEditingController();
  bool _isWriting = false, isChatLoading = false;

  var chatInfo, resInfo;
  String chatID, id, name;
  Timer chatTimer;
  var socket = io.io(Constants.socketUrl, <String, dynamic>{
    'transports': ['websocket']
  });
  @override
  void initState() {
    chatID = widget.chatDetails['chatId'];
    id = widget.userDetail['_id'];
    name = widget.userDetail['firstName'];
    fetchRestaurantInfo();
    super.initState();
  }

//fetchres info
  fetchRestaurantInfo() async {
    if (mounted) {
      setState(() {
        isChatLoading = true;
      });
    }
    LoginService.restoInfo().then((response) {
      try {
        if (response['response_code'] == 200) {
          resInfo = response['response_data'];
          socketInt();
        }
      } catch (error, stackTrace) {
        sentryError.reportError(error, stackTrace);
      }
    }).catchError((error) {
      sentryError.reportError(error, null);
    });
  }

  socketInt() {
    socket.on('connect', (data) {
      print('connect ');
    });

    socket.on('disconnect', (_) {
      print('disconnect');
    });
    if (widget.chatDetails['chatId'] != null) {
      socket.emit('user-chat-info', {"id": chatID});

      socket.on('chat-info-user-listen$id', (data) {
        isChatLoading = false;
        if (mounted) {
          setState(() {
            chatList = data['messages'];
            chatID = data['_id'];
          });
        }
      });
    } else {
      if (mounted) {
        setState(() {
          isChatLoading = false;
        });
      }
    }

    socket.on("user-new-chat-listen$id", (data) {
      chatList.add(data);
      if (data.length > 0) {
        if (mounted) {
          setState(() {
            chatList = chatList;
            _scrollController.animateTo(
                _scrollController.position.maxScrollExtent,
                duration: Duration(milliseconds: 100),
                curve: Curves.easeOut);
          });
        }
      }
    });
  }

  @override
  void dispose() {
    if (_scrollController != null) _scrollController.dispose();
    super.dispose();
  }

  showAlert(message) {
    showDialog<Null>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return new AlertDialog(
          content: new SingleChildScrollView(
            child: new ListBody(
              children: <Widget>[
                new Text(
                  message,
                  style: textBarlowRegularBlack(),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text(
                MyLocalizations.of(context).getLocalizations("NO"),
                style: TextStyle(color: red),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text(
                MyLocalizations.of(context).getLocalizations("YES"),
                style: textbarlowRegularaPrimary(),
              ),
              onPressed: () {
                socket.emit("chat-closed", {"id": chatID});
                socket.on('chat-closed-user-listen$id', (data) {
                  if (mounted) {
                    setState(() {
                      Navigator.of(context).pop();
                    });
                  }
                });
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: null,
      child: new Scaffold(
        appBar: new AppBar(
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20))),
          title: new Text(
            MyLocalizations.of(context).getLocalizations("CHAT"),
            style: textbarlowSemiBoldBlack(),
          ),
          centerTitle: true,
          backgroundColor: primary,
          actions: [
            chatID == null
                ? Container()
                : InkWell(
                    onTap: () {
                      socket.emit("chat-closed", {"id": chatID});
                      socket.on('chat-closed-user-listen$id', (data) {
                        if (mounted) {
                          setState(() {
                            Navigator.of(context).pop();
                          });
                        }
                      });
                    },
                    child: Padding(
                        padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                        child: Icon(Icons.close)),
                  ),
          ],
        ),
        body: isChatLoading
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
                          itemCount:
                              chatList.length == null ? 0 : chatList.length,
                          itemBuilder: (BuildContext context, int index) {
                            bool isOwnMessage = false;
                            if (chatList[index]['sentBy'] == 'User') {
                              isOwnMessage = true;
                            }
                            return isOwnMessage
                                ? _ownMessage(
                                    chatList[index]['message'],
                                  )
                                : _message(
                                    chatList[index]['message'],
                                  );
                          },
                        ),
                      ),
                      new Divider(height: 1.0),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey,
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
                                      onSubmitted: chatID == null
                                          ? intialChat
                                          : _submitMsg,
                                      decoration: new InputDecoration.collapsed(
                                          hintText: MyLocalizations.of(context)
                                              .getLocalizations(
                                                  "ENTER_TEXT_HERE")),
                                    ),
                                  ),
                                  new Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey,
                                    ),
                                    child: new IconButton(
                                      icon: new Icon(
                                        Icons.send,
                                        color: primary,
                                        size: 30,
                                      ),
                                      onPressed: _isWriting
                                          ? () => chatID == null
                                              ? intialChat(_textController.text)
                                              : _submitMsg(_textController.text)
                                          : null,
                                    ),
                                  ),
                                ],
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
      ),
    );
  }

  Widget _ownMessage(String message) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(
                        top: 12.0, bottom: 14.0, left: 16.0, right: 16.0),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.6,
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(0),
                          bottomRight: Radius.circular(40),
                          bottomLeft: Radius.circular(40),
                        ),
                        color: primary.withOpacity(0.60)),
                    child: Text(
                      message,
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _message(String message) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(
                        top: 12.0, bottom: 14.0, left: 16.0, right: 16.0),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.6,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(0),
                        topRight: Radius.circular(40),
                        bottomRight: Radius.circular(40),
                        bottomLeft: Radius.circular(40),
                      ),
                      color: Color(0xFFF0F0F0),
                    ),
                    child: Text(
                      message,
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _submitMsg(String txt) async {
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 100), curve: Curves.easeOut);
    _textController.clear();
    if (mounted) {
      setState(() {
        _isWriting = false;
      });
    }
    var chatInfo = {
      "message": txt,
      "sentBy": 'User',
      "senderName": name,
      "receiverName": "Manager",
      "senderId": id,
      "receiverId": resInfo['_id']
    };

    socket.emit('regular-chat', chatInfo);
    socket.on('regular-user-chat-listen$id', (data) {
      if (chatInfo != null) {
        chatList.add(data);
        if (mounted) {
          setState(() {
            chatList = chatList;
            chatInfo = null;
          });
        }
      }
    });
  }

  void intialChat(String txt) async {
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 100), curve: Curves.easeOut);
    _textController.clear();
    if (mounted) {
      setState(() {
        _isWriting = false;
      });
    }
    var chatInfo = {
      "message": txt.toString(),
      "sentBy": 'User',
      "senderName": name,
      "receiverName": "Manager",
      "senderId": id,
      "receiverId": resInfo['_id']
    };
    socket.emit('initialize-chat', chatInfo);
    socket.on('chat-info-user-listen$id', (data) {
      if (mounted) {
        setState(() {
          chatList = data['messages'];
          chatID = data['_id'];
        });
      }
    });
  }
}
