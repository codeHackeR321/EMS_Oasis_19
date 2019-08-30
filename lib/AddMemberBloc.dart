import 'package:bloc/bloc.dart';
import 'package:ems_oasis_19/AddMemberStates.dart';
import 'package:ems_oasis_19/AddTeamMemberEvents.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddMemberBloc extends Bloc<AddTeamMemberEvents, AddMemberStates> {
  final http.Client httpClient;

  AddMemberBloc({@required this.httpClient});

  @override
  AddMemberStates get initialState =>
      NoMemberScanned(memberCode: "", teamName: "q");

  @override
  Stream<AddMemberStates> mapEventToState(AddTeamMemberEvents event) async* {
    if (event is AddNewTeamMember) {
      try {
        if (currentState is NoMemberScanned) {
          String code = (currentState as NoMemberScanned).memberCode;
          String team = (currentState as NoMemberScanned).teamName;
          yield AddingNewMember();
          await _addNewMember(code, team);
          yield NoMemberScanned(memberCode: "", teamName: "");
        }
      } catch (error) {
        print(error.toString());
        yield ErrorAddingMember(errorMessage: error.toString());
      }
    }
  }

  Future<Null> _addNewMember(String code, String team) async {
    print("Entered Api call with $code and $team");
    throw Exception("Cannot Load Posts");
  }
}
