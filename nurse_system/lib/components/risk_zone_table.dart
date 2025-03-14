import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/colors.dart';
import '../utils/date_formatter.dart';
import 'card_container.dart';
import 'risk_badge.dart';

class RiskZoneTable extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final String collectionName = isHighRisk ? 'high_risk_users' : 'low_risk_users';
    final Color zoneColor = isHighRisk ? AppColors.redZoneColor : AppColors.greenZoneColor;
    final String riskLabel = isHighRisk ? 'High Risk' : 'Low Risk';

    return CardContainer(
      title: title,
      subtitle: subtitle,
      child: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection(collectionName)
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.person_off, size: 48, color: Colors.black12),
                  const SizedBox(height: 16),
                  Text(
                    "No ${isHighRisk ? 'high' : 'low'}-risk patients found",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            );
          }

          final users = snapshot.data!.docs;
          return ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowColor:
                    MaterialStateProperty.all(zoneColor.withOpacity(0.1)),
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
                rows: users.map((user) {
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
          );
        },
      ),
    );
  }
}