import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:yms/methods/firestore_methods.dart';
import 'package:yms/models/user_model.dart';
import 'package:yms/screens/phone.dart';

class SideBarWidget extends StatefulWidget {
  const SideBarWidget({super.key});

  @override
  State<SideBarWidget> createState() => _SideBarWidgetState();
}

class _SideBarWidgetState extends State<SideBarWidget> {
  late UserModel user;
  bool _isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      _isLoading = true;
    });
    user = await FirestoreMethods()
        .getUser(FirebaseAuth.instance.currentUser!.uid);

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    const canvasColor = Color(0xFF2E2E48);
    const scaffoldBackgroundColor = Color(0xFF464667);
    const accentCanvasColor = Color(0xFF3E3E61);
    final actionColor = const Color(0xFF5F5FA7).withOpacity(0.6);
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
        hoverColor: scaffoldBackgroundColor,
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
            color: actionColor.withOpacity(0.37),
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
        width: 225,
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
            label: user.name,
          ),
        if (!_isLoading)
          SidebarXItem(
            label: user.empId,
            icon: Icons.abc,
          ),
        if (!_isLoading)
          SidebarXItem(
            icon: Icons.email,
            label: user.email,
          ),
        if (!_isLoading)
          SidebarXItem(
            icon: Icons.warehouse,
            label: user.yardName,
          ),
        SidebarXItem(
          icon: Icons.edit,
          label: 'Edit Profile',
          onTap: () {},
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
