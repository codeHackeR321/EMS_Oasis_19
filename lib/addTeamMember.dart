import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class AddTeamMemberPage extends StatelessWidget {
  final String pageTitle = "Add Member";

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
        body: AddTeamMemberWidget(),
      ),
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