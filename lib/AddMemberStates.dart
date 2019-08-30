import 'package:equatable/equatable.dart';

abstract class AddMemberStates extends Equatable {}

class NoMemberScanned extends AddMemberStates {
String memberCode;
  String teamName;

  NoMemberScanned({
    this.memberCode,
    this.teamName,
  }); 

  void addMemberInfo(String code, String name) {
    this.memberCode = code;
    this.teamName = name;
  }

  @override
  String toString() {
    return "Adding Member $memberCode to Team $teamName";
  }
}

class AddingNewMember extends AddMemberStates {
  @override
  String toString() {
    return "No Member Scanned";
  }
}

class ErrorAddingMember extends AddMemberStates {
  String errorMessage;

  ErrorAddingMember({this.errorMessage});

  @override
  String toString() {
    return "Error adding New Member";
  }
}