import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hisnelmoslem/Shared/Widgets/Loading.dart';
import 'package:hisnelmoslem/Utils/azkar_database_helper.dart';
import 'package:hisnelmoslem/controllers/dashboard_controller.dart';
import 'package:hisnelmoslem/models/zikr_content.dart';
import 'package:hisnelmoslem/models/zikr_title.dart';
import 'package:hisnelmoslem/providers/app_settings.dart';
import 'package:hisnelmoslem/shared/constant.dart';
import 'package:hisnelmoslem/shared/functions/send_email.dart';
import 'package:hisnelmoslem/shared/transition_animation/transition_animation.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:wakelock/wakelock.dart';

import 'share_as_image.dart';

class AzkarReadCard extends StatefulWidget {
  final int index;

  const AzkarReadCard({required this.index});

  @override
  _AzkarReadCardState createState() => _AzkarReadCardState();
}

class _AzkarReadCardState extends State<AzkarReadCard> {
  final _vReadScaffoldKey = GlobalKey<ScaffoldState>();
  bool? isLoading = true;
  double? totalProgress = 0.0;
  //
  List<DbContent> zikrContent = <DbContent>[];
  DbTitle? zikrTitle;
  //
  @override
  void initState() {
    Wakelock.enable();
    getReady();
    super.initState();
  }

  getReady() async {
    await azkarDatabaseHelper
        .getTitleById(id: widget.index)
        .then((value) => zikrTitle = value);
    //
    await azkarDatabaseHelper
        .getContentsByTitleId(titleId: widget.index)
        .then((value) => zikrContent = value);

    setState(() {
      isLoading = false;
    });
  }

  checkProgress() {
    int totalNum = 0, done = 0;
    totalNum = zikrContent.length;
    for (var i = 0; i < zikrContent.length; i++) {
      if (zikrContent[i].count == 0) {
        done++;
      }
    }
    setState(() {
      totalProgress = done / totalNum;
    });
  }

  @override
  void dispose() {
    Wakelock.disable();
    super.dispose();
  }

  DashboardController dashboardController = Get.put(DashboardController());

