class Author {
  final String email;
  final String username;

  Author({
    required this.email,
    required this.username,
  });

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
      email: json['email'],
      username: json['username'],
    );
  }
}