import 'package:flutter/material.dart';

import '../components/table/header.dart';
import '../components/table/overview_cards.dart';
import '../components/table/user_table_section.dart';
import '../models/user_model.dart';
import '../services/firebase_service.dart';

class TablePage extends StatefulWidget {
  const TablePage({super.key});

  @override
  State<TablePage> createState() => _TablePageState();
}

class _TablePageState extends State<TablePage> {
  List<UserModel> users = [];
  List<UserModel> highRiskUsers = [];
  List<UserModel> lowRiskUsers = [];
  bool isLoading = true;

  String selectedUserType = 'total';

  final FirebaseService _firebaseService = FirebaseService();

  void changeSelectedUserType(String type) {
    setState(() {
      selectedUserType = type;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final result = await _firebaseService.fetchAllUserData();

      setState(() {
        users = result['users']!;
        highRiskUsers = result['highRiskUsers']!;
        lowRiskUsers = result['lowRiskUsers']!;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                  onRefresh: fetchData,
                  color: const Color(0xFF6C63FF),
                  child: ListView(
                    children: [
                      const Header(
                        title: "Risk Zone Monitor",
                        subtitle: "แดชบอร์ดติดตามผู้ใช้งานตามระดับความเสี่ยง",
                      ),
                      const SizedBox(height: 20),
                      OverviewCards(
                        totalUsers: users.length,
                        lowRiskUsers: lowRiskUsers.length,
                        highRiskUsers: highRiskUsers.length,
                        selectedType: selectedUserType,
                        onTypeSelected: changeSelectedUserType,
                      ),
                      const SizedBox(height: 20),
                      if (selectedUserType == 'high')
                        UserTableSection(
                          title: "Red Zone Users",
                          subtitle: "ผู้ใช้ในพื้นที่เสี่ยงสูง",
                          users: highRiskUsers,
                          statusColor: const Color(0xFFFF5252),
                          icon: Icons.warning_rounded,
                        )
                      else if (selectedUserType == 'low')
                        UserTableSection(
                          title: "Green Zone Users",
                          subtitle: "ผู้ใช้ในพื้นที่ปลอดภัย",
                          users: lowRiskUsers,
                          statusColor: const Color(0xFF4CAF50),
                          icon: Icons.shield_rounded,
                        )
                      else
                        UserTableSection(
                          title: "All Users",
                          subtitle: "รายการผู้ใช้งานทั้งหมดในระบบ",
                          users: users,
                          statusColor: const Color(0xFF6C63FF),
                          icon: Icons.people_alt_rounded,
                        ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
