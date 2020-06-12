import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';
import 'package:readymadeGroceryApp/screens/chat/chatpage.dart';
import 'package:readymadeGroceryApp/service/auth-service.dart';
import 'package:readymadeGroceryApp/service/constants.dart';
import 'package:readymadeGroceryApp/service/localizations.dart';
import 'package:readymadeGroceryApp/service/sentry-service.dart';
import 'package:readymadeGroceryApp/style/style.dart';
import 'package:readymadeGroceryApp/widgets/loader.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

SentryError sentryError = new SentryError();

class ChatListPage extends StatefulWidget {
  final Map localizedValues;
  final String locale;
  ChatListPage({Key key, this.locale, this.localizedValues});

  @override
  _ChatListPageState createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage>
    with TickerProviderStateMixin {
  Map chatData;
  bool isListLoading = false;
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
        isListLoading = true;
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
    socket.emit('user-chat-list', {"id": id});

    socket.on('disconnect', (_) {
      print('disconnect');
    });

    socket.on('chat-list-user$id', (data) {
      if (mounted) {
        setState(() {
          if (mounted) {
            setState(() {
              chatData = data;
              isListLoading = false;
            });
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: isListLoading
          ? SquareLoader()
          : chatData == null
              ? Center(
                  child: Image.asset('lib/assets/images/no-orders.png'),
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      GFButton(
                        onPressed: () async {
                          var result = Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) => Chat(
                                locale: widget.locale,
                                localizedValues: widget.localizedValues,
                                chatDetails: chatData,
                                userDetail: userData,
                              ),
                            ),
                          );
                          result.then((value) {
                            getUserData();
                          });
                        },
                        child: Padding(
                          padding:
                              const EdgeInsets.only(left: 18.0, right: 18.0),
                          child: Text(
                            chatData['message'],
                            style: textbarlowRegularaPrimar(),
                          ),
                        ),
                        type: GFButtonType.outline,
                        color: primary,
                        size: GFSize.LARGE,
                      ),
                      SizedBox(height: 20),
                      chatData['chatId'] == null
                          ? Container()
                          : GFButton(
                              onPressed: () async {
                                socket.emit(
                                    "chat-closed", {"id": chatData['chatId']});
                                socket.on('chat-closed-user-listen$id', (data) {
                                  if (mounted) {
                                    setState(() {
                                      getUserData();
                                    });
                                  }
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 18.0, right: 18.0),
                                child: Text(
                                  "Close-Chat",
                                  style: textbarlowRegularaPrimar(),
                                ),
                              ),
                              type: GFButtonType.outline,
                              color: primary,
                              size: GFSize.LARGE,
                            ),
                    ],
                  ),
                ),
    );
  }
}
