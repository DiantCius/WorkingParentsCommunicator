class Chat {
  final int? chatId;
  final String? name;
  final String? username;

  Chat(
      {this.chatId,
       this.name,
       this.username,});

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      chatId: json['chatId'],
      name: json['name'],
      username: json['username'],
    );
  }
}