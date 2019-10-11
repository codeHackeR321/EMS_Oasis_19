import 'package:ems_oasis_19/eventsList/model/Teams.dart';
import 'package:flutter/material.dart';
import 'AddMemberBloc.dart';
import 'AddMemberStates.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'AddTeamMemberEvents.dart';
import 'package:http/http.dart' as http;
import 'package:qr_code_scanner/qr_code_scanner.dart';

class AddTeamMemberPage extends StatelessWidget {
  final String pageTitle = "Add Member";
  bool addingTeam;
  String eventId;
  String levelId;
  TeamInfo1 teamInfo;

  AddTeamMemberPage({@required this.addingTeam, @required this.eventId, @required this.levelId, this.teamInfo});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: pageTitle,
      home: Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            child: Icon(Icons.arrow_back_ios),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
          title: Text(pageTitle),
        ),
        body: BlocProvider(
          builder: (context) {
            print("Entered Bloc Provider");
            return AddMemberBloc(httpClient: http.Client());
          },
          child: BlocChild(eventId, addingTeam, levelId, teamInfo),
        ),
      ),
    );
  }
}

class BlocChild extends StatefulWidget {
  @override
  _BlocChildState createState() => _BlocChildState(eventId, addingTeam, levelId, teamInfo: teamInfo);
  String eventId;
  bool addingTeam;
  String levelId;
  TeamInfo1 teamInfo;

  BlocChild(this.eventId, this.addingTeam, this.levelId, this.teamInfo);
}

class _BlocChildState extends State<BlocChild> {
AddMemberBloc _bloc;
final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
TextEditingController codeController = new TextEditingController(text: "");
TextEditingController teamNameController = new TextEditingController(text: "");
QRViewController controller;
String eventId;
bool addingTeam;
String levelId;
TeamInfo1 teamInfo;

_BlocChildState(this.eventId, this.addingTeam, this.levelId, {this.teamInfo});

@override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<AddMemberBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddMemberBloc, AddMemberStates>(
      builder: (context, state) {
        if(state is NoMemberScanned) {
          return SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: <Widget>[
                  addingTeam ? 
                    Center(
                      child: TextField(
                        controller: teamNameController,
                        autofocus: false,
                        decoration: InputDecoration(
                          hintText: "Enter Team"
                        ),
                      ),
                    ): 
                    Container(),
                  Flexible(
                    flex: 2,
                    child: ListView.builder(
                      itemCount: (state as NoMemberScanned).scannedMembers.toList().length,
                      itemBuilder: (BuildContext context, int index) {
                        return Center(child: Text((state as NoMemberScanned).scannedMembers.toList()[index]),);
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(8.0),
                    child: TextField(
                      controller: codeController,
                      autofocus: false,
                      decoration: InputDecoration(
                        hintText: "Enter unique code"
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: QRView(
                      key: qrKey,
                      onQRViewCreated: (QRViewController controller) {
                        this.controller = controller;
                        controller.scannedDataStream.listen((scanData) {
                          controller.pauseCamera();
                          setState(() {
                            print("Automatically called AddNewTeamMember");
                            (_bloc.currentState as NoMemberScanned).addMemberInfo(scanData);
                          });
                          controller.resumeCamera();
                        });
                      },
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Center(
                      child: RaisedButton(
                        child: Text("Add Member"),
                        /* To disable the button, we need to pass null in the onPressed field
                          Currently, the button is disabled if the loader is visible, or there is no text in the text field*/
                        onPressed: codeController.text.isNotEmpty ? () {
                          print("Added Member = ${codeController.text}");
                          setState(() {
                          (_bloc.currentState as NoMemberScanned).addMemberInfo(codeController.text);
                          codeController.text = ""; 
                          });
                          // Navigator.of(context).pop();
                        } : null,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Center(
                      child: RaisedButton(
                        child: addingTeam ? Text("Create New Team") : Text("Add All Team Members"),
                        onPressed: (state as NoMemberScanned).scannedMembers.isNotEmpty ? () {
                          if(addingTeam) {
                            if(teamNameController.text.isNotEmpty) {
                              print("Adding Team");
                              var qrCodes = (_bloc.currentState as NoMemberScanned).scannedMembers;
                              _bloc.dispatch(AddNewTeam(eventId: eventId, teamName: teamNameController.text, qrCodes: qrCodes.toList(), leader: qrCodes.toList()[0]));
                            }
                          } else {
                            print("Adding all team members");
                            // (_bloc.currentState as NoMemberScanned).addMemberInfo(codeController.text);
                            _bloc.dispatch(AddNewTeamMembers(teamInfo.name, eventId, levelId));
                          }
                        } : null,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        else if(state is ErrorAddingMember){
          return Center(child: Text(state.errorMessage),);
        }
        else if(state is AddingNewMember) {
          return Center(child: CircularProgressIndicator(),);
        }
        return Center(child: Text("Something went wrong."),);
      },
    );
  }
}

class AddTeamMemberWidget extends StatefulWidget {
  @override
  _AddTeamMemberWidgetState createState() => _AddTeamMemberWidgetState();
}

class _AddTeamMemberWidgetState extends State<AddTeamMemberWidget> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  TextEditingController codeController = new TextEditingController(text: "");
  QRViewController controller;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
           Column(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                padding: EdgeInsets.all(8.0),
                child: TextField(
                  controller: codeController,
                  autofocus: false,
                  decoration: InputDecoration(
                    hintText: "Enter unique code"
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: QRView(
                key: qrKey,
                onQRViewCreated: _onQRViewCreated,
              ),
            ),
            Expanded(
              flex: 1,
              child: Center(
                child: RaisedButton(
                  child: Text("Add Member"),
                  /* To disable the button, we need to pass null in the onPressed field
                    Currently, the button is disabled if the loader is visible, or there is no text in the text field*/
                  onPressed: isLoading ? null : codeController.text != "" ? () {
                    print("Added Member = ${codeController.text}");
                    setState(() {
                      Scaffold.of(context).showSnackBar(SnackBar(content: Text("Team Member Added!!"),));
                      // isLoading = !isLoading; 
                    });
                    // Navigator.of(context).pop();
                  } : null,
                ),
              ),
            )
          ],
        ),
        Center(
          child: Opacity(
            child: CircularProgressIndicator(),
            opacity: isLoading ? 1.0 : 0.0,
          ),
        )
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        codeController.text = scanData;
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}