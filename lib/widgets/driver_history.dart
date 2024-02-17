import 'package:flutter/material.dart';
import 'package:yms/colours.dart';

class DriverHistoryCard extends StatelessWidget {
  const DriverHistoryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(20),
        ),
        color: lightColor.withOpacity(0.6),
      ),
      margin: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Date - dd/mm/yyyy'),
              Text('Warehouse Name'),
              Text('Warehouse Address'),
              Text('Checkin Time'),
              Text('Checkout Time'),
            ],
          ),
          Image.asset(
            'assets/truck.png',
            fit: BoxFit.fill,
            height: MediaQuery.of(context).size.height * 0.20,
            width: MediaQuery.of(context).size.width * 0.35,
          ),
        ],
      ),
    );
  }
}
