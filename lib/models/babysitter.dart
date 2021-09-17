class Babysitter {
  final String username;
  final String email;

  Babysitter({
    required this.username,
    required this.email,
  });

  factory Babysitter.fromJson(Map<String, dynamic> json) {
    return Babysitter(
      username: json['username'],
      email: json['email'],
    );
  }
}