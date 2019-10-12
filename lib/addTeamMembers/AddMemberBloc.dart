import 'dart:convert';

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
          await _addNewMember(listOfMembers, team, event.eventId, event.teamId);
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

  Future<Null> _addNewMember(List<String> codes, String team, String eventId, String teamId) async {
    print("Entered Api call with ${codes.toString()} and $team");
    String jwt = await Config.getJWTFromSharedPreferences();
    httpClient.post(Config.membersList+"$eventId/team/$teamId/update", headers: {"Authorization":"Bearer $jwt", "Content-Type": "application/json"}, body: json.encode({
      "qr_codes": codes.toList()
    })).then((http.Response response) {
      print("Response Code of adding new team member = ${response.statusCode}");
      print("Response Body of adding new team member = ${response.body.toString()}");
      if (response.statusCode == 200) {

      } else if(response.statusCode == 401 && json.decode(response.body)["code"].toString() == "token_not_valid") {
        Config.refreshJWTToken().then((_) {
          _addNewMember(codes, team, eventId, teamId);
        });
      } else {
        throw("Failed to add team with unKnown exception");
      }
    });
  }

  Future<Null> _addNewTeam(String evetnId, String teamName, List<String> qrCodes, String leader) async {
    print("Entered api call to add team $teamName with members $qrCodes");
    String jwt = await Config.getJWTFromSharedPreferences();
    httpClient.post(Config.membersList+"$evetnId/team/add", headers: {"Authorization":"Bearer $jwt", "Content-Type": "application/json"}, body: json.encode({
      "name": teamName,
      "leader": leader,
      "participants": qrCodes.toList()
    })).then((http.Response response) {
      print("Response Code of adding new team member = ${response.statusCode}");
      print("Response Body of adding new team member = ${response.body.toString()}");
      if (response.statusCode == 200) {

      } else if(response.statusCode == 401 && json.decode(response.body)["code"].toString() == "token_not_valid") {
        Config.refreshJWTToken().then((_) {
          _addNewTeam(evetnId, teamName, qrCodes, leader);
        });
      } else {
        throw("Failed to add team with unKnown exception");
      }
    });
  }
}