  @override
  Widget build(BuildContext context) {
    final appSettings = Provider.of<AppSettingsNotifier>(context);
    return isLoading!
        ? Loading()
        : Scaffold(
            key: _vReadScaffoldKey,
            appBar: AppBar(
              title: Text(zikrTitle!.name,
                  style: TextStyle(fontFamily: "Uthmanic")),
              bottom: PreferredSize(
                preferredSize: Size(100, 5),
                child: LinearProgressIndicator(
                  value: totalProgress,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    blue,
                  ),
                  backgroundColor: grey,
                ),
              ),
            ),
            body: ScrollConfiguration(
              behavior: ScrollBehavior(),
              child: GlowingOverscrollIndicator(
                axisDirection: AxisDirection.down,
                color: black26,
                child: ListView.builder(
                  itemCount: zikrContent.length.isNaN ? 0 : zikrContent.length,
                  itemBuilder: (context, index) {
                    String text = appSettings.getTashkelStatus()
                        ? zikrContent[index].content
                        : zikrContent[index].content.replaceAll(
                            //* لحذف التشكيل
                            new RegExp(String.fromCharCodes([
                              1617,
                              124,
                              1614,
                              124,
                              1611,
                              124,
                              1615,
                              124,
                              1612,
                              124,
                              1616,
                              124,
                              1613,
                              124,
                              1618
                            ])),
                            "");
                    String source = zikrContent[index].source;
                    String fadl = zikrContent[index].fadl;
                    int cardnum = index + 1;
                    int _counter = zikrContent[index].count;
                    return InkWell(
                      onTap: () {
                        if (_counter > 0) {
                          _counter--;

                          setState(() {
                            zikrContent[index].count = (_counter);
                          });

                          if (_counter == 0) {
                            HapticFeedback.vibrate();
                          } else if (_counter < 0) {
                            _counter = 0;
                          }
                        }
                        checkProgress();
                      },
                      onLongPress: () {
                        final snackBar = SnackBar(
                          content: Text(
                            source,
                            textAlign: TextAlign.center,
                            softWrap: true,
                          ),
                          action: SnackBarAction(
                              label: 'نسخ',
                              onPressed: () {
                                // Some code to undo the change.
                                FlutterClipboard.copy(source).then((result) {
                                  final snackBar = SnackBar(
                                    content: Text('تم النسخ إلى الحافظة'),
                                    action: SnackBarAction(
                                      label: 'تم',
                                      onPressed: () {},
                                    ),
                                  );

                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                });
                              }),
                        );

                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      },
                      child: Card(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                    child: IconButton(
                                  splashRadius: 20,
                                  icon: Icon(MdiIcons.camera),
                                  onPressed: () {
                                    transitionAnimation.circleReval(
                                        context: Get.context!,
                                        goToPage: ShareAsImage(
                                            dbContent: zikrContent[index]));
                                  },
                                )),
                                !zikrContent[index].favourite
                                    ? IconButton(
                                        splashRadius: 20,
                                        padding: EdgeInsets.all(0),
                                        icon: Icon(Icons.favorite_border,
                                            color: bleuShade200),
                                        onPressed: () {
                                          setState(() {
                                            zikrContent[index].favourite = true;
                                          });
                                          dashboardController
                                              .addContentToFavourite(
                                                  zikrContent[index]);
                                        })
                                    : IconButton(
                                        splashRadius: 20,
                                        padding: EdgeInsets.all(0),
                                        icon: Icon(
                                          Icons.favorite,
                                          color: bleuShade200,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            zikrContent[index].favourite =
                                                false;
                                          });
                                          dashboardController
                                              .removeContentFromFavourite(
                                                  zikrContent[index]);
                                        }),
                                Expanded(
                                  flex: 1,
                                  child: IconButton(
                                      splashRadius: 20,
                                      padding: EdgeInsets.all(0),
                                      icon:
                                          Icon(Icons.copy, color: bleuShade200),
                                      onPressed: () {
                                        FlutterClipboard.copy(
                                                text + "\n" + fadl)
                                            .then((result) {
                                          final snackBar = SnackBar(
                                            content:
                                                Text('تم النسخ إلى الحافظة'),
                                            action: SnackBarAction(
                                              label: 'تم',
                                              onPressed: () {},
                                            ),
                                          );
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(snackBar);
                                        });
                                      }),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: IconButton(
                                      splashRadius: 20,
                                      padding: EdgeInsets.all(0),
                                      icon: Icon(Icons.share,
                                          color: bleuShade200),
                                      onPressed: () {
                                        Share.share(text + "\n" + fadl);
                                      }),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: IconButton(
                                      splashRadius: 20,
                                      padding: EdgeInsets.all(0),
                                      icon: Icon(Icons.report, color: orange),
                                      onPressed: () {
                                        sendEmail(
                                            toMailId:
                                                'hassaneltantawy@gmail.com',
                                            subject:
                                                'تطبيق حصن المسلم: خطأ إملائي ',
                                            body:
                                                ' السلام عليكم ورحمة الله وبركاته يوجد خطأ إملائي في' +
                                                    '\n' +
                                                    'الموضوع: ' +
                                                    zikrTitle!.name +
                                                    '\n' +
                                                    'الذكر رقم: ' +
                                                    '$cardnum' +
                                                    '\n' +
                                                    'النص: ' +
                                                    '$text' +
                                                    '\n' +
                                                    'والصواب:' +
                                                    '\n');
                                      }),
                                ),
                              ],
                            ),
                            Divider(),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 20, 10, 5),
                              child: Text(
                                text,
                                textAlign: TextAlign.center,
                                softWrap: true,
                                textDirection: TextDirection.rtl,
                                style: TextStyle(
                                    fontSize: appSettings.getfontSize() * 10,
                                    color: zikrContent[index].count == 0
                                        ? MAINCOLOR
                                        : white,
                                    //fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            zikrContent[index].fadl == ""
                                ? SizedBox()
                                : Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        10, 10, 10, 20),
                                    child: Text(
                                      zikrContent[index].fadl,
                                      textAlign: TextAlign.center,
                                      textDirection: TextDirection.rtl,
                                      softWrap: true,
                                      style: TextStyle(
                                          fontSize:
                                              appSettings.getfontSize() * 10,
                                          color: MAINCOLOR,
                                          //fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                            Divider(),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: CircleAvatar(
                                backgroundColor: Theme.of(context).primaryColor,
                                child: Text(
                                  zikrContent[index].count.toString(),
                                  style: TextStyle(color: MAINCOLOR),
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
            ),
            bottomNavigationBar: BottomAppBar(
              //elevation: 20,
              color: Theme.of(context).primaryColor,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Expanded(
                      flex: 1,
                      child: IconButton(
                          icon: Icon(MdiIcons.formatFontSizeIncrease),
                          onPressed: () {
                            setState(() {
                              appSettings
                                  .setfontSize(appSettings.getfontSize() + 0.3);
                            });
                          })),
                  Expanded(
                      flex: 1,
                      child: IconButton(
                          icon: Icon(MdiIcons.formatFontSizeDecrease),
                          onPressed: () {
                            setState(() {
                              appSettings
                                  .setfontSize(appSettings.getfontSize() - 0.3);
                            });
                          })),
                  Expanded(
                      flex: 1,
                      child: IconButton(
                          icon: Icon(MdiIcons.abjadArabic),
                          onPressed: () {
                            setState(() {
                              appSettings.toggleTashkelStatus();
                            });
                          })),
                ],
              ),
            ),
          );
  }
}
