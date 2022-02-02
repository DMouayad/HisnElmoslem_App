import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hisnelmoslem/controllers/dashboard_controller.dart';
import 'package:hisnelmoslem/models/zikr_content.dart';
import 'package:hisnelmoslem/models/zikr_title.dart';
import 'package:hisnelmoslem/providers/app_settings.dart';
import 'package:hisnelmoslem/shared/constant.dart';
import 'package:hisnelmoslem/shared/functions/send_email.dart';
import 'package:hisnelmoslem/shared/transition_animation/transition_animation.dart';

import 'package:hisnelmoslem/views/screens/azkar_read_card.dart';
import 'package:hisnelmoslem/views/screens/azkar_read_page.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

class FavouriteZikr extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appSettings = Provider.of<AppSettingsNotifier>(context);

    //
    return GetBuilder<DashboardController>(builder: (controller) {
      debugPrint("GetBuilder");
      return ListView.builder(
        itemCount: controller.favouriteConent.length,
        itemBuilder: (BuildContext context, int index) {
          //
          DbContent? dbContent = controller.favouriteConent[index];
          //
          DbTitle? dbTitle = controller.allTitle
              .where((element) => element.id == dbContent.titleId)
              .first;
          //
          return InkWell(
            splashColor: MAINCOLOR,
            onTap: () {
              if (dbContent.count > 0) {
                dbContent.count--;
                controller.update();
              }
            },
            child: Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                            splashRadius: 20,
                            padding: EdgeInsets.all(0),
                            icon: dbContent.favourite == 0
                                ? Icon(Icons.favorite_border,
                                    color: Colors.blue.shade200)
                                : Icon(Icons.favorite,
                                    color: Colors.blue.shade200),
                            onPressed: () {
                              controller.removeContentFromFavourite(dbContent);
                            }),
                        Expanded(
                          flex: 1,
                          child: IconButton(
                              splashRadius: 20,
                              padding: EdgeInsets.all(0),
                              icon:
                                  Icon(Icons.copy, color: Colors.blue.shade200),
                              onPressed: () {
                                FlutterClipboard.copy(dbContent.content +
                                        "\n" +
                                        dbContent.fadl)
                                    .then((result) {
                                  Get.snackbar("رسالة", 'تم النسخ إلى الحافظة');
                                  // Get..currentState!.showSnackBar(snackBar);
                                });
                              }),
                        ),
                        Expanded(
                          flex: 1,
                          child: IconButton(
                              splashRadius: 20,
                              padding: EdgeInsets.all(0),
                              icon: Icon(Icons.share,
                                  color: Colors.blue.shade200),
                              onPressed: () {
                                Share.share(
                                    dbContent.content + "\n" + dbContent.fadl);
                              }),
                        ),
                        Expanded(
                          flex: 1,
                          child: IconButton(
                              splashRadius: 20,
                              padding: EdgeInsets.all(0),
                              icon: Icon(Icons.report, color: Colors.orange),
                              onPressed: () {
                                sendEmail(
                                    toMailId: 'hassaneltantawy@gmail.com',
                                    subject: 'تطبيق حصن المسلم: خطأ إملائي ',
                                    body:
                                        ' السلام عليكم ورحمة الله وبركاته يوجد خطأ إملائي في' +
                                            '\n' +
                                            'الموضوع: ' +
                                            dbTitle.name +
                                            '\n' +
                                            'الذكر رقم: ' +
                                            '${dbContent.orderId}' +
                                            '\n' +
                                            'النص: ' +
                                            '${dbContent.content}' +
                                            '\n' +
                                            'والصواب:' +
                                            '\n');
                              }),
                        ),
                        Expanded(
                          flex: 1,
                          child: IconButton(
                            splashRadius: 20,
                            onPressed: () {
                              //TODO reset counter
                              //  dbContent.count =  ;
                              controller.update();
                            },
                            icon: Icon(Icons.repeat),
                          ),
                        ),
                      ],
                    ),
                    LinearProgressIndicator(
                      value: 1,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        MAINCOLOR,
                      ),
                      backgroundColor: Colors.grey,
                    ),
                    Container(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              dbContent.content.toString(),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              dbContent.fadl.toString(),
                              style: TextStyle(color: MAINCOLOR),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: CircleAvatar(
                              radius: 20,
                              backgroundColor: Theme.of(context).primaryColor,
                              child: Text(
                                dbContent.count.toString(),
                                style: TextStyle(color: MAINCOLOR),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ListTile(
                        tileColor: Theme.of(context).backgroundColor,
                        onTap: () {
                          String azkarReadMode = appSettings.getAzkarReadMode();
                          if (azkarReadMode == "Page") {
                            transitionAnimation.circleReval(
                                context: Get.context!,
                                goToPage: AzkarReadPage(index: dbTitle.id));
                          } else if (azkarReadMode == "Card") {
                            transitionAnimation.circleReval(
                                context: Get.context!,
                                goToPage: AzkarReadCard(index: dbTitle.id));
                          }
                        },
                        title: Text(
                          "الذهاب إلى ${dbTitle.name}",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      );
    });
  }
}
