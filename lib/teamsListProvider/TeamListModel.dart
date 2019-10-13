import 'package:ems_oasis_19/eventsList/model/Teams.dart';
import 'package:flutter/widgets.dart';
import 'package:ems_oasis_19/Config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TeamListModel with ChangeNotifier {
  String eventId;
  Teams teams;
  bool isLoading;
  
  TeamListModel(this.eventId) {
    isLoading = true;
    teams = Teams();
    getTeamDetailsForEvent(eventId);
  }

  Future<Null> getTeamDetailsForEvent(String eventId) async {
    try {
      String jwt = await Config.getJWTFromSharedPreferences();
      print("Recived JWT = $jwt");
      var response = await http.get(Config.membersList+"${eventId.toString()}", headers: {"Authorization":"Bearer $jwt"});
      print("Fetching teamList Successful with code ${response.statusCode}");
      print("Fetching teamList Successful with code ${json.decode(response.body.toString()).toString()}");
      if(response.statusCode == 200) {
        this.teams = Teams.fromJson(response.body.toString());
        print("Fetched Teams = ${teams.teamsInfo.toList()}");
        isLoading = false;
        notifyListeners();
      } else if(response.statusCode == 401 && json.decode(response.body)["code"].toString() == "token_not_valid") {
        Config.refreshJWTToken().then((_) {
          getTeamDetailsForEvent(eventId);
        });
      }
      notifyListeners();
    } catch(e) {
      print("An Exception occoured while fetching teams = ${e.toString()}");
    }
  }
}