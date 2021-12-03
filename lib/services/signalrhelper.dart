import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_client/models/message.dart';
import 'package:signalr_core/signalr_core.dart';

class SignalRHelper {
  final url = 'http://10.0.2.2:5000/chatHub';
  late HubConnection hubConnection;
  var messageList = <Message>[];
  String textMessage = '';

  void connect(receiveMessageHandler) {
    hubConnection = HubConnectionBuilder().withUrl(url).build();
    hubConnection.onclose((error) {
      log('Connection Close');
    });
    hubConnection.on('ReceiveMessage', receiveMessageHandler);
    if (hubConnection.state != HubConnectionState.connected) {
      hubConnection.start()?.catchError((value) => print(value));
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
  }

  void disconnect() {
    hubConnection.stop();
  }
}
