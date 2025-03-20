import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LogService {
  static Future<String> detectPlatform(BuildContext context) async {
    String platform = 'Unknown';
    try {
      if (Theme.of(context).platform == TargetPlatform.android) {
        platform = 'Android';
      } else if (Theme.of(context).platform == TargetPlatform.iOS) {
        platform = 'iOS';
      } else if (Theme.of(context).platform == TargetPlatform.windows) {
        platform = 'Windows';
      } else if (Theme.of(context).platform == TargetPlatform.macOS) {
        platform = 'macOS';
      } else if (Theme.of(context).platform == TargetPlatform.linux) {
        platform = 'Linux';
      } else if (Theme.of(context).platform == TargetPlatform.fuchsia) {
        platform = 'Fuchsia';
      } else {
        platform = 'Web/Unknown';
      }
    } catch (e) {
      platform = 'Error detecting platform';
    }
    return platform;
  }

  static Future<void> logAdminLogin(String adminEmail, String platform) async {
    await FirebaseFirestore.instance.collection('admin_logs').add({
      'adminEmail': adminEmail,
      'loginTime': FieldValue.serverTimestamp(),
      'device': platform,
    });
  }
}