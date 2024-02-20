import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hisnelmoslem/src/features/effects_manager/presentation/controller/sounds_manager_controller.dart';

class SoundsManagerPage extends StatelessWidget {
  const SoundsManagerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SoundsManagerController>(
      init: SoundsManagerController(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              "effect manager".tr,
            ),
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            elevation: 0,
          ),
          body: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              ListTile(
                leading: const Icon(
                  Icons.volume_up,
                ),
                title: Text("Sound Effect volume".tr),
                subtitle: Slider(
                  value: controller.soundEffectVolume,
                  onChanged: (value) {
                    controller.changeSoundEffectVolume(value);
                    controller.update();
                  },
                ),
              ),

              const Divider(),

              /// Tally Sound Allowed Vibrate
              SwitchListTile(
                title: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(
                    Icons.vibration,
                  ),
                  title: Text("phone vibration at every praise".tr),
                ),
                value: controller.isTallyVibrateAllowed,
                onChanged: (value) {
                  controller.changeTallyVibrateStatus(value: value);

                  if (value) {
                    controller.simulateTallyVibrate();
                  }

                  controller.update();
                },
              ),

              /// Tally Sound Allowed
              SwitchListTile(
                title: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(
                    Icons.speaker,
                  ),
                  title: Text("sound effect at every praise".tr),
                ),
                value: controller.isTallySoundAllowed,
                onChanged: (value) {
                  controller.changeTallySoundStatus(value: value);

                  if (value) {
                    controller.simulateTallySound();
                  }

                  controller.update();
                },
              ),

              /// Zikr Done Sound Allowed Vibrate
              SwitchListTile(
                title: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(
                    Icons.vibration,
                  ),
                  title: Text("phone vibration at single zikr end".tr),
                ),
                value: controller.isZikrDoneVibrateAllowed,
                onChanged: (value) {
                  controller.changeZikrDoneVibrateStatus(value: value);

                  if (value) {
                    controller.simulateZikrDoneVibrate();
                  }
                  controller.update();
                },
              ),

              /// Zikr Done Sound Allowed
              SwitchListTile(
                title: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(
                    Icons.speaker,
                  ),
                  title: Text("sound effect at single zikr end".tr),
                ),
                value: controller.isZikrDoneSoundAllowed,
                onChanged: (value) {
                  controller.changeZikrDoneSoundStatus(value: value);

                  if (value) {
                    controller.simulateZikrDoneSound();
                  }
                  controller.update();
                },
              ),

              /// Azkar Done Sound Allowed vibrate
              SwitchListTile(
                title: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(
                    Icons.vibration,
                  ),
                  title: Text("phone vibration when all zikr end".tr),
                ),
                value: controller.isAllAzkarFinishedVibrateAllowed,
                onChanged: (value) {
                  controller.changeAllAzkarFinishedVibrateStatus(
                    value: value,
                  );

                  if (value) {
                    controller.simulateAllAzkarVibrateFinished();
                  }
                  controller.update();
                },
              ),

              /// Azkar Done Sound Allowed
              SwitchListTile(
                title: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(
                    Icons.speaker,
                  ),
                  title: Text("sound effect when all zikr end".tr),
                ),
                value: controller.isAllAzkarFinishedSoundAllowed,
                onChanged: (value) {
                  controller.changeAllAzkarFinishedSoundStatus(value: value);

                  if (value) {
                    controller.simulateAllAzkarSoundFinished();
                  }
                  controller.update();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
