import 'package:get_storage/get_storage.dart';
import 'package:hisnelmoslem/src/core/values/constant.dart';
import 'package:hisnelmoslem/src/features/home/data/models/titles_freq_enum.dart';

class AppSettingsRepo {
  final GetStorage box;

  AppSettingsRepo(this.box);

  ///MARK:Release First open
  /* ******* is first open to this release ******* */

  static const _releaseFirstOpenKey = "is_${kAppVersion}_first_open";
  bool get isReleaseFirstOpen => box.read(_releaseFirstOpenKey) ?? true;

  Future<void> changIsReleaseFirstOpen({required bool value}) async {
    await box.write(_releaseFirstOpenKey, value);
  }

  ///MARK:Azkar Read Mode
  /* ******* Azkar Read Mode ******* */
  static const isCardReadModeKey = 'is_card_read_mode';

  /// get Zikr Page mode
  /// If it is true then
  /// page mode will be card mode
  /// if not page mode will be page
  bool get isCardReadMode => box.read(isCardReadModeKey) ?? false;

  /// set Zikr Page mode
  /// If it is true then
  /// page mode will be card mode
  /// if not page mode will be page
  Future<void> changeReadModeStatus({required bool value}) async =>
      box.write(isCardReadModeKey, value);

  ///
  void toggleReadModeStatus() {
    changeReadModeStatus(value: !isCardReadMode);
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

  ///MARK:Dashboard Arrangement
  /* ******* Dashboard Arrangement ******* */

  static const String dashboardArrangementKey = "list_arrange";

  List<int> get dashboardArrangement {
    final String? data = box.read(dashboardArrangementKey);

    if (data == null) {
      return [0, 1, 2];
    }
    final String tempList = data.replaceAll('[', '').replaceAll(']', '');
    return tempList.split(",").map<int>((e) => int.parse(e)).toList();
  }

  void changeDashboardArrangement(List<int> value) {
    box.write(dashboardArrangementKey, value.toString());
  }

  ///MARK:Azkar Read Mode
  /* ******* Azkar Read Mode ******* */
  static const praiseWithVolumeKeysKey = 'praiseWithVolumeKeys';

  bool get praiseWithVolumeKeys => box.read(praiseWithVolumeKeysKey) ?? true;

  Future<void> changePraiseWithVolumeKeysStatus({required bool value}) async =>
      box.write(praiseWithVolumeKeysKey, value);

  ///MARK:Titles Freq filters
  /* ******* Titles Freq filters ******* */
  static const String _titlesFreqFilter = "titlesFreqFilter";

  List<TitlesFreqEnum> get getTitlesFreqFilterStatus {
    final String? data = box.read(_titlesFreqFilter);

    final List<TitlesFreqEnum> result = List.of([]);
    if (data != null && data.isNotEmpty) {
      result.addAll(result.toEnumList(data));
    } else {
      result.addAll(TitlesFreqEnum.values);
    }

    return result;
  }

  Future setTitlesFreqFilterStatus(List<TitlesFreqEnum> freqList) async {
    return box.write(_titlesFreqFilter, freqList.toJson());
  }
}
