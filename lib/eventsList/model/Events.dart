// To parse this JSON data, do
//
//     final events = eventsFromJson(jsonString);

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ems_oasis_19/Config.dart';
import 'package:ems_oasis_19/Temp.dart';

Events eventsFromJson(List<dynamic> list) {
  /* var temp = (json.decode(str)["evetns"]);
  print("Temp in events = ${temp.toString()}"); */
  return  Events.fromJson(list);
}

Events eventsForError() => Events(events: []);

String eventsToJson(Events data) => json.encode(data.toJson());

class Events {
    List<Event> events;

    Events({
        this.events,
    });

    static Future<List<FinalEvents>> getListOfEvents(List<dynamic> json) async {
      var events = Events.fromJson(json);
      List<FinalEvents> list = new List();
      var jwt = await Config.getJWTFromSharedPreferences();
      for (var event in events.events) {
        var response = await http.get(Config.membersList+"${event.id}", headers: {"Authorization":"Bearer $jwt"});
        print("Response for event Details = ${response.statusCode}");
        print("Response Body = ${response.body.toString()}");
        var temp = Temp.fromJson(response.body.toString());
        for (var level in temp.levelsInfo) {
          list.add(FinalEvents(event, level.id));
        }
      }
      return list;
    }

    factory Events.fromJson(List<dynamic> json) => Events(
        events: List<Event>.from(json.map((x) => Event.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "events": List<dynamic>.from(events.map((x) => x.toJson())),
    };
}

class Event {
    String name;
    int id;
    int maxTeamSize;
    int minTeamSize;

    Event({
        this.name,
        this.id,
        this.maxTeamSize,
        this.minTeamSize,
    });

    factory Event.fromJson(Map<String, dynamic> json) => Event(
        name: json["name"],
        id: json["id"],
        maxTeamSize: json["max_team_size"],
        minTeamSize: json["min_team_size"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "id": id,
        "maxSize": maxTeamSize,
        "minSize": minTeamSize,
    };
}

class FinalEvents {
  Event event;
  int levelId;

  FinalEvents(this.event, this.levelId);

  factory FinalEvents.fromJson(Map<String, dynamic> json) => FinalEvents(Event.fromJson(json), json["level"]);

  Map<String, dynamic> toJson() => {
        "name": event.name,
        "id": event.id,
        "maxSize": event.maxTeamSize,
        "minSize": event.minTeamSize,
        "level": levelId
    };
}
