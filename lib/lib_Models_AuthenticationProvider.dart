import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:finalapplication/Models/database.dart';
import 'package:image_picker/image_picker.dart';

class AuthenticationProvider {
  final FirebaseAuth firebaseAuth;
  //FirebaseAuth instance
  AuthenticationProvider(this.firebaseAuth);
  //Constuctor to initalize the FirebaseAuth instance

  //Using Stream to listen to Authentication State
  Stream<User> get authState => firebaseAuth.idTokenChanges();

  //SIGN UP METHOD
  Future<String> signUp(
      {@required String email,
      @required String password,
      @required String Gender,
      @required int age,
      @required String name,
      @required PickedFile image}) async {
    try {
      print('essaye');

      await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      final _user = await firebaseAuth.currentUser;
      final _database = DatabaseService(Uid: _user.uid);
      print('öncesi');
      EasyLoading.showInfo('please wait this can take up to 5 or 6 minutes.');
      await _database.uploadFileWithMetadata(image.path);
      print('sonrası');
      await _database.UpdateUserData(
        Gender: Gender,
        age: age,
        name: name,
      );
      return 'a';
    } on FirebaseAuthException catch (e) {
      EasyLoading.showError(e.message);
      return e.message;
    }
  }

  //SIGN IN METHOD
  Future<String> signIn({String email, String password}) async {
    try {
      print('essaye');
      await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return "Signed in!";
    } on FirebaseAuthException catch (e) {
      EasyLoading.showError(e.message);
      throw e.message;
    }
  }

  //SIGN OUT METHOD
  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }
}
