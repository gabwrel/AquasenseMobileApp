import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:aquasenseapp/dashboard_page.dart';
import 'package:aquasenseapp/pages/maintenance_page.dart';
import 'package:aquasenseapp/pages/testnow_page.dart';
import 'package:aquasenseapp/pages/configuration_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
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
      title: 'Flutter Firebase Demo',
      theme: ThemeData(
        primaryColor: Colors.white,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: Scaffold(
        body: _pages[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home, color: Colors.blue,),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings, color: Colors.blue,),
              label: 'Maintenance',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.check_circle_outline, color: Colors.blue,),
              label: 'Test Now',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart, color: Colors.blue,),
              label: 'Configuration',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.blue,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
