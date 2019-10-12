import 'package:ems_oasis_19/eventsProvider/EventPages.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:ems_oasis_19/addTeamMembers/AddMemberStates.dart';
import 'package:ems_oasis_19/addTeamMembers/AddTeamMemberEvents.dart';
import 'package:ems_oasis_19/addTeamMembers/addTeamMember.dart';
import 'package:ems_oasis_19/eventsList/model/Events.dart';
import 'package:ems_oasis_19/eventsProvider/EventsModel.dart';
import 'package:flutter/material.dart';
import 'EventPages.dart';
import 'package:provider/provider.dart';

class EventsModel { 

  EventPage currentPage;
  String pageTitle;
  bool backbuttonVisible;

  EventsModel(this.currentPage) {
    pageTitle = currentPage.pageTitle;
    backbuttonVisible = false;
  }

  @override
  String toString() {
    return "Active Page = ${currentPage.toString()}";
  }

  Future<EventsModel> navigateToNextPage(BuildContext context) async {
    print("Entered Model Navigator");
    if(currentPage is EventsListPage) {
      var page = currentPage as EventsListPage;
      // TODO: Change the hardcode-ed level number
      print("Changing current page");
      currentPage = ListOfTeamsPage(page.selectedEvent.event.id, page.selectedEvent.levelId);
      page.notifyListeners();
      return this;
    }
  }

}