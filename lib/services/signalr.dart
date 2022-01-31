import 'dart:developer';
import 'package:signalr_core/signalr_core.dart';

class SignalRService {
  final url = 'http://10.0.2.2:5000/chatHub';
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

    /*if (hubConnection.state != HubConnectionState.connected) {
      hubConnection.start()?.then((value) => {
        hubConnection.invoke('JoinRoom', args: [name])
      });
    }*/
  }

  void disconnect() {
    hubConnection.stop();
  }

  void sendGroupMessage(String group, String name, String message) {
    hubConnection.invoke('SendMessageToGroup', args: [group, name, message]);
  }

  /*void sendMessage(String name, String message) {
    hubConnection.invoke('SendMessage', args: [name, message]);
    //textMessage = '';
    print(hubConnection.state);
  }*/

  /*void joinRoom(String name) async {
    //if (hubConnection.state == HubConnectionState.connected) {
    await hubConnection.invoke('JoinRoom', args: [name]);
    //}
  }*/

}
