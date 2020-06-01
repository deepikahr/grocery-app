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
  final Map localizedValues;
  final String locale;
  Chat({Key key, this.locale, this.localizedValues});

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> with TickerProviderStateMixin {
  List chatList = List();
  final ScrollController _scrollController = new ScrollController();
  final TextEditingController _textController = new TextEditingController();
  bool _isWriting = false, isChatLoading = false;
  var resInfo;
  var chatInfo;
  String name, id, image, chatID;
  Timer chatTimer;
  var socket = io.io(Constants.baseURL, <String, dynamic>{
    'transports': ['websocket']
  });
  @override
  void initState() {
    getUserInfor();
    super.initState();
  }

  Future getUserInfor() async {
    await LoginService.getUserInfo().then((onValue) {
      try {
        if (onValue['response_code'] == 200) {
          if (mounted) {
            setState(() {
              name = onValue['response_data']['userInfo']['firstName'];
              id = onValue['response_data']['userInfo']['_id'];
              if (onValue['response_data']['userInfo']['profilePic'] == null) {
                image =
                    'https://res.cloudinary.com/ddboxana4/image/upload/v1564040195/User_tzzeri.png';
              } else {
                image = onValue['response_data']['userInfo']['profilePic'];
              }
              fetchRestaurantInfo();
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

  socketInt() {
    socket.on('connect', (data) {
      print('connect ');
    });
    socket.emit('user-chat-list', {"id": id});

    socket.on('disconnect', (_) {
      print('disconnect');
    });

    socket.on('chat-list$id', (data) {
      if (data.length > 0) {
        if (mounted) {
          setState(() {
            isChatLoading = false;
            if (data['response_data'] != null) {
              if (mounted) {
                setState(() {
                  chatList = data['response_data']['messages'];
                  chatID = data['response_data']['_id'];
                });
              }
            } else {
              if (mounted) {
                setState(() {
                  chatID = null;
                });
              }
            }
          });
        }
      }
    });
    if (chatID == null) {
      var chatInfo = {
        "message": "hi",
        "sentBy": 'User',
        "user": id,
        "store": resInfo['_id'],
        "createdAt": DateTime.now().millisecondsSinceEpoch,
        "chatId": ""
      };
      socket.emit('initialize-chat', chatInfo);
      socket.on('chat-list$id', (data) {
        if (mounted) {
          setState(() {
            isChatLoading = false;
            chatList = data['response_data']['messages'];

            if (data['response_data']['_id'] == null) {
              chatID = "";
            } else {
              if (mounted) {
                setState(() {
                  chatID = data['response_data']['_id'];
                });
              }
            }
          });
        }
      });
    }
    socket.on("listen-new-messages$id", (data) {
      chatList.add(data);
      if (data.length > 0) {
        if (mounted) {
          setState(() {
            isChatLoading = false;
            chatList = chatList;
          });
        }
      }
    });
  }

//fetchres info
  fetchRestaurantInfo() async {
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
                MyLocalizations.of(context).no,
                style: TextStyle(color: red),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text(
                MyLocalizations.of(context).yes,
                style: textbarlowRegularaPrimary(),
              ),
              onPressed: () {
                socket.emit(
                    "close-chat", {"chatId": chatID, "store": resInfo['_id']});

                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<bool> _onWillPop() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            content: new Text(MyLocalizations.of(context).areyousureclosechat),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(),
                child: new Text(
                  MyLocalizations.of(context).no,
                ),
              ),
              new FlatButton(
                onPressed: () {
                  socket.emit("close-chat",
                      {"chatId": chatID, "store": resInfo['_id']});
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: new Text(
                  MyLocalizations.of(context).yes,
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext ctx) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: new Scaffold(
        appBar: new AppBar(
          leading: InkWell(
            onTap: () {
              showAlert(MyLocalizations.of(context).areyousureclosechat);
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
            MyLocalizations.of(context).chat,
            style: textbarlowSemiBoldBlack(),
          ),
          centerTitle: true,
          backgroundColor: primary,
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
                                      onSubmitted: _submitMsg,
                                      decoration: new InputDecoration.collapsed(
                                          hintText: MyLocalizations.of(context)
                                              .enterTextHere),
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
                                          ? () =>
                                              _submitMsg(_textController.text)
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
                        color: Color(0xFFFFECAC).withOpacity(0.60)),
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
        duration: Duration(milliseconds: 1000), curve: Curves.easeOut);
    _textController.clear();
    if (mounted) {
      setState(() {
        _isWriting = false;
      });
    }
    Msg msg = new Msg(
      name: name,
      txt: txt,
      animationController: new AnimationController(
          vsync: this, duration: new Duration(milliseconds: 800)),
    );
    var chatInfo = {
      "message": txt,
      "sentBy": 'User',
      "user": id,
      "store": resInfo['_id'],
      "createdAt": DateTime.now().millisecondsSinceEpoch,
      "chatId": chatID
    };

    socket.emit('send-message', chatInfo);
    socket.on('chat-list$id', (data) {
      chatList.add(chatInfo);
      if (mounted) {
        setState(() {
          isChatLoading = false;
          chatList = chatList;
        });
      }
    });

    msg.animationController.forward();
  }
}

class Msg extends StatelessWidget {
  Msg({this.txt, this.animationController, this.name});
  final String txt, name;
  final AnimationController animationController;
  @override
  Widget build(BuildContext ctx) {
    return new SizeTransition(
      sizeFactor: new CurvedAnimation(
          parent: animationController, curve: Curves.easeOut),
      axisAlignment: 0.0,
      child: new Container(
        color: Colors.transparent,
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Container(
              margin: const EdgeInsets.only(right: 18.0),
              child: new CircleAvatar(
                child: new Text('${name[0]}'),
                backgroundColor: primary,
              ),
            ),
            new Expanded(
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(
                    '${name[0]}',
                  ),
                  new Container(
                    margin: const EdgeInsets.only(top: 6.0),
                    child: new Text(
                      txt,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
