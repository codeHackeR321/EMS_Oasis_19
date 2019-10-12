import 'dart:convert';
import 'package:ems_oasis_19/eventsList/model/Teams.dart';

class Temp {
    Info eventInfo;
    List<Info> levelsInfo;
    List<Info> teamsInfo;

    Temp({
        this.eventInfo,
        this.levelsInfo,
        this.teamsInfo,
    });

    factory Temp.fromJson(String str) => Temp.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Temp.fromMap(Map<String, dynamic> json) => Temp(
        eventInfo: Info.fromMap(json["event_info"]),
        levelsInfo: List<Info>.from(json["levels_info"].map((x) => Info.fromMap(x))),
        teamsInfo: List<Info>.from(json["teams_info"].map((x) => Info.fromMap(x))),
    );

    Map<String, dynamic> toMap() => {
        "event_info": eventInfo.toMap(),
        "levels_info": List<dynamic>.from(levelsInfo.map((x) => x.toMap())),
        "teams_info": List<dynamic>.from(teamsInfo.map((x) => x.toMap())),
    };
}