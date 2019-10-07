import 'package:equatable/equatable.dart';

abstract class AddTeamMemberEvents extends Equatable {}

class AddNewTeamMembers extends AddTeamMemberEvents {
  String teamName;

  AddNewTeamMembers(this.teamName);

  @override
  String toString() {
    return "Add New Team Member";
  }
}