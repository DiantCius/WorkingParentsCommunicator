import 'package:flutter_client/models/user.dart';

class UsersResponse {
  final List<User> users;
  final int count;

  UsersResponse({
    required this.users,
    required this.count,
  });

  factory UsersResponse.fromJson(Map<String, dynamic> json) {

    var list = json['users'] as List;
    print(list.runtimeType);
    List<User> userList = list.map((i) => User.fromJson(i)).toList();

    return UsersResponse(
      users: userList,
      count: json['count'],
    );
  }
}