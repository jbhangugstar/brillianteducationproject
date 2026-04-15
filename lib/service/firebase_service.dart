import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:brillianteducationproject/models/user_model.dart';
import 'package:brillianteducationproject/models/kelas_model.dart';
import 'package:brillianteducationproject/models/enrollment_model.dart';

class FirebaseService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseStorage _storage = FirebaseStorage.instance;

  // ===============================
  // AUTH & USER PROFILE
  // ===============================

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

    await _firestore
        .collection('users')
        .doc(firebaseUser.uid)
        .set(newUser.toMap());
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

      final doc = await _firestore
          .collection('users')
          .doc(firebaseUser.uid)
          .get();
      if (doc.exists) {
        return UserModel.fromMap(doc.data()!);
      }
      return null;
    } catch (e) {
      print('Firebase login error: $e');
      return null;
    }
  }

  static Future<void> updateUserProfile(UserModel user) async {
    await _firestore
        .collection('users')
        .doc(user.id)
        .update(user.toMap());
  }

  static Future<String?> uploadProfileImage(File image, String uid) async {
    try {
      final ref = _storage.ref().child('profile_photos').child('$uid.jpg');
      await ref.putFile(image);
      final url = await ref.getDownloadURL();
      await _firestore.collection('users').doc(uid).update({'photoUrl': url});
      return url;
    } catch (e) {
      print('Upload error: $e');
      return null;
    }
  }

  static Future<void> deleteProfileImage(String uid) async {
    try {
      await _storage.ref().child('profile_photos').child('$uid.jpg').delete();
      await _firestore.collection('users').doc(uid).update({'photoUrl': null});
    } catch (e) {
      print('Delete photo error: $e');
    }
  }

  static Future<void> logout() async {
    await _auth.signOut();
  }

  // ===============================
  // KELAS (CRUD)
  // ===============================

  static Future<String> createKelas(Kelas kelas) async {
    final docRef = _firestore.collection('kelas').doc();
    final newKelas = kelas.copyWith(id: docRef.id);
    await docRef.set(newKelas.toMap());
    return docRef.id;
  }

  static Future<List<Kelas>> getAllKelas() async {
    final snapshot = await _firestore.collection('kelas').get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return Kelas.fromMap(data);
    }).toList();
  }

  static Future<void> updateKelas(Kelas kelas) async {
    if (kelas.id == null) return;
    await _firestore.collection('kelas').doc(kelas.id).update(kelas.toMap());
  }

  static Future<void> deleteKelas(String id) async {
    await _firestore.collection('kelas').doc(id).delete();
  }

  // ===============================
  // ENROLLMENT (CRUD)
  // ===============================

  static Future<String> enrollStudent(EnrollmentModel enrollment) async {
    final docRef = _firestore.collection('enrollments').doc();
    final data = enrollment.toMap();
    data['id'] = docRef.id;
    await docRef.set(data);
    return docRef.id;
  }

  static Stream<List<EnrollmentModel>> getEnrollmentsForTutor(String tutorId) {
    // Note: This logic depends on Kelas having idTutor
    // For simplicity, we can fetch all and filter, or use a complex query
    return _firestore
        .collection('enrollments')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => EnrollmentModel.fromMap({...doc.data(), 'id': doc.id}))
            .toList());
  }

  static Future<List<EnrollmentModel>> getStudentEnrollments(String studentId) async {
    final snapshot = await _firestore
        .collection('enrollments')
        .where('id_siswa', isEqualTo: studentId)
        .get();
    return snapshot.docs
        .map((doc) => EnrollmentModel.fromMap({...doc.data(), 'id': doc.id}))
        .toList();
  }
}
