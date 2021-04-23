import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Authentication base class
abstract class AuthBase {
  // initialization
  Future<FirebaseApp> initialize();

  // the data gotten from a succesful login
  Future<UserCredential> signInWithGoogle();
}
