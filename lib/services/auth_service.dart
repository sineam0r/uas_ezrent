import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  Future<Map<String, dynamic>> login({
    required BuildContext context,
    required String email,
    required String password
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      return {'success': true, 'message': 'Login berhasil'};
    } on FirebaseAuthException catch (e) {
      String message = 'Login gagal. Silakan coba lagi.';

      switch (e.code) {
        case 'user-not-found':
          message = 'Pengguna tidak ditemukan.';
          break;
        case 'wrong-password':
          message = 'Kata sandi salah.';
          break;
        case 'invalid-email':
          message = 'Format email tidak valid.';
          break;
        case 'user-disabled':
          message = 'Akun telah dinonaktifkan.';
          break;
      }

      return {'success': false, 'message': message};
    }
  }

  Future<Map<String, dynamic>> register({
    required BuildContext context,
    required String email,
    required String password,
    required String name
  }) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'name': name,
        'email': email.trim(),
        'createdAt': FieldValue.serverTimestamp(),
        'phoneNumber': '',
        'address': '',
      });

      return {'success': true, 'message': 'Pendaftaran berhasil'};
    } on FirebaseAuthException catch (e) {
      String message = 'Pendaftaran gagal. Silakan coba lagi.';

      switch (e.code) {
        case 'email-already-in-use':
          message = 'Email sudah digunakan.';
          break;
        case 'weak-password':
          message = 'Kata sandi terlalu lemah.';
          break;
        case 'invalid-email':
          message = 'Format email tidak valid.';
          break;
      }

      return {'success': false, 'message': message};
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<Map<String, dynamic>> resetPassword({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
      return {'success': true, 'message': 'Email reset password telah dikirim'};
    } on FirebaseAuthException catch (e) {
      String message = 'Gagal mengirim email reset password.';

      switch (e.code) {
        case 'invalid-email':
          message = 'Format email tidak valid.';
          break;
        case 'user-not-found':
          message = 'Pengguna dengan email tersebut tidak ditemukan.';
          break;
      }

      return {'success': false, 'message': message};
    }
  }
}