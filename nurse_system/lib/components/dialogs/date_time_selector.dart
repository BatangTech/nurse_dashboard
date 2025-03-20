import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'date_selector.dart';
import 'time_selector.dart';

class DateTimeSelector extends StatelessWidget {
  final DateTime selectedDate;
  final TimeOfDay selectedTime;
  final Function(DateTime) onDateChanged;
  final Function(TimeOfDay) onTimeChanged;

  const DateTimeSelector({
    Key? key,
    required this.selectedDate,
    required this.selectedTime,
    required this.onDateChanged,
    required this.onTimeChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'วันที่สัมภาษณ์',
          style: GoogleFonts.kanit(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF1F2251),
          ),
        ),
        const SizedBox(height: 8),
        DateSelector(
          selectedDate: selectedDate,
          onDateChanged: onDateChanged,
        ),
        
        const SizedBox(height: 16),
        Text(
          'เวลาสัมภาษณ์',
          style: GoogleFonts.kanit(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF1F2251),
          ),
        ),
        const SizedBox(height: 8),
        TimeSelector(
          selectedTime: selectedTime,
          onTimeChanged: onTimeChanged,
        ),
      ],
    );
  }
}
