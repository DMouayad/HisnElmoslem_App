import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hisnelmoslem/src/core/extensions/extension_object.dart';
import 'package:hisnelmoslem/src/core/shared/dialogs/commentary_dialog.dart';
import 'package:hisnelmoslem/src/core/shared/transition_animation/transition_animation.dart';
import 'package:hisnelmoslem/src/features/home/presentation/components/side_menu/toggle_brightness_btn.dart';
import 'package:hisnelmoslem/src/features/share_as_image/presentation/screens/share_as_image.dart';
import 'package:hisnelmoslem/src/features/zikr_viewer/presentation/controller/bloc/zikr_viewer_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ZikrViewerPageModeAppBar extends StatelessWidget {
  const ZikrViewerPageModeAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ZikrViewerBloc, ZikrViewerState>(
      builder: (context, state) {
        if (state is! ZikrViewerLoadedState) {
          return const SizedBox();
        }
        final activeZikr = state.activeZikr;
        if (activeZikr == null) {
          return const SizedBox();
        }
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Icon(MdiIcons.comment),
                  onPressed: () {
                    showCommentaryDialog(
                      context: context,
                      contentId: activeZikr.id,
                    );
                  },
                ),
                IconButton(
                  icon: Icon(MdiIcons.camera),
                  onPressed: () {
                    transitionAnimation.circleReval(
                      context: context,
                      goToPage: ShareAsImage(
                        dbContent: activeZikr,
                      ),
                    );
                  },
                ),
                if (!activeZikr.favourite)
                  IconButton(
                    padding: EdgeInsets.zero,
                    icon: const Icon(
                      Icons.favorite_border,
                    ),
                    onPressed: () {
                      context.read<ZikrViewerBloc>().add(
                            const ZikrViewerToggleZikrBookmarkEvent(
                              bookmark: true,
                            ),
                          );
                    },
                  )
                else
                  IconButton(
                    padding: EdgeInsets.zero,
                    icon: Icon(
                      Icons.favorite,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    onPressed: () {
                      context.read<ZikrViewerBloc>().add(
                            const ZikrViewerToggleZikrBookmarkEvent(
                              bookmark: false,
                            ),
                          );
                    },
                  ),
                IconButton(
                  padding: EdgeInsets.zero,
                  icon: const Icon(Icons.share),
                  onPressed: () async {
                    context
                        .read<ZikrViewerBloc>()
                        .add(const ZikrViewerShareZikrEvent());
                  },
                ),
                const ToggleBrightnessButton(),
                Center(
                  child: Text(
                    activeZikr.count.toString().toArabicNumber(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
            Stack(
              children: [
                LinearProgressIndicator(
                  value: 1 - state.manorProgress,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).colorScheme.primary,
                  ),
                ),
                LinearProgressIndicator(
                  backgroundColor: Colors.transparent,
                  value: state.majorProgress,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).colorScheme.primary.withOpacity(.5),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
