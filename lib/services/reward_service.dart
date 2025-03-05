import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RewardService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user's ID
  String get userId => _auth.currentUser?.uid ?? "";

  // Fetch user reward points
  Future<int> getUserPoints() async {
    if (userId.isEmpty) return 0; // No user logged in
    DocumentSnapshot userDoc = await _firestore.collection('users').doc(userId).get();
    return userDoc.exists ? (userDoc['points'] ?? 0) : 0;
  }

  // Add reward points after purchase
  Future<void> addPoints(int points) async {
    if (userId.isEmpty) return;
    await _firestore.collection('users').doc(userId).update({
      'points': FieldValue.increment(points),
    });
  }

  // Redeem reward points when used
  Future<bool> redeemPoints(int pointsToRedeem) async {
    int currentPoints = await getUserPoints();
    if (currentPoints < pointsToRedeem) return false; // Not enough points

    await _firestore.collection('users').doc(userId).update({
      'points': FieldValue.increment(-pointsToRedeem),
    });
    return true; // Successful redemption
  }
}
