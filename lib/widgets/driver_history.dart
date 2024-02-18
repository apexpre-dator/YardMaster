import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:yms/colours.dart';
import 'package:yms/models/vehicle_model.dart';

class DriverHistoryCard extends StatelessWidget {
  const DriverHistoryCard({super.key, required this.v});
  final Vehicle v;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(20),
        ),
        color: lightColor.withOpacity(0.6),
      ),
      margin: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      'Date - ${DateFormat('dd/MM/yy').format(DateTime.parse(v.timeIn))}'),
                  Text(
                      'Checkin Time - ${DateFormat.jm().format(DateTime.parse(v.timeIn))}'),
                  Text('Checkout Time -'),
                  Text('Vehicle No - ${v.vNo}')
                ],
              ),
              Image.asset(
                'assets/truck.png',
                fit: BoxFit.fill,
                height: MediaQuery.of(context).size.height * 0.20,
                width: MediaQuery.of(context).size.width * 0.30,
              ),
            ],
          ),
          Text('Warehouse Name'),
          Text(
            'Source Address - ${v.sourceCity},${v.sourceState},${v.sourceCountry.substring(8)}',
            maxLines: 3,
          ),
        ],
      ),
    );
  }
}
