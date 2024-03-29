import 'package:ems_oasis_19/addTeamMembers/addTeamMember.dart';
import 'package:ems_oasis_19/eventsProvider/EventPages.dart';
import 'package:ems_oasis_19/teamMembersListProvider/TeamMemberListScreen.dart';
import 'package:ems_oasis_19/teamsListProvider/TeamListModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TeamListScreen extends StatelessWidget {
  final String _pageTitle = "Teams";
  String eventId;
  EventPage eventPage;

  TeamListScreen(this.eventId, this.eventPage);

  @override
  Widget build(BuildContext context) {
    print("Entered Build Method");
    return ChangeNotifierProvider<TeamListModel>(
      builder: (BuildContext context) => TeamListModel(eventId),
      child: Scaffold(
        appBar: AppBar(
          title: Text(_pageTitle),
          leading: GestureDetector(
            child: Icon(Icons.arrow_back),
            onTap: () {
              (eventPage as EventsListPage).getEvetnsFromNet();
              Navigator.of(context).pop();
            },
          ),
        ),
        body: TeamListWidget(eventId)
      ),
    );
  }
}

class TeamListWidget extends StatelessWidget {
  String eventId;
  TextEditingController teamController = new TextEditingController(text: "");

  TeamListWidget(this.eventId);

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
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text("No Teams Registered for this event yet",
                style: TextStyle(
                  fontSize: 18.0,
                  color: Color.fromRGBO(255, 77, 77, 25)
                )
                  ,),
              )
              ,) :

              Flexible(
              flex: 1,
              child: Container(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ListView.builder(
                    itemCount: _listModel.teams.teamsInfo.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(0, 12.0, 0.0, 0.0),
                        child: Container(
                          width: double.infinity,
                          child: RaisedButton(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("${_listModel.teams.teamsInfo[index].name}",
                              style: TextStyle(
                                fontSize: 16.0,
                              ),),
                            ),
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => TeamMemberListScreen(eventId, _listModel.teams.teamsInfo[index], _listModel)));
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
           Container(
             width: double.infinity,
             child: Padding(
               padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 0.0),
               child: RaisedButton(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text("Add New Team",
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                  ),
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) {
                      return Material(
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(8.0),
                              child: TextField(
                              controller: teamController,
                              autofocus: false,
                              decoration: InputDecoration(
                                hintText: "Enter team Name"
                              ),
                            ),
                          ),
                          RaisedButton(
                            onPressed: () async {
                              FocusScope.of(context).requestFocus(FocusNode());
                              Navigator.push(context, MaterialPageRoute(builder: (context) => AddTeamMemberPage(addingTeam: true,eventId: eventId, teamName: teamController.text.toString(),)));
                            },
                            child: Text("OK"),
                          )

                          ],
                        ),
                      );
                    }
                  );
                  // Navigator.push(context, MaterialPageRoute(builder: (context) => AddTeamMemberPage(addingTeam: true, eventId: eventId,)));
                },
            ),
             ),
           ),
         ], 
        ),
    );
  }
}