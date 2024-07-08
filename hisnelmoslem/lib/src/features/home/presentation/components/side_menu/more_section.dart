import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hisnelmoslem/src/core/shared/transition_animation/transition_animation.dart';
import 'package:hisnelmoslem/src/core/utils/email_manager.dart';
import 'package:hisnelmoslem/src/features/about/presentation/screens/about.dart';
import 'package:hisnelmoslem/src/features/app_update_news/presentation/screens/app_update_news.dart';
import 'package:hisnelmoslem/src/features/home/presentation/components/side_menu/shared.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class MoreSection extends StatelessWidget {
  const MoreSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        DrawerCard(
          child: ListTile(
            leading: Icon(MdiIcons.gmail),
            title: Text("contact to dev".tr),
            onTap: () {
              EmailManager.messageUS();
            },
          ),
        ),
        DrawerCard(
          child: ListTile(
            leading: const Icon(Icons.history),
            title: Text("updates history".tr),
            onTap: () {
              transitionAnimation.fromBottom2Top(
                context: context,
                goToPage: const AppUpdateNews(),
              );
            },
          ),
        ),
        DrawerCard(
          child: ListTile(
            leading: const Icon(Icons.info),
            title: Text("about us".tr),
            onTap: () {
              transitionAnimation.fromBottom2Top(
                context: context,
                goToPage: const About(),
              );
            },
          ),
        ),
      ],
    );
  }
}
