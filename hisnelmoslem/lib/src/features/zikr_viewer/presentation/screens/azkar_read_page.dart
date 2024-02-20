import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hisnelmoslem/src/core/repos/app_data.dart';
import 'package:hisnelmoslem/src/core/shared/widgets/loading.dart';
import 'package:hisnelmoslem/src/core/values/constant.dart';
import 'package:hisnelmoslem/src/features/home/presentation/controller/dashboard_controller.dart';
import 'package:hisnelmoslem/src/features/zikr_viewer/presentation/components/zikr_viewer_page_mode_appbar.dart';
import 'package:hisnelmoslem/src/features/zikr_viewer/presentation/components/zikr_viewer_page_mode_bottom_bar.dart';
import 'package:hisnelmoslem/src/features/zikr_viewer/presentation/controller/azkar_read_page_controller.dart';

class AzkarReadPage extends StatelessWidget {
  final int index;

  const AzkarReadPage({super.key, required this.index});
  static DashboardController dashboardController =
      Get.put(DashboardController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AzkarReadPageController>(
      init: AzkarReadPageController(index: index),
      builder: (controller) {
        String? text = "";
        String? source = "";
        String? fadl = "";
        int? cardNumber = 0;
        if (!controller.isLoading) {
          text = appData.isTashkelEnabled
              ? controller.zikrContent[controller.currentPage].content
              : controller.zikrContent[controller.currentPage].content
                  .replaceAll(
                  //* لحذف التشكيل
                  RegExp(String.fromCharCodes(arabicTashkelChar)),
                  "",
                );

          source = controller.zikrContent[controller.currentPage].source;
          fadl = controller.zikrContent[controller.currentPage].fadl;
          cardNumber = controller.currentPage + 1;
        }

        return controller.isLoading
            ? const Loading()
            : Scaffold(
                key: controller.hReadScaffoldKey,
                appBar: AppBar(
                  centerTitle: true,
                  title: Text(
                    controller.zikrTitle!.name,
                  ),
                  actions: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "${controller.currentPage + 1}::${controller.zikrContent.length}",
                      ),
                    ),
                  ],
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(50),
                    child: ZikrViewerPageModeAppBar(
                      controller: controller,
                      text: text,
                      fadl: fadl,
                    ),
                  ),
                ),
                body: PageView.builder(
                  physics: const BouncingScrollPhysics(),
                  onPageChanged: controller.onPageViewChange,
                  controller: controller.pageController,
                  itemCount: controller.zikrContent.length.isNaN
                      ? 0
                      : controller.zikrContent.length,
                  itemBuilder: (context, index) {
                    /* I repeated this code here to prevent text to be look like
                         the text in the next page when we swipe */
                    final String text = appData.isTashkelEnabled
                        ? controller.zikrContent[index].content
                        : controller.zikrContent[index].content.replaceAll(
                            //* لحذف التشكيل
                            RegExp(String.fromCharCodes(arabicTashkelChar)),
                            "",
                          );
                    final bool containsAyah = text.contains("﴿");
                    return GestureDetector(
                      onTap: () {
                        controller.decreaseCount();
                      },
                      onLongPress: () {
                        final snackBar = SnackBar(
                          content: Text(
                            source!,
                            textAlign: TextAlign.center,
                            softWrap: true,
                          ),
                          action: SnackBarAction(
                            label: "copy".tr,
                            onPressed: () {
                              // Some code to undo the change.
                              FlutterClipboard.copy(source!).then((result) {
                                final snackBar = SnackBar(
                                  content: Text("copied to clipboard".tr),
                                  action: SnackBarAction(
                                    label: "done".tr,
                                    onPressed: () {},
                                  ),
                                );

                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              });
                            },
                          ),
                        );

                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      },
                      child: Stack(
                        children: [
                          Center(
                            child: FittedBox(
                              child: Text(
                                "${controller.zikrContent[index].count}",
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withOpacity(.2),
                                  fontSize: 250,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          ListView(
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.only(top: 10),
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 20, 10, 5),
                                child: Text(
                                  text,
                                  textAlign: TextAlign.center,
                                  softWrap: true,
                                  textDirection: TextDirection.rtl,
                                  style: TextStyle(
                                    fontSize: appData.fontSize * 10,
                                    height: 2,

                                    fontFamily:
                                        containsAyah ? "Uthmanic2" : null,
                                    // fontSize: 20,
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 10, 10, 20),
                                child: Text(
                                  controller.zikrContent[index].fadl,
                                  textAlign: TextAlign.center,
                                  textDirection: TextDirection.rtl,
                                  softWrap: true,
                                  style: TextStyle(
                                    fontSize: appData.fontSize * 10,
                                    height: 2,

                                    //fontSize: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
                bottomNavigationBar: ZikrViewerPageModeBottomBar(
                  controller: controller,
                  text: text,
                  fadl: fadl,
                  cardNumber: cardNumber,
                ),
              );
      },
    );
  }
}
