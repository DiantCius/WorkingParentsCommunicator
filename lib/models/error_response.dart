class ErrorResponse {
  final String message;

  ErrorResponse({
    required this.message,
  });

  factory ErrorResponse.fromJson(Map<String, dynamic> json) {
    return ErrorResponse(
      message: json['error'],
    );
  }
}