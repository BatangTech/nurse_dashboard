import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

class RiskLevelPage extends StatefulWidget {
  final String userId;

  const RiskLevelPage({Key? key, required this.userId}) : super(key: key);

  @override
  _RiskLevelPageState createState() => _RiskLevelPageState();
}

class _RiskLevelPageState extends State<RiskLevelPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isLoading = true;
  List<Map<String, dynamic>> _riskData = [];

  @override
  void initState() {
    super.initState();
    _fetchUserRiskData();
  }

  Future<void> _fetchUserRiskData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      List<Map<String, dynamic>> userRiskData = [];

      // ดึงข้อมูลจาก high_risk_users
      final highRiskDoc = await _firestore
          .collection('high_risk_users')
          .doc(widget.userId)
          .get();

      if (highRiskDoc.exists) {
        final data = highRiskDoc.data()!;
        userRiskData.add({
          'id': highRiskDoc.id,
          'user_id': widget.userId,
          'collection': 'high_risk_users',
          'risk_level': data['risk_level'] ?? 'ระดับความเสี่ยง: **แดง (red)**',
          'timestamp': data['timestamp'] as Timestamp,
        });
      }

      // ดึงข้อมูลจาก low_risk_users
      final lowRiskDoc = await _firestore
          .collection('low_risk_users')
          .doc(widget.userId)
          .get();

      if (lowRiskDoc.exists) {
        final data = lowRiskDoc.data()!;
        userRiskData.add({
          'id': lowRiskDoc.id,
          'user_id': widget.userId,
          'collection': 'low_risk_users',
          'risk_level':
              data['risk_level'] ?? 'ระดับความเสี่ยง: **เขียว (low risk)**',
          'timestamp': data['timestamp'] as Timestamp,
        });
      }

      // ดึงข้อมูลผู้ใช้จาก `users` collection
      final userDoc =
          await _firestore.collection('users').doc(widget.userId).get();
      final userData = userDoc.data();

      if (userData != null) {
        for (var riskItem in userRiskData) {
          riskItem['name'] = userData['name'] ?? 'Unknown';
          riskItem['email'] = userData['email'] ?? 'No email';
        }
      }

      setState(() {
        _riskData = userRiskData;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching user risk data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Color _getRiskColor(String riskLevel, String collection) {
    if (collection == 'high_risk_users' ||
        riskLevel.contains('แดง') ||
        riskLevel.contains('red')) {
      return const Color(0xFFE53935); // สีแดงที่สดใส
    } else if (collection == 'low_risk_users' ||
        riskLevel.contains('เขียว') ||
        riskLevel.contains('low') ||
        riskLevel.contains('green')) {
      return const Color(0xFF43A047); // สีเขียวที่สดใส
    }
    return const Color(0xFF9E9E9E); // สีเทา
  }

  void _showRiskDetailsModal(BuildContext context, Map<String, dynamic> riskItem) {
    final collection = riskItem['collection'] as String;
    final timestamp = riskItem['timestamp'] as Timestamp;
    final date = DateFormat('dd/MM/yyyy HH:mm').format(timestamp.toDate());
    final riskColor = _getRiskColor(riskItem['risk_level'], collection);
    final name = riskItem['name'] as String;
    final email = riskItem['email'] as String;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
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
                Container(
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
                ),
                
                // Content
                Expanded(
                  child: ListView(
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
                      FutureBuilder<DocumentSnapshot>(
                        future: _firestore
                            .collection(collection)
                            .doc(riskItem['id'])
                            .get(),
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

                          if (snapshot.hasError || !snapshot.hasData) {
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
                                  Text(
                                    'ไม่สามารถโหลดข้อมูลได้',
                                    style: GoogleFonts.kanit(
                                      fontSize: 14,
                                      color: Colors.grey[700],
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
                            child: Text(
                              reasonPart,
                              style: GoogleFonts.kanit(
                                fontSize: 15,
                                height: 1.5,
                                color: const Color(0xFF424770),
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                      // ประวัติการประเมิน
                      Text(
                        'ประวัติการประเมิน',
                        style: GoogleFonts.kanit(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF1F2251),
                        ),
                      ),
                      const SizedBox(height: 12),
                      FutureBuilder<QuerySnapshot>(
                        future: _firestore
                            .collection('risk_assessment_history')
                            .where('user_id', isEqualTo: widget.userId)
                            .orderBy('timestamp', descending: true)
                            .limit(5)
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

                          if (snapshot.hasError || !snapshot.hasData || snapshot.data!.docs.isEmpty) {
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
                                'ไม่พบประวัติการประเมิน',
                                style: GoogleFonts.kanit(
                                  fontSize: 14,
                                  color: Colors.grey[700],
                                ),
                                textAlign: TextAlign.center,
                              ),
                            );
                          }

                          final historyDocs = snapshot.data!.docs;
                          
                          return Column(
                            children: historyDocs.map((doc) {
                              final data = doc.data() as Map<String, dynamic>;
                              final historyTimestamp = data['timestamp'] as Timestamp;
                              final historyDate = DateFormat('dd/MM/yyyy HH:mm')
                                  .format(historyTimestamp.toDate());
                              
                              final riskLevel = data['risk_level'] as String? ?? 'ไม่มีข้อมูล';
                              final isHighRisk = riskLevel.contains('แดง') || 
                                  riskLevel.contains('red') || 
                                  riskLevel.contains('สูง');
                              
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
                                child: Row(
                                  children: [
                                    Container(
                                      width: 12,
                                      height: 12,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: isHighRisk
                                            ? const Color(0xFFE53935)
                                            : const Color(0xFF43A047),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'ความเสี่ยง: ${isHighRisk ? "สูง" : "ต่ำ"}',
                                            style: GoogleFonts.kanit(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: const Color(0xFF1F2251),
                                            ),
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
                              );
                            }).toList(),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                
                // Footer with buttons
                Container(
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
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: riskColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'ดำเนินการต่อ',
                            style: GoogleFonts.kanit(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Replace Scaffold with Dialog
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16),
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(maxWidth: 500, maxHeight: MediaQuery.of(context).size.height * 0.85),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    offset: const Offset(0, 1),
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'ข้อมูลความเสี่ยง',
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
            ),
            // Content
            Expanded(
              child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : _riskData.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'ไม่พบข้อมูลความเสี่ยงสำหรับผู้ใช้นี้',
                            style: GoogleFonts.kanit(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _riskData.length,
                      itemBuilder: (context, index) {
                        final riskItem = _riskData[index];
                        final collection = riskItem['collection'] as String;
                        final timestamp = riskItem['timestamp'] as Timestamp;
                        final date = DateFormat('dd/MM/yyyy HH:mm').format(timestamp.toDate());
                        final riskColor = _getRiskColor(riskItem['risk_level'], collection);
                        
                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                offset: const Offset(0, 2),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: () => _showRiskDetailsModal(context, riskItem),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color: riskColor.withOpacity(0.1),
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: riskColor.withOpacity(0.3),
                                              width: 1.5,
                                            ),
                                          ),
                                          child: Center(
                                            child: Icon(
                                              collection == 'high_risk_users'
                                                  ? Icons.warning_amber_rounded
                                                  : Icons.check_circle_outline,
                                              color: riskColor,
                                              size: 20,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                riskItem['name'] ?? 'ไม่พบชื่อ',
                                                style: GoogleFonts.kanit(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                  color: const Color(0xFF1F2251),
                                                ),
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                riskItem['email'] ?? 'ไม่พบอีเมล',
                                                style: GoogleFonts.kanit(
                                                  fontSize: 14,
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Container(
                                      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                                      decoration: BoxDecoration(
                                        color: riskColor.withOpacity(0.08),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        collection == 'high_risk_users'
                                            ? 'ความเสี่ยงสูง (แดง)'
                                            : 'ความเสี่ยงต่ำ (เขียว)',
                                        style: GoogleFonts.kanit(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: riskColor,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.calendar_today_rounded,
                                              size: 14,
                                              color: Colors.grey[500],
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              'ประเมินเมื่อ: $date',
                                              style: GoogleFonts.kanit(
                                                fontSize: 12,
                                                color: Colors.grey[700],
                                              ),
                                            ),
                                          ],
                                        ),
                                        Icon(
                                          Icons.arrow_forward_ios,
                                          size: 14,
                                          color: Colors.grey[400],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
            // Footer
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    offset: const Offset(0, -1),
                    blurRadius: 5,
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[200],
                  foregroundColor: Colors.grey[800],
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'ปิด',
                  style: GoogleFonts.kanit(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}