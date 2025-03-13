import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:nurse_system/pages/login_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyDTccw-bA9QTyCaxvwlbWKYMyLS3x1a4KM",
          projectId: "ncds-user-app",
          messagingSenderId: "647448783618",
          appId: "1:647448783618:web:8eedcca497bfbdb370f01b"));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: Colors.grey[50],
      ),
      home: const LoginPage(),
    );
  }
}
