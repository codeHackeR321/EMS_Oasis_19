import 'package:ems_oasis_19/eventsList/BLoC/EventsListBloc.dart';
import 'package:ems_oasis_19/eventsList/BLoC/EventsListStates.dart';
import 'package:ems_oasis_19/eventsList/EventsRepository.dart';
import 'package:ems_oasis_19/eventsList/model/Events.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EventListScreen extends StatelessWidget {
  final String pageTitle = "Evetns";

  init() {
    print("Entered init for stless widget");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
        body: BlocProvider(
          builder: (context) {
            return EventsListBloc();
          },
          child: ListOfEvents(),
        ),
      ),
    );
  }
}

class ListOfEvents extends StatefulWidget {
  @override
  _ListOfEventsState createState() => _ListOfEventsState();
}

class _ListOfEventsState extends State<ListOfEvents> {
  EventsListBloc _bloc;
  EventsRepository _repo;

  @override
  void initState() {
    _bloc = BlocProvider.of<EventsListBloc>(context);
    _repo = new EventsRepository();
    _repo.getEvents();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventsListBloc, EventsListStates>(
      builder: (context, state) {
        if(state is LoadingEvents) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        else if(state is EventsListLoaded) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: new ListView.builder(
              itemCount: state.eventList.events.length,
              itemBuilder: (BuildContext context, int index) {
                return EventsListViewCard(state.eventList.events[index]);
              },
            ),
          );
        }
      },
    );
  }
}

class EventsListViewCard extends StatelessWidget {
  Event event;
  EventsListViewCard(this.event);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16.0,4.0,16.0,4.0),
            child: Text(
                event.name,
            textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}