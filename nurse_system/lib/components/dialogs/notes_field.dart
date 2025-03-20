// notes_field.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotesField extends StatelessWidget {
  final TextEditingController controller;

  const NotesField({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: 3,
      decoration: InputDecoration(
        hintText: 'ระบุข้อมูลหรือคำถามที่ต้องการให้ AI สัมภาษณ์...',
        hintStyle: GoogleFonts.kanit(
          fontSize: 14,
          color: Colors.grey[400],
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE53935)),
        ),
        contentPadding: const EdgeInsets.all(16),
      ),
      style: GoogleFonts.kanit(
        fontSize: 14,
        color: const Color(0xFF1F2251),
      ),
    );
  }
}