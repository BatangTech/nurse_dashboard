import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TableHeader extends StatelessWidget {
  const TableHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          double totalWidth = constraints.maxWidth;
          
          return Row(
            children: [
              const SizedBox(width: 8),
              Flexible(
                flex: (totalWidth * 0.6).toInt(), // 40% ของพื้นที่
                fit: FlexFit.tight,
                child: Text(
                  "ชื่อ",
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[600],
                  ),
                ),
              ),
              Flexible(
                flex: (totalWidth * 0.25).toInt(), // 20% ของพื้นที่
                fit: FlexFit.tight,
                child: Text(
                  "สถานะ",
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[600],
                  ),
                ),
              ),
              Flexible(
                flex: (totalWidth * 0.22).toInt(), // 20% ของพื้นที่
                fit: FlexFit.tight,
                child: Text(
                  "คะแนนเสี่ยง",
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[600],
                  ),
                ),
              ),
              Flexible(
                flex: (totalWidth * 0.15).toInt(), // 20% ของพื้นที่
                fit: FlexFit.tight,
                child: Text(
                  "อัพเดทล่าสุด",
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[600],
                  ),
                ),
              ),
              const SizedBox(width: 40),
            ],
          );
        },
      ),
    );
  }
}
