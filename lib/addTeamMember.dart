import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class AddTeamMember extends StatefulWidget {
  @override
  _AddTeamMemberState createState() => _AddTeamMemberState();
}

class _AddTeamMemberState extends State<AddTeamMember> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  TextEditingController codeController = new TextEditingController();
  QRViewController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
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
                onPressed: () {
                  print("Added Member = ${codeController.text}");
                  Navigator.of(context).pop();
                },
              ),
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