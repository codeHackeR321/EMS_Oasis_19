class Config {
  static String jwtKey = "JWT";
  static String refreshKey = "Refresh";
  static String testUrl = "https://private-anon-b0dfecf108-emsoasis19.apiary-mock.com/ems";
  static String productionUrl = "http://test1.bits-oasis.org/ems";
  static String baseUrl = testUrl;
  static String authUrl = baseUrl+"/jwt/get_token/";
  static String refreshUrl = baseUrl+"/jwt/refresh_token";
  static String eventsListUrl = baseUrl+"/events/app";
}