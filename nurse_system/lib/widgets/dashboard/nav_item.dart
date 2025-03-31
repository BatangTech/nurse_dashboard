import 'package:flutter/material.dart';
import 'package:nurse_system/constants/colors.dart';
import 'package:google_fonts/google_fonts.dart';

class NavItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final int index;
  final int selectedIndex;
  final Function(int) onTap;
  final bool disabled;
  final bool isWarning;

  const NavItem({
    Key? key,
    required this.icon,
    required this.text,
    required this.index,
    required this.selectedIndex,
    required this.onTap,
    this.disabled = false,
    this.isWarning = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isSelected = selectedIndex == index;
    
    Color getSelectedBgColor() {
      if (isWarning) return AppColors.redZoneColor.withOpacity(0.1);
      return AppColors.primaryColor.withOpacity(0.1);
    }
    
    Color getSelectedTextColor() {
      if (isWarning) return AppColors.redZoneColor;
      return AppColors.primaryColor;
    }
    
    Color getSelectedIconColor() {
      if (isWarning) return AppColors.redZoneColor;
      return AppColors.primaryColor;
    }
    
    Color bgColor = isSelected ? getSelectedBgColor() : Colors.transparent;
    
    Color textColor = disabled 
        ? Colors.grey[400]! 
        : isSelected 
            ? getSelectedTextColor()
            : Colors.grey[700]!;
            
    Color iconColor = disabled 
        ? Colors.grey[400]! 
        : isSelected || isWarning
            ? getSelectedIconColor()
            : Colors.grey[600]!;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
      child: Material(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
        child: InkWell(
          onTap: disabled ? null : () => onTap(index),
          borderRadius: BorderRadius.circular(6),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: iconColor,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  text,
                  style: GoogleFonts.prompt(
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                    color: textColor,
                  ),
                ),
                if (isSelected) ...[
                  const Spacer(),
                  Container(
                    width: 4,
                    height: 24,
                    decoration: BoxDecoration(
                      color: isWarning ? AppColors.redZoneColor : AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }
}