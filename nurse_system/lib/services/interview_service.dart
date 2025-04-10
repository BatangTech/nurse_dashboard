import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class InterviewService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> scheduleInterview({
    required String userId,
    required String userName,
    required String userEmail,
    required DateTime interviewDateTime,
    required String notes,
    required bool sendReminder,
    required String Function(TimeOfDay) timeFormat,
  }) async {
    final TimeOfDay selectedTime = TimeOfDay(
      hour: interviewDateTime.hour,
      minute: interviewDateTime.minute,
    );

    DocumentReference interviewRef =
        await _firestore.collection('scheduled_interviews').add({
      'user_id': userId,
      'user_name': userName,
      'user_email': userEmail,
      'interview_datetime': Timestamp.fromDate(interviewDateTime),
      'notes': notes,
      'status': 'scheduled',
      'created_at': FieldValue.serverTimestamp(),
      'nurse_id': FirebaseAuth.instance.currentUser?.uid,
      'nurse_name': FirebaseAuth.instance.currentUser?.displayName,
      'is_ai_interview': true,
      'completed': false,
    });

    await _firestore.collection('user_notifications').add({
      'user_id': userId,
      'title': 'การสัมภาษณ์ความเสี่ยงได้รับการจัดตารางแล้ว',
      'message':
          'คุณได้รับการนัดหมายเพื่อสัมภาษณ์เกี่ยวกับความเสี่ยงในวันที่ ${DateFormat('dd/MM/yyyy').format(interviewDateTime)} เวลา ${timeFormat(selectedTime)}',
      'type': 'interview_scheduled',
      'read': false,
      'created_at': FieldValue.serverTimestamp(),
      'data': {
        'interview_id': interviewRef.id,
        'interview_datetime': Timestamp.fromDate(interviewDateTime),
      },
      'is_ai_interview': true,
    });

    if (sendReminder) {
      await _firestore.collection('fcm_notifications').add({
        'user_id': userId,
        'title': 'การสัมภาษณ์ความเสี่ยง',
        'body':
            'คุณมีการนัดหมายสัมภาษณ์ความเสี่ยงในวันที่ ${DateFormat('dd/MM/yyyy').format(interviewDateTime)} เวลา ${timeFormat(selectedTime)}',
        'data': {
          'type': 'ai_interview_scheduled',
          'interview_id': interviewRef.id,
        },
        'scheduled_at': Timestamp.fromDate(
            interviewDateTime.subtract(const Duration(hours: 1))),
        'sent': false,
      });
    }

    await _scheduleReminders(
        interviewRef.id, interviewDateTime, userId, timeFormat(selectedTime));
  }

  Future<void> _scheduleReminders(
    String interviewId,
    DateTime interviewDateTime,
    String userId,
    String formattedTime,
  ) async {
    await _firestore.collection('scheduled_reminders').add({
      'user_id': userId,
      'interview_id': interviewId,
      'reminder_time': Timestamp.fromDate(
          interviewDateTime.subtract(const Duration(days: 1))),
      'title': 'เตรียมความพร้อมสำหรับการสัมภาษณ์พรุ่งนี้',
      'message': 'คุณมีการนัดหมายสัมภาษณ์ความเสี่ยงพรุ่งนี้เวลา $formattedTime',
      'is_sent': false,
      'created_at': FieldValue.serverTimestamp(),
    });

    await _firestore.collection('scheduled_reminders').add({
      'user_id': userId,
      'interview_id': interviewId,
      'reminder_time': Timestamp.fromDate(
          interviewDateTime.subtract(const Duration(hours: 1))),
      'title': 'การสัมภาษณ์จะเริ่มในอีก 1 ชั่วโมง',
      'message':
          'การสัมภาษณ์ความเสี่ยงของคุณจะเริ่มในอีก 1 ชั่วโมง กรุณาเตรียมความพร้อม',
      'is_sent': false,
      'created_at': FieldValue.serverTimestamp(),
    });
  }
}
