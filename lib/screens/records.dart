import 'package:flutter/material.dart';
import 'package:toggle_list/toggle_list.dart';

const Color appColor = Colors.blueAccent;

class RecordScreen extends StatefulWidget {
  static const routeName = '/record-screen';
  const RecordScreen({super.key});

  @override
  State<RecordScreen> createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Records"),
        centerTitle: true,
        elevation: 0,
        leading: const Icon(
          Icons.menu,
        ),
        actions: const [
          Icon(
            Icons.more_vert,
          ),
        ],
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(23),
          ),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 10, left: 5, right: 5),
        child: ToggleList(
          divider: const SizedBox(height: 10),
          toggleAnimationDuration: const Duration(milliseconds: 400),
          scrollPosition: AutoScrollPosition.begin,
          trailing: const Padding(
            padding: EdgeInsets.all(10),
            child: Icon(Icons.expand_more),
          ),
          children: List.generate(
            5,
            (index) => ToggleListItem(
              leading: const Padding(
                padding: EdgeInsets.all(10),
                child: Icon(Icons.sailing),
              ),
              title: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Registration Number',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(fontSize: 17),
                    ),
                    Text(
                      'Vehicle No',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              divider: const Divider(
                color: Colors.white,
                height: 2,
                thickness: 2,
              ),
              content: Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(20),
                  ),
                  color: appColor.withOpacity(0.15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Destination',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      'CheckIn Time:\nCheckOut Time:\nDockNo:\nParkingLot:\nObjective:',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Divider(
                      color: appColor.withOpacity(0.15),
                      height: 0,
                      thickness: 0,
                    ),
                  ],
                ),
              ),
              headerDecoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: const BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
              expandedHeaderDecoration: BoxDecoration(
                color: appColor.withOpacity(0.60),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
