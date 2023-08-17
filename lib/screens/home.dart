import 'package:flutter/material.dart';
import 'package:motion_tab_bar_v2/motion-tab-bar.dart';
import 'package:motion_tab_bar_v2/motion-tab-controller.dart';

import 'package:yms/screens/incomingRegistration.dart';
import 'package:yms/screens/outgoingVehicles.dart';
import 'package:yms/screens/qr_scan.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  MotionTabBarController? _motionTabBarController;

  @override
  void initState() {
    super.initState();
    _motionTabBarController = MotionTabBarController(
      initialIndex: 0,
      length: 3,
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
        title: const Text("Yard Management System"),
        centerTitle: true,
      ),
      body: TabBarView(
        controller: _motionTabBarController,
        children: <Widget>[
          SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
              height: MediaQuery.of(context).size.height - 100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      print('here');
                      Navigator.of(context)
                          .pushNamed(IncomingRegistration.routeName);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                        color: Colors.black54,
                        width: 3,
                      )),
                      height: 180,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset('assets/incoming.gif'),
                          const Text(
                            'Incoming',
                            style: TextStyle(
                              color: Colors.blueAccent,
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  GestureDetector(
                    onTap: () {
                      // Navigator.of(context)
                      //               .pushNamed(QRViewExample.routeName);
                      // Navigator.of(context).pop();
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => OutgoingRegistration(
                            vRegNo: "e68615c0-3c63-11ee-a167-893336dfd0f6"),
                      ));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                        color: Colors.black54,
                        width: 3,
                      )),
                      height: 180,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset('assets/outgoing.gif'),
                          const Text(
                            'Outgoing',
                            style: TextStyle(
                              color: Colors.blueAccent,
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            child: Center(
              child: Text("Records"),
            ),
          ),
          Container(
            child: Center(
              child: Text("Dashboard"),
            ),
          ),
        ],
      ),
      bottomNavigationBar: MotionTabBar(
        tabBarColor: Colors.blueAccent,
        controller: _motionTabBarController,
        labels: const [
          "Home",
          "Records",
          "Dashboard",
        ],
        initialSelectedTab: "Home",
        tabIconColor: Colors.white,
        tabSelectedColor: Colors.red,
        onTabItemSelected: (int value) {
          setState(() {
            _motionTabBarController?.index = value;
          });
        },
        icons: const [
          Icons.home,
          Icons.receipt,
          Icons.person,
        ],
        textStyle: const TextStyle(color: Colors.white),
      ),
    );
  }
}
