import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:code_realm/auth/authproviderbase.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Authenticate extends AuthBase {
  @override
  Future<FirebaseApp> initialize() async {
    // values are found in your firebase app details firebase.console.com
    // google-services.json file is downloaded from created firebase app
    await dotenv.load(fileName: 'file.env');
    return await Firebase.initializeApp(
        name: '${dotenv.env['firebase_appname']}',
        options: FirebaseOptions(
            apiKey: '${dotenv.env['firebase_apikey']}',
            appId: '${dotenv.env['firebase_appId']}',
            messagingSenderId: '${dotenv.env['firebase_messagingSenderId']}',
            projectId: '${dotenv.env['firebase_projectId']}'));
  }

  @override
  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    // Create a new credential
    final OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
