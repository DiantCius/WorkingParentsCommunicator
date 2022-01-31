class Babysitter {
  final String? username;
  final String? email;

  Babysitter({
    this.username,
    this.email,
  });

  factory Babysitter.fromJson(Map<String, dynamic> json) {
    return Babysitter(
      username: json['username'],
      email: json['email'],
    );
  }
}
