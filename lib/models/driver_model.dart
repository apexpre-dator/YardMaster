import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yms/models/vehicle_model.dart';

class Driver {
  final String dId;
  final String dName;
  final String dlNo;
  final String phone;
  final String address;
  final String vRegNo;
  String photoUrl;

  Driver({
    required this.dId,
    required this.dName,
    required this.dlNo,
    required this.phone,
    required this.address,
    required this.vRegNo,
    required this.photoUrl,
  });

  Map<String, dynamic> toJson() => {
        "dId": dId,
        "dName": dName,
        "dlNo": dlNo,
        "phone": phone,
        "address": address,
        "vRegNo": vRegNo,
        "photoUrl": photoUrl,
      };

  static Driver fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Driver(
      dId: snapshot["dId"],
      dName: snapshot["dName"],
      dlNo: snapshot["dlNo"],
      phone: snapshot["phone"],
      address: snapshot["address"],
      vRegNo: snapshot["vRegNo"],
      photoUrl: snapshot["photoUrl"],
    );
  }
}
