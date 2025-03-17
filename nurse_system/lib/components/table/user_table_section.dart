import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/user_model.dart';
import 'table_header.dart';
import 'table_row.dart';

class UserTableSection extends StatefulWidget {
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
  _UserTableSectionState createState() => _UserTableSectionState();
}

class _UserTableSectionState extends State<UserTableSection> {
  bool showAllUsers = false;

  @override
  Widget build(BuildContext context) {
    final String status = widget.statusColor == const Color(0xFFFF5252)
        ? "Red zone"
        : "Green zone";
    final displayedUsers =
        showAllUsers ? widget.users : widget.users.take(5).toList();

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
                      widget.title,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1F2251),
                      ),
                    ),
                    Text(
                      widget.subtitle,
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
                    color: widget.statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(widget.icon, color: widget.statusColor, size: 20),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFEEEEF0)),
          const TableHeader(),
          if (widget.users.isEmpty)
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
            ...displayedUsers.map((user) => UserTableRow(
                  userId: user.id,
                  name: user.name,
                  status: status,
                  date: user.getFormattedDate(),
                  statusColor: widget.statusColor,
                  riskScore: user.riskScore,
                )),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "แสดงผล ${displayedUsers.length} จากทั้งหมด ${widget.users.length} รายการ",
                  style: GoogleFonts.kanit(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                if (widget.users.length > 5)
                  TextButton(
                    onPressed: () {
                      setState(() {
                        showAllUsers = !showAllUsers;
                      });
                    },
                    child: Text(
                      showAllUsers ? "ย่อรายการ" : "ดูทั้งหมด",
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
