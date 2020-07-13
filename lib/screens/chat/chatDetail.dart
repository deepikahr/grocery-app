import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:readymadeGroceryApp/service/constants.dart';
import 'package:readymadeGroceryApp/service/localizations.dart';
import 'package:readymadeGroceryApp/service/sentry-service.dart';
import 'package:readymadeGroceryApp/style/style.dart';
import 'package:readymadeGroceryApp/widgets/loader.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

SentryError sentryError = new SentryError();

class ChatDetails extends StatefulWidget {
  final Map localizedValues, chatDetails, userDetail;
  final String locale;
  ChatDetails(
      {Key key,
      this.locale,
      this.localizedValues,
      this.chatDetails,
      this.userDetail});

  @override
  _ChatDetailsState createState() => _ChatDetailsState();
}

class _ChatDetailsState extends State<ChatDetails>
    with TickerProviderStateMixin {
  List chatList = List();
  final ScrollController _scrollController = new ScrollController();
  bool isChatLoading = false;

  var chatInfo;
  String chatID, id;
  Timer chatTimer;
  var socket = io.io(Constants.socketUrl, <String, dynamic>{
    'transports': ['websocket']
  });
  @override
  void initState() {
    chatID = widget.chatDetails['_id'];
    id = widget.userDetail['_id'];

    socketInt();
    super.initState();
  }

  socketInt() {
    if (mounted) {
      setState(() {
        isChatLoading = true;
      });
    }
    socket.on('connect', (data) {
      print('connect ');
    });

    socket.on('disconnect', (_) {
      print('disconnect');
    });

    socket.emit('user-chat-closed-info', {"id": chatID});

    socket.on('user-chat-closed-info-listen$id', (data) {
      if (mounted) {
        setState(() {
          chatList = data['messages'];
          chatID = data['_id'];
          isChatLoading = false;
        });
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
                socket.emit("chat-closed");
                socket.on('chat-closed-user-listen$chatID', (data) {
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
            MyLocalizations.of(context).getLocalizations("CHAT_DETAIL"),
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
}
