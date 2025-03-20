import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ErrorMessage extends StatelessWidget {
  final String message;

  const ErrorMessage({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red[200]!),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red[700], size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: GoogleFonts.kanit(
                fontSize: 12,
                color: Colors.red[700],
              ),
            ),
          ),
        ],
      ),
    );
  }
}