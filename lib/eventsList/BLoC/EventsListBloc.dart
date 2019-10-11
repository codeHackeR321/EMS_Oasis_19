import 'package:ems_oasis_19/eventsList/BLoC/EventsListEvents.dart';
import 'package:ems_oasis_19/eventsList/BLoC/EventsListStates.dart';
import 'package:bloc/bloc.dart';
import 'package:ems_oasis_19/eventsList/EventsRepository.dart';

class EventsListBloc extends Bloc<EventsListEvents, EventsListStates> {
  EventsRepository _eventsRepository = EventsRepository();

  @override
  EventsListStates get initialState => LoadingEvents();

  @override
  Stream<EventsListStates> mapEventToState(EventsListEvents event) async* {
    if(event is FetchEvents) {
      if(currentState is LoadingEvents) {
      var events = await _eventsRepository.getEvents();
      // print("Recived Events = ${events.toJson().toString()}");
      await _eventsRepository.addEventsToDatabase(events).then((bool x) {
        ShowEvents(events);
      });
      }
    }
    else if(event is ShowEvents) {
      yield EventsListLoaded(event.eventList);
    }
  }

}