import 'package:flutter_client/models/babysitter.dart';

class UsersResponse {
  final List<Babysitter> users;
  final int count;

  UsersResponse({
    required this.users,
    required this.count,
  });

  factory UsersResponse.fromJson(Map<String, dynamic> json) {

    var list = json['users'] as List;
    print(list.runtimeType);
    List<Babysitter> userList = list.map((i) => Babysitter.fromJson(i)).toList();

    return UsersResponse(
      users: userList,
      count: json['count'],
    );
  }
}