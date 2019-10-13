import 'dart:convert';

class Teams {
    Info eventInfo;
    List<Info> levelsInfo;
    List<Info> teamsInfo;

    Teams({
        this.eventInfo,
        this.levelsInfo,
        this.teamsInfo,
    });

    Teams membersForError() {
      return Teams(teamsInfo: []);
    }

    factory Teams.fromJson(String str) => Teams.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Teams.fromMap(Map<String, dynamic> json) => Teams(
        eventInfo: Info.fromMap(json["event_info"]),
        levelsInfo: List<Info>.from(json["levels_info"].map((x) => Info.fromMap(x))),
        teamsInfo: List<Info>.from(json["teams_info"].map((x) => Info.fromMap(x)))
    );

    Map<String, dynamic> toMap() => {
        "event_info": eventInfo.toMap(),
        "level_info": List<dynamic>.from(levelsInfo.map((x) => x.toMap())),
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

/* class Info {
  String name;
  int totalScore;
  int id;

  Info({
    this.name="",
    this.totalScore=0,
    this.id=0
  });

  factory Info.fromJson(String str) => Info.fromMap(json.decode(str));

  factory Info.fromMap(Map<String, dynamic> json) => Info(
    name: json["name"],
    totalScore: json["score"],
    id: json["id"]
  );

  Map<String, dynamic> toMap() => {
        "name": name,
        "score": totalScore,
        "id": id
    };
} */
