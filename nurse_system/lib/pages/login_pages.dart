import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nurse_system/components/login/custom_text_field.dart';
import 'package:nurse_system/components/login/error_message.dart';
import 'package:nurse_system/components/login/login_button.dart';
import 'package:nurse_system/components/login/login_footer.dart';
import 'package:nurse_system/components/login/login_header.dart';
import 'package:nurse_system/constants/styles.dart';
import 'package:nurse_system/services/auth_service.dart';
import 'package:nurse_system/services/log_service.dart';
import 'dashboard_pages.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  String _errorMessage = '';

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final username = _usernameController.text.trim();
      final password = _passwordController.text.trim();

      final authResult = await AuthService.login(username, password);

      if (authResult.success) {
        try {
          final platform = await LogService.detectPlatform(context);
          await LogService.logAdminLogin(username, platform);
        } catch (e) {
          print('Failed to log admin login: $e');
        }

        if (!context.mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DashboardPage()),
        );
      } else {
        setState(() {
          _errorMessage = 'ชื่อผู้ใช้หรือรหัสผ่านไม่ถูกต้อง';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'เกิดข้อผิดพลาด: $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
        isDarkMode ? AppStyles.darkBackground : AppStyles.lightBackground;
    final textColor =
        isDarkMode ? AppStyles.darkTextColor : AppStyles.lightTextColor;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 450),
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    LoginHeader(textColor: textColor),
                    const SizedBox(height: 40),
                    Text(
                      "ชื่อผู้ใช้หรืออีเมล",
                      style: GoogleFonts.prompt(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    CustomTextField(
                      controller: _usernameController,
                      textColor: textColor,
                      hintText: "กรอกชื่อผู้ใช้หรืออีเมล",
                      icon: Icons.person_outline,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'กรุณากรอกชื่อผู้ใช้หรืออีเมล';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    Text(
                      "รหัสผ่าน",
                      style: GoogleFonts.prompt(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    CustomTextField(
                      controller: _passwordController,
                      textColor: textColor,
                      hintText: "กรอกรหัสผ่าน",
                      icon: Icons.lock_outline,
                      isPassword: true,
                      isPasswordVisible: _isPasswordVisible,
                      onTogglePasswordVisibility: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'กรุณากรอกรหัสผ่าน';
                        }
                        return null;
                      },
                    ),
                    if (_errorMessage.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      ErrorMessage(message: _errorMessage),
                    ],
                    const SizedBox(height: 32),
                    LoginButton(
                      onPressed: _handleLogin,
                      isLoading: _isLoading,
                    ),
                    const SizedBox(height: 24),
                    LoginFooter(textColor: textColor),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
