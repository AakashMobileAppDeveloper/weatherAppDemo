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
            Visibility(
              visible: !controller.noDataFound.value,
              child: Column(
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
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text("Select an City"),
                                  content: SizedBox(
                                    width: double.maxFinite, // Ensures the dialog is scrollable
                                    child: ListView.builder(
                                      shrinkWrap: true, // Ensures it only takes as much space as needed
                                      itemCount: controller.data.length,
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).pop();
                                            controller.cityName.value = controller.data[index];
                                            controller.appSharedPreference.saveCityName(cityNameValue: controller.cityName.value);
                                            Future.delayed(Duration(microseconds: 1500), () {
                                              controller.fetchData();
                                            });
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: AppColors.secondaryColor,
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              padding: const EdgeInsets.all(16.0),
                                              child: Text(
                                                controller
                                                    .capitalizeFirstLetter(controller.data[index]),
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.of(context).pop(),
                                      child: const Text("Close"),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Row(
                            children: [
                              Icon(
                                Icons.arrow_drop_down,
                                color: AppColors.whiteColor,
                              ),
                              SizedBox(width: 5,),
                              SizedBox(
                                width: width / 2.5,
                                child: Text(
                                  controller
                                      .capitalizeFirstLetter(controller.cityName.value),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: AppColors.whiteColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            controller.degreeConvertor();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(
                                Icons.compare_arrows_rounded,
                                color: AppColors.whiteColor,
                              ),
                              SizedBox(width: 5,),
                              Text(
                                controller.degreeMeasurement.value,
                                style: TextStyle(
                                  color: AppColors.whiteColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 2,),
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
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "${controller.todayTemp.value}°",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 85,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.whiteColor,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                controller.description(),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.whiteColor,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 110,
                          margin: EdgeInsets.only(left: 18, right: 18),
                          padding: EdgeInsets.only(left: 20, top: 15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: AppColors.secondaryColor,
                          ),
                          child: ListView.builder(
                            itemCount: controller.afterCurrentHours.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: EdgeInsets.only(right: 25),
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text(
                                        index == 0 ? "Now" : "${controller.afterCurrentHours[index].datetime.split(':')[0]}:${controller.afterCurrentHours[index].datetime.split(':')[1]}",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: AppColors.whiteColor,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            decoration: TextDecoration.none),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      SizedBox(
                                        width: 75,
                                        height: 30,
                                        child: Center(
                                          child: Text(
                                            controller.afterCurrentHours[index].conditions.toString(),
                                            textAlign: TextAlign.center,
                                            maxLines: 2,
                                            style: TextStyle(
                                                color: AppColors.whiteColor,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500,
                                                decoration: TextDecoration.none),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "${controller.afterCurrentHours[index].temp.floor()}°",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: AppColors.whiteColor,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            decoration: TextDecoration.none),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              left: 18, right: 18, top: 15, bottom: 25),
                          padding: EdgeInsets.only(left: 20, top: 15, right: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: AppColors.secondaryColor,
                          ),
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: controller.daysList.length,
                            itemBuilder: (context, index) {
                              return Container(
                                height: 50,
                                margin: EdgeInsets.only(bottom: 10),
                                child: Center(
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: width / 3.5,
                                        child: Text(
                                          controller.formatDateWithDay(DateTime.parse(controller.daysList[index].datetime ?? DateTime.now().toString())),
                                          style: TextStyle(
                                            color: AppColors.whiteColor,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            decoration: TextDecoration.none,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: 10,right: 10),
                                        width: 75,
                                        child: Text(
                                          "${controller.daysList[index].conditions}",
                                          style: TextStyle(
                                            color: AppColors.whiteColor,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            decoration: TextDecoration.none,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 85,
                                        child: Text(
                                          "${controller.daysList[index].tempmin.floor()}° / ${controller.daysList[index].tempmax.floor()}°",
                                          style: TextStyle(
                                            color: AppColors.whiteColor,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            decoration: TextDecoration.none,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: controller.noDataFound.value,
                child: Container(
                  height: height,
                  width: width,
                  color: AppColors.primaryColor,
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.signal_wifi_connected_no_internet_4,
                          color: AppColors.whiteColor,
                          size: 75,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Kindly Turn on Internet to get weather update.Since you are new to our app",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.whiteColor,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
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
                              controller.fetchData();
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
                              if (controller.deniedCount.value >= 2) {
                                Get.snackbar("Warning",
                                    "Permission denied twice already will get the default chennai location");
                                controller.cityName.value = "chennai";
                                controller.fetchData();
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
            Visibility(
              visible: controller.isLoading.value,
              child: Container(
                width: width,
                height: height,
                color: AppColors.blackColor.withAlpha(100),
                child: Center(
                  child: CircularProgressIndicator(
                    color: AppColors.whiteColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
