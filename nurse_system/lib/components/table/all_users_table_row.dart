import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../dialogs/main_dialog.dart';
import 'user_details_bottom_sheet.dart';

class AllUsersTableRow extends StatelessWidget {
  final String userId;
  final String name;
  final String userEmail;
  final String date;
  final Color statusColor;
  final String riskScore;

  const AllUsersTableRow({
    super.key,
    required this.userId,
    required this.name,
    required this.userEmail,
    required this.date,
    required this.statusColor,
    required this.riskScore,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showUserDetailsBottomSheet(context),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    statusColor,
                    statusColor.withOpacity(0.7),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  name.isNotEmpty ? name[0].toUpperCase() : "?",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF2A3548),
                      letterSpacing: -0.2,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "ชื่อ",
                    style: GoogleFonts.kanit(
                      fontSize: 12,
                      color: const Color(0xFF9CA3AF),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                child: Column(
                  children: [
                    Text(
                      riskScore,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF3D5AF1),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "คะแนน",
                      style: GoogleFonts.kanit(
                        fontSize: 12,
                        color: const Color(0xFF9CA3AF),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.event_outlined,
                    size: 16,
                    color: Color(0xFF9CA3AF),
                  ),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      date,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: const Color(0xFF64748B),
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 8),
              height: 32,
              child: ElevatedButton(
                onPressed: () => _showScheduleInterviewDialog(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3D5AF1),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                ),
                child: Text(
                  'นัดสัมภาษณ์',
                  style: GoogleFonts.kanit(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 32,
              height: 32,
              child: IconButton(
                icon: const Icon(
                  Icons.more_horiz_rounded,
                  color: Color(0xFF64748B),
                  size: 20,
                ),
                onPressed: () => _showOptionsMenu(context),
                padding: EdgeInsets.zero,
                splashRadius: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showUserDetailsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => UserDetailsBottomSheet(
        userId: userId,
        isFromAllUsers: true,
      ),
    );
  }

  void _showScheduleInterviewDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ScheduleInterviewDialog(
        userId: userId,
        userName: name,
        userEmail: userEmail,
      ),
    );
  }

  void _showOptionsMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3D5AF1).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.person_outline_rounded,
                    color: Color(0xFF3D5AF1),
                    size: 20,
                  ),
                ),
                title: Text(
                  'ดูข้อมูลผู้ใช้',
                  style: GoogleFonts.kanit(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF2A3548),
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _showUserDetailsBottomSheet(context);
                },
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3D5AF1).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.calendar_month_rounded,
                    color: Color(0xFF3D5AF1),
                    size: 20,
                  ),
                ),
                title: Text(
                  'นัดสัมภาษณ์',
                  style: GoogleFonts.kanit(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF2A3548),
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _showScheduleInterviewDialog(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
