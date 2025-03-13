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
        color: Colors.grey[100], // สีพื้นหลังเบาๆ
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWeeklyRevenueSection(),
            const SizedBox(height: 24),
            const Divider(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 1, child: _buildRedZoneTable()),
                const SizedBox(width: 16),
                Expanded(flex: 1, child: _buildGreenZoneTable()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeeklyRevenueSection() {
    return _buildCard(
      title: 'Weekly Revenue',
      child: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('users').snapshots(),
        builder: (context, totalSnapshot) {
          return StreamBuilder<QuerySnapshot>(
            stream: _firestore.collection('high_risk_users').snapshots(),
            builder: (context, redZoneSnapshot) {
              return StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('low_risk_users').snapshots(),
                builder: (context, greenZoneSnapshot) {
                  if (totalSnapshot.connectionState ==
                          ConnectionState.waiting ||
                      redZoneSnapshot.connectionState ==
                          ConnectionState.waiting ||
                      greenZoneSnapshot.connectionState ==
                          ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  int totalUsers = totalSnapshot.data?.docs.length ?? 1;
                  int redZoneUsers = redZoneSnapshot.data?.docs.length ?? 0;
                  int greenZoneUsers = greenZoneSnapshot.data?.docs.length ?? 0;

                  double redPercentage = (redZoneUsers / totalUsers) * 100;
                  double greenPercentage = (greenZoneUsers / totalUsers) * 100;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildLabel('This month'),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          _buildRiskIndicator(
                              '${redPercentage.toInt()}%', Colors.red),
                          const SizedBox(width: 16),
                          _buildRiskIndicator(
                              '${greenPercentage.toInt()}%', Colors.green),
                        ],
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 200,
                        child: _buildAreaChart(),
                      ),
                    ],
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildRedZoneTable() {
    return _buildCard(
      title: 'Red Zone Patients',
      child: StreamBuilder<QuerySnapshot>(
        stream: _firestore
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
            columnSpacing: 20,
            columns: const [
              DataColumn(
                  label: Text('USER ID',
                      style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(
                  label: Text('RISK LEVEL',
                      style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(
                  label: Text('DATE',
                      style: TextStyle(fontWeight: FontWeight.bold))),
            ],
            rows: users.map((user) {
              var data = user.data() as Map<String, dynamic>;
              String userId = data['user_id'] ?? "Unknown";
              Timestamp timestamp = data['timestamp'] ?? Timestamp.now();
              String date = "${timestamp.toDate()}";

              return DataRow(
                cells: [
                  DataCell(Text(userId)),
                  DataCell(_buildRiskIndicator("Red Zone", Colors.red)),
                  DataCell(Text(date)),
                ],
              );
            }).toList(),
          );
        },
      ),
    );
  }

  Widget _buildGreenZoneTable() {
    return _buildCard(
      title: 'Green Zone Patients',
      child: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('low_risk_users')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No low-risk users found"));
          }

          final users = snapshot.data!.docs;
          return DataTable(
            columnSpacing: 20,
            columns: const [
              DataColumn(
                  label: Text('USER ID',
                      style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(
                  label: Text('RISK LEVEL',
                      style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(
                  label: Text('DATE',
                      style: TextStyle(fontWeight: FontWeight.bold))),
            ],
            rows: users.map((user) {
              var data = user.data() as Map<String, dynamic>;
              String userId = data['user_id'] ?? "Unknown";
              Timestamp timestamp = data['timestamp'] ?? Timestamp.now();
              String date = "${timestamp.toDate()}";

              return DataRow(
                cells: [
                  DataCell(Text(userId)),
                  DataCell(_buildRiskIndicator("Green Zone", Colors.green)),
                  DataCell(Text(date)),
                ],
              );
            }).toList(),
          );
        },
      ),
    );
  }

  Widget _buildCard({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            spreadRadius: 3,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildRiskIndicator(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(label,
            style: TextStyle(color: color, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Future<List<FlSpot>> _fetchMonthlyRedZoneData() async {
    DateTime now = DateTime.now();
    List<FlSpot> spots = [];

    for (int i = 5; i >= 0; i--) {
      DateTime month = DateTime(now.year, now.month - i, 1);
      DateTime startOfMonth = DateTime(month.year, month.month, 1);
      DateTime endOfMonth = DateTime(month.year, month.month + 1, 1);

      QuerySnapshot snapshot = await _firestore
          .collection('high_risk_users')
          .where('timestamp',
              isGreaterThanOrEqualTo: Timestamp.fromDate(startOfMonth))
          .where('timestamp', isLessThan: Timestamp.fromDate(endOfMonth))
          .get();

      spots.add(FlSpot(5 - i.toDouble(), snapshot.docs.length.toDouble()));
    }

    return spots;
  }

  Widget _buildAreaChart() {
    return FutureBuilder<List<FlSpot>>(
      future: _fetchMonthlyRedZoneData(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        List<FlSpot> dataPoints = snapshot.data!;

        return LineChart(
          LineChartData(
            gridData: FlGridData(show: false),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40,
                  interval: 1,
                  getTitlesWidget: (value, meta) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        value.toInt().toString(),
                        style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                            fontWeight: FontWeight.bold),
                      ),
                    );
                  },
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    List<String> months = [
                      'Jan',
                      'Feb',
                      'Mar',
                      'Apr',
                      'May',
                      'Jun',
                      'Jul',
                      'Aug',
                      'Sep',
                      'Oct',
                      'Nov',
                      'Dec'
                    ];
                    return Padding(
                      padding: const EdgeInsets.only(top: 6.0),
                      child: Text(
                        months[value.toInt()],
                        style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                            fontWeight: FontWeight.bold),
                      ),
                    );
                  },
                ),
              ),
            ),
            borderData: FlBorderData(show: false),
            lineBarsData: [
              LineChartBarData(
                spots: dataPoints,
                isCurved: true,
                color: Colors.redAccent,
                barWidth: 4,
                belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                    colors: [
                      Colors.redAccent.withOpacity(0.5),
                      Colors.transparent
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                dotData: FlDotData(
                  show: true,
                  checkToShowDot: (spot, barData) {
                    return true;
                  },
                  getDotPainter: (spot, percent, barData, index) {
                    return FlDotCirclePainter(
                      radius: 4,
                      color: Colors.redAccent,
                      strokeWidth: 2,
                      strokeColor: Colors.white,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
