import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef void CustomQRScannerCallback(CustomQRScannerController controoler);

class CustomQRScanner extends StatefulWidget {
  @override
  _CustomQRScannerState createState() => _CustomQRScannerState();
}

class _CustomQRScannerState extends State<CustomQRScanner> {
  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}

class CustomQRScannerController {
  MethodChannel _channel;
  
  CustomQRScannerController(int id) {
    this._channel = new MethodChannel("customQRScanner$id");
  }
  
}