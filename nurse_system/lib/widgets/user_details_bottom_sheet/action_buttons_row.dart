import 'package:flutter/material.dart';

import '../../../pages/risk_level_page.dart';
import 'action_button.dart';

class ActionButtonsRow extends StatelessWidget {
  final String userId;

  const ActionButtonsRow({
    super.key,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
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