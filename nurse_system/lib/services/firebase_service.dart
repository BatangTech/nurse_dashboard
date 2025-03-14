import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, List<UserModel>>> fetchAllUserData() async {
    // ดึงข้อมูลจาก collections ต่างๆ
    final usersSnapshot = await _firestore.collection('users').limit(10).get();
    final highRiskSnapshot = await _firestore.collection('high_risk_users').limit(10).get();
    final lowRiskSnapshot = await _firestore.collection('low_risk_users').limit(10).get();

    // แปลงข้อมูลให้อยู่ในรูปแบบ UserModel
    final users = usersSnapshot.docs.map((doc) => UserModel.fromFirestore(doc)).toList();
    final highRiskUsers = highRiskSnapshot.docs.map((doc) => UserModel.fromFirestore(doc)).toList();
    final lowRiskUsers = lowRiskSnapshot.docs.map((doc) => UserModel.fromFirestore(doc)).toList();

    return {
      'users': users,
      'highRiskUsers': highRiskUsers,
      'lowRiskUsers': lowRiskUsers,
    };
  }
}