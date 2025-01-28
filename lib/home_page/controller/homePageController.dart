import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:weather_demo_app/utils/appColor.dart';
import 'package:weather_demo_app/utils/network_conectivity_helper.dart';
import 'package:weather_demo_app/utils/shared_preference.dart';
import 'package:weather_demo_app/utils/weather_data_model.dart';

class HomePageController extends GetxController {

  RxBool isLocationDenied = false.obs;
  RxBool isLoading = false.obs;
  RxBool noDataFound = true.obs;
  RxBool hasLocalData = false.obs;

  RxString cityName = "".obs;
  RxString temperature = "metric".obs;
  RxString degreeMeasurement = "toFahrenheit".obs;
  RxString todayTemp = "".obs;

  RxList daysList = [].obs;
  RxList afterCurrentHours = [].obs;
  List<String> data = [
    "chennai",
    "coimbatore",
    "madurai",
    "tiruchirappalli",
    "cuddalore",
    "bangalore",
    "puducherry",
  ];

  RxInt deniedCount = 0.obs;
  WeatherDataModel? weatherDataModel;
  Days? currentDay;
  AppSharedPreference appSharedPreference = AppSharedPreference();
  var networkController = Get.put(CheckingInternetConnectivity());

  @override
  void onInit() {
    getLocationPermission();
    super.onInit();
  }

  getLocationPermission() async {
    PermissionStatus locationPermission = await Permission.location.status;

    if (locationPermission == PermissionStatus.denied ||
        locationPermission == PermissionStatus.permanentlyDenied) {
      locationPermission = await Permission.location.request();
    }

    print("The permission of the location is ${locationPermission}");

    if (locationPermission.isGranted) {
      geoLocation();
    } else {
      isLocationDenied.value = true;
      deniedCount.value = deniedCount.value + 1;
    }
    update();
  }

  geoLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    List<Placemark> placemarks = await placemarkFromCoordinates(
        double.parse(position.latitude.toStringAsFixed(2)),
        double.parse(position.longitude.toStringAsFixed(2)));

