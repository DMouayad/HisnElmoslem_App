import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:hisnelmoslem/src/core/extensions/extension_platform.dart';
import 'package:hisnelmoslem/src/core/localization/translation.dart';
import 'package:hisnelmoslem/src/core/repos/app_data.dart';
import 'package:hisnelmoslem/src/features/alarms_manager/data/models/awesome_notification_manager.dart';
import 'package:hisnelmoslem/src/features/alarms_manager/data/repository/alarm_database_helper.dart';
import 'package:hisnelmoslem/src/features/fake_hadith/data/repository/fake_hadith_database_helper.dart';
import 'package:hisnelmoslem/src/features/home/data/repository/azkar_database_helper.dart';
import 'package:hisnelmoslem/src/features/home/presentation/screens/dashboard.dart';
import 'package:hisnelmoslem/src/features/onboarding/presentation/screens/onboarding.dart';
import 'package:hisnelmoslem/src/features/tally/data/repository/tally_database_helper.dart';
import 'package:hisnelmoslem/src/features/themes/presentation/controller/cubit/theme_cubit.dart';
import 'package:hisnelmoslem/src/features/ui/presentation/components/desktop_window_wrapper.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    awesomeNotificationManager.listen();
  }

  @override
  Future<void> dispose() async {
    await azkarDatabaseHelper.close();
    await fakeHadithDatabaseHelper.close();
    await alarmDatabaseHelper.close();
    await tallyDatabaseHelper.close();
    awesomeNotificationManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeCubit()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          return GetMaterialApp(
            // Translation
            translations: HisnAppTranslation(),
            locale: Locale(AppData.instance.appLocale),
            fallbackLocale: const Locale("ar"),
            //
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            debugShowCheckedModeBanner: false,
            title: "Hisn Elmoslem".tr,
            theme: state.themeData(),
            builder: (context, child) {
              if (PlatformExtension.isDesktop) {
                final botToastBuilder = BotToastInit();
                return DesktopWindowWrapper(
                  child: botToastBuilder(context, child),
                );
              }
              return child ?? const SizedBox();
            },

            // home: const AzkarDashboard(),

            home: AppData.instance.isFirstOpenToThisRelease
                ? const OnBoardingPage()
                : const AzkarDashboard(),
          );
        },
      ),
    );
  }
}
