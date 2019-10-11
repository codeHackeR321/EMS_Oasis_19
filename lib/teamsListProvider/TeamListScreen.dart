import 'package:ems_oasis_19/addTeamMembers/addTeamMember.dart';
import 'package:ems_oasis_19/teamsListProvider/TeamListModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TeamListScreen extends StatelessWidget {
  final String _pageTitle = "Teams";
  String eventId, levelId;

  TeamListScreen(this.eventId, this.levelId);

  @override
  Widget build(BuildContext context) {
    print("Entered Build Method");
    return ChangeNotifierProvider<TeamListModel>(
      builder: (BuildContext context) => TeamListModel(eventId, levelId),
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
        body: TeamListWidget(eventId, levelId)
      ),
    ),
    );
  }
}

class TeamListWidget extends StatelessWidget {
  String eventId;
  String levelId;

  TeamListWidget(this.eventId, this.levelId);

  @override
  Widget build(BuildContext context) {
    print("Entered Build method");
    final TeamListModel _listModel = Provider.of<TeamListModel>(context);
   /*  _listModel.teams.teamsInfo.forEach((team){
      print("Data in New variable = ${team.name}\t${team.id}\n");
    }); */
    return Center(
      child: _listModel.isLoading ? 
        CircularProgressIndicator() :
        Column(
         children: <Widget>[
           _listModel.teams.teamsInfo.isEmpty || _listModel.teams == null ? 
            Center(child: Text("No Teams Registered for this event yet"),) :
            Flexible(
              flex: 1,
              child: Container(
                child: ListView.builder(
                  itemCount: _listModel.teams.teamsInfo.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Center(
                      child: RaisedButton(
                        child: Text("Team \n ${_listModel.teams.teamsInfo[index].name}"),
                        onPressed: () {
                          
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
           Container(
             child: RaisedButton(
              child: Text("Add New Team"),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => AddTeamMemberPage(addingTeam: true, eventId: eventId, levelId: levelId,)));
              },
            ),
           ),
         ], 
        ),
    );
  }
}