    print("The value of the cityName.value is $cityName");
    print("The location is got $placemarks");
    hasLocalData.value = await appSharedPreference.hasWeatherData();
    if (networkController.internetAvailable.value) {
      fetchData();
      cityName.value = placemarks[0].locality.toString().toLowerCase();
      appSharedPreference.saveCityName(cityNameValue: cityName.value);
    } else {
      if (hasLocalData.value) {
        noDataFound.value = false;
        setLocalUI();
      } else {
        noDataFound.value = true;
      }
    }
    update();
  }

  setLocalUI() async {

    final now = DateTime.now();
    final currentHour = now.hour;
    final todayDate = DateTime.now().toIso8601String().split('T')[0];
    isLoading.value = true;
    cityName.value = await appSharedPreference.getCityName() ?? "";

    var value = await appSharedPreference.getWeatherData() ?? "";

    var decodeData = json.decode(value);
    
    weatherDataModel = WeatherDataModel.fromJson(decodeData);
    
    currentDay =
        weatherDataModel?.days?.firstWhere((day) => day.datetime == todayDate);
    daysList.clear();
    daysList.addAll(weatherDataModel?.days?.where((day) {
      final dayDate =
      DateTime.parse(day.datetime); // Parse the day datetime
      final difference = dayDate
          .difference(now)
          .inDays; // Calculate the difference in days
      return difference >= 0 &&
          difference < 6; // Include today and the next 6 days
    }).toList() ?? []);
    afterCurrentHours.clear();
    afterCurrentHours.addAll(currentDay?.hours?.where((hour) {
      final hourTime = int.parse(hour.datetime.split(':')[0]);
      return hourTime >=
          currentHour; // Include hours from the current hour onward
    }).toList() ??
        []);

    print('Today\'s afterCurrentHours are: ${afterCurrentHours.first}');
    if (currentDay != null) {
      // Get the temperature for today
      todayTemp.value = currentDay?.temp.floor().toString() ?? "";
      print('Today\'s Temp: $todayTemp');
    }
    isLoading.value = false;
    update();
  }

  fetchData() async {
    isLoading.value = true;
    weatherDataModel = await getWeatherData();

    final now = DateTime.now();
    final currentHour = now.hour;

    // 1. Get today's date in YYYY-MM-DD format
    final todayDate = DateTime.now().toIso8601String().split('T')[0];
    print("The value of the today date is $todayDate");
    // 2. Find today's day data
    currentDay =
        weatherDataModel?.days?.firstWhere((day) => day.datetime == todayDate);
    daysList.clear();
    daysList.addAll(weatherDataModel?.days?.where((day) {
          final dayDate =
              DateTime.parse(day.datetime); // Parse the day datetime
          final difference = dayDate
              .difference(now)
              .inDays; // Calculate the difference in days
          return difference >= 0 &&
              difference < 6; // Include today and the next 6 days
        }).toList() ??
        []);
    afterCurrentHours.clear();

    afterCurrentHours.addAll(currentDay?.hours?.where((hour) {
          final hourTime = int.parse(hour.datetime.split(':')[0]);
          return hourTime >=
              currentHour; // Include hours from the current hour onward
        }).toList() ??
        []);

    print('Today\'s afterCurrentHours are: ${afterCurrentHours.first}');
    if (currentDay != null) {
      // Get the temperature for today
      todayTemp.value = currentDay?.temp.floor().toString() ?? "";
      print('Today\'s Temp: $todayTemp');
    }
    isLoading.value = false;
    update();
  }

  String formatDateWithDay(DateTime date) {
    final today = DateTime.now();
    final tomorrow = today.add(Duration(days: 1));
    final DateFormat formatter = DateFormat('d MMM E'); // Example: 28 Jan Tue

    if (isSameDate(date, today)) {
      return '${formatter.format(date)} Today';
    } else if (isSameDate(date, tomorrow)) {
      return '${formatter.format(date)} Tomorrow';
    } else {
      return formatter.format(date); // Example: 30 Jan Thu
    }
  }

  bool isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  String description() {
    if (currentDay?.humidity != null) {
      return "${currentDay?.conditions ?? ""} ${currentDay?.tempmax ?? ""}° / ${currentDay?.tempmin ?? ""}° AirQuality: ${currentDay?.humidity.floor()}";
    } else {
      return "${currentDay?.conditions ?? ""} ${currentDay?.tempmax ?? ""}° / ${currentDay?.tempmin ?? ""}°";
    }
  }

  String capitalizeFirstLetter(String input) {
    if (input.isEmpty) return input; // Handle empty string
    return input[0].toUpperCase() + input.substring(1);
  }

  getWeatherData() async {
    try {
      Dio dio = Dio();
      String url =
          "https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/${cityName.value}?unitGroup=${temperature.value}&key=K7LWHE83HRTBV25PJTU3QQABM&contentType=json";
      var response = await dio.get(url);

      if (response.statusCode == 200) {
        var data = response.data;
        appSharedPreference.saveWeatherData(daysValue: data);
        WeatherDataModel values = WeatherDataModel.fromJson(data);
        noDataFound.value = false;
        return values;
      }
    } catch (e) {
      print("the error occured $e");
    }
  }

  degreeConvertor() {
    if (networkController.internetAvailable.value) {
      if (degreeMeasurement.value == "toFahrenheit") {
        degreeMeasurement.value = "toCelsius";
        temperature.value = "us";
      } else {
        degreeMeasurement.value = "toFahrenheit";
        temperature.value = "metric";
      }
      fetchData();
    } else {
      Get.snackbar(
        "ALERT!",
        "PLEASE CONNECT TO THE INTERNET",
        snackPosition: SnackPosition.TOP,
        backgroundColor: AppColors.blackColor.withAlpha(150),
        colorText: AppColors.whiteColor,
        duration: const Duration(days: 1),
      );
    }
    update();
  }
}
