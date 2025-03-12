import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class CautionInfoCard extends StatelessWidget {
  const CautionInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0), // ✅ Padding ขอบของ Card
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Caution",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 8, 64, 110),
              ),
            ),
            const SizedBox(height: 20), // ✅ เว้นระยะก่อนกราฟ
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('high_risk_users')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text(
                      "No data available",
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  );
                }

                var docs = snapshot.data!.docs;

                // 🔹 ลำดับเดือนที่ถูกต้อง
                List<String> monthOrder = [
                  "Jan", "Feb", "Mar", "Apr", "May", "Jun",
                  "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
                ];

                Map<String, int> redZoneCounts = {};

                for (var doc in docs) {
                  var data = doc.data() as Map<String, dynamic>;
                  if (data.containsKey('timestamp')) {
                    var date = (data['timestamp'] as Timestamp).toDate();
                    String month = DateFormat('MMM').format(date);

                    redZoneCounts[month] = (redZoneCounts[month] ?? 0) + 1;
                  }
                }

                // เรียงเดือนตามลำดับ
                List<String> sortedMonths = monthOrder
                    .where((m) => redZoneCounts.containsKey(m))
                    .toList();

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SizedBox(
                    height: 220,
                    child: LineChart(
                      LineChartData(
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 30,
                              getTitlesWidget: (value, meta) {
                                if (value.toInt() >= 0 &&
                                    value.toInt() < sortedMonths.length) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Text(
                                      sortedMonths[value.toInt()],
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  );
                                }
                                return const SizedBox();
                              },
                              interval: 1,
                            ),
                          ),
                          rightTitles:
                              AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          topTitles:
                              AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        ),
                        gridData: FlGridData(show: false),
                        borderData: FlBorderData(show: false),
                        lineBarsData: [
                          // เส้น Red Zone
                          LineChartBarData(
                            spots: List.generate(
                              sortedMonths.length,
                              (index) => FlSpot(
                                  index.toDouble(),
                                  (redZoneCounts[sortedMonths[index]] ?? 0)
                                      .toDouble()),
                            ),
                            isCurved: true,
                            color: Colors.red,
                            barWidth: 3,
                            isStrokeCapRound: true,
                            belowBarData: BarAreaData(show: false),
                            dotData: FlDotData(show: true),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
