import 'dart:developer';
import 'package:signalr_core/signalr_core.dart';

class SignalR {
  final url = 'http://10.0.2.2:5000/chatHub';
  late HubConnection hubConnection;
  String textMessage = '';

  void connect(receiveMessageHandler, String name) {
    hubConnection = HubConnectionBuilder().withUrl(url).build();
    hubConnection.onclose((error) {
      log('Connection Close');
    });
    hubConnection.on('ReceiveMessage', receiveMessageHandler);
    if (hubConnection.state != HubConnectionState.connected) {
      hubConnection.start()?.then((value) => {
            hubConnection.invoke('JoinRoom', args: [name])
          });
      print(hubConnection.state.toString());
    }
  }

  void sendMessage(String name, String message) {
    hubConnection.invoke('SendMessage', args: [name, message]);
    // messageList.add(Message(
    //     name: name,
    //     message: message,
    //     isMine: true));
    textMessage = '';
    print(hubConnection.state);
  }

  void sendGroupMessage(String group, String name, String message) {
    hubConnection.invoke('SendMessageToGroup', args: [group, name, message]);
    textMessage = '';
  }

  void joinRoom(String name) async {
    //if (hubConnection.state == HubConnectionState.connected) {
    await hubConnection.invoke('JoinRoom', args: [name]);
    print('dupa z grupy');
    //}
  }

  void disconnect() {
    hubConnection.stop();
  }
}
