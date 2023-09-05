import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  GoogleSignIn googleSignIn = GoogleSignIn();
  Rx<User?> user = Rx<User?>(FirebaseAuth.instance.currentUser);
  CollectionReference<Map<String, dynamic>> firebasecollection =
      FirebaseFirestore.instance.collection('users');
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    user.bindStream(auth.authStateChanges());
  }

  void login() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    print(credential);
    final userCredential = await auth.signInWithCredential(credential);
    User? user = userCredential.user!;
    print("uuuuser$user");

    FirebaseFirestore.instance.collection('users').doc(user.uid).set({
      "username": user.displayName,
      "profilepic": user.photoURL,
      "email": user.email,
      "uid": user.uid
    });
  }

  void signOut() async {
    auth.signOut();
  }
}
