import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:yms/screens/phone.dart';

class SideBarWidget extends StatelessWidget {
  const SideBarWidget({super.key});

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
        width: 150,
        decoration: BoxDecoration(
          color: canvasColor,
        ),
      ),
      //footerDivider: divider,
      headerBuilder: (context, extended) {
        return SizedBox(
          height: 50,
          child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Icon(Icons.home_filled)
              // child: Image.asset('assets/images/avatar.png'),
              ),
        );
      },
      items: [
        SidebarXItem(
          icon: Icons.person,
          label: 'Profile',
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
