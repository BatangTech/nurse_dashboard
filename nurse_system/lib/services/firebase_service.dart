import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Fetches users from a collection and sorts them by name
  Future<List<UserModel>> _fetchUserCollection(String collectionName) async {
    final snapshot = await _firestore.collection(collectionName).get();

    // Convert snapshot to list of UserModel objects
    List<UserModel> users = await Future.wait(
      snapshot.docs.map((doc) => UserModel.fromFirestore(doc)).toList(),
    );

    // Sort the list by name (alphabetically)
    users.sort((a, b) => a.name.compareTo(b.name));

    return users;
  }

  /// Fetches users from all collections and returns them sorted by name
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

  /// Fetches only user names from all collections and returns them sorted
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

  /// Optional: Method to fetch data sorted by a specific field
  Future<List<UserModel>> fetchSortedUsersByField(String collectionName, String field) async {
    final snapshot = await _firestore.collection(collectionName).get();

    List<UserModel> users = await Future.wait(
      snapshot.docs.map((doc) => UserModel.fromFirestore(doc)).toList(),
    );

    // Sort dynamically by the specified field
    users.sort((a, b) {
      // Use reflection or implement based on your UserModel structure
      // This is a simplified example assuming the field is accessible
      if (field == 'name') {
        return a.name.compareTo(b.name);
      }
      // Add more fields as needed
      return 0;
    });

    return users;
  }
}