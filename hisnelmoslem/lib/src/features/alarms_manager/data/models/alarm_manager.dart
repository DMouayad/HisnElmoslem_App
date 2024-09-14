// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hisnelmoslem/src/core/functions/get_snackbar.dart';
import 'package:hisnelmoslem/src/core/functions/print.dart';
import 'package:hisnelmoslem/src/core/values/constant.dart';
import 'package:hisnelmoslem/src/features/alarms_manager/data/models/alarm.dart';
import 'package:hisnelmoslem/src/features/alarms_manager/data/models/alarm_repeat_type.dart';
import 'package:hisnelmoslem/src/features/alarms_manager/data/models/awesome_notification_manager.dart';
import 'package:hisnelmoslem/src/features/alarms_manager/data/repository/alarm_database_helper.dart';

AlarmManager alarmManager = AlarmManager();

class AlarmManager {
  Future<void> alarmState({
    required DbAlarm dbAlarm,
    bool showMsg = true,
  }) async {
    if (dbAlarm.isActive) {
      // Get.snackbar("رسالة", "تفعيل منبه ${dbAlarm.title}",
      //     duration: const Duration(seconds: 1),
      //     icon: Image.asset("assets/images/app_icon.png"));
      if (showMsg) {
        getSnackbar(message: "${"activate".tr} | ${dbAlarm.title}");
      }

      if (dbAlarm.repeatType == AlarmRepeatType.daily) {
        await awesomeNotificationManager.addCustomDailyReminder(
          id: dbAlarm.titleId,
          title: dbAlarm.title,
          body: dbAlarm.body,
          time: Time(dbAlarm.hour, dbAlarm.minute),
          payload: dbAlarm.titleId.toString(),
        );
      } else {
        await awesomeNotificationManager.addCustomWeeklyReminder(
          id: dbAlarm.titleId,
          title: dbAlarm.title,
          body: dbAlarm.body,
          time: Time(dbAlarm.hour, dbAlarm.minute),
          payload: dbAlarm.titleId.toString(),
          weekday: dbAlarm.repeatType.getWeekDay(),
        );
      }
    } else {
      // Get.snackbar("رسالة", "الغاء تفعيل منبه ${dbAlarm.title}",
      //     duration: const Duration(seconds: 1),
      //     icon: Image.asset("assets/images/app_icon.png"));
      if (showMsg) {
        getSnackbar(message: "${"deactivate".tr} | ${dbAlarm.title}");
      }

      awesomeNotificationManager.cancelNotificationById(id: dbAlarm.titleId);
    }
  }

  Future<void> checkAllAlarmsInDb() async {
    final box = GetStorage(kAppStorageKey);
    final bool isAwesomeSet = box.read<bool>('is_awesome_set') ?? false;
    if (!isAwesomeSet) {
      hisnPrint("Setup Awesome from database ....");
      await alarmDatabaseHelper.getAlarms().then((value) {
        final List<DbAlarm> alarms = value;
        for (var i = 0; i < alarms.length; i++) {
          final DbAlarm alarm = alarms[i];
          alarmState(dbAlarm: alarm, showMsg: false);
        }
      });
      box.write('is_awesome_set', true);
    }
  }
}
