import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hisnelmoslem/src/core/values/constant.dart';
import 'package:hisnelmoslem/src/features/alarms_manager/data/models/awesome_day.dart';
import 'package:hisnelmoslem/src/features/alarms_manager/data/models/awesome_notification_manager.dart';

class AppData {
  final box = GetStorage(kAppStorageKey);

  static final AppData instance = AppData._();

  factory AppData() {
    return instance;
  }
  AppData._();

  /* ******* Azkar Read Mode ******* */

  /// get Zikr Page mode
  /// If it is true then
  /// page mode will be card mode
  /// if not page mode will be page
  bool get isCardReadMode => box.read('is_card_read_mode') ?? false;

  /// set Zikr Page mode
  /// If it is true then
  /// page mode will be card mode
  /// if not page mode will be page
  Future<void> changeReadModeStatus({required bool value}) async =>
      box.write('is_card_read_mode', value);

  ///
  void toggleReadModeStatus() {
    changeReadModeStatus(value: !isCardReadMode);
  }

  ///MARK: Font
  /* ******* Font Size ******* */

  /// get font size default value is 2.6
  double get fontSize => box.read<double>('font_size') ?? 2.6;

  /// set font size
  Future<void> changFontSize(double value) async {
    final double tempValue = value.clamp(1.5, 4);
    await box.write('font_size', tempValue);
  }

  /// increase font size by .2
  void resetFontSize() {
    changFontSize(2.6);
  }

  /// increase font size by .2
  void increaseFontSize() {
    changFontSize(fontSize + .2);
  }

  /// decrease font size by .2
  void decreaseFontSize() {
    changFontSize(fontSize - .2);
  }

  /* ******* Font Size ******* */

  /// get font size default value is 2.6
  String get fontFamily => box.read('font_family') ?? "Amiri";

  /// set font size
  Future<void> changFontFamily(String value) async {
    box.write('font_family', value);
  }

  /// increase font size by .2
  void resetFontFamily() {
    changFontFamily("Amiri");
  }
  /* ******* App Locale ******* */

  /// get font size default value is 2.6
  String get appLocale => box.read('app_locale') ?? "ar";

  /// set font size
  Future<void> changAppLocale(String value) async {
    box.write('app_locale', value);
  }

  /// increase font size by .2
  void resetAppLocale() {
    changFontFamily("ar");
  }

  /* ******* Diacritics ******* */

  /// get Diacritics status
  bool get isDiacriticsEnabled => box.read('tashkel_status') ?? true;

  /// set Diacritics status
  Future<void> changDiacriticsStatus({required bool value}) async =>
      box.write('tashkel_status', value);

  ///
  void toggleDiacriticsStatus() {
    changDiacriticsStatus(value: !isDiacriticsEnabled);
  }

  /* ******* Surat al kahf alarm ******* */

  /// get Surat al kahf alarm status
  bool get isCaveAlarmEnabled => box.read('cave_status') ?? false;

  /// set Surat al kahf alarm status
  Future<void> changCaveAlarmStatus({required bool value}) async {
    await box.write('cave_status', value);
    _activateCaveAlarm(value: value);
  }

  ///
  void toggleCaveAlarmStatus() {
    changCaveAlarmStatus(value: !isCaveAlarmEnabled);
  }

  /* ******* monday and thursday fast alarm ******* */

  /// get monday and thursday fast alarm alarm status
  bool get isFastAlarmEnabled => box.read('fast_status') ?? false;

  /// set monday and thursday fast alarm alarm status
  Future<void> changFastAlarmStatus({required bool value}) async {
    await box.write('fast_status', value);
    _activateFastAlarm(value: value);
  }

  ///
  void toggleFastAlarmStatus() {
    changFastAlarmStatus(value: !isFastAlarmEnabled);
  }

  /* ******* Share as image ******* */

  /* ******* is first open to this release ******* */
  /// Check is first open to this release
  bool get isFirstOpenToThisRelease =>
      box.read("is_${appVersion}_first_open") ?? true;

  /// Change is first open to this release
  Future<void> changIsFirstOpenToThisRelease({required bool value}) async {
    await box.write("is_${appVersion}_first_open", value);
  }

  /**
   * Function to active and disable constant alarms
   */

  ///
  void _activateCaveAlarm({required bool value}) {
    if (value) {
      awesomeNotificationManager.addCustomWeeklyReminder(
        id: 555,
        title: "صيام غدا الإثنين",
        body:
            "قال رسول الله صلى الله عليه وسلم :\n تُعرضُ الأعمالُ يومَ الإثنين والخميسِ فأُحِبُّ أن يُعرضَ عملي وأنا صائمٌ ",
        time: Time(20),
        weekday: AwesomeDay.sunday.value,
        payload: "555",
        needToOpen: false,
      );
      awesomeNotificationManager.addCustomWeeklyReminder(
        id: 666,
        title: "صيام غدا الخميس",
        body:
            "قال رسول الله صلى الله عليه وسلم :\n تُعرضُ الأعمالُ يومَ الإثنين والخميسِ فأُحِبُّ أن يُعرضَ عملي وأنا صائمٌ ",
        time: Time(20),
        weekday: AwesomeDay.wednesday.value,
        payload: "666",
        needToOpen: false,
      );
    } else {
      awesomeNotificationManager.cancelNotificationById(id: 555);
      awesomeNotificationManager.cancelNotificationById(id: 666);
    }
  }

