import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tutam_fit/models/user_model.dart';
import 'package:tutam_fit/services/local_storage_service.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final LocalStorageService _storage = LocalStorageService();

  Future<UserModel?> registerWithEmail({
    required String email,
    required String password,
    required String name,
    required String phone,
    required String city,
    required String role,
  }) async {
    final userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = UserModel(
      id: userCredential.user!.uid,
      name: name,
      email: email,
      phone: phone,
      city: city,
      role: role,
      createdAt: Timestamp.now(),
      updatedAt: Timestamp.now(),
    );

    await _firestore.collection('users').doc(user.id).set(user.toJson());

    final token = await userCredential.user?.getIdToken();
    if (token != null) await _storage.saveToken(token);
    return user;
  }

  Future<UserModel?> loginWithEmail(String email, String password) async {
    final userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final doc = await _firestore
        .collection('users')
        .doc(userCredential.user!.uid)
        .get();
    final user = UserModel.fromJson(doc.data()!);
    final token = await userCredential.user?.getIdToken();
    if (token != null) await _storage.saveToken(token);
    return user;
  }

  Future<UserModel?> loginWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) return null;
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCredential = await _auth.signInWithCredential(credential);
    final firebaseUser = userCredential.user!;
    final docRef = _firestore.collection('users').doc(firebaseUser.uid);
    final doc = await docRef.get();

    UserModel user;

    if (!doc.exists) {
      user = UserModel(
        id: firebaseUser.uid,
        name: firebaseUser.displayName ?? '',
        email: firebaseUser.email ?? '',
        phone: '',
        city: '',
        role: 'user',
        createdAt: Timestamp.now(),
        updatedAt: Timestamp.now(),
      );

      await docRef.set(user.toJson());
    } else {
      user = UserModel.fromJson(doc.data()!);
    }
    final token = await userCredential.user?.getIdToken();
    if (token != null) await _storage.saveToken(token);

    return user;
  }

  Future<void> logout() async {
    await _auth.signOut();
    await GoogleSignIn().signOut();
    await _storage.deleteToken();
  }

  Future<bool> isLoggedIn() async {
    return _auth.currentUser != null;
  }

  Future<UserModel?> getCurrentUser() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    final doc = await _firestore.collection('users').doc(user.uid).get();
    if (!doc.exists) return null;

    return UserModel.fromJson({...doc.data()!, 'id': doc.id});
  }

  Future<UserModel?> updateUserProfile({
    required String id,
    required String phone,
    required String city,
    required String role,
  }) async {
    final docRef = _firestore.collection('users').doc(id);

    await docRef.update({
      'phone': phone,
      'city': city,
      'role': role,
      'updatedAt': Timestamp.now(),
    });

    final doc = await docRef.get();
    return UserModel.fromJson({...doc.data()!, 'id': doc.id});
  }
}
