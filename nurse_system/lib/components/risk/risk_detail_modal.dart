// Risk Detail Modal
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import '../dialogs/main_dialog.dart';
import 'risk_utils.dart';
import 'risk_assessment_history.dart';

class RiskDetailModal extends StatelessWidget {
  final Map<String, dynamic> riskItem;
  final FirebaseFirestore firestore;

  const RiskDetailModal({
    Key? key,
    required this.riskItem,
    required this.firestore,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final collection = riskItem['collection'] as String;
    final timestamp = riskItem['timestamp'] as Timestamp;
    final date = DateFormat('dd/MM/yyyy HH:mm').format(timestamp.toDate());
    final riskColor = RiskUtils.getRiskColor(riskItem['risk_level'], collection);
    final name = riskItem['name'] as String;
    final email = riskItem['email'] as String;
    final userId = riskItem['user_id'] as String;

    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              _buildHeader(context, name, email, riskColor, collection, date),
              
              // Content
              Expanded(
                child: _buildContent(
                  scrollController, 
                  riskColor, 
                  collection, 
                  userId
                ),
              ),

              // Footer with buttons
              _buildFooter(context, collection, riskColor, userId, name, email),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(
    BuildContext context, 
    String name, 
    String email, 
    Color riskColor, 
    String collection, 
    String date
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 1),
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'รายละเอียดความเสี่ยง',
                style: GoogleFonts.kanit(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF1F2251),
                ),
              ),
              IconButton(
                icon: Icon(Icons.close, color: Colors.grey[600]),
                onPressed: () => Navigator.pop(context),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      riskColor.withOpacity(0.7),
                      riskColor.withOpacity(0.4),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    name.isNotEmpty ? name[0].toUpperCase() : "?",
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1F2251),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      email,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              color: riskColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: riskColor.withOpacity(0.2),
                width: 1.5,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: riskColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'ระดับความเสี่ยง: ${collection == 'high_risk_users' ? 'สูง (แดง)' : 'ต่ำ (เขียว)'}',
                  style: GoogleFonts.kanit(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: riskColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(
                Icons.calendar_today_rounded,
                size: 16,
                color: Colors.grey[500],
              ),
              const SizedBox(width: 6),
              Text(
                'ประเมินเมื่อ: $date',
                style: GoogleFonts.kanit(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  
Widget _buildContent(
  ScrollController scrollController, 
  Color riskColor, 
  String collection, 
  String userId
) {
  print("Debug - Building content for collection: $collection and userId: $userId");
  
  return ListView(
    controller: scrollController,
    padding: const EdgeInsets.all(20),
    children: [
      // ส่วนรายละเอียด
      Text(
        'รายละเอียด',
        style: GoogleFonts.kanit(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF1F2251),
        ),
      ),
      const SizedBox(height: 12),
      _buildDetailSection(riskColor, collection),
      const SizedBox(height: 24),

      _buildRecommendationSection(riskColor, collection),
      const SizedBox(height: 24),
      
      // ส่ง collection ที่ชัดเจนเพื่อการกรองที่ถูกต้อง
      RiskAssessmentHistory(
        userId: userId,
        firestore: firestore,
        riskType: collection, // ส่งค่าประเภทความเสี่ยงตาม collection ที่กำลังดู
      ),
    ],
  );
}

  // แก้ไขที่ _buildDetailSection เพื่อให้แสดงประวัติทั้งหมดแทนที่จะแสดงเพียงรายการล่าสุด
Widget _buildDetailSection(Color riskColor, String collection) {
  return FutureBuilder<DocumentSnapshot>(
    future: firestore.collection(collection).doc(riskItem['id']).get(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: riskColor,
            ),
          ),
        );
      }

      if (snapshot.hasError || !snapshot.hasData || !snapshot.data!.exists) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.grey[200]!,
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.error_outline,
                color: Colors.grey[600],
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'ไม่พบข้อมูลความเสี่ยงใน${collection == "high_risk_users" ? "กลุ่มความเสี่ยงสูง" : "กลุ่มความเสี่ยงต่ำ"}',
                  style: GoogleFonts.kanit(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
              ),
            ],
          ),
        );
      }

      final data = snapshot.data!.data() as Map<String, dynamic>?;
      if (data == null) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.grey[200]!,
            ),
          ),
          child: Text(
            'ไม่พบข้อมูลรายละเอียด',
            style: GoogleFonts.kanit(
              fontSize: 14,
              color: Colors.grey[700],
            ),
          ),
        );
      }

      final fullRiskLevel = data['risk_level'] as String? ?? 'ไม่มีข้อมูล';
      final reasonPart = fullRiskLevel.contains('เหตุผล:')
          ? fullRiskLevel.split('เหตุผล:')[1].trim()
          : 'ไม่มีข้อมูลเหตุผล';

      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.grey[200]!,
            width: 1.0,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              reasonPart,
              style: GoogleFonts.kanit(
                fontSize: 15,
                height: 1.5,
                color: const Color(0xFF424770),
              ),
            ),
            if (data['timestamp'] != null) SizedBox(height: 12),
            if (data['timestamp'] != null)
              Text(
                'วันที่ประเมิน: ${DateFormat('dd/MM/yyyy HH:mm').format((data['timestamp'] as Timestamp).toDate())}',
                style: GoogleFonts.kanit(
                  fontSize: 13,
                  color: Colors.grey[600],
                ),
              ),
          ],
        ),
      );
    },
  );
}

  Widget _buildRecommendationSection(Color riskColor, String collection) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'คำแนะนำ',
          style: GoogleFonts.kanit(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF1F2251),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: riskColor.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: riskColor.withOpacity(0.15),
              width: 1.0,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    collection == 'high_risk_users'
                        ? Icons.warning_amber_rounded
                        : Icons.check_circle_outline,
                    color: riskColor,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      collection == 'high_risk_users'
                          ? 'ผู้ใช้อยู่ในกลุ่มเสี่ยงสูง ควรได้รับการติดตามอย่างใกล้ชิด สำหรับอาการที่อาจเกิดขึ้น ควรแนะนำให้ผู้ใช้พบแพทย์เพื่อรับคำปรึกษาเพิ่มเติม'
                          : 'ผู้ใช้อยู่ในกลุ่มเสี่ยงต่ำ ควรแนะนำให้ดูแลสุขภาพตามปกติ และสังเกตอาการหากมีการเปลี่ยนแปลง',
                      style: GoogleFonts.kanit(
                        fontSize: 14,
                        height: 1.5,
                        color: const Color(0xFF424770),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFooter(
    BuildContext context, 
    String collection, 
    Color riskColor, 
    String userId, 
    String name, 
    String email
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, -1),
            blurRadius: 5,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                side: BorderSide(color: Colors.grey[300]!),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'ปิด',
                style: GoogleFonts.kanit(
                  color: Colors.grey[700],
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                if (collection == 'high_risk_users') {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return ScheduleInterviewDialog(
                        userId: userId,
                        userName: name,
                        userEmail: email,
                      );
                    },
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: riskColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                collection == 'high_risk_users' ? 'ติดต่อ' : 'ตกลง',
                style: GoogleFonts.kanit(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}