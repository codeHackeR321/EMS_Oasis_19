import 'package:equatable/equatable.dart';

abstract class AddTeamMemberEvents extends Equatable {}

class AddNewTeamMember extends AddTeamMemberEvents {
  @override
  String toString() {
    return "Add New Team Member";
  }
}