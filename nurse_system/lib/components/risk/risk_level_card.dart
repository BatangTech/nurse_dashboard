// Risk Level Card component
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'risk_utils.dart';

class RiskLevelCard extends StatelessWidget {
  final Map<String, dynamic> riskItem;
  final VoidCallback onTap;

  const RiskLevelCard({
    Key? key,
    required this.riskItem,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final collection = riskItem['collection'] as String;
    final timestamp = riskItem['timestamp'] as Timestamp;
    final date = DateFormat('dd/MM/yyyy HH:mm').format(timestamp.toDate());
    final riskColor = RiskUtils.getRiskColor(riskItem['risk_level'], collection);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: riskColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: riskColor.withOpacity(0.3),
                          width: 1.5,
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          collection == 'high_risk_users'
                              ? Icons.warning_amber_rounded
                              : Icons.check_circle_outline,
                          color: riskColor,
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            riskItem['name'] ?? 'ไม่พบชื่อ',
                            style: GoogleFonts.kanit(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF1F2251),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            riskItem['email'] ?? 'ไม่พบอีเมล',
                            style: GoogleFonts.kanit(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                  decoration: BoxDecoration(
                    color: riskColor.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    collection == 'high_risk_users'
                        ? 'ความเสี่ยงสูง (แดง)'
                        : 'ความเสี่ยงต่ำ (เขียว)',
                    style: GoogleFonts.kanit(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: riskColor,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_rounded,
                          size: 14,
                          color: Colors.grey[500],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'ประเมินเมื่อ: $date',
                          style: GoogleFonts.kanit(
                            fontSize: 12,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                      color: Colors.grey[400],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}