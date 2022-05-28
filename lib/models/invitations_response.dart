import 'package:flutter_client/models/invitation.dart';

class InvitationsResponse {
  final List<Invitation> invitations;
  final int count;

  InvitationsResponse({
    required this.invitations,
    required this.count,
  });

  factory InvitationsResponse.fromJson(Map<String, dynamic> json) {

    var list = json['invitations'] as List;
    List<Invitation> babysitterList = list.map((i) => Invitation.fromJson(i)).toList();

    return InvitationsResponse(
      invitations: babysitterList,
      count: json['count'],
    );
  }
}