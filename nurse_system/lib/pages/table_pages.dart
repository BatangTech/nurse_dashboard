import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class TablePage extends StatelessWidget {
  const TablePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Complex Table",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // ตารางข้อมูล
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(color: Colors.black12, blurRadius: 5),
                ],
              ),
              child: Column(
                children: [
                  _buildTableHeader(),
                  const Divider(),
                  _buildTableRow(
                    "่Jason Ray",
                    "Green zone",
                    "12 Jul 2023",
                    Icons.refresh,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // กราฟ Earnings & Conversions
            Row(
              children: [
                Expanded(child: _buildEarningsChart()),
                const SizedBox(width: 16),
                Expanded(child: _buildConversionsChart()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ส่วนหัวของตาราง
  Widget _buildTableHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
        Text("NAME", style: TextStyle(fontWeight: FontWeight.bold)),
        Text("STATUS", style: TextStyle(fontWeight: FontWeight.bold)),
        Text("DATE", style: TextStyle(fontWeight: FontWeight.bold)),
        Text("Chat", style: TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  // แถวของข้อมูลในตาราง
  Widget _buildTableRow(
      String name, String status, String date, IconData icon) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(name),
        Row(
          children: [
            Icon(Icons.circle, color: Colors.green, size: 12),
            const SizedBox(width: 5),
            Text(status, style: TextStyle(color: Colors.green)),
          ],
        ),
        Text(date),
        Icon(icon, color: Colors.blue),
      ],
    );
  }

  // กราฟ Earnings
  Widget _buildEarningsChart() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _boxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Earnings", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          SizedBox(
            height: 150,
            child: PieChart(
              PieChartData(
                sections: [
                  PieChartSectionData(
                      value: 80,
                      color: const Color.fromARGB(255, 33, 195, 52),
                      title: "80%"),
                  PieChartSectionData(
                      value: 60, color: Colors.red, title: "60%"),
                ],
                sectionsSpace: 2,
                centerSpaceRadius: 30,
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Green zone 80%",
                  style: TextStyle(color: Color.fromARGB(255, 43, 180, 16))),
              Text("Red zone 60%", style: TextStyle(color: Colors.red)),
            ],
          ),
        ],
      ),
    );
  }

  // กราฟ Conversions
  Widget _buildConversionsChart() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _boxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Conversions",
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          SizedBox(
            height: 150,
            child: BarChart(
              BarChartData(
                barGroups: List.generate(7, (index) {
                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                          toY: (index + 1) * 20.0,
                          color: Colors.blue,
                          width: 10),
                      BarChartRodData(
                          toY: (index + 1) * 10.0,
                          color: Colors.lightBlue,
                          width: 10),
                    ],
                  );
                }),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        List<String> days = ["S", "M", "T", "W", "T", "F", "S"];
                        return Text(days[value.toInt()],
                            style: TextStyle(fontSize: 12));
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                gridData: FlGridData(show: false),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // กล่องตกแต่ง UI
  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
    );
  }
}
