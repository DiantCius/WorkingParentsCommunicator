import 'package:flutter_client/models/chat_user.dart';

class ChatUsersResponse {
  final List<ChatUser> chatUsers;
  final int count;

  ChatUsersResponse({
    required this.chatUsers,
    required this.count,
  });

  factory ChatUsersResponse.fromJson(Map<String, dynamic> json) {

    var list = json['users'] as List;
    List<ChatUser> chatUserList = list.map((i) => ChatUser.fromJson(i)).toList();

    return ChatUsersResponse(
      chatUsers: chatUserList,
      count: json['count'],
    );
  }
}