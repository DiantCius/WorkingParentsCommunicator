class Message {
  String? name;
  String? message;
  bool isMine = false;

  Message({this.name, this.message, this.isMine = false});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      name: json['username'],
      message: json['text'],
    );
  }
}