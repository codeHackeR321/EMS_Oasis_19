import 'dart:convert';

import 'package:ems_oasis_19/Config.dart';
import 'package:ems_oasis_19/addTeamMembers/addTeamMember.dart';
import 'package:ems_oasis_19/eventsList/EventsRepository.dart';
import 'package:ems_oasis_19/eventsList/view/EventListScreen.dart';
import 'package:ems_oasis_19/eventsProvider/EventPages.dart';
import 'package:ems_oasis_19/eventsProvider/EventsScreen.dart';
import 'package:ems_oasis_19/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginForm extends StatefulWidget {
  // HomePageDeciderState parent;

  LoginForm();

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  TextEditingController userNameController = TextEditingController(text: "test_cd");
  TextEditingController passwordController = TextEditingController(text: "test123456");

  @override
  Widget build(BuildContext context) {
    return isLoading ? 
      Center(
        child: CircularProgressIndicator(),
      ) :
      Container(
      child: Center(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment:MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 24.0),
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0,0.0,16.0,16.0),
                child: Text(
                 'Login',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32.0
                  ),
                ),
              ),
              SizedBox(height: 24.0),
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0,0.0,16.0,8.0),
                child: TextFormField(
                  controller: userNameController,
                  decoration: InputDecoration(
                    hintText: "Enter Username"
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 24.0),
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0,0.0,16.0,8.0),
                child: TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: "Enter Password"
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter some text2';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0,0.0,16.0,8.0),
                child: RaisedButton(
                  onPressed: () {
                    /* widget.parent.setState(() {
                      widget.parent.isLoading = true;                  
                    }); */
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => AddTeamMemberPage()));
                    // Validate returns true if the form is valid, or false
                    // otherwise.
                    if (_formKey.currentState.validate()) {
                      String username = userNameController.text;
                      String password = passwordController.text;
                      setState(() {
                       isLoading = true; 
                      });
                      loginUser(username, password);
                      // navigateToNextPage();
                      // If the form is valid, display a Snackbar.
                      // Scaffold.of(context).showSnackBar(SnackBar(content: Text('Processing Data')));
                    }
                  },
                  child: Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<Null> loginUser(String username, String password) async {
    http.post(Config.authUrl,
      body: json.encode({
        "username": username,
        "password": password
      }),
       headers: {"Content-Type": "application/json"}
    ).then((http.Response response) async {
        print("Login response = ${response.body.toString()}");
        if(response.statusCode == 200) {
          var body = json.decode(response.body);
          print("Login Body = ${body.toString()}");
          try{
            String jwt = body["access"];
            String refresh = body["refresh"];
            print("Saving $jwt, and \n $refresh in shared preferences");
            bool saveSuccessful = await saveJwtSharedPrefs(jwt, refresh);
            if(!saveSuccessful){
              throw Exception("Unable to save data in Shared Preferences");
            }
            setState(() {
             isLoading = false; 
             navigateToNextPage();
            });
            print("Login Sucewssful");
          } catch(e) {
            print(e.toString());
            loginUser(username, password);
          }
        }
        else{
          print("Error in Logging in");
          print(response.statusCode);
        }
    });
  }

  Future<bool> saveJwtSharedPrefs(String jwt, String refresh) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    try {
      await sharedPreferences.setString(Config.jwtKey, jwt);
    await sharedPreferences.setString(Config.refreshKey, refresh);
    } catch(e) {
      print(e.toString());
      return false;
    }
    return true;
  }

  Future<Null> navigateToNextPage() async { 
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => EventScreen()));
   }
}