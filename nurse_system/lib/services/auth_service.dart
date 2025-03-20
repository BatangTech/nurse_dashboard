class AuthResult {
  final bool success;
  final String? errorMessage;

  AuthResult({required this.success, this.errorMessage});
}

class AuthService {
  static const String _adminUsername = 'admin@ncds.com';
  static const String _adminPassword = 'admin123456';

  static Future<AuthResult> login(String username, String password) async {
    if (username == _adminUsername && password == _adminPassword) {
      return AuthResult(success: true);
    } else {
      return AuthResult(success: false, errorMessage: 'ชื่อผู้ใช้หรือรหัสผ่านไม่ถูกต้อง');
    }
  }
}