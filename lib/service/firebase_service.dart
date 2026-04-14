import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:brillianteducationproject/models/user_model.dart';

class FirebaseService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<UserModel> registerUser(UserModel user) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: user.email,
      password: user.password, 
    );

    final firebaseUser = cred.user!;
    
    final newUser = UserModel(
      id: firebaseUser.uid,
      email: user.email,
      password: '', // Don't store password in Firestore
      role: user.role,
      nama: user.nama,
    );

    await _firestore.collection('users').doc(firebaseUser.uid).set(newUser.toMap());
    return newUser;
  }

  static Future<UserModel?> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final firebaseUser = cred.user!;
      
      final doc = await _firestore.collection('users').doc(firebaseUser.uid).get();
      if (doc.exists) {
        return UserModel.fromMap(doc.data()!);
      }
      return null;
    } catch (e) {
      print('Firebase login error: $e');
      return null;
    }
  }
  
  static Future<void> logout() async {
    await _auth.signOut();
  }
}