  ///
  void _activateFastAlarm({required bool value}) {
    if (value) {
      awesomeNotificationManager.addCustomWeeklyReminder(
        id: 777,
        title: "sura Al-Kahf".tr,
        body:
            "روى الحاكم في المستدرك مرفوعا إن من قرأ سورة الكهف يوم الجمعة أضاء له من النور ما بين الجمعتين. وصححه الألباني",
        time: Time(
          9,
        ),
        weekday: AwesomeDay.friday.value,
        payload: "الكهف",
        needToOpen: false,
      );
    } else {
      awesomeNotificationManager.cancelNotificationById(id: 777);
    }
  }

  ///MARK:Hinidi Digits
  /* ******* Hinidi Digits ******* */

  static const String _useHindiDigitsKey = "useHindiDigits";
  bool get useHindiDigits => box.read(_useHindiDigitsKey) ?? false;

  Future<void> changeUseHindiDigits({required bool use}) async =>
      await box.write(_useHindiDigitsKey, use);

  Future toggleUseHindiDigits() async {
    await changeUseHindiDigits(use: !useHindiDigits);
  }

  ///MARK:WakeLock
  /* ******* WakeLock ******* */

  static const String _enableWakeLockKey = "enableWakeLock";
  bool get enableWakeLock => box.read(_enableWakeLockKey) ?? false;

  Future<void> changeEnableWakeLock({required bool use}) async =>
      box.write(_enableWakeLockKey, use);

  void toggleEnableWakeLock() {
    changeEnableWakeLock(use: !enableWakeLock);
  }

  ///MARK:Effects Sound
  /* ******* Effects ******* */

  ///
  static const _isTallySoundAllowedKey = 'tally_sound';
  bool get isTallySoundAllowed => box.read(_isTallySoundAllowedKey) ?? false;

  void changeTallySoundStatus({required bool value}) =>
      box.write(_isTallySoundAllowedKey, value);

  ///
  static const _isZikrDoneSoundAllowedKey = 'zikr_done_sound';
  bool get isZikrDoneSoundAllowed =>
      box.read(_isZikrDoneSoundAllowedKey) ?? false;

  void changeZikrDoneSoundStatus({required bool value}) =>
      box.write(_isZikrDoneSoundAllowedKey, value);

  ///
  static const _isTransitionSoundAllowedKey = 'tally_transition_sound';
  bool get isTransitionSoundAllowed =>
      box.read(_isTransitionSoundAllowedKey) ?? false;

  void changeTransitionSoundStatus({required bool value}) =>
      box.write(_isTransitionSoundAllowedKey, value);

  ///
  static const _isAllAzkarFinishedSoundAllowedKey = 'all_azkar_finished_sound';
  bool get isAllAzkarFinishedSoundAllowed =>
      box.read(_isAllAzkarFinishedSoundAllowedKey) ?? false;

  void changeAllAzkarFinishedSoundStatus({required bool value}) =>
      box.write(_isAllAzkarFinishedSoundAllowedKey, value);

  ///
  static const _soundEffectVolumeKey = 'soundEffectVolume';
  double get soundEffectVolume => box.read(_soundEffectVolumeKey) ?? 1;

  void changeSoundEffectVolume(double value) =>
      box.write(_soundEffectVolumeKey, value);

  ///MARK: Effect Vibration
  /* ******* Effects Vibration ******* */
  ///
  static const _isTallyVibrateAllowedKey = 'tally_vibrate';
  bool get isTallyVibrateAllowed =>
      box.read(_isTallyVibrateAllowedKey) ?? false;

  void changeTallyVibrateStatus({required bool value}) =>
      box.write(_isTallyVibrateAllowedKey, value);

  ///
  static const _isZikrDoneVibrateAllowedKey = 'zikr_done_vibrate';

  bool get isZikrDoneVibrateAllowed =>
      box.read(_isZikrDoneVibrateAllowedKey) ?? false;

  void changeZikrDoneVibrateStatus({required bool value}) =>
      box.write(_isZikrDoneVibrateAllowedKey, value);

  ///
  static const _isTransitionVibrateAllowedKey = 'tally_transition_vibrate';

  bool get isTransitionVibrateAllowed =>
      box.read(_isTransitionVibrateAllowedKey) ?? false;

  void changeTransitionVibrateStatus({required bool value}) =>
      box.write(_isTransitionVibrateAllowedKey, value);

  ///
  static const _isAllAzkarFinishedVibrateAllowedKey =
      "all_azkar_finished_vibrate";

  bool get isAllAzkarFinishedVibrateAllowed =>
      box.read(_isAllAzkarFinishedVibrateAllowedKey) ?? false;

  void changeAllAzkarFinishedVibrateStatus({required bool value}) =>
      box.write(_isAllAzkarFinishedVibrateAllowedKey, value);
}
