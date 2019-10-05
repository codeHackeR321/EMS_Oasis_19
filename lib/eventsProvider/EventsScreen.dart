import 'package:ems_oasis_19/AddMemberStates.dart';
import 'package:ems_oasis_19/AddTeamMemberEvents.dart';
import 'package:ems_oasis_19/addTeamMember.dart';
import 'package:ems_oasis_19/eventsList/model/Events.dart';
import 'package:ems_oasis_19/eventsProvider/EventsModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EventsScreen extends StatelessWidget {
  final String pageTitle = "Evetns";

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<EventsModel>(
      builder: (_) => EventsModel(),
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
        body: EventsListOne()
      ),
    ),
    );
  }
}

class EventsListOne extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final EventsModel _eventsModel = Provider.of<EventsModel>(context);
    print("Providers initialized Successfully with ${_eventsModel.toString()}");

    return Center(
      child: _eventsModel.isLoading ? 
        CircularProgressIndicator() : 
        new ListView.builder(
          itemCount: _eventsModel.listOfEvents.events.length,
          itemBuilder: (BuildContext context, int index) {
          return EventsListViewCard(_eventsModel.listOfEvents.events[index]);
        },
      ),
    );
  }
}

class EventsListViewCard extends StatelessWidget {
  Event event;
  EventsListViewCard(this.event);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: RaisedButton(
        onPressed: () {
          navigateToNextPage(context);
        },
        child: Center(
          child: Text(event.name),
          ),
        ),
    );
  }

  Future<Null> navigateToNextPage(BuildContext context) async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => AddTeamMemberPage()));
  }
}