import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:io';
import 'package:flutter/cupertino.dart';

class DatabaseService {
  final String Uid;

  DatabaseService({@required this.Uid});

  final CollectionReference UserData =
      FirebaseFirestore.instance.collection('UserData');

  Future<void> UpdateUserData(
      {String Gender, int age, String name,}) async {
    try {
      return await UserData.doc(Uid).set({
        'Gender': Gender,
        'age': age,
        'name': name,
        'wins': 0,
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> uploadFileWithMetadata(String filePath) async {
    File file = File(filePath);

    try {
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref('/ProfilePictures/$Uid');

      await ref.putFile(file);
    } catch (e) {
      print(e);
    }
  }
}
