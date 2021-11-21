import 'package:flutter_client/models/child.dart';
import 'package:flutter_client/models/user.dart';

class InviteModel {
  User? addressedUser;
  Child? child;

  InviteModel({this.addressedUser, this.child});
}
