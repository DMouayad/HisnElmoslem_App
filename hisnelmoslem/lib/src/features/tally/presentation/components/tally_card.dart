import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hisnelmoslem/generated/lang/app_localizations.dart';
import 'package:hisnelmoslem/src/core/extensions/extension_object.dart';
import 'package:hisnelmoslem/src/core/models/editor_result.dart';
import 'package:hisnelmoslem/src/core/shared/dialogs/yes_no_dialog.dart';
import 'package:hisnelmoslem/src/core/values/constant.dart';
import 'package:hisnelmoslem/src/features/tally/data/models/tally.dart';
import 'package:hisnelmoslem/src/features/tally/presentation/components/dialogs/tally_editor.dart';
import 'package:hisnelmoslem/src/features/tally/presentation/controller/bloc/tally_bloc.dart';
import 'package:intl/intl.dart';

class TallyCard extends StatelessWidget {
  final DbTally dbTally;

  const TallyCard({super.key, required this.dbTally});

  @override
  Widget build(BuildContext context) {
    final state = context.read<TallyBloc>().state;
    final bool isActivated;
    if (state is TallyLoadedState) {
      isActivated = dbTally.id == state.activeCounter?.id;
    } else {
      isActivated = false;
    }
    return Container(
      decoration: BoxDecoration(
        border: BoxBorder.fromLTRB(
          right: BorderSide(
            width: 10,
            color: isActivated
                ? Theme.of(context).colorScheme.primary
                : Colors.transparent,
          ),
        ),
      ),
      child: ListTile(
        isThreeLine: true,
        tileColor: isActivated
            ? Theme.of(
                context,
              ).colorScheme.primary.withAlpha((.2 * 255).round())
            : null,
        onTap: () {
          context.read<TallyBloc>().add(
            TallyToggleCounterActivationEvent(
              counter: dbTally,
              activate: !isActivated,
            ),
          );
        },
        title: Text(
          dbTally.title,
          style: Theme.of(context).textTheme.displayMedium,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Text(
                    DateFormat(kDateTimeHumanFormat).format(dbTally.lastUpdate),
                  ),
                ),
                IconButton(
                  tooltip: S.of(context).edit,
                  onPressed: () async {
                    final EditorResult<DbTally>? result =
                        await showTallyEditorDialog(
                          context: context,
                          dbTally: dbTally,
                        );

                    if (result == null || !context.mounted) return;
                    switch (result.action) {
                      case EditorActionEnum.edit:
                        context.read<TallyBloc>().add(
                          TallyEditCounterEvent(counter: result.value),
                        );
                      case EditorActionEnum.delete:
                        context.read<TallyBloc>().add(
                          TallyDeleteCounterEvent(counter: result.value),
                        );
                      default:
                    }
                  },
                  icon: const Icon(Icons.edit),
                ),
                IconButton(
                  tooltip: S.of(context).delete,
                  onPressed: () async {
                    final bool? confirm = await showDialog(
                      context: context,
                      builder: (_) {
                        return YesOrNoDialog(
                          msg: S.of(context).counterWillBeDeleted,
                        );
                      },
                    );

                    if (confirm == null || !confirm || !context.mounted) {
                      return;
                    }

                    context.read<TallyBloc>().add(
                      TallyDeleteCounterEvent(counter: dbTally),
                    );
                  },
                  icon: const Icon(Icons.delete),
                ),
              ],
            ),
          ],
        ),
        trailing: Text(
          dbTally.count.toString().toArabicNumber(),
          style: const TextStyle(fontSize: 15),
        ),
      ),
    );
  }
}
