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
    if (await googleSignIn.isSignedIn()) {
      loggedInUser = await googleSignIn.signInSilently();
      print(loggedInUser);
      return true;
    }
    return false;
  }

  Future<bool> gmailLogin() async {
    try {
      // Trigger the authentication flow
      loggedInUser = await googleSignIn.signIn();
      print(loggedInUser);

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await loggedInUser!.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth!.accessToken,
        idToken: googleAuth.idToken,
      );

      // Once signed in, return the UserCredential
      await auth.signInWithCredential(credential);

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
