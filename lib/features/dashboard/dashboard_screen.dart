import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:onestoprx_driver/features/dashboard/pages/dashboard_explore.dart';
import '../../core/theme/app_colors.dart';
import '../../util/image_constant.dart';
import '../../widgets/custom_image_view.dart';
import '../../widgets/translatable_text.dart';
import 'pages/dashboard_home.dart';
import 'pages/dashboard_earnings.dart';
import 'pages/dashboard_activity.dart';
import 'pages/dashboard_account.dart';

class DashboardScreen extends StatefulWidget {
  final int? passIndex;
  
  const DashboardScreen({Key? key, this.passIndex}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late PageController _pageController;
  int _page = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _pageController = PageController(initialPage: widget.passIndex ?? 0);
    _page = widget.passIndex ?? 0;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void onPageChanged(int page) {
    setState(() {
      this._page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    void toPage(int page) {
      _pageController.jumpToPage(page);
    }

    List<BottomMenuModel> bottomMenuList = [
      BottomMenuModel(
        icon: ImageConstant.imgNavHome,
        activeIcon: ImageConstant.activeAHome,
        title: "Home",
        type: BottomBarEnum.Home,
      ),
      BottomMenuModel(
        icon: ImageConstant.tripIcon,
        activeIcon: ImageConstant.tripIcon,
        title: "Trips",
        type: BottomBarEnum.Search,
      ),
      BottomMenuModel(
        icon: ImageConstant.wallet,
        activeIcon: ImageConstant.wallet,
        title: "Earnings",
        type: BottomBarEnum.Messages,
      ),
      // BottomMenuModel(
      //   icon: ImageConstant.imgNavActivity,
      //   activeIcon: ImageConstant.activeActivity,
      //   title: "Activity",
      //   type: BottomBarEnum.Activity,
      // ),
      BottomMenuModel(
        icon: ImageConstant.imgUser,
        activeIcon: ImageConstant.activeAccount,
        title: "Account",
        type: BottomBarEnum.Account,
      )
    ];

    var routeWidgetsA = <Widget>[
      const DashboardHome(),
      const DashboardTrips(),
      const DashboardEarnings(),
      // const DashboardActivity(),
      const DashboardAccount(),
    ];

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Stack(
          children: [
            PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: _pageController,
              onPageChanged: onPageChanged,
              children: routeWidgetsA,
            ),
            Positioned(
              bottom: 1,
              child: SafeArea(
                child: Container(
                  width: size.width - 24,
                  padding: const EdgeInsets.all(4),
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(1000),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(bottomMenuList.length, (index) {
                      return Expanded(
                        child: IconButton(
                          onPressed: () => toPage(index),
                          icon: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CustomImageView(
                                imagePath: _page == index
                                    ? bottomMenuList[index].activeIcon
                                    : bottomMenuList[index].icon,
                                height: 25,
                                width: 25,
                              ),
                              const SizedBox(height: 4),
                              TranslatableText(
                                text: bottomMenuList[index].title ?? "",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: _page == index
                                      ? CupertinoColors.activeBlue
                                      : Colors.grey,
                                  fontSize: 10.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

enum BottomBarEnum {
  Home,
  Search,
  Messages,
  // Activity,
  Account,
}

class BottomMenuModel {
  BottomMenuModel({
    required this.icon,
    required this.activeIcon,
    this.title,
    required this.type,
  });

  String icon;
  String activeIcon;
  String? title;
  BottomBarEnum type;
}
