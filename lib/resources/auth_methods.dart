// ignore_for_file: avoid_print

import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram/models/user.dart' as model;
import 'package:instagram/resources/storage_methods.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //SignUp user
  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String name,
    required String bio,
    required Uint8List file,
  }) async {
    String res = "Some error occured";
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          bio.isNotEmpty) {
        //register user to firebase
        UserCredential userCred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        print(userCred);

        String photoUrl = await StorageMethods()
            .uploadImageToStorage('profilePics', file, false);

        model.User user = model.User(
          username: username,
          name: name,
          uid: userCred.user!.uid,
          email: email,
          password: password,
          bio: bio,
          photoUrl: photoUrl,
          followers: [],
          following: [],
        );

        // add user to database
        await _firestore.collection('users').doc(userCred.user!.uid).set(
              user.toJason(),
            );
        res = 'Sucess';
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  // getUserData
  Future<model.User> getUserData() async {
    User currentUser = _auth.currentUser!;
    DocumentSnapshot snap =
        await _firestore.collection('users').doc(currentUser.uid).get();

    return model.User.fromSnap(snap);
  }

  //login user
  Future<String> logInUser(
      {required String email, required String password}) async {
    String res = 'Some error occured';

    try {
      if ((email.isNotEmpty || password.isNotEmpty)) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = 'sucess';
      } else {
        res = 'please enter all the fields';
      }
    } catch (e) {
      res = e.toString();
      print(e);
    }
    return res;
  }
}
