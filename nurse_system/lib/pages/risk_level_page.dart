// Main RiskLevelPage
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import '../components/risk/risk_detail_modal.dart';
import '../components/risk/risk_level_card.dart';


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

  void _showRiskDetailsModal(
      BuildContext context, Map<String, dynamic> riskItem) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => RiskDetailModal(
        riskItem: riskItem,
        firestore: _firestore,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16),
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(
            maxWidth: 500,
            maxHeight: MediaQuery.of(context).size.height * 0.85),
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
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
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
                            return RiskLevelCard(
                              riskItem: riskItem,
                              onTap: () => _showRiskDetailsModal(context, riskItem),
                            );
                          },
                        ),
            ),
            // Footer
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    const BorderRadius.vertical(bottom: Radius.circular(16)),
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