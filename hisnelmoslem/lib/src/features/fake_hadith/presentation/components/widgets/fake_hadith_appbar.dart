import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FakehadithAppBar extends StatelessWidget {
  const FakehadithAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      title: Text("fake hadith".tr),
      centerTitle: true,
      elevation: 0,
      pinned: true,
      floating: true,
      snap: true,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: TabBar(
          tabs: [
            Tab(
              child: Text(
                "new".tr,
              ),
            ),
            Tab(
              child: Text(
                "have been read".tr,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
