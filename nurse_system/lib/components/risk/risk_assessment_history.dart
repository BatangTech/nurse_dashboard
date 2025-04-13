// risk_assessment_history.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';


class RiskAssessmentHistory extends StatelessWidget {
  final String userId;
  final FirebaseFirestore firestore;
  final String? riskType;
  
  const RiskAssessmentHistory({
    Key? key,
    required this.userId,
    required this.firestore,
    this.riskType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ประวัติการประเมิน${riskType == 'high_risk_users' ? ' (ความเสี่ยงสูง)' : riskType == 'low_risk_users' ? ' (ความเสี่ยงต่ำ)' : ''}',
          style: GoogleFonts.kanit(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF1F2251),
          ),
        ),
        const SizedBox(height: 12),
        _buildHistoryList(context),
      ],
    );
  }

  Widget _buildHistoryList(BuildContext context) {
    print("Debug - Fetching conversation history for user: $userId");

    return FutureBuilder<QuerySnapshot>(
      // ดึงข้อมูลจาก conversations/userId/sessions แทน
      future: firestore
          .collection('conversations')
          .doc(userId)
          .collection('sessions')
          .orderBy('timestamp', descending: true)
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.grey[400],
              ),
            ),
          );
        }

        if (snapshot.hasError) {
          print("Debug - Error fetching history: ${snapshot.error}");
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
              'เกิดข้อผิดพลาดในการโหลดข้อมูล: ${snapshot.error}',
              style: GoogleFonts.kanit(
                fontSize: 14,
                color: Colors.grey[700],
              ),
              textAlign: TextAlign.center,
            ),
          );
        }

        // ดึงข้อมูลแชทปัจจุบันด้วย (main conversation)
        return FutureBuilder<DocumentSnapshot>(
          future: firestore.collection('conversations').doc(userId).get(),
          builder: (context, mainSnapshot) {
            List<Map<String, dynamic>> allHistory = [];
            
            // เพิ่มข้อมูลแชทปัจจุบัน (ถ้ามี)
            if (mainSnapshot.hasData && mainSnapshot.data!.exists) {
              final mainData = mainSnapshot.data!.data() as Map<String, dynamic>;
              final timestamp = mainData['timestamp'] ?? Timestamp.now();
              final riskLevel = mainData['risk_level'] ?? '';
              
              // กรองตามประเภทความเสี่ยง (ถ้ากำหนด)
              if (riskType == null || 
                  (riskType == 'high_risk_users' && _isHighRisk(riskLevel)) ||
                  (riskType == 'low_risk_users' && !_isHighRisk(riskLevel))) {
                allHistory.add({
                  'timestamp': timestamp,
                  'risk_level': riskLevel,
                  'is_current': true,
                  'id': userId,
                });
              }
            }
            
            // เพิ่มข้อมูลประวัติแชท
            if (snapshot.hasData) {
              for (var doc in snapshot.data!.docs) {
                final data = doc.data() as Map<String, dynamic>;
                final sessionRiskLevel = data['risk_level'] ?? '';
                
                // กรองตามประเภทความเสี่ยง (ถ้ากำหนด)
                if (riskType == null || 
                    (riskType == 'high_risk_users' && _isHighRisk(sessionRiskLevel)) ||
                    (riskType == 'low_risk_users' && !_isHighRisk(sessionRiskLevel))) {
                  allHistory.add({
                    'timestamp': data['timestamp'] ?? Timestamp.now(),
                    'risk_level': sessionRiskLevel,
                    'is_current': false,
                    'id': doc.id,
                  });
                }
              }
            }
            
            // เรียงลำดับตามเวลา (ล่าสุดก่อน)
            allHistory.sort((a, b) {
              final Timestamp aTime = a['timestamp'] as Timestamp;
              final Timestamp bTime = b['timestamp'] as Timestamp;
              return bTime.compareTo(aTime);
            });
            
            print("Debug - Found ${allHistory.length} history items");
            
            if (allHistory.isEmpty) {
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
                  'ไม่พบประวัติการประเมิน${riskType == 'high_risk_users' ? 'ความเสี่ยงสูง' : riskType == 'low_risk_users' ? 'ความเสี่ยงต่ำ' : ''}',
                  style: GoogleFonts.kanit(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            }
            
            return Column(
              children: allHistory.map((item) {
                final timestamp = item['timestamp'] as Timestamp;
                final historyDate = DateFormat('dd/MM/yyyy HH:mm').format(timestamp.toDate());
                final isHighRisk = _isHighRisk(item['risk_level']);
                final docId = item['id'];
                final isCurrent = item['is_current'] ?? false;
                
                return _buildHistoryItem(context, isHighRisk, historyDate, docId.toString(), isCurrent);
              }).toList(),
            );
          },
        );
      },
    );
  }
  
  bool _isHighRisk(String riskLevel) {
    return riskLevel.contains('แดง') || 
           riskLevel.contains('red') || 
           riskLevel.contains('สูง');
  }

  Widget _buildHistoryItem(BuildContext context, bool isHighRisk, String historyDate, String docId, bool isCurrent) {
    final riskColor = isHighRisk ? const Color(0xFFE53935) : const Color(0xFF43A047);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey[200]!,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            offset: const Offset(0, 1),
            blurRadius: 3,
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          // แสดงข้อมูลในรูปแบบ dialog
          _showHistoryDetail(context, docId, isCurrent, isHighRisk);
        },
        child: Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: riskColor,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'ความเสี่ยง: ${isHighRisk ? "สูง" : "ต่ำ"}',
                        style: GoogleFonts.kanit(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF1F2251),
                        ),
                      ),
                      if (isCurrent)
                        Container(
                          margin: const EdgeInsets.only(left: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFF5C6BC0).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            'ปัจจุบัน',
                            style: GoogleFonts.kanit(
                              fontSize: 11,
                              color: const Color(0xFF5C6BC0),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    historyDate,
                    style: GoogleFonts.kanit(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }
  
  void _showHistoryDetail(BuildContext context, String docId, bool isCurrent, bool isHighRisk) async {
    try {
      DocumentSnapshot doc;
      
      if (isCurrent) {
        doc = await firestore.collection('conversations').doc(userId).get();
      } else {
        doc = await firestore.collection('conversations').doc(userId).collection('sessions').doc(docId).get();
      }
      
      if (!doc.exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('ไม่พบข้อมูลรายละเอียด', style: GoogleFonts.kanit()),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      
      final data = doc.data() as Map<String, dynamic>;
      final riskLevel = data['risk_level'] ?? 'ไม่ระบุ';
      final timestamp = data['timestamp'] as Timestamp;
      final date = DateFormat('dd/MM/yyyy HH:mm').format(timestamp.toDate());
      final riskColor = isHighRisk ? const Color(0xFFE53935) : const Color(0xFF43A047);
      
      // แสดง Dialog รายละเอียด
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            'รายละเอียดการประเมิน',
            style: GoogleFonts.kanit(
              fontWeight: FontWeight.w500,
              color: const Color(0xFF1F2251),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                      'ระดับความเสี่ยง: ${isHighRisk ? 'สูง (แดง)' : 'ต่ำ (เขียว)'}',
                      style: GoogleFonts.kanit(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: riskColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today_rounded,
                    size: 16,
                    color: Colors.grey[500],
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'วันที่ประเมิน: $date',
                    style: GoogleFonts.kanit(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'รายละเอียด:',
                style: GoogleFonts.kanit(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF1F2251),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Text(
                  riskLevel,
                  style: GoogleFonts.kanit(
                    fontSize: 14,
                    color: Colors.grey[800],
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'ปิด',
                style: GoogleFonts.kanit(color: Colors.grey[700]),
              ),
            ),
          ],
        ),
      );
      
    } catch (e) {
      print('Error showing history detail: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('เกิดข้อผิดพลาดในการโหลดข้อมูล', style: GoogleFonts.kanit()),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}