import 'dart:convert';

import 'package:ems_oasis_19/Config.dart';
import 'package:ems_oasis_19/eventsList/BLoC/EventsListBloc.dart';
import 'package:ems_oasis_19/eventsList/BLoC/EventsListEvents.dart';
import 'package:ems_oasis_19/eventsList/BLoC/EventsListStates.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:ems_oasis_19/Database.dart';
import 'package:ems_oasis_19/eventsList/model/Events.dart';
import 'package:sqflite/sqflite.dart';

class EventsRepository {

  Future<Events> getEvents() async {
    try{
      // Response response = await _dio.get(Config.eventsListUrl);
      // Response response = await _dio.get("http://www.mocky.io/v2/5d87a658340000b67c0a1566");
      var response = await http.get("http://www.mocky.io/v2/5d87a658340000b67c0a1566");
      print("Fetching userList Successful with code ${response.statusCode}");
      print("Fetching userList Successful with code ${json.decode(response.body.toString()).toString()}");
      var eventList = eventsFromJson(json.decode(response.body)["events"]);
      addEventsToDatabase(eventList).then((bool value) async {
        print("Value retuned = ${value}");
        var x = await getEvents();
        x.events.forEach((event){
          print("Reterived Event = ${event.toString()}");
        });
        // bloc.dispatch(ShowEvents(x));
      });
      return eventsForError();
    }catch(e) {
      print("Error in fetching events = ${e.toString()}");
      // Return an empty list of events in case of any error
      return eventsForError();
    }
  }

  Future<bool> addEventsToDatabase(Events events) async {
    DatabaseProvider _database = await DatabaseProvider.databaseProvider;
    for (var event in events.events) {
      var res = await _database.addEvent(event);
      print("Res after adding event to database = ${res.toString()}");
    }
    return true;
  }
}