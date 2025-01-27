import 'package:get/get.dart';
import 'package:weather_demo_app/home_page/controller/homePageController.dart';

class HomePageBinding extends Bindings {

  @override
  void dependencies() {
    Get.lazyPut<HomePageController>(() {
      return HomePageController();
    });
  }

}