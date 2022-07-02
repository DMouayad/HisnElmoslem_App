import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hisnelmoslem/controllers/app_data_controllers.dart';
import 'package:hisnelmoslem/controllers/quran_controller.dart';
import 'package:hisnelmoslem/shared/functions/print.dart';
import 'package:hisnelmoslem/shared/transition_animation/transition_animation.dart';
import 'package:hisnelmoslem/shared/widgets/loading.dart';
import 'package:hisnelmoslem/utils/alarm_database_helper.dart';
import 'package:hisnelmoslem/utils/alarm_manager.dart';
import 'package:hisnelmoslem/utils/awesome_notification_manager.dart';
import 'package:hisnelmoslem/utils/fake_hadith_database_helper.dart';
import 'package:hisnelmoslem/utils/migration/migration.dart';
import 'package:hisnelmoslem/utils/notification_manager.dart';
import 'package:hisnelmoslem/views/azkar/azkar_read_card.dart';
import 'package:hisnelmoslem/views/azkar/azkar_read_page.dart';
import 'package:hisnelmoslem/views/dashboard/dashboard.dart';
import 'package:hisnelmoslem/views/onboarding/onboarding.dart';
import 'package:hisnelmoslem/views/quran/quran_read_page.dart';
import 'package:intl/intl.dart';
import 'themes/theme_services.dart';
import 'utils/azkar_database_helper.dart';
import 'utils/tally_database_helper.dart';

void main() async {
  /// Make sure all stuff are initialized
  WidgetsFlutterBinding.ensureInitialized();

  ///
  await GetStorage.init();

  /// Start Migration steps
  await Migration.start();

  /// Init Awesome Notification
  await awesomeNotificationManager.init();

  /// Disable all notification from local_notification
  await localNotifyManager.cancelAllNotifications();

  /// U Doesn't open app for long time notification
  await awesomeNotificationManager.appOpenNotification();
  await alarmManager.checkAllAlarmsInDb();

  /// Make Phone StatusBar Transparent
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.top]);

  /// Keep app in portrait mode and
  /// make it static when phone rotation change
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  ///
  Intl.defaultLocale = 'ar';

  ///
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      /// Check if awesome notification is allowed
      await awesomeNotificationManager.checkIfAllowed(Get.context!);
    });

    ///
    AwesomeNotifications().createdStream.listen((notification) async {
      hisnPrint("createdStream: ${notification.payload}");
    });

    ///
    AwesomeNotifications().actionStream.listen((notification) async {
      List<String> payloadsList = notification.payload!.values.toList();
      String payload = payloadsList[0];
      hisnPrint("actionStream: ${notification.payload}");
      hisnPrint("actionStream: $payload");
      if ((notification.channelKey == 'in_app_notification' ||
              notification.channelKey == 'scheduled_channel') &&
          Platform.isIOS) {
        await AwesomeNotifications().getGlobalBadgeCounter().then(
          (value) async {
            await AwesomeNotifications().setGlobalBadgeCounter(value - 1);
          },
        );
      }

      if (payload.isNotEmpty) {
        hisnPrint(payload);
        onNotificationClick(payload);
      } else {
        hisnPrint("actionStream: Else");
      }
    });

    setState(() {
      isLoading = false;
    });
  }

  ///
  onNotificationClick(String payload) {
    /// go to quran page if clicked
    if (payload == "الكهف") {
      transitionAnimation.fromBottom2Top(
          context: Get.context!,
          goToPage: const QuranReadPage(
            surahName: SurahNameEnum.alKahf,
          ));
    }

    /// ignore constant alarms if clicked
    else if (payload == "555" || payload == "666") {
    }

    /// go to zikr page if clicked
    else {
      int? pageIndex = int.parse(payload);
      //
      if (appData.isCardReadMode) {
        transitionAnimation.fromBottom2Top(
            context: Get.context!, goToPage: AzkarReadCard(index: pageIndex));
      } else {
        transitionAnimation.fromBottom2Top(
            context: Get.context!, goToPage: AzkarReadPage(index: pageIndex));
      }
    }
  }

  @override
  void dispose() async {
    //Close databases
    await azkarDatabaseHelper.close();
    await fakeHadithDatabaseHelper.close();
    await alarmDatabaseHelper.close();
    await tallyDatabaseHelper.close();
    awesomeNotificationManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO to be deleted in next update 01
    final box = GetStorage();
    final openOnBoard = box.read('is_v2.0_first_open') ?? true;

    return GetMaterialApp(
      locale: const Locale('ar'),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      debugShowCheckedModeBanner: false,
      title: 'حصن المسلم',
      theme: ThemeServices.getTheme(),
      // theme: Themes.yellowTheme,
      // home: const AzkarDashboard(),
      // TODO to be deleted in next update 02
      home: isLoading
          ? const Loading()
          : openOnBoard
              ? const OnBoardingPage()
              : const AzkarDashboard(),
    );
  }
}
