import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class StorageMethods {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadImgToStorage(String vRegNo, File file, bool d) async {
    Reference ref;

    if( d ){
      ref = _storage.ref().child('vehicles').child(vRegNo);
    }
    else{
      ref = _storage.ref().child('drivers').child(vRegNo);
    }
    
    UploadTask uploadTask = ref.putFile(file);

    TaskSnapshot snap = await uploadTask;
    
    String downloadURL = await snap.ref.getDownloadURL();

    return downloadURL;
  }
}