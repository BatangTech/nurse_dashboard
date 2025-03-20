import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/interview_service.dart';
import 'dialog_footer.dart';
import 'dialog_header.dart';
import 'notes_field.dart';
import 'reminder_notification_checkbox.dart';
import 'user_info_card.dart';
import 'date_time_selector.dart';
import 'info_banner.dart';
import 'error_message.dart';


class ScheduleInterviewDialog extends StatefulWidget {
  final String userId;
  final String userName;
  final String userEmail;

  const ScheduleInterviewDialog({
    Key? key,
    required this.userId,
    required this.userName,
    required this.userEmail,
  }) : super(key: key);

  @override
  _ScheduleInterviewDialogState createState() =>
      _ScheduleInterviewDialogState();
}

class _ScheduleInterviewDialogState extends State<ScheduleInterviewDialog> {
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  TimeOfDay _selectedTime = const TimeOfDay(hour: 9, minute: 0);
  final TextEditingController _notesController = TextEditingController();
  bool _isSaving = false;
  String? _errorMessage;
  bool _sendReminderNotification = true;
  final InterviewService _interviewService = InterviewService();

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _updateSelectedDate(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
  }

  void _updateSelectedTime(TimeOfDay time) {
    setState(() {
      _selectedTime = time;
    });
  }

  Future<void> _saveInterview() async {
    if (_isSaving) return;

    setState(() {
      _isSaving = true;
      _errorMessage = null;
    });

    try {
      final DateTime interviewDateTime = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedTime.hour,
        _selectedTime.minute,
      );

      await _interviewService.scheduleInterview(
        userId: widget.userId,
        userName: widget.userName,
        userEmail: widget.userEmail,
        interviewDateTime: interviewDateTime,
        notes: _notesController.text,
        sendReminder: _sendReminderNotification,
        timeFormat: (time) => time.format(context),
      );

      Navigator.of(context).pop(true);
    } catch (e) {
      setState(() {
        _errorMessage = 'เกิดข้อผิดพลาด: $e';
        _isSaving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16),
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(
          maxWidth: 500,
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            DialogHeader(
              title: 'นัดสัมภาษณ์ AI สำหรับผู้ใช้ Red Zone',
              onClose: () => Navigator.pop(context),
            ),

            // Content
            Flexible(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // User Info
                      UserInfoCard(
                        userName: widget.userName,
                        userEmail: widget.userEmail,
                      ),

                      const SizedBox(height: 24),
                      
                      // Date and Time Selectors
                      DateTimeSelector(
                        selectedDate: _selectedDate, 
                        selectedTime: _selectedTime,
                        onDateChanged: _updateSelectedDate,
                        onTimeChanged: _updateSelectedTime,
                      ),

                      const SizedBox(height: 16),
                      Text(
                        'บันทึกเพิ่มเติม',
                        style: GoogleFonts.kanit(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF1F2251),
                        ),
                      ),
                      const SizedBox(height: 8),
                      NotesField(controller: _notesController),

                      const SizedBox(height: 16),
                      const InfoBanner(
                        message: 'การสัมภาษณ์นี้จะดำเนินการโดย AI ที่จะทำหน้าที่สอบถามผู้ใช้ในกลุ่มเสี่ยงสูงเพื่อประเมินความเสี่ยงที่แท้จริง',
                      ),

                      const SizedBox(height: 16),
                      ReminderNotificationCheckbox(
                        value: _sendReminderNotification,
                        onChanged: (value) {
                          setState(() {
                            _sendReminderNotification = value ?? true;
                          });
                        },
                      ),

                      if (_errorMessage != null) ...[
                        const SizedBox(height: 12),
                        ErrorMessage(message: _errorMessage!),
                      ],
                    ],
                  ),
                ),
              ),
            ),

            // Footer with buttons
            DialogFooter(
              onCancel: () => Navigator.pop(context),
              onSave: _saveInterview,
              isSaving: _isSaving,
            ),
          ],
        ),
      ),
    );
  }
}