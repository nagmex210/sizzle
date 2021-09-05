import 'package:flutter/cupertino.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';

class Userdata extends ChangeNotifier {
  String url;
  Map<String,dynamic> userData ;
  String uid;


  Future<String> GetUserpp() async {
    String downloadURL = await firebase_storage.FirebaseStorage.instance
        .ref('/ProfilePictures/${uid}')
        .getDownloadURL();

    url = downloadURL;
    print(url);
    notifyListeners();
  }


   void updateUserUid (newUserUid) {
    print(newUserUid);
    uid = newUserUid ;
    print(uid);
    notifyListeners();
  }


  Future<String> GetUserData() async {
   final CollectionReference users =  FirebaseFirestore.instance.collection('UserData');
   users.doc(uid).get().then((DocumentSnapshot documentSnapshot) {
     if (documentSnapshot.exists) {
       print('Document data: ${documentSnapshot.data()}');
       userData = documentSnapshot.data();
     } else {
       print('Document does not exist on the database');
     }
   });

  }


}
