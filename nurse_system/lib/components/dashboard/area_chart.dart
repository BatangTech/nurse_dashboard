import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/colors.dart';

class AreaChart extends StatelessWidget {
  const AreaChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<FlSpot>>(
      future: _fetchMonthlyRedZoneData(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        List<FlSpot> dataPoints = snapshot.data!;

        return LineChart(
          LineChartData(
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: 1,
              getDrawingHorizontalLine: (value) {
                return FlLine(
                  color: Colors.black.withOpacity(0.05),
                  strokeWidth: 1,
                  dashArray: [5, 5],
                );
              },
            ),
            titlesData: FlTitlesData(
              leftTitles: const AxisTitles(
                sideTitles: SideTitles(
                  showTitles: false,
                ),
              ),
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 30,
                  interval: 1,
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

                    // แสดงเฉพาะเดือนหลัก
                    if (value % 2 != 0) {
                      return Container();
                    }

                    DateTime now = DateTime.now();
                    int currentMonth = now.month - 1; // 0-based index
                    int monthIndex = (currentMonth - (5 - value.toInt())) % 12;
                    if (monthIndex < 0) monthIndex += 12;

                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        months[monthIndex],
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                        ),
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
                color: AppColors.redZoneColor,
                barWidth: 3,
                isStrokeCapRound: true,
                dotData: FlDotData(
                  show: true,
                  getDotPainter: (spot, percent, barData, index) {
                    return FlDotCirclePainter(
                      radius: 4,
                      color: AppColors.redZoneColor,
                      strokeWidth: 2,
                      strokeColor: Colors.white,
                    );
                  },
                ),
                belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                    colors: [
                      AppColors.redZoneColor.withOpacity(0.4),
                      AppColors.redZoneColor.withOpacity(0.1),
                      AppColors.redZoneColor.withOpacity(0.0),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
              LineChartBarData(
                spots: [
                  const FlSpot(0, 5),
                  const FlSpot(1, 7),
                  const FlSpot(2, 6),
                  const FlSpot(3, 9),
                  const FlSpot(4, 11),
                  const FlSpot(5, 10),
                ],
                isCurved: true,
                color: AppColors.greenZoneColor,
                barWidth: 3,
                isStrokeCapRound: true,
                dotData: FlDotData(
                  show: true,
                  getDotPainter: (spot, percent, barData, index) {
                    return FlDotCirclePainter(
                      radius: 4,
                      color: AppColors.greenZoneColor,
                      strokeWidth: 2,
                      strokeColor: Colors.white,
                    );
                  },
                ),
                belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                    colors: [
                      AppColors.greenZoneColor.withOpacity(0.4),
                      AppColors.greenZoneColor.withOpacity(0.1),
                      AppColors.greenZoneColor.withOpacity(0.0),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<List<FlSpot>> _fetchMonthlyRedZoneData() async {
    List<FlSpot> spots = [
      const FlSpot(0, 8),
      const FlSpot(1, 12),
      const FlSpot(2, 10),
      const FlSpot(3, 14),
      const FlSpot(4, 7),
      const FlSpot(5, 9),
    ];

    return spots;
  }
}
