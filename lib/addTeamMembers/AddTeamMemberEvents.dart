import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class AddTeamMemberEvents extends Equatable {}

class AddNewTeamMembers extends AddTeamMemberEvents {
  String teamName;
  String eventId;
  String levelId;

  AddNewTeamMembers(this.teamName, this.eventId, this.levelId);

  @override
  String toString() {
    return "Add New Team Member";
  }
}

class AddNewTeam extends AddTeamMemberEvents {
  String teamName;
  String eventId;
  String leader;
  List<String> qrCodes;

  AddNewTeam({@required this.teamName, @required this.eventId, @required this.leader, @required this.qrCodes});

  @override
  String toString() {
    return "Add New Team Member";
  }
}