import 'package:readymadeGroceryApp/service/constants.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class SocketService {
  late io.Socket socket;

  SocketService() {
    socket = io.io(Constants.apiUrl, <String, dynamic>{
      'transports': ['websocket'],
    });
  }

  io.Socket getSocket() {
    return socket;
  }

  void socketInitialize() {
    try {
      socket.on('connect', (_) {
        socketClear();
        print('Grocery Socket Connected to ${Constants.apiUrl}');
      });
    } catch (e) {
      socketConnectError();
    }
  }

  void socketDisconnect() {
    socket.on('disconnect', (_) {
      socketClear();
      print('Grocery Socket Disconnected');
    });
  }

  void socketConnectError() {
    socket.on('connect_error', (data) => print('socket-connection-erro $data'));
  }

  void socketClear() {
    socket.clearListeners();
  }

  void socketSendMsg(chatInfo) {
    socket.emit('message-user-to-store', chatInfo);
  }

  void socketListenMsg(String userId, Function listener) {
    socket.on('message-user-$userId', (data) {
      if (data != null) {
        listener(data);
      }
    });
  }
}
