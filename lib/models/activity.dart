import 'package:flutter_client/models/author.dart';

class Activity {
  final int? activityId;
  final String? action;
  final String? notes;
  final String? postTime;
  final Author? author;

  Activity({this.activityId, this.action, this.notes, this.postTime, this.author});

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      activityId: json['activityId'],
      action: json['action'],
      notes: json['notes'],
      postTime: json['postTime'],
      author: Author.fromJson(json['author']),
    );
  }
}
