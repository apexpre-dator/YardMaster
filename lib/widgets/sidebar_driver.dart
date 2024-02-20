import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:yms/methods/firestore_methods.dart';
import 'package:yms/models/driver_model.dart';
import 'package:yms/screens/phone.dart';
import 'package:yms/colours.dart';

class SideBarDriverWidget extends StatefulWidget {
  const SideBarDriverWidget({super.key});

  @override
  State<SideBarDriverWidget> createState() => _SideBarDriverWidgetState();
}

class _SideBarDriverWidgetState extends State<SideBarDriverWidget> {
  late DriverModel user;
  bool _isLoading = false;

  getData() async {
    setState(() {
      _isLoading = true;
    });
    user = await FirestoreMethods()
        .getDriver(FirebaseAuth.instance.currentUser!.uid);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    final SidebarXController controller =
        SidebarXController(selectedIndex: 0, extended: true);

    return SidebarX(
      controller: controller,
      theme: SidebarXTheme(
        //margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: canvasColor,
          borderRadius: BorderRadius.circular(20),
        ),
        hoverColor: darkColor,
        textStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
        selectedTextStyle: const TextStyle(color: Colors.white),
        itemTextPadding: const EdgeInsets.only(left: 30),
        selectedItemTextPadding: const EdgeInsets.only(left: 30),
        itemDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: canvasColor),
        ),
        selectedItemDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: borderColor,
          ),
          gradient: const LinearGradient(
            colors: [accentCanvasColor, canvasColor],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.28),
              blurRadius: 30,
            )
          ],
        ),
        iconTheme: IconThemeData(
          color: Colors.white.withOpacity(0.7),
          size: 20,
        ),
        selectedIconTheme: const IconThemeData(
          color: Colors.white,
          size: 20,
        ),
      ),
      extendedTheme: const SidebarXTheme(
        width: 260,
        decoration: BoxDecoration(
          color: canvasColor,
        ),
      ),
      //footerDivider: divider,
      headerBuilder: (context, extended) {
        return const SizedBox(
          height: 150,
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: CircleAvatar(
              minRadius: 25,
              backgroundColor: Colors.white,
              child: Icon(
                Icons.person_2_rounded,
                size: 25,
                color: Color(0xFF5F5FA7),
              ),
            ),
            // child: Image.asset('assets/images/avatar.png'),
          ),
        );
      },
      items: [
        if (!_isLoading)
          SidebarXItem(
            icon: Icons.person,
            label: user.dName,
          ),
        if (!_isLoading)
          SidebarXItem(
            label: user.dlNo,
            icon: Icons.abc,
          ),
        if (!_isLoading)
          SidebarXItem(
            icon: Icons.phone,
            label: user.phone,
          ),
        if (!_isLoading)
          SidebarXItem(
            icon: Icons.mail,
            label: user.address,
          ),
        SidebarXItem(
          icon: Icons.logout_outlined,
          label: 'Logout',
          onTap: () {
            FirebaseAuth auth = FirebaseAuth.instance;
            auth.signOut();
            Navigator.of(context).popAndPushNamed(MyPhone.routeName);
          },
        ),
      ],
    );
  }
}
