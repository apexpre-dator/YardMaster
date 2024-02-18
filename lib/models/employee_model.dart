import 'package:cloud_firestore/cloud_firestore.dart';

class EmployeeModel {
  final String name;
  final String email;
  final String empId;
  final String uid;
  final String yardName;
  String? phone;

  EmployeeModel({
    required this.name,
    required this.email,
    required this.empId,
    required this.uid,
    required this.yardName,
    this.phone,
  });

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "name": name,
        "email": email,
        "empId": empId,
        "yardName": yardName,
        "phone": phone,
      };

  static EmployeeModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return EmployeeModel(
      name: snapshot['name'],
      email: snapshot['email'],
      empId: snapshot['empId'],
      uid: snapshot['uid'],
      yardName: snapshot['yardName'],
      phone: snapshot['phone'],
    );
  }
}
