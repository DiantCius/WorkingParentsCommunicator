class Invitation {
  final int? invitationId;
  final int? addressedUserId;
  final int? childId;
  final String? inviteDate;

  Invitation(
      {this.invitationId, this.addressedUserId, this.childId, this.inviteDate});

  factory Invitation.fromJson(Map<String, dynamic> json) {
    return Invitation(
      invitationId: json['invitationId'],
      addressedUserId: json['addressedUserId'],
      childId: json['childId'],
      inviteDate: json['inviteDate'],
    );
  }
}
