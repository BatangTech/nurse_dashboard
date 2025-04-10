import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final bool isSelected;

  const SummaryCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    // สีพื้นฐานที่ดูเป็นทางการมากขึ้น
    final baseColor = isSelected ? color : const Color(0xFF3A4C66);
    final cardColor = Colors.white;
    final statusText = 'กำลังดู';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isSelected 
                ? color.withOpacity(0.12) 
                : Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
            spreadRadius: isSelected ? 1 : 0,
          ),
        ],
        border: Border.all(
          color: isSelected 
              ? color.withOpacity(0.4) 
              : Colors.grey.withOpacity(0.15),
          width: 1.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with icon and title
          Row(
            children: [
              // Icon with professional container
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isSelected 
                      ? color.withOpacity(0.12)
                      : const Color(0xFFF3F5F9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon, 
                  color: isSelected ? color : baseColor, 
                  size: 18,
                ),
              ),
              const SizedBox(width: 14),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  color: isSelected ? color : baseColor,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.2,
                ),
              ),
              const Spacer(),
              // Status indicator if selected
              if (isSelected)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: color.withOpacity(0.25),
                      width: 0.8,
                    ),
                  ),
                  child: Text(
                    statusText,
                    style: GoogleFonts.kanit(
                      fontSize: 11,
                      color: color,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Value with professional display
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: GoogleFonts.poppins(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: isSelected ? color : baseColor,
                  height: 1.0,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(width: 6),
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  "คน",
                  style: GoogleFonts.kanit(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 14),
          
          // Progress indicator with more professional look
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'ความคืบหน้า',
                    style: GoogleFonts.kanit(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    '${value}%',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: isSelected ? color : baseColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Container(
                height: 6,
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F2F5),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.grey.withOpacity(0.15),
                    width: 0.5,
                  ),
                ),
                child: Row(
                  children: [
                    Flexible(
                      flex: int.parse(value),
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected ? color : baseColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    if (int.parse(value) < 100)
                      Flexible(
                        flex: 100 - int.parse(value),
                        child: Container(),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}