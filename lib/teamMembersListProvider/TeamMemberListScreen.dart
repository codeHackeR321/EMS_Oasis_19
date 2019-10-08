import 'package:ems_oasis_19/eventsList/model/Teams.dart';
import 'package:ems_oasis_19/teamMembersListProvider/TeamMembersListModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TeamMemberListScreen extends StatelessWidget {
  String _pageTitle;
  String eventId;
  Info team;

  TeamMemberListScreen(this.eventId, this.team){
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
              Navigator.of(context).pop();
            },
          ),
        ),
        body: MembersListWidget()
      ),
    ),
    );
  }
}

class MembersListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TeamMembersListModel _listModel = Provider.of<TeamMembersListModel>(context);
    return Center(
      child: _listModel.isLoading ? 
        CircularProgressIndicator() : 
        Column(
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
                    return Center(
                      child: Column(
                        children: <Widget>[
                          Text(_listModel.teamMembers.participationsInfo[index].name),
                          Text(_listModel.teamMembers.participationsInfo[index].college)
                        ],
                      ),
                    );
                  },
                ),
            ),
            Container(
              child: RaisedButton(
                child: Text("Add Team Member"),
                onPressed: () {
                  
                },
              ),
            )
          ],
        ),
    );
  }
}