import 'package:flutter_client/models/message.dart';

class MessagesResponse {
  final List<Message> messages;
  final int count;

  MessagesResponse({
    required this.messages,
    required this.count,
  });

  factory MessagesResponse.fromJson(Map<String, dynamic> json) {

    var list = json['messages'] as List;
    List<Message> messageList = list.map((i) => Message.fromJson(i)).toList();

    return MessagesResponse(
      messages: messageList,
      count: json['count'],
    );
  }
}