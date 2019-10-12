import 'package:ems_oasis_19/eventsList/model/TeamMembers.dart';
import 'package:ems_oasis_19/eventsList/model/Teams.dart';
import 'package:flutter/foundation.dart';
import 'package:ems_oasis_19/Config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TeamMembersListModel with ChangeNotifier {
  TeamInfo1 teamInfo;
  String eventId;
  bool isLoading;
  TeamMembers teamMembers;

  TeamMembersListModel(this.eventId, this.teamInfo) {
    isLoading = true;
    getListOfTeamMembers(eventId, teamInfo);
  }

  Future<Null> getListOfTeamMembers(String eventId, TeamInfo1 team) async {
    try {
      String jwt = await Config.getJWTFromSharedPreferences();
      print("Recived JWT = $jwt");
      var response = await http.get(Config.membersList+"${eventId.toString()}/team/${team.id}/details", headers: {"Authorization":"Bearer $jwt"});
      print("Fetching teamList Successful with code ${response.statusCode}");
      print("Fetching teamList Successful with code ${response.body.toString()}");
      if(response.statusCode == 200) {
        teamMembers = TeamMembers.fromJson(response.body.toString());
        print("Team Members recived from net = ${teamMembers.teamInfo.toMap()}");
        isLoading = false;
        notifyListeners();
      } else if(response.statusCode == 401 && json.decode(response.body)["code"].toString() == "token_not_valid") {
        Config.refreshJWTToken().then((_) {
          getListOfTeamMembers(eventId, team);
        });
      }
    } catch(e) {
      print("An Exception occoured while fetching teams = ${e.toString()}");
    }
  }


}