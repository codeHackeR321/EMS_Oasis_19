import 'package:equatable/equatable.dart';

abstract class AddMemberStates extends Equatable {}

class NoMemberScanned extends AddMemberStates {
  Set<String> scannedMembers;
  
  NoMemberScanned() {
    scannedMembers = Set();
  } 

  void addMemberInfo(String code) {
    this.scannedMembers.add(code);
  }

  @override
  String toString() {
    return "Adding Members to Team \n Members = $scannedMembers";
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