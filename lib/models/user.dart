class User {
  final String? username;
  final String? email;
  final String? invitedBy;

  User({
    this.username,
    this.email,
    this.invitedBy
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'],
      email: json['email'],
      invitedBy: json['invitedBy']
    );
  }
}
