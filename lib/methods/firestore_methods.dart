import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yms/methods/storage_methods.dart';
import 'package:yms/models/driver_model.dart';
import 'package:yms/models/vehicle_model.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> registerVehicle(
    Vehicle v,
    Driver d,
    File? vehicleImage,
    File? driverPic,
  ) async {
    String res = "Error Occured!";

    try {
      String vPhotoUrl =
          await StorageMethods().uploadImgToStorage(v.regNo, vehicleImage!, false);
      String dPhotoUrl =
          await StorageMethods().uploadImgToStorage(v.regNo, driverPic!, true);

      v.photoUrl = vPhotoUrl;
      d.photoUrl = dPhotoUrl;

      _firestore.collection('vehicles').doc().set(
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
}
