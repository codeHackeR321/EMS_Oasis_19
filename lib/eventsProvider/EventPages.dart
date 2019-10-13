import 'dart:io';
import 'package:ems_oasis_19/eventsList/model/TeamMembers.dart' as prefix0;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ems_oasis_19/eventsList/model/Events.dart';
import 'package:ems_oasis_19/eventsList/model/TeamMembers.dart';
import 'package:ems_oasis_19/eventsList/model/Teams.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ems_oasis_19/Database.dart';
import 'dart:convert';
import 'package:ems_oasis_19/Config.dart';

abstract class EventPage with ChangeNotifier {
  String pageTitle;
  bool isLoading;

  String getPageTitile() {
    return pageTitle;
  }
}

class EventsListPage extends EventPage {
  List<FinalEvents> listOfEvents;
  FinalEvents selectedEvent;
  List<Event> listEvents = [];

  EventsListPage() {
    listOfEvents = [];
    pageTitle = "Events";
    isLoading = true;
    selectedEvent = null;
    getEvetnsFromNet();
  }

  Future<Null> getEvetnsFromNet() async {
    try{
      // Response response = await _dio.get(Config.eventsListUrl);
      // Response response = await _dio.get("http://www.mocky.io/v2/5d87a658340000b67c0a1566");
      String UserJWT = await getJWTFromSharedPreferences();
      print("Recived JWT = ${UserJWT}");
      var response = await http.get(Config.eventsListUrl, headers: {"Authorization":"Bearer $UserJWT"});
      print("Fetching userList Successful with code ${response.statusCode}");
      print("Fetching userList Successful with code ${json.decode(response.body.toString()).toString()}");
      if(response.statusCode == 200) {
        var eventList = await Events.getListOfEvents(json.decode(response.body)["events"]);
        listEvents = Events.fromJson(json.decode(response.body)["events"]).events;
        addEventsToDatabase(eventList).then((bool value) async {
          print("Value retuned = ${value}");
          this.listOfEvents = await DatabaseProvider.databaseProvider.getAllEvetns();
          listOfEvents.forEach((event){
            print("Reterived Event = ${event.toString()}");
          });
          print("Listener Notified");
          isLoading = false;
          notifyListeners();
          // bloc.dispatch(ShowEvents(x));
        });
        listOfEvents = [];
        isLoading = false;
        notifyListeners();
      } else if(response.statusCode == 401 && json.decode(response.body)["code"].toString() == "token_not_valid") {
        Config.refreshJWTToken().then((_) {
          getEvetnsFromNet();
        });
      }
    }catch(e) {
      print("Error in fetching events = ${e.toString()}");
      // Return an empty list of events in case of any error
      listOfEvents = [];
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addEventsToDatabase(List<FinalEvents> events) async {
    DatabaseProvider _database = await DatabaseProvider.databaseProvider;
    var res = await _database.addEvent(events);
    print("Res after adding event to database = ${res.toString()}");
    notifyListeners();
    return true;
  }

  @override
  String toString() {
    return "Events List Page with list = ${listOfEvents.toString()}\n${this.hashCode}";
  }

  Future<String> getJWTFromSharedPreferences() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String key = "";
    try {
      key = await sharedPreferences.getString(Config.jwtKey);
    } catch(e) {
      print("Error in reading JWT = ${e.toString()}");
    }
    return key;
  }
}

class ListOfTeamsPage extends EventPage {
  int eventId;
  int levelId;
  Teams members;
  Map<Info, TeamMembers> completeTeamMap = Map();

  ListOfTeamsPage(this.eventId, this.levelId) {
    members = Teams();
    pageTitle = "List  Of Team Members";
    isLoading = true;
    // getMembersFromNet();
  }

  void getMembersFromNet() async {
    try {
      String UserJWT = await getJWTFromSharedPreferences();
      print("Recived JWT = $UserJWT");
      var response = await http.get(Config.membersList+"${eventId.toString()}/level/${levelId.toString()}", headers: {"Authorization":"Bearer $UserJWT"});
      print("Fetching teamList Successful with code ${response.statusCode}");
      print("Fetching teamList Successful with code ${json.decode(response.body.toString()).toString()}");
      if(response.statusCode == 200) {
        members = Teams.fromJson(response.body.toString());
        for(var team in members.teamsInfo) {
          print("Team in for loop = ${team.toString()}");
          var membersResponse = await http.get(Config.membersList+"/${eventId.toString()}/team/${team.id.toString()}/details");
          print("Fetching memberList Successful with code ${membersResponse.statusCode}");
          print("Fetching memberList Successful with body ${json.decode(membersResponse.body.toString()).toString()}");
          TeamMembers teamMembers = TeamMembers.fromJson(membersResponse.body.toString());
          completeTeamMap[team] = teamMembers;
          print("Map entry for team $team = ${teamMembers.toMap().toString()}");
          isLoading = false;
          notifyListeners();
        }
        print("Exited For Loop and notified listeners");
        isLoading = false;
        notifyListeners();
      } else if(response.statusCode == 401 && json.decode(response.body)["code"].toString() == "token_not_valid") {
        Config.refreshJWTToken().then((_) {
          getMembersFromNet();
        });
      }
    } catch(e) {
      print("Error in fetching members = ${e.toString()}");
      members.teamsInfo = [];
    }
  }

  Future<String> getJWTFromSharedPreferences() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String key = "";
    try {
      key = await sharedPreferences.getString(Config.jwtKey);
    } catch(e) {
      print("Error in reading JWT = ${e.toString()}");
    }
    return key;
  }
}