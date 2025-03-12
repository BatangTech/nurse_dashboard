import 'package:dashboard_2/screens/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'screens/dashboard_screen.dart';
import 'screens/patient_screen.dart';
import 'screens/monitor_screen.dart';  // ✅ นำเข้า MonitorScreen
import 'styles/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyDTccw-bA9QTyCaxvwlbWKYMyLS3x1a4KM",
        projectId: "ncds-user-app",
        messagingSenderId: "647448783618",
        appId: "1:647448783618:web:8eedcca497bfbdb370f01b",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: appTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: '/login', // ✅ หน้าเริ่มต้น
      routes: {
        '/login':(context)=>LoginPage(),
        '/dashboard': (context) => DashboardScreen(),
        '/patient': (context) => PatientScreen(),
        '/monitor': (context) => MonitorScreen(),  // ✅ เพิ่มหน้า Monitor
        '/logout': (context) => LoginPage(),  // ✅ เพิ่มหน้า Monitor
      },
    );
  }
}
