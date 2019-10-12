import 'package:ems_oasis_19/eventsList/model/Events.dart';
import 'package:equatable/equatable.dart';

abstract class EventsListEvents extends Equatable {}

class ShowEvents extends EventsListEvents {
  List<FinalEvents> eventList;

  ShowEvents(this.eventList);

  @override
  String toString() {
    return "Called Show Events";
  }
}

class FetchEvents extends EventsListEvents {
  @override
  String toString() {
        return "Called Fetch Events";

  }
}