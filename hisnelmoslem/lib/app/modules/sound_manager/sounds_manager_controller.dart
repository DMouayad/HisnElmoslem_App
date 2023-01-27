import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import 'package:get/state_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:vibration/vibration.dart';

class SoundsManagerController extends GetxController {
  /* *************** Variables *************** */
  final box = GetStorage();

  /////////////////////////////
  /// Sounds

  /// get Tally Sound mode
  bool get isTallySoundAllowed => box.read('tally_sound') ?? false;

  /// set Tally Sound mode
  void changeTallySoundStatus(bool val) => box.write('tally_sound', val);

  /// get Tally Done Sound mode
  bool get isZikrDoneSoundAllowed => box.read('zikr_done_sound') ?? false;

  /// set Tally Done Sound mode
  void changeZikrDoneSoundStatus(bool val) => box.write('zikr_done_sound', val);

  /// get Tally Transition Sound mode
  bool get isTransitionSoundAllowed =>
      box.read('tally_transition_sound') ?? false;

  /// set Tally  Transition Sound mode
  void changeTransitionSoundStatus(bool val) =>
      box.write('tally_transition_sound', val);

  /// get Tally Finished Sound mode
  bool get isAllAzkarFinishedSoundAllowed =>
      box.read('all_azkar_finished_sound') ?? false;

  /// set Tally Finished Sound mode
  void changeAllAzkarFinishedSoundStatus(bool val) =>
      box.write('all_azkar_finished_sound', val);

  /////////////////////////////
  /// Vibration

  /// get Sound Effect Volume
  double get soundEffectVolume => box.read('soundEffectVolume') ?? 1;

  /// set Tally Vibrate mode
  void changeSoundEffectVolume(double val) =>
      box.write('soundEffectVolume', val);

  /// get Tally Vibrate mode
  bool get isTallyVibrateAllowed => box.read('tally_vibrate') ?? false;

  /// set Tally Vibrate mode
  void changeTallyVibrateStatus(bool val) => box.write('tally_vibrate', val);

  /// get Tally Done Vibrate mode
  bool get isZikrDoneVibrateAllowed => box.read('zikr_done_vibrate') ?? false;

  /// set Tally Done Vibrate mode
  void changeZikrDoneVibrateStatus(bool val) =>
      box.write('zikr_done_vibrate', val);

  /// get Tally Transition Vibrate mode
  bool get isTransitionVibrateAllowed =>
      box.read('tally_transition_vibrate') ?? false;

  /// set Tally  Transition Vibrate mode
  void changeTransitionVibrateStatus(bool val) =>
      box.write('tally_transition_vibrate', val);

  /// get Tally Finished Vibrate mode
  bool get isAllAzkarFinishedVibrateAllowed =>
      box.read('all_azkar_finished_vibrate') ?? false;

  /// set Tally Finished Vibrate mode
  void changeAllAzkarFinishedVibrateStatus(bool val) =>
      box.write('all_azkar_finished_vibrate', val);

  ///
  final player = AudioPlayer();

/* *************** Controller life cycle *************** */

  /* *************** Functions *************** */
  //

  /////////////////////
  /// Play Sound

  simulateTallySound() async {
    // player.play('sounds/tally_sound.mp3');
    await player.play(
      AssetSource('sounds/tally_sound.mp3'),
      volume: soundEffectVolume,
    );
  }

  simulateZikrDoneSound() async {
    await player.play(
      AssetSource('sounds/zikr_done_sound.mp3'),
      volume: soundEffectVolume,
    );
  }

  simulateTransitionSound() {}

  simulateAllAzkarSoundFinished() async {
    await player.play(
      AssetSource('sounds/all_azkar_finished_sound.mp3'),
      volume: soundEffectVolume,
    );
  }

  /////////////////////
  /// Play vibration

  simulateTallyVibrate() async {
    await Vibration.hasCustomVibrationsSupport().then(
      (value) => {
        if (value!)
          {Vibration.vibrate(duration: 100)}
        else
          {HapticFeedback.lightImpact()}
      },
    );
  }

  simulateZikrDoneVibrate() async {
    await Vibration.hasCustomVibrationsSupport().then(
      (value) => {
        if (value!)
          {Vibration.vibrate(duration: 300)}
        else
          {HapticFeedback.mediumImpact()}
      },
    );
  }

  simulateTransitionVibrate() async {
    await Vibration.hasCustomVibrationsSupport().then(
      (value) => {
        if (value!)
          {Vibration.vibrate(duration: 25)}
        else
          {HapticFeedback.vibrate()}
      },
    );
  }

  Future<void> simulateAllAzkarVibrateFinished() async {
    await Vibration.hasCustomVibrationsSupport().then(
      (value) => {
        if (value!) {Vibration.vibrate()} else {HapticFeedback.heavyImpact()}
      },
    );
  }

  //////////////////////////////
  void playTallyEffects() {
    if (isTallySoundAllowed) {
      simulateTallySound();
    }
    if (isTallyVibrateAllowed) {
      simulateTallyVibrate();
    }
  }

  void playZikrDoneEffects() {
    if (isZikrDoneSoundAllowed) {
      simulateZikrDoneSound();
    }
    if (isZikrDoneVibrateAllowed) {
      simulateZikrDoneVibrate();
    }
  }

  playTransitionEffects() {
    if (isTransitionSoundAllowed) {
      simulateTransitionSound();
    }
    if (isTransitionVibrateAllowed) {
      simulateTransitionVibrate();
    }
  }

  playAllAzkarFinishedEffects() {
    if (isAllAzkarFinishedSoundAllowed) {
      simulateAllAzkarSoundFinished();
    }
    if (isAllAzkarFinishedVibrateAllowed) {
      simulateAllAzkarVibrateFinished();
    }
  }
}
