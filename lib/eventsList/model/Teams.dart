import 'dart:convert';

class Teams {
    Info eventInfo;
    Info levelInfo;
    List<Info> teamsInfo;

    Teams({
        this.eventInfo,
        this.levelInfo,
        this.teamsInfo,
    });

    Teams membersForError() {
      return Teams(teamsInfo: []);
    }

    factory Teams.fromJson(String str) => Teams.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Teams.fromMap(Map<String, dynamic> json) => Teams(
        eventInfo: Info.fromMap(json["event_info"]),
        levelInfo: Info.fromMap(json["level_info"]),
        teamsInfo: List<Info>.from(json["teams_info"].map((x) => Info.fromMap(x))),
    );

    Map<String, dynamic> toMap() => {
        "event_info": eventInfo.toMap(),
        "level_info": levelInfo.toMap(),
        "teams_info": List<dynamic>.from(teamsInfo.map((x) => x.toMap())),
    };
}

class Info {
    String name;
    int id;

    Info({
        this.name= "",
        this.id = 0,
    });

    factory Info.fromJson(String str) => Info.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Info.fromMap(Map<String, dynamic> json) => Info(
        name: json["name"],
        id: json["id"],
    );

    Map<String, dynamic> toMap() => {
        "name": name,
        "id": id,
    };
}
