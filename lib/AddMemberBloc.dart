import 'package:bloc/bloc.dart';
import 'package:ems_oasis_19/AddMemberStates.dart';
import 'package:ems_oasis_19/AddTeamMemberEvents.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddMemberBloc extends Bloc<AddTeamMemberEvents, AddMemberStates> {
  final http.Client httpClient;

  AddMemberBloc({@required this.httpClient});

  // TODO: Have some way to get the name of the team
  @override
  AddMemberStates get initialState =>
      NoMemberScanned();

  @override
  Stream<AddMemberStates> mapEventToState(AddTeamMemberEvents event) async* {
    if (event is AddNewTeamMembers) {
      try {
        if (currentState is NoMemberScanned) {
          List<String> listOfMembers = (currentState as NoMemberScanned).scannedMembers.toList();
          String team = event.teamName;
          yield AddingNewMember();
          await _addNewMember(listOfMembers, team);
          yield NoMemberScanned();
          /* String code = (currentState as NoMemberScanned).memberCode;
          String team = (currentState as NoMemberScanned).teamName;
          yield AddingNewMember();
          await _addNewMember(code, team);
          yield NoMemberScanned(memberCode: "", teamName: ""); */
        }
      } catch (error) {
        print(error.toString());
        yield ErrorAddingMember(errorMessage: error.toString());
      }
    }
  }

  Future<Null> _addNewMember(List<String> codes, String team) async {
    print("Entered Api call with ${codes.toString()} and $team");
    // throw Exception("Cannot Load Posts");
  }
}
