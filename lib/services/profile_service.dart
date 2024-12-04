import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uas_ezrent/models/user.dart';

class ProfileService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserModel?> getCurrentUserProfile() async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) return null;

      final snapshot = await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .get();

      if (snapshot.exists) {
        return UserModel.fromMap(snapshot.data()!, snapshot.id);
      }
      return null;
    } catch (e) {
      print('Error getting user profile: $e');
      return null;
    }
  }

  Future<UserModel?> getUserProfile(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .get();

      if (snapshot.exists) {
        return UserModel.fromMap(snapshot.data()!, snapshot.id);
      }
      return null;
    } catch (e) {
      print('Error getting user profile: $e');
      return null;
    }
  }

  Future<bool> updateProfile({
    String? name,
    String? phoneNumber,
    String? address,
    DateTime? birthDate,
  }) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) return false;

      final updateData = <String, dynamic>{};

      if (name != null) updateData['name'] = name;
      if (phoneNumber != null) updateData['phoneNumber'] = phoneNumber;
      if (address != null) updateData['address'] = address;
      if (birthDate != null) updateData['birthDate'] = birthDate;

      await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .update(updateData);

      return true;
    } catch (e) {
      print('Error updating profile: $e');
      return false;
    }
  }
}