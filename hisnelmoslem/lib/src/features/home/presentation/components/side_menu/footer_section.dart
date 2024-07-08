import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hisnelmoslem/src/features/home/presentation/components/side_menu/shared.dart';
import 'package:hisnelmoslem/src/features/home/presentation/controller/dashboard_controller.dart';

class FooterSection extends StatelessWidget {
  const FooterSection({
    super.key,
    required this.controller,
  });

  final DashboardController controller;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DrawerCard(
            child: ListTile(
              leading: const Icon(Icons.close),
              title: Text("close".tr),
              onTap: () {
                controller.toggleDrawer();
              },
            ),
          ),
        ],
      ),
    );
  }
}
