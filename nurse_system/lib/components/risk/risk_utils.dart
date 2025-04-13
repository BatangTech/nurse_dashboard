import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class RiskUtils {
  /// Returns the appropriate color based on the risk level and collection
  static Color getRiskColor(String riskLevel, String collection) {
    if (collection == 'high_risk_users' ||
        riskLevel.contains('แดง') ||
        riskLevel.contains('red')) {
      return const Color(0xFFE53935); // Red color for high risk
    } else if (collection == 'low_risk_users' ||
        riskLevel.contains('เขียว') ||
        riskLevel.contains('low') ||
        riskLevel.contains('green')) {
      return const Color(0xFF43A047); // Green color for low risk
    }
    return const Color(0xFF9E9E9E); // Grey color for unknown risk
  }

  /// Formats a Timestamp to a readable date string
  static String formatTimestamp(Timestamp timestamp) {
    return DateFormat('dd/MM/yyyy HH:mm').format(timestamp.toDate());
  }

  /// Extracts the reason part from a risk level string
  static String extractRiskReason(String fullRiskLevel) {
    if (fullRiskLevel.contains('เหตุผล:')) {
      return fullRiskLevel.split('เหตุผล:')[1].trim();
    }
    return 'ไม่มีข้อมูลเหตุผล';
  }

  /// Returns a risk level display text based on the collection
  static String getRiskLevelText(String collection) {
    return collection == 'high_risk_users' ? 'ความเสี่ยงสูง (แดง)' : 'ความเสี่ยงต่ำ (เขียว)';
  }

  /// Returns a recommendation text based on the risk level
  static String getRecommendationText(String collection) {
    if (collection == 'high_risk_users') {
      return 'ผู้ใช้อยู่ในกลุ่มเสี่ยงสูง ควรได้รับการติดตามอย่างใกล้ชิด สำหรับอาการที่อาจเกิดขึ้น ควรแนะนำให้ผู้ใช้พบแพทย์เพื่อรับคำปรึกษาเพิ่มเติม';
    } else {
      return 'ผู้ใช้อยู่ในกลุ่มเสี่ยงต่ำ ควรแนะนำให้ดูแลสุขภาพตามปกติ และสังเกตอาการหากมีการเปลี่ยนแปลง';
    }
  }

  /// Returns the appropriate icon based on the risk level
  static IconData getRiskIcon(String collection) {
    return collection == 'high_risk_users' 
        ? Icons.warning_amber_rounded 
        : Icons.check_circle_outline;
  }

  /// Checks if a risk level indicates high risk
  static bool isHighRisk(String riskLevel) {
    return riskLevel.contains('แดง') || 
           riskLevel.contains('red') || 
           riskLevel.contains('สูง');
  }
}