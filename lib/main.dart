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
  HomePageDeciderState createState() => HomePageDeciderState();
}

class HomePageDeciderState extends State<HomePageDecider> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      firstChild: Center(child: CircularProgressIndicator(),),
      secondChild:  LoginForm(this),
      crossFadeState: isLoading ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      duration: Duration(
        milliseconds: 500,
      ),
    );
  }
}

