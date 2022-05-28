import 'package:flutter_client/models/activity.dart';

class ActivityResponse {
  final List<Activity> activities;
  final int count;

  ActivityResponse({
    required this.activities,
    required this.count,
  });

  factory ActivityResponse.fromJson(Map<String, dynamic> json) {

    var list = json['activities'] as List;
    List<Activity> activityList = list.map((i) => Activity.fromJson(i)).toList();

    return ActivityResponse(
      activities: activityList,
      count: json['count'],
    );
  }
}
