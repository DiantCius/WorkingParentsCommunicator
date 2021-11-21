import 'package:flutter_client/models/child.dart';

class ChildResponse {
  final Child child;

  ChildResponse({required this.child});

  factory ChildResponse.fromJson(Map<String, dynamic> json) {
    return ChildResponse(
      child: Child.fromJson(json['child']),
    );
  }
}