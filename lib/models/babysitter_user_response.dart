import 'package:flutter_client/models/babysitter.dart';

class BabysitterUserResponse {
  final List<Babysitter> babysitters;
  final int count;

  BabysitterUserResponse({
    required this.babysitters,
    required this.count,
  });

  factory BabysitterUserResponse.fromJson(Map<String, dynamic> json) {

    var list = json['babysitters'] as List;
    print(list.runtimeType);
    List<Babysitter> babysitterList = list.map((i) => Babysitter.fromJson(i)).toList();

    return BabysitterUserResponse(
      babysitters: babysitterList,
      count: json['count'],
    );
  }
}