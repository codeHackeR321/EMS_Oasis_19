import 'package:ems_oasis_19/addTeamMembers/AddMemberStates.dart';
import 'package:ems_oasis_19/addTeamMembers/AddTeamMemberEvents.dart';
import 'package:ems_oasis_19/addTeamMembers/addTeamMember.dart';
import 'package:ems_oasis_19/eventsList/model/Events.dart';
import 'package:ems_oasis_19/eventsList/model/TeamMembers.dart';
import 'package:ems_oasis_19/eventsList/model/Teams.dart';
import 'package:ems_oasis_19/eventsProvider/EventsModel.dart';
import 'package:ems_oasis_19/teamsListProvider/TeamListScreen.dart';
import 'package:flutter/material.dart';
import 'EventPages.dart';
import 'package:provider/provider.dart';

class EventScreen extends StatefulWidget {
  @override
  _EventScreenState createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  String pageTitle;
  EventsModel _eventsModel;

  _EventScreenState() {
    print("Entered Constructor");
    pageTitle = "Events";
    _eventsModel = EventsModel(EventsListPage());
    print("Exited Constuctor");
  }

  @override
  Widget build(BuildContext context) {
    print("Build method called");
    print("Current Model = $_eventsModel");
    var b = (_) {
      print("Entered external builder");
      return _eventsModel.currentPage;
    };
    print("Value for b = ${b.toString()}");
    return new ChangeNotifierProvider<EventPage>(
      builder: b,
      child: MaterialApp(
      title: pageTitle,
      home: Scaffold(
        appBar: AppBar(
          title: Text(pageTitle),
          leading: GestureDetector(
            child: Icon(Icons.arrow_back),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: EventsListOne(this)
      ),
    ),
    );
  }

  Widget ListOfTeamsWidget(ListOfTeamsPage eventPage) {
    var keys = eventPage.completeTeamMap.keys.toList();
    return Center(
      child: eventPage.isLoading ? 
      CircularProgressIndicator() :
      eventPage.completeTeamMap.isEmpty ?
      Text("There are no teams currently") :
      new ListView.builder(
        itemCount: keys.length,
        itemBuilder: (BuildContext context, int index) {
          return Center(
            child: Row(
              children: <Widget>[
                Container(
                  child: Text(keys[index].name),
                ),
                Flexible(
                  flex: 1,
                  child: ListView.builder(
                    itemCount: eventPage.completeTeamMap[keys[index]].participationsInfo.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Center(
                        child: Text("${eventPage.completeTeamMap[keys[index]].participationsInfo[index].name}\n${eventPage.completeTeamMap[keys[index]].participationsInfo[index].college}"),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      )
    );
  }

  Widget EventsListPageWidget(EventsListPage eventPage, BuildContext context, _EventScreenState state) {
    print("Entered widget function");
     return Center(
      child: eventPage.isLoading ? 
        CircularProgressIndicator() : 
        new ListView.builder(
          itemCount: eventPage.listOfEvents.events.length,
          itemBuilder: (BuildContext context, int index) {
          return EventsListViewCard(eventPage.listOfEvents.events[index], context,state);
        },
      ),
    );
  }

  Widget EventsListViewCard(Event event, BuildContext context, _EventScreenState state) {
    return Container(
      child: RaisedButton(
        onPressed: () async {
          print("Button Pressed");
          /* (_eventsModel.currentPage as EventsListPage).selectedEvent = event;
          _eventsModel.navigateToNextPage(context).then((EventsModel em) {
            setState(() {
             this.pageTitle = _eventsModel.pageTitle; 
             this._eventsModel = EventsModel(ListOfTeamsPage(event.id, 1));
            });;
          }); */
          /* var teamPage = ListOfTeamsPage(event.id, 1);
          await teamPage.getMembersFromNet();
          var eventsModel = EventsModel(teamPage);
          state._eventsModel = eventsModel;
          setState(() {
           print("Entered Set State"); 
          }); */
          Navigator.push(context, MaterialPageRoute(builder: (context) => TeamListScreen(event.id.toString(), "1")));
        },
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(event.name),
          ),
          ),
        ),
    );
  }
}

class EventsListOne extends StatelessWidget {
  _EventScreenState screen;

  EventsListOne(this.screen);

  @override
  Widget build(BuildContext context) {
    print("Starting to fetch Provider");
    final EventPage _eventPage = Provider.of<EventPage>(context);
    print("Providers initialized Successfully with ${_eventPage.toString()}");

    if(_eventPage is EventsListPage) {
      print("Entered if condition");
      return screen.EventsListPageWidget(_eventPage as EventsListPage, context, screen);
    }
    else if(_eventPage is ListOfTeamsPage) {
      print("Current Page Changed to list of teams page");
      return screen.ListOfTeamsWidget(_eventPage);
    }
  }
}