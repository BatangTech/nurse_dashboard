import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'dart:developer' as developer;

class UserModel {
  final String id;
  final String name;
  final String email;
  final Timestamp? lastActivity;
  final String riskScore;
  final Map<String, dynamic> additionalData;

  UserModel({
    required this.id,
    required this.name,
    this.email = '',
    this.lastActivity,
    required this.riskScore,
    this.additionalData = const {},
  });

  static Future<UserModel> fromFirestore(DocumentSnapshot doc) async {
    final data = doc.data() as Map<String, dynamic>;

    developer.log('Document ID: ${doc.id}');
    developer.log('All document data: $data');
    developer.log('Available keys: ${data.keys.toList()}');

    String? userId = data['user_id'] ?? data['uid'];
    String userName = 'User_${doc.id.substring(0, 5)}';
    String userEmail = ''; 

    if (userId != null) {
      var userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      if (userDoc.exists) {
        final userData = userDoc.data();
        userName = userData?['name'] ??
            userData?['displayName'] ??
            userData?['fullName'] ??
            userData?['email'] ??
            userName;

        userEmail = userData?['email'] ?? '';
      }
    }

    developer.log('Final selected name: $userName');
    developer.log('User email: $userEmail');

    return UserModel(
      id: doc.id,
      name: userName,
      email: userEmail,
      lastActivity: data['last_activity'] as Timestamp? ??
          data['lastActive'] as Timestamp? ??
          data['lastActivity'] as Timestamp?,
      riskScore: data['risk_score']?.toString() ??
          data['riskScore']?.toString() ??
          'N/A',
      additionalData: data,
    );
  }

  String getFormattedDate() {
    if (lastActivity == null) return "N/A";
    DateTime date = lastActivity!.toDate();
    return DateFormat('dd/MM/yyyy').format(date);
  }
}
