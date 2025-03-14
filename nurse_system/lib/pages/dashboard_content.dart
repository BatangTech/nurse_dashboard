import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../components/dashboard/risk_distribution_cards.dart';
import '../components/dashboard/risk_trend_chart.dart';
import '../components/dashboard/risk_zone_table.dart';
import '../constants/colors.dart';

class DashboardContent extends StatefulWidget {
  const DashboardContent({Key? key}) : super(key: key);

  @override
  _DashboardContentState createState() => _DashboardContentState();
}

class _DashboardContentState extends State<DashboardContent> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(24),
        color: AppColors.backgroundColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Patient Dashboard',
              style: GoogleFonts.poppins(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Overview of patient risk analysis',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 24),
            const RiskTrendChart(),
            const SizedBox(height: 24),
            const RiskDistributionCards(),
            const SizedBox(height: 24),
            const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: RiskZoneTable(
                    isHighRisk: true,
                    title: 'Red Zone Patients',
                    subtitle: 'Patients requiring immediate attention',
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  flex: 1,
                  child: RiskZoneTable(
                    isHighRisk: false,
                    title: 'Green Zone Patients',
                    subtitle: 'Patients with low risk levels',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
