import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yms/methods/storage_methods.dart';
import 'package:yms/models/driver_model.dart';
import 'package:yms/models/vehicle_model.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> exitYard(Vehicle v) async {
    String res = "Error Occured!";

    try {
      _firestore.collection('vehicles').doc(v.regNo).update({
        "destination": v.destination,
        "timeOut": v.timeOut,
      });

      res = "success";
    } on FirebaseException catch (e) {
      res = e.toString();
    } catch (e) {
      res = e.toString();
    }

    return res;
  }

  Future<String> registerVehicle(
    Vehicle v,
    Driver d,
    File? vehicleImage,
    File? driverPic,
  ) async {
    String res = "Error Occured!";

    try {
      String vPhotoUrl = await StorageMethods()
          .uploadImgToStorage(v.regNo, vehicleImage!, false);
      String dPhotoUrl =
          await StorageMethods().uploadImgToStorage(v.regNo, driverPic!, true);

      v.photoUrl = vPhotoUrl;
      d.photoUrl = dPhotoUrl;

      _firestore.collection('vehicles').doc(v.regNo).set(
            v.toJson(),
          );
      _firestore.collection('drivers').doc(d.dId).set(
            d.toJson(),
          );

      res = "success";
    } on FirebaseException catch (e) {
      res = e.toString();
    } catch (e) {
      res = e.toString();
    }

    return res;
  }

  Future<Vehicle> getVehicle(String vRegNo) async {
    DocumentSnapshot doc =
        await _firestore.collection('vehicles').doc(vRegNo).get();
    Vehicle v = Vehicle.fromSnap(doc);
    return v;
  }

  Future<List<Vehicle>> getVehicles() async {
    List<Vehicle> v = [];
    var temp = await _firestore.collection('vehicles').get();
    final allData = temp.docs.map((doc) => doc.data()).toList();
    for (var element in allData) {
      DocumentSnapshot doc =
          await _firestore.collection('vehicles').doc(element['regNo']).get();
      v.add(Vehicle.fromSnap(doc));
    }
    return v;
  }

  Future<Driver> getDriver(String dId) async {
    DocumentSnapshot doc =
        await _firestore.collection('drivers').doc(dId).get();
    Driver d = Driver.fromSnap(doc);
    return d;
  }
}
