import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hisnelmoslem/src/core/functions/show_toast.dart';
import 'package:hisnelmoslem/src/core/shared/dialogs/dialog_maker.dart';
import 'package:hisnelmoslem/src/features/alarms_manager/data/models/alarm.dart';
import 'package:hisnelmoslem/src/features/alarms_manager/data/models/alarm_repeat_type.dart';

Future<DbAlarm?> showAlarmEditorDialog({
  required BuildContext context,
  required DbAlarm dbAlarm,
  required bool isToEdit,
}) async {
  // show the dialog
  return showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return AlarmEditorDialog(
        dbAlarm: dbAlarm,
        isToEdit: isToEdit,
      );
    },
  );
}

class AlarmEditorDialog extends StatefulWidget {
  final DbAlarm dbAlarm;
  final bool isToEdit;

  const AlarmEditorDialog({
    super.key,
    required this.dbAlarm,
    required this.isToEdit,
  });

  @override
  AlarmEditorDialogState createState() => AlarmEditorDialogState();
}

class AlarmEditorDialogState extends State<AlarmEditorDialog> {
  late TimeOfDay _time = TimeOfDay.now();

  bool iosStyle = true;
  int? selectedHour;
  int? selectedMinute;

  void onTimeChanged(TimeOfDay newTime) {
    setState(() {
      _time = newTime;
      selectedHour = newTime.hour;
      selectedMinute = newTime.minute;
    });
  }

  TextEditingController bodyController = TextEditingController();

  late AlarmRepeatType repeatType;

  @override
  void initState() {
    super.initState();
    if (widget.isToEdit) {
      _time = TimeOfDay.now()
          .replacing(hour: widget.dbAlarm.hour, minute: widget.dbAlarm.minute);

      bodyController = TextEditingController(text: widget.dbAlarm.body);
      repeatType = widget.dbAlarm.repeatType;
      selectedHour = widget.dbAlarm.hour;
      selectedMinute = widget.dbAlarm.minute;
    } else {
      bodyController = TextEditingController(
        text: 'فَاذْكُرُونِي أَذْكُرْكُمْ وَاشْكُرُوا لِي وَلَا تَكْفُرُونِ',
      );
      repeatType = AlarmRepeatType.daily;
    }
  }

  @override
  void dispose() {
    bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DialogMaker(
      height: 380,
      header: Text(
        () {
          if (widget.isToEdit) {
            return "edit reminder".tr;
          } else {
            return "add reminder".tr;
          }
        }(),
        style: const TextStyle(
          fontSize: 25,
        ),
        textAlign: TextAlign.center,
      ),
      content: [
        Text(
          widget.dbAlarm.title,
          style: const TextStyle(fontSize: 20),
          textAlign: TextAlign.center,
        ),
        TextField(
          style: TextStyle(
            color: Theme.of(context).listTileTheme.textColor,
          ),
          textAlign: TextAlign.center,
          controller: bodyController,
          maxLength: 100,
          autofocus: true,
          decoration: InputDecoration(
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            hintText: "set message for you".tr,
            contentPadding:
                const EdgeInsets.only(left: 15, bottom: 5, top: 5, right: 15),
          ),
        ),
        Card(
          clipBehavior: Clip.hardEdge,
          child: ListTile(
            leading: const Icon(Icons.alarm),
            title: Text(
              selectedHour == null
                  ? "click to choose time".tr
                  : '$selectedHour : $selectedMinute',
              textAlign: TextAlign.center,
              textDirection: TextDirection.ltr,
            ),
            onTap: () {
              Navigator.of(context).push(
                showPicker(
                  context: context,
                  value: Time(hour: _time.hour, minute: _time.minute),
                  onChange: onTimeChanged,
                  iosStylePicker: true,
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,

                  // Optional onChange to receive value as DateTime
                  onChangeDateTime: (DateTime dateTime) {},
                ) as Route,
              );
            },
          ),
        ),
        Card(
          clipBehavior: Clip.hardEdge,
          child: DropdownButton<AlarmRepeatType>(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            value: repeatType,
            isExpanded: true,
            icon: const Icon(Icons.arrow_drop_down),
            iconSize: 30,

            underline: const SizedBox(),
            // style: TextStyle(
            //   color: Theme.of(context).listTileTheme.textColor,
            // ),
            // dropdownColor: Theme.of(context).scaffoldBackgroundColor,
            onChanged: (AlarmRepeatType? newValue) {
              if (newValue == null) return;
              setState(() {
                repeatType = newValue;
              });
            },
            items: AlarmRepeatType.values
                .map<DropdownMenuItem<AlarmRepeatType>>(
                    (AlarmRepeatType value) {
              return DropdownMenuItem<AlarmRepeatType>(
                // alignment: Alignment.center,

                value: value,
                child: Text(
                  value.getUserFriendlyName(),

                  // textAlign: TextAlign.center,
                ),
              );
            }).toList(),
          ),
        ),
      ],
      footer: Row(
        children: [
          Expanded(
            child: ListTile(
              title: Text(
                "done".tr,
                textAlign: TextAlign.center,
              ),
              onTap: () {
                setState(() {
                  if (selectedHour != null) {
                    final editedAlarm = widget.dbAlarm.copyWith(
                      body: bodyController.text,
                      hour: selectedHour,
                      hasAlarmInside: true,
                      minute: selectedMinute,
                      repeatType: repeatType,
                    );

                    if (widget.isToEdit) {
                      Navigator.pop(context, editedAlarm);
                    } else {
                      Navigator.pop(
                        context,
                        editedAlarm.copyWith(isActive: true),
                      );
                    }
                  } else {
                    showToast(msg: "please choose time for the reminder".tr);
                  }
                });
              },
            ),
          ),
          Expanded(
            child: ListTile(
              title: Text(
                "close".tr,
                textAlign: TextAlign.center,
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
