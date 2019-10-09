import 'package:bloc/bloc.dart';
import 'package:ems_oasis_19/addTeamMembers/AddMemberStates.dart';
import 'package:ems_oasis_19/addTeamMembers/AddTeamMemberEvents.dart';
import 'package:flutter/material.dart';
import 'package:ems_oasis_19/Config.dart';
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
          await _addNewMember(listOfMembers, team, event.eventId);
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
    else if (event is AddNewTeam) {
      try {
        if(currentState is NoMemberScanned) {
          List<String> qrCodes = (event as AddNewTeam).qrCodes;
          String leader = (event as AddNewTeam).leader;
          String eventId = (event as AddNewTeam).eventId;
          String teamName = (event as AddNewTeam).teamName;
          yield AddingNewMember();
          await _addNewTeam(eventId, teamName, qrCodes, leader);
          yield NoMemberScanned();
        }
      } catch(error) {
        print(error.toString());
        yield ErrorAddingMember(errorMessage: error.toString());
      }
    }
  }

  Future<Null> _addNewMember(List<String> codes, String team, String eventId) async {
    print("Entered Api call with ${codes.toString()} and $team");
    // throw Exception("Cannot Load Posts");
  }

  Future<Null> _addNewTeam(String evetnId, String teamName, List<String> qrCodes, String leader) async {
    print("Entered api call to add team $teamName with members $qrCodes");
  }
}
