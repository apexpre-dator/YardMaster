import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yms/methods/storage_methods.dart';
import 'package:yms/models/driver_model.dart';
import 'package:yms/models/employee_model.dart';
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
    // String dId,
    File? vehicleImage,
    File? driverPic,
  ) async {
    String res = "Error Occured!";

    try {
      String vPhotoUrl = await StorageMethods()
          .uploadImgToStorage(v.regNo, vehicleImage!, false);
      // String dPhotoUrl =
      //     await StorageMethods().uploadImgToStorage(v.regNo, driverPic!, true);

      v.photoUrl = vPhotoUrl;

      _firestore.collection('vehicles').doc(v.regNo).set(
            v.toJson(),
          );

      // Need to update Image in Driver's Collection
      // _firestore.collection('drivers').doc(dId).set(
      //       d.toJson(),
      //     );

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

  Future<Vehicle?> getCurrentDriverVehicle(String dId) async {
    Vehicle? v;
    var temp = await _firestore
        .collection('vehicles')
        .where('dId', isEqualTo: dId)
        .where('timeOut', isEqualTo: null)
        .get();
    final allData = temp.docs.map((doc) => doc.data()).toList();
    for (var element in allData) {
      DocumentSnapshot doc =
          await _firestore.collection('vehicles').doc(element['regNo']).get();
      v = Vehicle.fromSnap(doc);
    }
    return v;
  }

  Future<List<Vehicle>> getDriverVehicles(String dId) async {
    List<Vehicle> v = [];
    var temp = await _firestore
        .collection('vehicles')
        .where('dId', isEqualTo: dId)
        .get();
    final allData = temp.docs.map((doc) => doc.data()).toList();
    for (var element in allData) {
      DocumentSnapshot doc =
          await _firestore.collection('vehicles').doc(element['regNo']).get();
      v.add(Vehicle.fromSnap(doc));
    }
    return v;
  }

  Future<DriverModel> getDriver(String dId) async {
    DocumentSnapshot doc =
        await _firestore.collection('drivers').doc(dId).get();
    DriverModel d = DriverModel.fromSnap(doc);
    return d;
  }

  Future<EmployeeModel> getEmplpyee(String dId) async {
    DocumentSnapshot doc =
        await _firestore.collection('employees').doc(dId).get();
    EmployeeModel d = EmployeeModel.fromSnap(doc);
    return d;
  }
}
