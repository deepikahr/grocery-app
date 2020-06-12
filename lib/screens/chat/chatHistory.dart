import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:readymadeGroceryApp/screens/chat/chatDetail.dart';
import 'package:readymadeGroceryApp/service/auth-service.dart';
import 'package:readymadeGroceryApp/service/constants.dart';
import 'package:readymadeGroceryApp/service/sentry-service.dart';
import 'package:readymadeGroceryApp/style/style.dart';
import 'package:readymadeGroceryApp/widgets/loader.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

SentryError sentryError = new SentryError();

class ChatHistoryListPage extends StatefulWidget {
  final Map localizedValues;
  final String locale;
  ChatHistoryListPage({Key key, this.locale, this.localizedValues});

  @override
  _ChatHistoryListPageState createState() => _ChatHistoryListPageState();
}

class _ChatHistoryListPageState extends State<ChatHistoryListPage>
    with TickerProviderStateMixin {
  List chatCloseList = List();
  bool isChatCloseListLoading = false;
  String id;
  Map userData;
  var socket = io.io(Constants.socketUrl, <String, dynamic>{
    'transports': ['websocket']
  });
  @override
  void initState() {
    getUserData();
    super.initState();
  }

  getUserData() async {
    if (mounted) {
      setState(() {
        isChatCloseListLoading = true;
      });
    }
    await LoginService.getUserInfo().then((onValue) {
      try {
        if (onValue['response_code'] == 200) {
          if (mounted) {
            setState(() {
              id = onValue['response_data']['userInfo']['_id'];
              userData = onValue['response_data']['userInfo'];

              socketInt();
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
      print("connected.....");
    });
    socket.emit('user-chat-history', {"id": id});

    socket.on('disconnect', (_) {
      print('disconnect');
    });

    socket.on('chat-list-user-history$id', (data) {
      if (data.length > 0) {
        if (mounted) {
          setState(() {
            if (mounted) {
              setState(() {
                chatCloseList = data;
                isChatCloseListLoading = false;
              });
            }
          });
        }
      } else {
        if (mounted) {
          setState(() {
            if (mounted) {
              setState(() {
                chatCloseList = [];
                isChatCloseListLoading = false;
              });
            }
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: isChatCloseListLoading
          ? SquareLoader()
          : chatCloseList.length == 0
              ? Center(
                  child: Image.asset('lib/assets/images/no-orders.png'),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    new Expanded(
                      child: new ListView.builder(
                        itemCount: chatCloseList.length,
                        padding: new EdgeInsets.only(left: 10.0, right: 10.0),
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  var result = Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          ChatDetails(
                                        locale: widget.locale,
                                        localizedValues: widget.localizedValues,
                                        chatDetails: chatCloseList[index],
                                        userDetail: userData,
                                      ),
                                    ),
                                  );
                                  result.then((value) {
                                    getUserData();
                                  });
                                },
                                child: new Container(
                                  color: Colors.transparent,
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: new Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      new Container(
                                        margin:
                                            const EdgeInsets.only(right: 18.0),
                                        child: new CircleAvatar(
                                          child: new Text(
                                              '${chatCloseList[index]['receiverId']['firstName'][0]}'),
                                          backgroundColor: primary,
                                        ),
                                      ),
                                      new Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            new Container(
                                              margin: const EdgeInsets.only(
                                                  top: 6.0),
                                              child: new Text(
                                                chatCloseList[index]
                                                    ['receiverId']['firstName'],
                                              ),
                                            ),
                                            new Container(
                                              margin: const EdgeInsets.only(
                                                  top: 6.0),
                                              child: new Text(
                                                DateFormat(
                                                        'dd/MM/yyyy, hh:mm a')
                                                    .format(
                                                  DateTime
                                                      .fromMillisecondsSinceEpoch(
                                                          chatCloseList[index][
                                                              'lastMessageTime']),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Divider()
                            ],
                          );
                        },
                      ),
                    )
                  ],
                ),
    );
  }
}
