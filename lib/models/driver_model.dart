import 'package:cloud_firestore/cloud_firestore.dart';

class DriverModel {
  final String dId;
  final String dName;
  final String dlNo;
  final String phone;
  final String address;

  DriverModel({
    required this.dId,
    required this.dName,
    required this.dlNo,
    required this.phone,
    required this.address,
  });

  Map<String, dynamic> toJson() => {
        "dId": dId,
        "dName": dName,
        "dlNo": dlNo,
        "phone": phone,
        "address": address,
      };

  static DriverModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return DriverModel(
      dId: snapshot["dId"],
      dName: snapshot["dName"],
      dlNo: snapshot["dlNo"],
      phone: snapshot["phone"],
      address: snapshot["address"],
    );
  }
}
