// firebase
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

// model
import 'package:money_monitoring/app/modules/home/data/models/user_model.dart';

import 'package:get/get.dart';
import 'package:money_monitoring/app/routes/app_pages.dart';

class AuthController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  late GoogleSignIn googleSignIn = GoogleSignIn();
  GoogleSignInAccount? loggedInUser;

  var user = UserModel().obs;

  Future<bool> autoLogin() async {
    // await googleSignIn.disconnect();
    // await googleSignIn.signOut();
    if (await googleSignIn.isSignedIn()) {
      loggedInUser = await googleSignIn.signInSilently();

      // Add user to firestore
      CollectionReference users = firestore.collection('users');

      final currentUser = await users.doc(loggedInUser!.email).get();
      final currentUserData = currentUser.data() as Map<String, dynamic>;

      user(UserModel.fromJson(currentUserData));
      user.refresh();

      // check bulan ini apa sudah tersimpan di DB
      checkOrCreateMonthRecord();

      return true;
    }
    return false;
  }

  Future<void> checkOrCreateMonthRecord() async {
    // Add user to firestore
    CollectionReference users = firestore.collection('users');

    var dateNow = DateTime.now();

    String monthName = DateFormat.MMMM().format(dateNow);
    String monthNumber = DateFormat.M().format(dateNow);
    String year = DateFormat.y().format(dateNow);
    // untuk id document
    String UID = monthName + '-' + year;

    QuerySnapshot moneyHistoryRef = await users
        .doc(loggedInUser!.email)
        .collection('moneyHistory')
        .where('month', isEqualTo: monthNumber)
        .where('year', isEqualTo: year)
        .get();

    if (moneyHistoryRef.docs.length == 0) {
      await users
          .doc(loggedInUser!.email)
          .collection('moneyHistory')
          .doc(UID)
          .set({
        "id": UID,
        "year": year,
        "month": monthNumber,
        "monthName": monthName,
        "totalInMonth": 0,
      });
    }
  }

  Future<void> gmailLogin() async {
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
        await users.doc(loggedInUser!.email).update({
          "updatedAt": dateNow,
        });
      } else {
        await users.doc(loggedInUser!.email).set({
          "name": loggedInUser!.displayName,
          "email": loggedInUser!.email,
          "photoUrl": loggedInUser!.photoUrl,
          "createdAt": dateNow,
          "updatedAt": dateNow,
          "totalEntireSpent": 0,
        });
      }

      final currentUser = await users.doc(loggedInUser!.email).get();
      final currentUserData = currentUser.data() as Map<String, dynamic>;

      user(UserModel.fromJson(currentUserData));
      user.refresh();
      print(user);

      // check bulan ini apa sudah tersimpan di DB
      checkOrCreateMonthRecord();

      Get.offAllNamed(Routes.HOME);
    } catch (e) {
      print(e);
      Get.defaultDialog(title: 'Login Error', middleText: '$e');
    }
  }
}
