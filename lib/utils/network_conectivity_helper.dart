import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:weather_demo_app/home_page/controller/homePageController.dart';
import 'package:weather_demo_app/utils/appColor.dart';

class CheckingInternetConnectivity extends GetxController {
  Connectivity connectivity = Connectivity();
  RxBool internetAvailable = false.obs;

  @override
  void onInit() {
    super.onInit();
    /// Listen to connectivity changes and expect a List<ConnectivityResult>
    connectivity.onConnectivityChanged.listen(
          (List<ConnectivityResult> results) {
        if (results.isNotEmpty) {
          /// Process the first ConnectivityResult from the list
          updateConnectionStatus(results.first);
        }
      },
    );
  }

  void updateConnectionStatus(ConnectivityResult connectivityResult) {
    if (connectivityResult == ConnectivityResult.none) {
      /// Show an alert if there is no connection
      internetAvailable.value = false;
      Get.snackbar(
        "ALERT!",
        "PLEASE CONNECT TO THE INTERNET",
        snackPosition: SnackPosition.TOP,
        backgroundColor: AppColors.blackColor.withAlpha(150),
        colorText: AppColors.whiteColor,
        duration: const Duration(days: 1),
      );
    } else {
      /// Close the snack bar if the internet is reconnected
      internetAvailable.value = true;
      if (Get.isSnackbarOpen) {
        Get.closeCurrentSnackbar();
      }
      Get.put(HomePageController()).fetchData();
    }
  }
}
