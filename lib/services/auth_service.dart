import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tutam_fit/models/user_model.dart';
import 'package:tutam_fit/repositories/user_repository.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final UserRepository _userRepo;

  AuthService(this._userRepo);

  FirebaseAuth get auth => _auth;

  Future<User?> signUpWithEmail(
    String email,
    String password,
  ) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await _userRepo.addUser(
      UserModel(
        name: '',
        email: email,
        phone: '',
        city: '',
        role: 'user',
        createdAt: Timestamp.now(),
        updatedAt: Timestamp.now(),
      ),
      cred.user!.uid,
    );

    return cred.user;
  }

  Future<User?> signInWithEmail(String email, String password) async {
    final cred = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return cred.user;
  }

  Future<User?> signInWithGoogle() async {
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) return null;

    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCred = await _auth.signInWithCredential(credential);

    final uid = userCred.user!.uid;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();

    if (!doc.exists) {
      await _userRepo.addUser(
        UserModel(
          name: userCred.user?.displayName ?? '',
          email: userCred.user?.email ?? '',
          phone: '',
          city: '',
          role: 'user',
          createdAt: Timestamp.now(),
          updatedAt: Timestamp.now(),
        ),
        uid,
      );
    }

    return userCred.user;
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}
