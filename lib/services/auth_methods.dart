import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecosort_app_test/models/user.dart' as model;
import 'package:firebase_auth/firebase_auth.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot snap =
        await _firestore.collection('users').doc(currentUser.uid).get();

    return model.User.fromSnap(snap);
  }

  // sign up the user
  Future<String> signupUser({
    required String email,
    required String password,
    required String username,
    required String bio,
  }) async {
    String res = "Some error occurred";

    try {
      if (email.isNotEmpty &&
          password.isNotEmpty &&
          username.isNotEmpty &&
          bio.isNotEmpty) {
        // registering user here
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        print(cred.user!.uid);

        // adding user to database

        model.User user = model.User(
          username: username,
          uid: cred.user!.uid,
          email: email,
        );

        await _firestore.collection('users').doc(cred.user!.uid).set(
              user.toJson(),
            );

        res = 'success';
      } else {
        res = 'Please fill all the fields';
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // loggin in user
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error occurred!";

    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = "success";
      } else {
        res = "Please input all fields";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
