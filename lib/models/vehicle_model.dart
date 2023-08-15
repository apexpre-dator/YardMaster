import 'package:yms/models/driver_model.dart';

class Vehicle {
  final String regNo;
  final String vNo;
  final String vWeight;
  final String vModel;
  final String persons;
  final Driver driver;
  final String objective;
  final int dockNo;
  final int lotNo;
  final DateTime timeIn;
  final DateTime timeOut;
  final String source;
  final String destination;
  
  Vehicle({
    required this.regNo,
    required this.vNo,
    required this.vWeight,
    required this.vModel,
    required this.persons,
    required this.driver,
    required this.objective,
    required this.dockNo,
    required this.lotNo,
    required this.timeIn,
    required this.timeOut,
    required this.source,
    required this.destination,
  });

}
