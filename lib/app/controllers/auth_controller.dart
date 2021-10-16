// firebase
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// model
import 'package:money_monitoring/app/modules/home/data/models/user_model.dart';

import 'package:get/get.dart';

class AuthController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  late GoogleSignIn googleSignIn = GoogleSignIn();
  GoogleSignInAccount? loggedInUser;

  var user = UserModel().obs;

  Future<bool> autoLogin() async {
    await googleSignIn.disconnect();
    await googleSignIn.signOut();
    if (await googleSignIn.isSignedIn()) {
      loggedInUser = await googleSignIn.signInSilently();
      print(loggedInUser);
      return true;
    }
    return false;
  }

  Future<bool> gmailLogin() async {
    String dateNow = DateTime.now().toIso8601String();
    try {
      // Trigger the authentication flow
      loggedInUser = await googleSignIn.signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await loggedInUser!.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth!.accessToken,
        idToken: googleAuth.idToken,
      );

      // Add user to firestore
      CollectionReference users = firestore.collection('users');

      print(loggedInUser);
      await auth.signInWithCredential(credential);
      final checkUser = await users.doc(loggedInUser!.email).get();

      if (checkUser.data() != null) {
      } else {
        await users.doc(loggedInUser!.email).set({
          "name": loggedInUser!.displayName,
          "email": loggedInUser!.email,
          "photoUrl": loggedInUser!.photoUrl,
          "createdAt": dateNow,
          "updatedAt": dateNow,
          "totalEntireSpent": 0.toString(),
        });
      }

      final currentUser = await users.doc(loggedInUser!.email).get();
      final currentUserData = currentUser.data() as Map<String, dynamic>;

      user(UserModel.fromJson(currentUserData));
      user.refresh();
      print(user);

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
