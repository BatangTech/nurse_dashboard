import 'package:flutter/material.dart';

import '../../../pages/risk_level_page.dart';
import 'action_button.dart';

class ActionButtonsRow extends StatelessWidget {
  final String userId;
  final bool isFromAllUsers; // เพิ่มพารามิเตอร์นี้

  const ActionButtonsRow({
    super.key,
    required this.userId,
    this.isFromAllUsers = false, // กำหนดค่าเริ่มต้น
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        if (!isFromAllUsers)
          ActionButton(
            icon: Icons.assessment,
            label: 'ดูระดับความเสี่ยง',
            color: Colors.orange,
            onTap: () {
              Navigator.pop(context);
              showDialog(
                context: context,
                builder: (context) => RiskLevelPage(userId: userId),
                barrierDismissible: true,
              );
            },
          ),
      ],
    );
  }
}
