import 'package:ems_oasis_19/addTeamMembers/addTeamMember.dart';
import 'package:ems_oasis_19/eventsList/model/Teams.dart';
import 'package:ems_oasis_19/teamMembersListProvider/TeamMembersListModel.dart';
import 'package:ems_oasis_19/teamsListProvider/TeamListModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TeamMemberListScreen extends StatelessWidget {
  String _pageTitle;
  String eventId;
  Info team;
  TeamListModel listModel;

  TeamMemberListScreen(this.eventId, this.team, this.listModel){
    _pageTitle = team.name;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TeamMembersListModel>(
      builder: (BuildContext context) => TeamMembersListModel(eventId, team),
      child: MaterialApp(
      title: _pageTitle,
      home: Scaffold(
        appBar: AppBar(
          title: Text(_pageTitle),
          leading: GestureDetector(
            child: Icon(Icons.arrow_back),
            onTap: () {
              listModel.getTeamDetailsForEvent(listModel.eventId);
              Navigator.of(context).pop();
            },
          ),
        ),
        body: MembersListWidget(eventId, team)
      ),
    ),
    );
  }
}

class MembersListWidget extends StatelessWidget {
  String eventId;
  Info team;

  MembersListWidget(this.eventId, this.team);

  @override
  Widget build(BuildContext context) {
    final TeamMembersListModel _listModel = Provider.of<TeamMembersListModel>(context);
    return Center(
      child: _listModel.isLoading ? 
        CircularProgressIndicator() : 
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Flexible(
              flex: 1,
              child: _listModel.teamMembers.participationsInfo.isEmpty ? 
                Center(
                  child: Text("This Team currently has no members enrolled"),
                ) :
                ListView.builder(
                  itemCount: _listModel.teamMembers.participationsInfo.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Text(_listModel.teamMembers.participationsInfo[index].name),
                                  Text(_listModel.teamMembers.participationsInfo[index].college)
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
            ),
            Container(
              child: RaisedButton(
                child: Text("Add Team Member"),
                onPressed: () async {
                 Navigator.push(context, MaterialPageRoute(builder: (context) => AddTeamMemberPage(addingTeam: false,eventId: eventId ,teamInfo: team, model: _listModel))); 
                },
              ),
            )
          ],
        ),
    );
  }
}