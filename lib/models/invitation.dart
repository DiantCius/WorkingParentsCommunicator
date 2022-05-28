class Invitation {
  final int? invitationId;
  final String? childName;
  final String? inviteDate;

  Invitation({this.invitationId,this.childName, this.inviteDate});

  factory Invitation.fromJson(Map<String, dynamic> json) {
    return Invitation(
      invitationId: json['invitationId'],
      childName: json['childName'],
      inviteDate: json['inviteDate'],
    );
  }
}
