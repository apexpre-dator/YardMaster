import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String name;
  final String email;
  final String empId;
  final String uid;
  final String yardName;
  final String phone;

  User({
    required this.name,
    required this.email,
    required this.empId,
    required this.uid,
    required this.yardName,
    required this.phone,
  });

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "name": name,
        "email": email,
        "empId": empId,
        "yardName": yardName,
        "phone": phone,
      };

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return User(
      name: snapshot['name'],
      email: snapshot['email'],
      empId: snapshot['empId'],
      uid: snapshot['uid'],
      yardName: snapshot['yardName'],
      phone: snapshot['phone'],
    );
  }
}
