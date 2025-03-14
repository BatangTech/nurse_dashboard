import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/user_model.dart';
import 'table_header.dart';
import 'table_row.dart';

class UserTableSection extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<UserModel> users;
  final Color statusColor;
  final IconData icon;

  const UserTableSection({
    super.key,
    required this.title,
    required this.subtitle,
    required this.users,
    required this.statusColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final String status = statusColor == const Color(0xFFFF5252)
        ? "Red zone"
        : "Green zone";

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1F2251),
                      ),
                    ),
                    Text(
                      subtitle,
                      style: GoogleFonts.kanit(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: statusColor, size: 20),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFEEEEF0)),
          const TableHeader(),
          if (users.isEmpty)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                  "ไม่พบข้อมูลผู้ใช้ในส่วนนี้",
                  style: GoogleFonts.kanit(
                    color: Colors.grey[400],
                  ),
                ),
              ),
            )
          else
            ...users.take(5).map((user) => UserTableRow(
                  name: user.userId,
                  status: status,
                  date: user.getFormattedDate(),
                  statusColor: statusColor,
                  riskScore: user.riskScore,
                )),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "แสดงผล ${users.length > 5 ? 5 : users.length} จากทั้งหมด ${users.length} รายการ",
                  style: GoogleFonts.kanit(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                if (users.length > 5)
                  TextButton(
                    onPressed: () {
                      // เพิ่มฟังก์ชันเพื่อดูข้อมูลเพิ่มเติม
                    },
                    child: Text(
                      "ดูทั้งหมด",
                      style: GoogleFonts.kanit(
                        fontSize: 12,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
