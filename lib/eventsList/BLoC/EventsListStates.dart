import 'package:ems_oasis_19/eventsList/model/Events.dart';
import 'package:equatable/equatable.dart';

abstract class EventsListStates extends Equatable {}

class LoadingEvents extends EventsListStates {
  @override
  String toString() {
    return "Loading List of evetnts";
  }
}

class ErrorLoadingEvents extends EventsListStates {
  String errorMessage;

  @override
  String toString() {
    return "Error in Loading list of events = \n${errorMessage}";
  }
}

class EventsListLoaded extends EventsListStates {
  List<FinalEvents> eventList;

  EventsListLoaded(this.eventList);

  @override
  String toString() {
    return "Successfully loaded events = \n${eventList.toString()}";
  }
}