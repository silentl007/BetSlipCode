import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:BetSlipCode/auth/authproviderbase.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Authenticate extends AuthBase {
  @override
  Future<FirebaseApp> initialize() async {
    return await Firebase.initializeApp(
      name: 'BetSlipChat',
      options: FirebaseOptions(
        apiKey: 'AIzaSyAR4dV-kGNWK8eYpxW88PJh-bMgJTgHei8',
        appId: '1:810514184313:android:f87e471fffc1557b487ca8',
        messagingSenderId: '810514184313',
        projectId: 'betslipchat'
      )
    );
  }

  @override
  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
  final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

  // Obtain the auth details from the request
  final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

  // Create a new credential
  final GoogleAuthCredential credential = GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );

  // Once signed in, return the UserCredential
  return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
