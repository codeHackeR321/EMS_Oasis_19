import 'dart:convert';

class TeamMembers {
    String eventName;
    TeamInfo teamInfo;
    List<ParticipationsInfo> participationsInfo;
    List<LevelsInfo> levelsInfo;

    TeamMembers({
        this.eventName,
        this.teamInfo,
        this.participationsInfo,
        this.levelsInfo,
    });

    factory TeamMembers.fromJson(String str) => TeamMembers.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory TeamMembers.fromMap(Map<String, dynamic> json) => TeamMembers(
        eventName: json["event_name"],
        teamInfo: TeamInfo.fromMap(json["team_info"]),
        participationsInfo: List<ParticipationsInfo>.from(json["participations_info"].map((x) => ParticipationsInfo.fromMap(x))),
        levelsInfo: List<LevelsInfo>.from(json["levels_info"].map((x) => LevelsInfo.fromMap(x))),
    );

    Map<String, dynamic> toMap() => {
        "event_name": eventName,
        "team_info": teamInfo.toMap(),
        "participations_info": List<dynamic>.from(participationsInfo.map((x) => x.toMap())),
        "levels_info": List<dynamic>.from(levelsInfo.map((x) => x.toMap())),
    };
}

class LevelsInfo {
    String name;
    String judge;
    int score;
    String status;

    LevelsInfo({
        this.name,
        this.judge,
        this.score,
        this.status,
    });

    factory LevelsInfo.fromJson(String str) => LevelsInfo.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory LevelsInfo.fromMap(Map<String, dynamic> json) => LevelsInfo(
        name: json["name"],
        judge: json["judge"],
        score: json["score"],
        status: json["status"],
    );

    Map<String, dynamic> toMap() => {
        "name": name,
        "judge": judge,
        "score": score,
        "status": status,
    };
}

class ParticipationsInfo {
    String name;
    String college;
    String emsCode;

    ParticipationsInfo({
        this.name,
        this.college,
        this.emsCode,
    });

    factory ParticipationsInfo.fromJson(String str) => ParticipationsInfo.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory ParticipationsInfo.fromMap(Map<String, dynamic> json) => ParticipationsInfo(
        name: json["name"],
        college: json["college"],
        emsCode: json["ems_code"],
    );

    Map<String, dynamic> toMap() => {
        "name": name,
        "college": college,
        "ems_code": emsCode,
    };
}

class TeamInfo {
    String teamName;
    String teamCode;
    int teamCurrLevel;

    TeamInfo({
        this.teamName,
        this.teamCode,
        this.teamCurrLevel,
    });

    factory TeamInfo.fromJson(String str) => TeamInfo.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory TeamInfo.fromMap(Map<String, dynamic> json) => TeamInfo(
        teamName: json["team_name"],
        teamCode: json["team_code"],
        teamCurrLevel: json["team_curr_level"],
    );

    Map<String, dynamic> toMap() => {
        "team_name": teamName,
        "team_code": teamCode,
        "team_curr_level": teamCurrLevel,
    };
}
