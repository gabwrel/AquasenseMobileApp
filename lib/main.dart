import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
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
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    DashboardPage(),
    MaintenancePage(),
    TestNowPage(),
    ConfigurationPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AquaSense',
      theme: ThemeData(
        primaryColor: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: Scaffold(
        body: _pages[_selectedIndex],
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
              selectedIndex: _selectedIndex,
              items: [
                BottomBarItem(iconData: Icons.home),
                BottomBarItem(iconData: Icons.settings),
                BottomBarItem(iconData: Icons.water_drop),
                BottomBarItem(iconData: Icons.bar_chart),
              ],
              onSelect: _onItemTapped,
              color: Colors.blue),
        ),
      ),
    );
  }
}
