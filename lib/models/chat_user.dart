class ChatUser {
  final String? username;
  final String? email;

  ChatUser({
    this.username,
    this.email,
  });

  factory ChatUser.fromJson(Map<String, dynamic> json) {
    return ChatUser(
      username: json['username'],
      email: json['email'],
    );
  }
}