import 'package:ems_oasis_19/login.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'Form Validation Demo';

    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
          title: Text(appTitle),
        ),
        body: HomePageDecider(),
      ),
    );
  }
}

class HomePageDecider extends StatefulWidget {
  @override
  _HomePageDeciderState createState() => _HomePageDeciderState();
}

class _HomePageDeciderState extends State<HomePageDecider> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return isLoading ? Center(child: CircularProgressIndicator(),) : LoginForm();
  }
}

