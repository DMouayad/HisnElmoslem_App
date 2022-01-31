import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hisnelmoslem/shared/widgets/loading.dart';
import 'package:hisnelmoslem/shared/constant.dart';
import 'package:hisnelmoslem/shared/transition_animation/transition_animation.dart';
import 'package:hisnelmoslem/utils/notification_manager.dart';
import 'package:hisnelmoslem/views/pages/bookmarks.dart';
import 'package:hisnelmoslem/views/pages/fehrs.dart';
import 'package:hisnelmoslem/views/screens/app_update_news.dart';
import 'package:hisnelmoslem/views/screens/fake_hadith.dart';
import 'package:hisnelmoslem/views/screens/quran_read_page.dart';
import 'package:hisnelmoslem/views/screens/settings.dart';
import 'package:hisnelmoslem/views/screens/tally.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'azkar_read_page.dart';

class AzkarDashboard extends StatefulWidget {
  final String? payload;
  const AzkarDashboard({Key? key, required this.payload}) : super(key: key);

  @override
  _AzkarDashboardState createState() => _AzkarDashboardState();
}

class _AzkarDashboardState extends State<AzkarDashboard>
    with SingleTickerProviderStateMixin {
  TextEditingController searchController = TextEditingController();
  int currentIndex = 0;
  bool isLoading = false;
  bool isSearching = false;
  String searchTxt = "";
  late TabController tabController;

  @override
  void dispose() {
    searchController.dispose();
    tabController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top]);

    //Manage Notification feedback

    if (widget.payload != "") {
      onNotificationClick(widget.payload!);
    }

    localNotifyManager.setOnNotificationReceive(onNotificationReceive);
    localNotifyManager.setOnNotificationClick(onNotificationClick);

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top]);

    tabController = new TabController(initialIndex: 0, length: 2, vsync: this);
    // pageController = new PageController(initialPage: 0);
    setState(() {
      isLoading = false;
    });
  }

  onNotificationReceive(ReceiveNotification notification) {}

  onNotificationClick(String payload) {
    debugPrint('payload = $payload');
    if (payload == "الكهف") {
      transitionAnimation.fromBottom2Top(
          context: context, goToPage: QuranReadPage());
    } else if (payload == "555" || payload == "777") {
    } else {
      int? pageIndex = int.parse(payload);
      debugPrint('pageIndex = $pageIndex');

      debugPrint('Will open = $pageIndex');
      debugPrint("pageIndex: " + pageIndex.toString());
      transitionAnimation.fromBottom2Top(
          context: context, goToPage: AzkarReadPage(index: pageIndex));
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Loading()
        : Scaffold(
            body: NestedScrollView(
              floatHeaderSlivers: true,
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverAppBar(
                    title: isSearching
                        ? TextFormField(
                            style: TextStyle(decorationColor: MAINCOLOR),
                            textAlign: TextAlign.center,
                            controller: searchController,
                            autofocus: true,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                hintText: "البحث",
                                contentPadding: EdgeInsets.only(
                                    left: 15, bottom: 5, top: 5, right: 15),
                                prefix: IconButton(
                                  icon: Icon(Icons.clear_all),
                                  onPressed: () {
                                    searchController.clear();
                                    setState(() {
                                      searchTxt = "";
                                    });
                                  },
                                )),
                            onChanged: (value) {
                              setState(() {
                                searchTxt = value;
                              });
                            },
                          )
                        : GestureDetector(
                            onLongPress: () {
                              transitionAnimation.fromBottom2Top(
                                  context: context, goToPage: QuranReadPage());
                            },
                            onTap: () {
                              transitionAnimation.fromBottom2Top(
                                  context: context, goToPage: AppUpdateNews());
                            },
                            child: Image.asset(
                              'assets/images/app_icon.png',
                              scale: 6,
                            ),
                          ),
                    pinned: true,
                    floating: true,
                    snap: true,
                    bottom: TabBar(
                        indicatorColor: Colors.blue.shade200,
                        labelColor: Colors.blue.shade200,
                        unselectedLabelColor: Colors.white,
                        controller: tabController,
                        tabs: [
                          Tab(
                            child: Text(
                              "الفهرس",
                              style: TextStyle(fontFamily: "Uthmanic"),
                            ),
                          ),
                          Tab(
                            child: Text(
                              "المفضلة",
                              style: TextStyle(fontFamily: "Uthmanic"),
                            ),
                          ),
                        ]),
                    actions: [
                      isSearching
                          ? IconButton(
                              splashRadius: 20,
                              padding: EdgeInsets.all(0),
                              icon: Icon(Icons.exit_to_app_sharp),
                              onPressed: () {
                                setState(() {
                                  isSearching = false;
                                  searchController.clear();
                                });
                              })
                          : IconButton(
                              splashRadius: 20,
                              padding: EdgeInsets.all(0),
                              icon: Icon(Icons.search),
                              onPressed: () {
                                setState(() {
                                  isSearching = true;
                                  searchTxt = "";
                                });
                              }),
                      isSearching
                          ? SizedBox()
                          : IconButton(
                              splashRadius: 20,
                              padding: EdgeInsets.all(0),
                              icon: Icon(Icons.watch_outlined),
                              onPressed: () {
                                transitionAnimation.fromBottom2Top(
                                    context: context, goToPage: Tally());
                              }),
                      isSearching
                          ? SizedBox()
                          : IconButton(
                              splashRadius: 20,
                              padding: EdgeInsets.all(0),
                              icon: Icon(
                                MdiIcons.bookOpenPageVariant,
                              ),
                              onPressed: () {
                                transitionAnimation.fromBottom2Top(
                                    context: context, goToPage: FakeHadith());
                              }),
                      IconButton(
                          splashRadius: 20,
                          padding: EdgeInsets.all(0),
                          icon: Icon(Icons.settings),
                          onPressed: () {
                            transitionAnimation.fromBottom2Top(
                                context: context, goToPage: Settings());
                          }),
                    ],
                  ),
                ];
              },
              body: TabBarView(
                controller: tabController,
                children: [
                  AzkarFehrs(
                    isSearching: isSearching,
                    searchTxt: searchTxt,
                  ),
                  AzkarBookmarks(),
                ],
              ),
            ),
          );
  }
}
