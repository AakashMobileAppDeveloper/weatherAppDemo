import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class HomePageController extends GetxController {
  RxString cityName = "".obs;
  RxBool isLocationDenied = false.obs;
  RxInt deniedCount = 0.obs;

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

    List<Placemark> placemarks =
        await placemarkFromCoordinates(double.parse(position.latitude.toStringAsFixed(2)), double.parse(position.longitude.toStringAsFixed(2)));
    cityName.value = placemarks[0].locality.toString().toLowerCase();
    print("The value of the cityName.value is $cityName");
    print("The location is got $placemarks");
    update();
  }

  String capitalizeFirstLetter(String input) {
    if (input.isEmpty) return input; // Handle empty string
    return input[0].toUpperCase() + input.substring(1);
  }

}
