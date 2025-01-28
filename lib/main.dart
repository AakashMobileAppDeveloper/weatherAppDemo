import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather_demo_app/pages.dart';
import 'package:weather_demo_app/utils/network_conectivity_helper.dart';

void main() {
  Get.put<CheckingInternetConnectivity>(
    CheckingInternetConnectivity(),
    permanent: true,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      getPages: Pages.routes,
      initialRoute: Pages.home,
    );
  }
}