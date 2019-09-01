class Config {
  static String jwtKey = "JWT";
  static String refreshKey = "Refresh";
  static String baseUrl = "http://test1.bits-oasis.org/ems";
  static String authUrl = baseUrl+"/jwt/get_token/";
  static String refreshUrl = baseUrl+"/jwt/refresh_token";
}