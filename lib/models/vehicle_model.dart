import 'package:cloud_firestore/cloud_firestore.dart';

class Vehicle {
  final String regNo;
  final String vNo;
  final String vWeight;
  final String vModel;
  final String persons;
  final String dId;
  final String objective;
  final String dockNo;
  final String lotNo;
  final String timeIn;
  String? timeOut;
  final String sourceWarehouse;
  final String sourceCity;
  final String sourceState;
  final String sourceCountry;
  String? destination;
  String photoUrl;

  Vehicle({
    required this.regNo,
    required this.vNo,
    required this.vWeight,
    required this.vModel,
    required this.persons,
    required this.dId,
    required this.objective,
    required this.dockNo,
    required this.lotNo,
    required this.timeIn,
    this.timeOut,
    required this.sourceWarehouse,
    required this.sourceCity,
    required this.sourceState,
    required this.sourceCountry,
    this.destination,
    required this.photoUrl,
  });

  Map<String, dynamic> toJson() => {
        "regNo": regNo,
        "vNo": vNo,
        "vWeight": vWeight,
        "vModel": vModel,
        "persons": persons,
        "dId": dId,
        "objective": objective,
        "dockNo": dockNo,
        "lotNo": lotNo,
        "timeIn": timeIn,
        "timeOut": timeOut,
        "sourceWarehouse": sourceWarehouse,
        "sourceCity": sourceCity,
        "sourceState": sourceState,
        "sourceCountry": sourceCountry,
        "destination": destination,
        "photoUrl": photoUrl,
      };

  static Vehicle fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Vehicle(
      regNo: snapshot["regNo"],
      vNo: snapshot["vNo"],
      vWeight: snapshot["vWeight"],
      vModel: snapshot["vModel"],
      persons: snapshot["persons"],
      dId: snapshot["dId"],
      objective: snapshot["objective"],
      dockNo: snapshot["dockNo"],
      lotNo: snapshot["lotNo"],
      timeIn: snapshot["timeIn"],
      sourceWarehouse: snapshot["sourceWarehouse"],
      sourceCity: snapshot["sourceCity"],
      sourceState: snapshot["sourceState"],
      sourceCountry: snapshot["sourceCountry"],
      photoUrl: snapshot["photoUrl"],
      destination: snapshot["destination"],
      timeOut: snapshot["timeOut"],
    );
  }
}
