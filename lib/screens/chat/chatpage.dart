import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocery_pro/service/auth-service.dart';
import 'package:grocery_pro/service/constants.dart';
import 'package:grocery_pro/service/sentry-service.dart';
import 'package:grocery_pro/style/style.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

SentryError sentryError = new SentryError();

class Chat extends StatefulWidget {
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
  String name, id, image;
  Timer chatTimer;
  var socket = io.io(Constants.socketURL, <String, dynamic>{
    'transports': ['websocket'],
    'extraHeaders': {'foo': 'bar'}
  });
  @override
  void initState() {
    getUserInfor();
    super.initState();
  }

  Future getUserInfor() async {
    // getUserInfo().then((value) {
    //   try {
    //
    //   } catch (error, stackTrace) {
    //     sentryError.reportError(error, stackTrace);
    //   }
    await LoginService.getUserInfo().then((onValue) {
      try {
        if (mounted) {
          setState(() {
            name = onValue['response_data']['userInfo']['firstName'] +
                        onValue['response_data']['userInfo']['lastName'] ==
                    null
                ? ""
                : onValue['response_data']['userInfo']['lastName'];
            id = onValue['response_data']['userInfo']['_id'];
            if (onValue['response_data']['userInfo']['profilePic'] == null) {
              image =
                  'https://res.cloudinary.com/ddboxana4/image/upload/v1564040195/User_tzzeri.png';
            } else {
              image = onValue['response_data']['userInfo']['profilePic'];
            }
            fetchRestaurantInfo();
            socketInt();
          });
        }
      } catch (error, stackTrace) {
        sentryError.reportError(error, stackTrace);
      }
    }).catchError((error) {
      sentryError.reportError(error, null);
    });
  }

  socketInt() {
    print("vv");
    socket.on('connect', (data) {
      print('connect ');
    });
    socket.emit('userChatList', [
      {"id": id}
    ]);
    socket.on('event', (data) {
      print(data);
    });
    socket.on('disconnect', (_) {
      print('disconnect');
    });
    socket.on('fromServer', (_) {
      print(_);
    });
    socket.on('userListen$id', (data) {
      print(data);
      if (mounted) {
        setState(() {
          isChatLoading = false;
          chatList = data['message'];
          print(chatList);
        });
      }
    });
    socket.on('userListenLastMessage$id', (data) {
      chatList.add(data);
      if (mounted) {
        setState(() {
          isChatLoading = false;
          chatList = chatList;
        });
      }
    });
  }

//fetchres info
  fetchRestaurantInfo() async {
    LoginService.restoInfo().then((response) {
      try {
        resInfo = response['response_data'];
        print(resInfo);
        if (resInfo == null) {
          Navigator.pop(context);
          throw new Exception("Error while fetching data");
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

  @override
  Widget build(BuildContext context) {
    Widget otherMessage(message) {
      return Row(
        children: <Widget>[
          Flexible(
            flex: 2,
            fit: FlexFit.tight,
            child: Container(
              margin: EdgeInsets.only(left: 15, right: 10),
              width: 55,
              height: 55,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(image: AssetImage(''), fit: BoxFit.fill),
              ),
            ),
          ),
          Flexible(
            flex: 20,
            fit: FlexFit.tight,
            child: Container(
              width: MediaQuery.of(context).size.width,
              constraints: BoxConstraints(maxWidth: 280, minHeight: 56),
              margin: EdgeInsets.only(
                left: 0,
                right: 20,
                top: 30,
              ),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Color(0xFFF0F0F0),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(0),
                      topRight: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                      bottomLeft: Radius.circular(40))),
              child: Text(
                'Hi, How can I help you ?',
                // style: hintTextPopregularwhitesm(),
              ),
            ),
          )
        ],
      );
    }

    Widget ownMessage(message) {
      return Row(
        children: <Widget>[
          Flexible(
            flex: 20,
            fit: FlexFit.tight,
            child: Container(
              alignment: Alignment.topRight,
              width: MediaQuery.of(context).size.width,
              constraints: BoxConstraints(maxWidth: 280, minHeight: 56),
              margin: EdgeInsets.only(
                left: 20,
                // right: 0,
                top: 30,
              ),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Color(0xFFFFECAC).withOpacity(0.60),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(0),
                  bottomRight: Radius.circular(40),
                  bottomLeft: Radius.circular(40),
                ),
              ),
              child: Text(
                'Hello',
                // style: hintTextPopregularwhitesm(),
              ),
            ),
          ),
          Flexible(
            flex: 2,
            fit: FlexFit.tight,
            child: Container(
              margin: EdgeInsets.only(left: 15, right: 10),
              width: 55,
              height: 55,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                // image: DecorationImage(
                //     image: AssetImage(
                //         'lib/assets/images/profile.png'),
                //     fit: BoxFit.fill)
              ),
            ),
          ),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: primary,
        elevation: 0,
        title: Text('Chat', style: textbarlowSemiBoldBlack()),
        iconTheme: new IconThemeData(color: Colors.black),
      ),
      body: isChatLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
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
                          if (chatList[index]['sentBy'] == 'user') {
                            isOwnMessage = true;
                          }
                          return isOwnMessage
                              ? ownMessage(
                                  chatList[index]['message'],
                                )
                              : otherMessage(
                                  chatList[index]['message'],
                                );
                        },
                      ),
                    ),
                    new Divider(height: 1.0),
                    new IconTheme(
                      data: new IconThemeData(
                          color: Theme.of(context).accentColor),
                      child: new Container(
                          child: Padding(
                            padding: EdgeInsets.only(left: 10.0),
                            child: Row(
                              children: <Widget>[
                                new Flexible(
                                  child: new TextField(
                                    maxLines: 2,
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
                                        hintText: "Enter text here" + "..."),
                                  ),
                                ),
                                new Container(
                                    margin: new EdgeInsets.symmetric(
                                        horizontal: 3.0),
                                    child: Theme.of(context).platform ==
                                            TargetPlatform.iOS
                                        ? new CupertinoButton(
                                            child: new Text("submit"),
                                            onPressed: _isWriting
                                                ? () => _submitMsg(
                                                    _textController.text)
                                                : null)
                                        : new IconButton(
                                            icon: new Icon(Icons.send),
                                            onPressed: _isWriting
                                                ? () => _submitMsg(
                                                    _textController.text)
                                                : null,
                                          )),
                              ],
                            ),
                          ),
                          decoration:
                              Theme.of(context).platform == TargetPlatform.iOS
                                  ? new BoxDecoration(
                                      border: new Border(
                                          top: new BorderSide(
                                              color: Colors.white70)),
                                      color: Colors.white,
                                    )
                                  : BoxDecoration(
                                      color: Colors.white,
                                    )),
                    )
                  ],
                )
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
    print(resInfo['_id']);
    var chatInfo = {
      "message": txt,
      "sentBy": 'user',
      "user": id,
      "receiver": resInfo['_id'],
    };
    print(chatInfo);
    socket.emit('chat', [chatInfo]);
    socket.on('userListen$id', (data) {
      if (mounted) {
        setState(() {
          chatList = data['message'];
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
                foregroundColor: Colors.lightBlue,
              ),
            ),
            new Expanded(
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text('${name[0]}'),
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
