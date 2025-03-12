import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class DashboardContent extends StatefulWidget {
  const DashboardContent({Key? key}) : super(key: key);

  @override
  _DashboardContentState createState() => _DashboardContentState();
}

class _DashboardContentState extends State<DashboardContent> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(24),
        color: Colors.grey[50],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWeeklyRevenueSection(),
            const SizedBox(height: 24),
            _buildRedZoneTable(),
          ],
        ),
      ),
    );
  }

  Widget _buildWeeklyRevenueSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Weekly Revenue',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text('This month'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                '48%',
                style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo[600]),
              ),
              const SizedBox(width: 8),
              const Text('This Week'),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: [
                      const FlSpot(0, 1),
                      const FlSpot(1, 1.5),
                      const FlSpot(2, 1.4),
                      const FlSpot(3, 2),
                      const FlSpot(4, 1.8),
                      const FlSpot(5, 1.9),
                    ],
                    isCurved: true,
                    color: Colors.indigo,
                    barWidth: 3,
                    dotData: FlDotData(show: false),
                  ),
                  LineChartBarData(
                    spots: [
                      const FlSpot(0, 0.5),
                      const FlSpot(1, 1),
                      const FlSpot(2, 0.8),
                      const FlSpot(3, 1.2),
                      const FlSpot(4, 0.9),
                      const FlSpot(5, 1.3),
                    ],
                    isCurved: true,
                    color: Colors.blue[300],
                    barWidth: 3,
                    dotData: FlDotData(show: false),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRedZoneTable() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Red Zone Patients',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('high_risk_users')
                .orderBy('timestamp', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text("No high-risk users found"));
              }

              final users = snapshot.data!.docs;
              return DataTable(
                columns: const [
                  DataColumn(label: Text('USER ID')),
                  DataColumn(label: Text('RISK LEVEL')),
                  DataColumn(label: Text('DATE')),
                ],
                rows: users.map((user) {
                  var data = user.data() as Map<String, dynamic>;
                  String userId = data['user_id'] ?? "Unknown";
                  String riskLevel = data['risk_level'] ?? "Unknown";
                  Timestamp timestamp = data['timestamp'] ?? Timestamp.now();
                  String date = "${timestamp.toDate()}";

                  return DataRow(
                    cells: [
                      DataCell(Text(userId)),
                      DataCell(
                        Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "Red Zone",
                              style: const TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                      DataCell(Text(date)),
                    ],
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
