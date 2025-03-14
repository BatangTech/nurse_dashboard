import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class UserModel {
  final String id;
  final String userId;
  final Timestamp? lastActivity;
  final String riskScore;
  final Map<String, dynamic> additionalData;

  UserModel({
    required this.id,
    required this.userId,
    this.lastActivity,
    required this.riskScore,
    this.additionalData = const {},
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: doc.id,
      userId: data['user_id']?.toString() ?? 'ไม่ระบุชื่อ',
      lastActivity: data['last_activity'] as Timestamp?,
      riskScore: data['risk_score']?.toString() ?? 'N/A',
      additionalData: data,
    );
  }

  String getFormattedDate() {
    if (lastActivity == null) return "N/A";
    DateTime date = lastActivity!.toDate();
    return DateFormat('dd/MM/yyyy').format(date);
  }
}