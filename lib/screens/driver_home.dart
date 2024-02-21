import 'package:flutter/material.dart';
import 'package:motion_tab_bar_v2/motion-tab-bar.dart';
import 'package:motion_tab_bar_v2/motion-tab-controller.dart';
import 'package:yms/colours.dart';
import 'package:yms/screens/driver_QRScreen.dart';
import '../widgets/sidebar_driver.dart';
import './driver_history.dart';

class DriverHomeScreen extends StatefulWidget {
  const DriverHomeScreen({super.key});
  static const routeName = '/driver';

  @override
  State<DriverHomeScreen> createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen>
    with TickerProviderStateMixin {
  MotionTabBarController? _motionTabBarController;

  @override
  void initState() {
    super.initState();
    _motionTabBarController = MotionTabBarController(
      initialIndex: 0,
      length: 2,
      vsync: this,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _motionTabBarController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("YardMaster"),
        centerTitle: true,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(23),
          ),
        ),
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.notifications_none,
          ),
        ),
        // actions: [
        //   IconButton(
        //       onPressed: () {
        //         FirebaseAuth auth = FirebaseAuth.instance;
        //         auth.signOut();
        //         Navigator.of(context).popAndPushNamed(MyPhone.routeName);
        //       },
        //       icon: Icon(Icons.logout))
        // ],
      ),
      endDrawer: const SafeArea(child: SideBarDriverWidget()),
      body: TabBarView(
        controller: _motionTabBarController,
        children: const <Widget>[
          // QR Screen
          DriverQRScreen(),
          // History Screen
          DriverHistoryScreen(),
        ],
      ),
      bottomNavigationBar: MotionTabBar(
        tabBarColor: darkColor,
        controller: _motionTabBarController,
        labels: const [
          "QR Code",
          "History",
        ],
        initialSelectedTab: "QR Code",
        tabIconColor: Colors.white,
        tabSelectedColor: lightColor.withOpacity(1),
        onTabItemSelected: (int value) {
          setState(() {
            _motionTabBarController?.index = value;
          });
        },
        icons: const [
          Icons.qr_code_2,
          Icons.history,
        ],
        textStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
