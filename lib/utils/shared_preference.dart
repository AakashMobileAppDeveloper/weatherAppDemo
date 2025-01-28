import 'package:shared_preferences/shared_preferences.dart';

class AppSharedPreference {

  static String cityName = "/cityName";
  static String degreeMeasurement = "/degreeMeasurement";
  static String degreeValue = "/degreeValue";

  Future<bool> hasCityName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(cityName);  // Returns true if the key exists
  }

  Future<void> saveCityName({required String bearerToken}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(cityName, bearerToken);
  }

  /// Retrieve the token from SharedPreferences
  Future<String?> getCityName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(cityName);
  }

  Future<void> saveDegreeMeasurement({required String bearerToken}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(cityName, bearerToken);
  }

  /// Retrieve the token from SharedPreferences
  Future<String?> getDegreeMeasurement() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(cityName);
  }

  Future<void> saveDegreeValue({required String bearerToken}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(cityName, bearerToken);
  }

  /// Retrieve the token from SharedPreferences
  Future<String?> getDegreeValue() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(cityName);
  }
}