import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/colors.dart';
import '../../utils/date_formatter.dart';
import 'risk_badge.dart';

class RiskZoneTable extends StatefulWidget {
  final bool isHighRisk;
  final String title;
  final String subtitle;

  const RiskZoneTable({
    Key? key,
    required this.isHighRisk,
    required this.title,
    required this.subtitle,
  }) : super(key: key);

  @override
  _RiskZoneTableState createState() => _RiskZoneTableState();
}

class _RiskZoneTableState extends State<RiskZoneTable> {
  bool showAllUsers = false;

  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final String collectionName = widget.isHighRisk ? 'high_risk_users' : 'low_risk_users';
    final Color zoneColor = widget.isHighRisk ? AppColors.redZoneColor : AppColors.greenZoneColor;
    final String riskLabel = widget.isHighRisk ? 'High Risk' : 'Low Risk';
    final IconData icon = widget.isHighRisk ? Icons.error_outline : Icons.check_circle_outline;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection(collectionName)
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final users = snapshot.data?.docs ?? [];

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF1F2251),
                          ),
                        ),
                        Text(
                          widget.subtitle,
                          style: GoogleFonts.kanit(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: zoneColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(icon, color: zoneColor, size: 20),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, color: Color(0xFFEEEEF0)),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  headingRowColor: MaterialStateProperty.all(zoneColor.withOpacity(0.1)),
                  headingTextStyle: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  dataTextStyle: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                  columnSpacing: 20,
                  horizontalMargin: 16,
                  dividerThickness: 0.5,
                  columns: const [
                    DataColumn(label: Text('PATIENT ID')),
                    DataColumn(label: Text('STATUS')),
                    DataColumn(label: Text('DATE')),
                  ],
                  rows: (showAllUsers ? users : users.take(5))
                      .map((user) {
                    var data = user.data() as Map<String, dynamic>;
                    String userId = data['user_id'] ?? "Unknown";
                    Timestamp timestamp = data['timestamp'] ?? Timestamp.now();
                    String date = DateFormatter.formatDate(timestamp.toDate());

                    return DataRow(
                      cells: [
                        DataCell(Text(userId)),
                        DataCell(RiskBadge(label: riskLabel, color: zoneColor)),
                        DataCell(Text(date)),
                      ],
                    );
                  }).toList(),
                ),
              ),
              if (users.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Text(
                      "ไม่พบข้อมูลผู้ใช้ในส่วนนี้",
                      style: GoogleFonts.kanit(
                        color: Colors.grey[400],
                      ),
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "แสดงผล ${showAllUsers ? users.length : users.take(5).length} จากทั้งหมด ${users.length} รายการ",
                      style: GoogleFonts.kanit(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    if (users.length > 5)
                      TextButton(
                        onPressed: () {
                          setState(() {
                            showAllUsers = !showAllUsers;
                          });
                        },
                        child: Text(
                          showAllUsers ? "ย่อรายการ" : "ดูทั้งหมด",
                          style: GoogleFonts.kanit(
                            fontSize: 12,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}