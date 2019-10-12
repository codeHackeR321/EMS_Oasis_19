import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Config {
  static String jwtKey = "JWT";
  static String refreshKey = "Refresh";
  static String testUrl = "https://private-anon-b0dfecf108-emsoasis19.apiary-mock.com/ems";
  static String productionUrl = "https://testwallet.bits-oasis.org/ems";
  static String baseUrl = productionUrl;
  static String authUrl = baseUrl+"/jwt/get_token/";
  static String refreshUrl = baseUrl+"/jwt/refresh_token/";
  static String eventsListUrl = baseUrl+"/events/app";
  static String membersList = baseUrl+"/events/";

  static Future<Null> refreshJWTToken() async {
    String jwtToken = await getJWTFromSharedPreferences();
    String refresh = await getRefreshToken();
    http.post(refreshUrl,
    body: json.encode({
      "refresh": refresh
    }),
    headers: {"Authorization":"Bearer $jwtToken", "Content-Type": "application/json"}
    ).then((http.Response response) async {
     if(response.statusCode == 200) {
          var body = json.decode(response.body);
          try{
            String jwt = body["access"];
            bool saveSuccessful = await saveJwtSharedPrefs(jwt, refresh);
            if(!saveSuccessful){
              throw Exception("Unable to save data in Shared Preferences");
            }
            print("Refresh Sucewssful");
          } catch(e) {
            print(e.toString());
            refreshJWTToken();
          }
        }
        else{
          print("Error in Refreshing in");
          print(response.statusCode);
          print(response.body.toString());
        } 
    });
  }

  static Future<bool> saveJwtSharedPrefs(String jwt, String refresh) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    try {
      await sharedPreferences.setString(jwtKey, jwt);
    await sharedPreferences.setString(refreshKey, refresh);
    } catch(e) {
      print(e.toString());
      return false;
    }
    return true;
  }
  
  static Future<String> getRefreshToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String key = "";
    try {
      key = await sharedPreferences.getString(refreshKey);
    } catch(e) {
      print("Error in reading JWT = ${e.toString()}");
    }
    return key;
  }

  static Future<String> getJWTFromSharedPreferences() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String key = "";
    try {
      key = await sharedPreferences.getString(Config.jwtKey);
    } catch(e) {
      print("Error in reading JWT = ${e.toString()}");
    }
    return key;
  }
}