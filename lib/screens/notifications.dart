import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Notifications extends StatefulWidget {
  static const routeName = '/notifications';
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  final String userId = FirebaseAuth.instance.currentUser!.uid;

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
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('drivers')
            .doc(userId)
            .collection('notifications')
            .orderBy('timestamp', descending: false)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          var data = snapshot.data!.docs;
          return ListView.builder(
            itemCount: data.length,
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              final snap = data[index].data();

              var time = DateFormat('hh:mm a')
                  .format(DateTime.parse(snap['time']))
                  .toString();
              var date = DateFormat("dd-MM-yyyy")
                  .format(DateTime.parse(snap['time']))
                  .toString();

              return ListTile(
                leading: CircleAvatar(
                  child: Icon(Icons.notifications_active_outlined),
                ),
                title: Text('YardMaster'),
                subtitle: Text(snap['text']),
                trailing: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      date,
                    ),
                    Text(
                      time,
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
