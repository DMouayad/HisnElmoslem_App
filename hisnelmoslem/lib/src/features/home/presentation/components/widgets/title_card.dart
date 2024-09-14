import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:hisnelmoslem/src/core/repos/app_data.dart';
import 'package:hisnelmoslem/src/core/shared/dialogs/alarm_dialog.dart';
import 'package:hisnelmoslem/src/core/shared/transition_animation/transition_animation.dart';
import 'package:hisnelmoslem/src/features/alarms_manager/data/models/alarm.dart';
import 'package:hisnelmoslem/src/features/alarms_manager/presentation/controller/bloc/alarms_bloc.dart';
import 'package:hisnelmoslem/src/features/home/data/models/zikr_title.dart';
import 'package:hisnelmoslem/src/features/home/presentation/controller/bloc/home_bloc.dart';
import 'package:hisnelmoslem/src/features/zikr_viewer/presentation/screens/azkar_read_card.dart';
import 'package:hisnelmoslem/src/features/zikr_viewer/presentation/screens/azkar_read_page.dart';

class TitleCard extends StatelessWidget {
  final int index;
  final DbTitle dbTitle;
  final DbAlarm? dbAlarm;

  const TitleCard({
    super.key,
    required this.dbTitle,
    required this.dbAlarm,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final DbAlarm alarm =
        dbAlarm ?? DbAlarm(titleId: dbTitle.id, title: dbTitle.name);

    return ListTile(
      tileColor: index % 2 != 0
          ? Theme.of(context).colorScheme.primary.withOpacity(.05)
          : null,
      leading: dbTitle.favourite
          ? IconButton(
              icon: Icon(
                Icons.bookmark,
                color: Theme.of(context).colorScheme.primary,
              ),
              onPressed: () {
                context
                    .read<HomeBloc>()
                    .add(HomeUnBookmarkTitleEvent(title: dbTitle));
              },
            )
          : IconButton(
              icon: const Icon(Icons.bookmark_border_outlined),
              onPressed: () {
                context
                    .read<HomeBloc>()
                    .add(HomeBookmarkTitleEvent(title: dbTitle));
              },
            ),
      trailing: dbAlarm == null
          ? IconButton(
              icon: const Icon(Icons.alarm_add_rounded),
              onPressed: () async {
                final DbAlarm? editedAlarm = await showAlarmEditorDialog(
                  context: context,
                  dbAlarm: alarm,
                  isToEdit: false,
                );

                if (editedAlarm == null) return;
                if (!context.mounted) return;

                context.read<AlarmsBloc>().add(AlarmsAddEvent(editedAlarm));
              },
            )
          : GestureDetector(
              onLongPress: () async {
                final DbAlarm? editedAlarm = await showAlarmEditorDialog(
                  context: context,
                  dbAlarm: alarm,
                  isToEdit: true,
                );

                if (editedAlarm == null) return;
                if (!context.mounted) return;

                context.read<AlarmsBloc>().add(AlarmsEditEvent(editedAlarm));
              },
              child: alarm.isActive
                  ? IconButton(
                      icon: Icon(
                        Icons.notifications_active,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      onPressed: () {
                        context.read<AlarmsBloc>().add(
                              AlarmsEditEvent(
                                alarm.copyWith(isActive: false),
                              ),
                            );
                      },
                    )
                  : IconButton(
                      icon: const Icon(
                        Icons.notifications_off,
                      ),
                      onPressed: () {
                        context.read<AlarmsBloc>().add(
                              AlarmsEditEvent(
                                alarm.copyWith(isActive: true),
                              ),
                            );
                      },
                    ),
            ),

      title: Text(
        dbTitle.name,
      ),
      // trailing: Text(zikrList[index]),
      onTap: () {
        if (!AppData.instance.isCardReadMode) {
          transitionAnimation.circleReval(
            context: Get.context!,
            goToPage: AzkarReadPage(index: dbTitle.id),
          );
        } else {
          transitionAnimation.circleReval(
            context: Get.context!,
            goToPage: AzkarReadCard(index: dbTitle.id),
          );
        }
      },
    );
  }
}
