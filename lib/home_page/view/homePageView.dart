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

    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return GetBuilder<HomePageController>(
      // init: HomePageController(),
        builder: (homePageController) {
          return Container(
            height: height,
            width: width,
            color: AppColors.primaryColor,
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 40),
                      padding: EdgeInsets.all(10),
                      height: 45,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: width / 1.5,
                            child: Text(
                              controller.capitalizeFirstLetter(controller.cityName.value),
                              style: TextStyle(
                                color: AppColors.whiteColor,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {

                            },
                            child: Icon(
                              Icons.settings,
                              color: AppColors.whiteColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                        child: ListView(
                          children: [
                            Container(
                              margin: EdgeInsets.only(),
                              height: height / 5,
                              width: width,
                              padding: EdgeInsets.only(left: 20,right: 20),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "26°",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 85,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.whiteColor,
                                      decoration: TextDecoration.none,
                                    ),
                                  ),
                                  SizedBox(height: 10,),
                                  Text(
                                    "dataefwbjbfjbdbfwrwrbgibergbrifjccjhjhhhkfkfkfk",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.whiteColor,
                                      decoration: TextDecoration.none,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
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