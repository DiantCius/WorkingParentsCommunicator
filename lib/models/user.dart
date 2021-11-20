class User {
  final String? username;
  final String? email;
  final bool? isInvited;

  User({
    this.username,
    this.email,
    this.isInvited
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'],
      email: json['email'],
      isInvited: json['isInvited']
    );
  }
}
