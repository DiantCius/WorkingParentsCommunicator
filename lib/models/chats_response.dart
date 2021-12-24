import 'package:flutter_client/models/chat.dart';

class ChatsResponse {
  final List<Chat> chats;
  final int count;

  ChatsResponse({
    required this.chats,
    required this.count,
  });

  factory ChatsResponse.fromJson(Map<String, dynamic> json) {

    var list = json['chats'] as List;
    List<Chat> chatList = list.map((i) => Chat.fromJson(i)).toList();

    return ChatsResponse(
      chats: chatList,
      count: json['count'],
    );
  }
}