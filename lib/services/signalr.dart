import 'dart:developer';
import 'package:flutter_client/main.dart';
import 'package:signalr_core/signalr_core.dart';

class SignalRService {
  final url = '$serverUrl/chatHub';
  late HubConnection hubConnection;

  void connect(messageHandler, String name) {
    hubConnection = HubConnectionBuilder().withUrl(url).build();
    hubConnection.onclose((error) {
      log('Connection Close');
    });

    hubConnection.on('Message', messageHandler);
    hubConnection.start()?.then((value) => {
          hubConnection.invoke('JoinRoom', args: [name])
        });
  }

  void disconnect() {
    hubConnection.stop();
  }

  void sendGroupMessage(String group, String name, String message) {
    hubConnection.invoke('SendMessageToGroup', args: [group, name, message]);
  }
}
