import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nurse_system/constants/styles.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final Color textColor;
  final String hintText;
  final IconData icon;
  final bool isPassword;
  final bool? isPasswordVisible;
  final Function()? onTogglePasswordVisibility;
  final String? Function(String?)? validator;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.textColor,
    required this.hintText,
    required this.icon,
    this.isPassword = false,
    this.isPasswordVisible,
    this.onTogglePasswordVisibility,
    this.validator,
  }) : assert(!isPassword || (isPasswordVisible != null && onTogglePasswordVisibility != null),
            'isPasswordVisible and onTogglePasswordVisibility must be provided for password fields');

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final inputBgColor = isDarkMode ? AppStyles.darkInputBackground : AppStyles.lightInputBackground;
    final borderColor = isDarkMode ? Colors.grey[800]! : Colors.grey[300]!;

    return TextFormField(
      controller: controller,
      obscureText: isPassword && !(isPasswordVisible ?? false),
      style: GoogleFonts.prompt(color: textColor),
      validator: validator,
      decoration: InputDecoration(
        filled: true,
        fillColor: inputBgColor,
        hintText: hintText,
        hintStyle: GoogleFonts.prompt(
          color: textColor.withOpacity(0.5),
          fontSize: 14,
        ),
        prefixIcon: Icon(
          icon,
          color: AppStyles.primaryColor,
        ),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  isPasswordVisible! ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey[600],
                ),
                onPressed: onTogglePasswordVisibility,
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: borderColor, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: borderColor, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppStyles.primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 16,
        ),
      ),
    );
  }
}