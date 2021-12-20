import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hisnelmoslem/AppManager/NotificationManager.dart';
import 'package:hisnelmoslem/Pages/Bookmarks.dart';
import 'package:hisnelmoslem/Pages/Fehrs.dart';
import 'package:hisnelmoslem/Screens/AppUpdateNews.dart';
import 'package:hisnelmoslem/Screens/FakeHadith.dart';
import 'package:hisnelmoslem/Screens/Settings.dart';
import 'package:hisnelmoslem/Screens/Tally.dart';
import 'package:hisnelmoslem/Shared/TransitionAnimation/TransitionAnimation.dart';
import 'package:hisnelmoslem/Shared/Widgets/Loading.dart';
import 'package:hisnelmoslem/Shared/constant.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'AzkarReadPage.dart';
import 'QuranReadPage.dart';

class AzkarDashboard extends StatefulWidget {
  const AzkarDashboard({Key? key}) : super(key: key);

  @override
  _AzkarDashboardState createState() => _AzkarDashboardState();
}

class _AzkarDashboardState extends State<AzkarDashboard>
    with SingleTickerProviderStateMixin {
  TextEditingController searchController = TextEditingController();
  int currentIndex =0;
  bool isLoading = false;
  bool isSearching = false;
  String searchTxt ="";
  late TabController tabController;

  // PageController pageController;
  //var appSettings;

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });

    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);

    //Manage Notification feedback
    localNotifyManager.setOnNotificationReceive(onNotificationReceive);
    localNotifyManager.setOnNotificationClick(onNotificationClick);

    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);

    tabController = new TabController(initialIndex: 0, length: 2, vsync: this);
    // pageController = new PageController(initialPage: 0);
    setState(() {
      isLoading = false;
    });
  }

  onNotificationReceive(ReceiveNotification notification) {}

  onNotificationClick(String payload) {
    print('payload = $payload');
    if (payload == "الكهف") {
      transitionAnimation.fromBottom2Top(
          context: context, goToPage: QuranReadPage());
    } else if (payload == "555" || payload == "777") {
    } else {
      int? pageIndex = int.parse(payload);
      print('pageIndex = $pageIndex');
      if (pageIndex != null) {
        print('Will open = $pageIndex');
        print(pageIndex.toString());
        transitionAnimation.fromBottom2Top(
            context: context, goToPage: AzkarReadPage(index: pageIndex - 1));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Loading()
        : DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: AppBar(
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
                  onLongPress: (){
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
                bottom: TabBar(
                  indicatorColor: Colors.blue.shade200,
                  labelColor: Colors.blue.shade200,
                  unselectedLabelColor: Colors.white,
                  tabs: <Widget>[
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
                  ],
                ),
              ),
              body: ScrollConfiguration(
                behavior: ScrollBehavior(),
                child: GlowingOverscrollIndicator(
                  axisDirection: AxisDirection.left,
                  color: Colors.black26,
                  child: TabBarView(
                    physics: ClampingScrollPhysics(),
                    children: [
                      AzkarFehrs(
                        isSearching: isSearching,
                        searchTxt: searchTxt,
                      ),
                      AzkarBookmarks(),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
