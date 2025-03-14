import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import 'stat_card.dart';

class RiskDistributionCards extends StatelessWidget {
  const RiskDistributionCards({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('users').snapshots(),
      builder: (context, totalSnapshot) {
        return StreamBuilder<QuerySnapshot>(
          stream: _firestore.collection('high_risk_users').snapshots(),
          builder: (context, redZoneSnapshot) {
            return StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('low_risk_users').snapshots(),
              builder: (context, greenZoneSnapshot) {
                if (totalSnapshot.connectionState == ConnectionState.waiting ||
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

                return Row(
                  children: [
                    Expanded(
                      child: StatCard(
                        icon: Icons.warning_rounded,
                        title: 'Red Zone',
                        subtitle: 'High Risk Patients',
                        value: '${redPercentage.toInt()}%',
                        color: AppColors.redZoneColor,
                        iconBackgroundColor:
                            AppColors.redZoneColor.withOpacity(0.1),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: StatCard(
                        icon: Icons.check_circle_outline,
                        title: 'Green Zone',
                        subtitle: 'Low Risk Patients',
                        value: '${greenPercentage.toInt()}%',
                        color: AppColors.greenZoneColor,
                        iconBackgroundColor:
                            AppColors.greenZoneColor.withOpacity(0.1),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: StatCard(
                        icon: Icons.people_outline,
                        title: 'Total',
                        subtitle: 'All Patients',
                        value: totalUsers.toString(),
                        color: AppColors.primaryColor,
                        iconBackgroundColor:
                            AppColors.primaryColor.withOpacity(0.1),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }
}
