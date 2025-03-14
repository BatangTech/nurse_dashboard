import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nurse_system/components/dashboard/area_chart.dart';
import 'package:nurse_system/components/dashboard/card_container.dart';
import 'package:nurse_system/components/dashboard/risk_indicator.dart';
import 'package:nurse_system/components/dashboard/time_filter_chip.dart';
import '../../constants/colors.dart';

class RiskTrendChart extends StatelessWidget {
  const RiskTrendChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    
    return CardContainer(
      title: 'Risk Trend Analysis',
      subtitle: 'Monitoring patient risk distribution over time',
      child: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('users').snapshots(),
        builder: (context, totalSnapshot) {
          return StreamBuilder<QuerySnapshot>(
            stream: _firestore.collection('high_risk_users').snapshots(),
            builder: (context, redZoneSnapshot) {
              return StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('low_risk_users').snapshots(),
                builder: (context, greenZoneSnapshot) {
                  if (totalSnapshot.connectionState == ConnectionState.waiting ||
                      redZoneSnapshot.connectionState == ConnectionState.waiting ||
                      greenZoneSnapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TimeFilterChip(label: 'This Month', isSelected: true),
                          TimeFilterChip(label: 'Last 3 Months'),
                          TimeFilterChip(label: '6 Months'),
                          TimeFilterChip(label: '1 Year'),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          RiskIndicator(label: 'High Risk', color: AppColors.redZoneColor),
                          SizedBox(width: 24),
                          RiskIndicator(label: 'Low Risk', color: AppColors.greenZoneColor),
                        ],
                      ),
                      SizedBox(height: 20),
                      SizedBox(
                        height: 200,
                        child: AreaChart(),
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
}
