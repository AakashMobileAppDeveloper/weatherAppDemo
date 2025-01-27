import 'package:get/get.dart';
import 'package:weather_demo_app/home_page/binding/homePageBinding.dart';
import 'package:weather_demo_app/home_page/view/homePageView.dart';

class Pages {
  Pages._();

  static const String home = "/home";

  static final routes = [
    GetPage(
      name: home,
      page: () => HomePageView(),
      binding: HomePageBinding(),
    ),
  ];
}
