// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:aquasenseapp/pages/login_page.dart';
import 'package:aquasenseapp/dashboard_page.dart';
import 'package:aquasenseapp/pages/maintenance_page.dart';
import 'package:aquasenseapp/pages/testnow_page.dart';
import 'package:aquasenseapp/pages/configuration_page.dart';
import 'package:bottom_bar_matu/bottom_bar_matu.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  final int selectedIndex;

  const MyApp({super.key, this.selectedIndex = 0});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0;
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  final List<Widget> _pages = [
    const DashboardPage(),
    const MaintenancePage(),
    const TestNowPage(),
    const ConfigurationPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onLoginSuccess() {
    // Navigate to DashboardPage after successful login
    navigatorKey.currentState?.pushReplacementNamed('/dashboard');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AquaSense',
      theme: ThemeData(
        primaryColor: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontFamily: 'Satoshi'),
          // Add more text styles as needed
        ),
      ),
      navigatorKey: navigatorKey,
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginPage(
              onLoginSuccess: _onLoginSuccess,
            ),
        '/dashboard': (context) =>
            DashboardScreen(_pages, _selectedIndex, _onItemTapped),
      },
    );
  }
}

class DashboardScreen extends StatelessWidget {
  final List<Widget> pages;
  final int selectedIndex;
  final void Function(int) onItemTapped;

  const DashboardScreen(this.pages, this.selectedIndex, this.onItemTapped,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 100,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomBarBubble(
          selectedIndex: selectedIndex,
          items: [
            BottomBarItem(iconData: Icons.monitor_heart_rounded),
            BottomBarItem(iconData: Icons.water_drop),
            BottomBarItem(iconData: Icons.query_stats_rounded),
            BottomBarItem(iconData: Icons.tune_rounded),
          ],
          onSelect: onItemTapped,
          color: Colors.blue,
        ),
      ),
    );
  }
}
