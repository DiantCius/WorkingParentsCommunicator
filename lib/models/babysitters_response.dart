import 'package:flutter_client/models/babysitter.dart';

class BabysittersResponse {
  final List<Babysitter> babysitters;
  final int count;

  BabysittersResponse({
    required this.babysitters,
    required this.count,
  });

  factory BabysittersResponse.fromJson(Map<String, dynamic> json) {
    var list = json['babysitters'] as List;
    List<Babysitter> babysitterList =
        list.map((i) => Babysitter.fromJson(i)).toList();

    return BabysittersResponse(
      babysitters: babysitterList,
      count: json['count'],
    );
  }
}
