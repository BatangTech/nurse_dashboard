
import 'package:flutter/material.dart';
import 'package:nurse_system/constants/colors.dart';
import 'package:nurse_system/pages/dashboard_content.dart';
import 'package:nurse_system/pages/table_pages.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../widgets/dashboard/dashboard_drawer.dart';
import '../widgets/dashboard/dashboard_header.dart';
import '../widgets/dashboard/dashboard_sidebar.dart';
import '../widgets/dashboard/sign_out_dialog.dart';


class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);
  
  @override
  State createState() => _DashboardPageState();
}

class _DashboardPageState extends State {
  int _selectedIndex = 0;
  final String _currentDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
  
  final List _pages = [
    const DashboardContent(),
    const TablePage(),
  ];
  
  void _handleNavigation(int index) {
    if (index == 2) {
      _handleSignOut();
      return;
    }
    
    setState(() {
      _selectedIndex = index;
    });
  }
  
  void _handleSignOut() {
    showDialog(
      context: context,
      builder: (context) => SignOutDialog(
        onConfirm: () {
          Navigator.pop(context);
          Navigator.pushReplacementNamed(context, '/');
        },
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWideScreen = screenWidth > 1000;
    
    return Scaffold(
      appBar: isWideScreen 
          ? null 
          : AppBar(
              backgroundColor: AppColors.primaryColor,
              title: Text(
                'ระบบ NCDs',
                style: GoogleFonts.prompt(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              leading: Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
              ),
            ),
      drawer: isWideScreen 
          ? null 
          : DashboardDrawer(
              selectedIndex: _selectedIndex,
              onNavigation: _handleNavigation,
            ),
      body: isWideScreen
          ? Row(
              children: [
                DashboardSidebar(
                  selectedIndex: _selectedIndex,
                  onNavigation: _handleNavigation,
                ),
                Expanded(
                  child: _buildMainContent(),
                ),
              ],
            )
          : _buildMainContent(),
    );
  }
  
  Widget _buildMainContent() {
    return Column(
      children: [
        DashboardHeader(
          selectedIndex: _selectedIndex,
          currentDate: _currentDate,
        ),
        Expanded(
          child: Container(
            color: AppColors.backgroundColor,
            child: _pages[_selectedIndex],
          ),
        ),
      ],
    );
  }
}