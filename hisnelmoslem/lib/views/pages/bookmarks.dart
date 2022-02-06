import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hisnelmoslem/controllers/dashboard_controller.dart';
import 'package:hisnelmoslem/models/alarm.dart';
import 'package:hisnelmoslem/shared/cards/zikr_card.dart';

class AzkarBookmarks extends StatelessWidget {
  const AzkarBookmarks({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashboardController>(builder: (controller) {
      return Scaffold(
        body: Scrollbar(
          controller: controller.bookmarksScrollController,
          isAlwaysShown: false,
          child: new ListView.builder(
            padding: EdgeInsets.only(top: 10),
            itemBuilder: (context, index) {
              //TODO get rid of this for loop
              DbAlarm tempAlarm =
                  DbAlarm(titleId: controller.favouriteTitle[index].orderId);
              for (var item in controller.alarms) {
                // debugPrint(item.toString());
                if (item.title == controller.favouriteTitle[index].name) {
                  tempAlarm = item;
                }
              }
              controller.favouriteTitle
                  .sort((a, b) => a.orderId.compareTo(b.orderId));
              return TitleCard(
                fehrsTitle: controller.favouriteTitle[index],
                //controller.alarms
                dbAlarm: tempAlarm,
              );
            },
            itemCount: controller.favouriteTitle.length,
          ),
        ),
      );
    });
  }
}
