// To parse this JSON data, do
//
//     final events = eventsFromJson(jsonString);

import 'dart:convert';

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
