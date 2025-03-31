import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<UserModel>> _fetchUserCollection(String collectionName) async {
    final snapshot =
        await _firestore.collection(collectionName).get(); //.limit(10).get();

    return await Future.wait(
      snapshot.docs.map((doc) => UserModel.fromFirestore(doc)).toList(),
    );
  }

  Future<Map<String, List<UserModel>>> fetchAllUserData() async {
    final users = await _fetchUserCollection('users');
    final highRiskUsers = await _fetchUserCollection('high_risk_users');
    final lowRiskUsers = await _fetchUserCollection('low_risk_users');

    return {
      'users': users,
      'highRiskUsers': highRiskUsers,
      'lowRiskUsers': lowRiskUsers,
    };
  }

  Future<Map<String, List<String>>> fetchAllUserNames() async {
    final users = await _fetchUserCollection('users');
    final highRiskUsers = await _fetchUserCollection('high_risk_users');
    final lowRiskUsers = await _fetchUserCollection('low_risk_users');

    return {
      'users': users.map((user) => user.name).toList(),
      'highRiskUsers': highRiskUsers.map((user) => user.name).toList(),
      'lowRiskUsers': lowRiskUsers.map((user) => user.name).toList(),
    };
  }
}
