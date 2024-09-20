import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hisnelmoslem/generated/l10n.dart';
import 'package:hisnelmoslem/src/core/extensions/extension_object.dart';
import 'package:hisnelmoslem/src/core/shared/widgets/text_divider.dart';
import 'package:hisnelmoslem/src/features/settings/presentation/controller/cubit/settings_cubit.dart';
import 'package:hisnelmoslem/src/features/zikr_viewer/data/models/zikr_content.dart';
import 'package:hisnelmoslem/src/features/zikr_viewer/presentation/components/zikr_content_builder.dart';
import 'package:hisnelmoslem/src/features/zikr_viewer/presentation/controller/bloc/zikr_viewer_bloc.dart';

class ZikrViewerPageBuilder extends StatelessWidget {
  const ZikrViewerPageBuilder({
    super.key,
    required this.dbContent,
  });

  final DbContent dbContent;
  @override
  Widget build(BuildContext context) {
    final bool isDone = dbContent.count == 0;
    return GestureDetector(
      onTap: () {
        context
            .read<ZikrViewerBloc>()
            .add(ZikrViewerDecreaseZikrEvent(content: dbContent));
      },
      onLongPress: () {
        final snackBar = SnackBar(
          content: Text(
            dbContent.source,
            textAlign: TextAlign.center,
            softWrap: true,
          ),
          action: SnackBarAction(
            label: S.of(context).copy,
            onPressed: () async {
              context
                  .read<ZikrViewerBloc>()
                  .add(ZikrViewerCopyZikrEvent(content: dbContent));
            },
          ),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      },
      child: Stack(
        children: [
          Center(
            child: FittedBox(
              child: Text(
                isDone
                    ? S.of(context).done
                    : "${dbContent.count}".toArabicNumber(),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary.withOpacity(.02),
                  fontSize: 250,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          BlocBuilder<SettingsCubit, SettingsState>(
            builder: (context, state) {
              return ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(15),
                children: [
                  ZikrContentBuilder(
                    dbContent: dbContent,
                    enableDiacritics: state.showDiacritics,
                    fontSize: state.fontSize * 10,
                  ),
                  if (dbContent.fadl.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    const TextDivider(),
                    Text(
                      dbContent.fadl,
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.rtl,
                      softWrap: true,
                      style: TextStyle(
                        fontSize: state.fontSize * 8,
                        height: 2,
                      ),
                    ),
                  ],
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
