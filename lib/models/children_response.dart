import 'package:flutter_client/models/child.dart';

class ChildrenResponse {
  final List<Child> children;
  final int count;

  ChildrenResponse({required this.children, required this.count});

  factory ChildrenResponse.fromJson(Map<String, dynamic> json) {

    var list = json['children'] as List;
    List<Child> childList = list.map((i) => Child.fromJson(i)).toList();

    return ChildrenResponse(
      children: childList,
      count: json['count'],
    );
  }
}
