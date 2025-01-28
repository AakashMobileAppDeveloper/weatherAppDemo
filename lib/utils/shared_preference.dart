import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class AppSharedPreference {

  static String cityName = "/cityName";
  static String totalDays = "/totalDays";

  Future<bool> hasWeatherData() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(totalDays);  // Returns true if the key exists
  }

  Future<void> saveCityName({required String cityNameValue}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(cityName, cityNameValue);
  }

  /// Retrieve the token from SharedPreferences
  Future<String?> getCityName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(cityName);
  }

  Future<void> saveWeatherData({required Map<String,dynamic> daysValue}) async {
    final prefs = await SharedPreferences.getInstance();
    var value = json.encode(daysValue);
    await prefs.setString(totalDays, value);
  }

  /// Retrieve the token from SharedPreferences
  Future<String?> getWeatherData() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(totalDays);
  }

}