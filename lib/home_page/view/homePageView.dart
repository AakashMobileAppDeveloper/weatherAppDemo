import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather_demo_app/home_page/controller/homePageController.dart';
import 'package:weather_demo_app/utils/appColor.dart';

class HomePageView extends GetView<HomePageController> {
  HomePageView({super.key});

  @override
  // TODO: implement controller
  var controller = Get.put(HomePageController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomePageController>(
      // init: HomePageController(),
        builder: (homePageController) {
          return Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: AppColors.primaryColor,
            child: Stack(
              children: [

                Visibility(
                  visible: controller.isLocationDenied.value,
                    child: Center(
                      child: Container(
                        height: 130,
                        width: Get.width - 30,
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: AppColors.whiteColor,
                        ),
                        child: Column(
                          children: [
                            Text(
                              "By Default chennai weather will be displayed",
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                                color: AppColors.blackColor,
                                decoration: TextDecoration.none,
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    controller.isLocationDenied.value = false;
                                    controller.cityName.value = "chennai";
                                    controller.update();
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryColor,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Text(
                                      "Ok",
                                      style: TextStyle(
                                        color: AppColors.blackColor,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                        decoration: TextDecoration.none,
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    controller.isLocationDenied.value = false;
                                    if (controller.deniedCount.value >= 2)  {
                                      Get.snackbar("Warning", "Permission denied twice already will get the default chennai location");
                                      controller.cityName.value = "chennai";
                                    } else {
                                      controller.getLocationPermission();
                                    }
                                    controller.update();
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryColor,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Text(
                                      "Get Current Location",
                                      style: TextStyle(
                                        color: AppColors.blackColor,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                        decoration: TextDecoration.none,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                ),
              ],
            ),
          );
        }
    );
  }
}