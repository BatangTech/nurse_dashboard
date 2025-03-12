import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PatientList extends StatelessWidget {
  const PatientList({super.key, required});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('high_risk_users') // ✅ ใช้ high_risk_users
            .orderBy('timestamp', descending: true) // ✅ เรียงตามวันที่
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildCard(
              title: "Red Zone Patients",
              content: Center(child: CircularProgressIndicator()),
            );
          }
          if (snapshot.hasError) {
            return _buildCard(
              title: "Red Zone Patients",
              content: Text("Error loading data"),
            );
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return _buildCard(
              title: "Red Zone Patients",
              content: Text("No Red Zone patients found"),
            );
          }

          var patients = snapshot.data!.docs.map((doc) {
            var data = doc.data() as Map<String, dynamic>;
            return data;
          }).toList();

          return _buildCard(
            title: "Red Zone Patients",
            content: SizedBox(
              height: 150,
              child: SingleChildScrollView(
                child: Column(
                  children: patients.take(6).map((data) {
                    return Container(
                      width: double.infinity,
                      height: 40,
                      padding: EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(data['user_id'] ?? 'Unknown'),
                          ),
                          Expanded(
                            flex: 1,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.cancel,
                                  color: Colors.red,
                                ),
                                SizedBox(width: 5),
                                Text("Red Zone", style: TextStyle(color: Colors.red)),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              data['timestamp'] != null
                                  ? DateFormat('dd-MM-yyyy').format(
                                      (data['timestamp'] as Timestamp).toDate(),
                                    )
                                  : 'No date',
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCard({required String title, required Widget content}) {
    return Card(
      color: Colors.white,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 8, 64, 110),
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 2,
                  child: Text("User ID", style: TextStyle(fontWeight: FontWeight.bold, color: Color.fromARGB(255, 8, 64, 110))),
                ),
                Expanded(
                  flex: 1,
                  child: Text("Status", style: TextStyle(fontWeight: FontWeight.bold, color: Color.fromARGB(255, 8, 64, 110))),
                ),
                Expanded(
                  flex: 1,
                  child: Text("Date", style: TextStyle(fontWeight: FontWeight.bold, color: Color.fromARGB(255, 8, 64, 110))),
                ),
              ],
            ),
            Divider(),
            Expanded(
              child: content,
            ),
          ],
        ),
      ),
    );
  }
}
