// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, avoid_print
import 'package:aquasenseapp/components/firebase_api.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:aquasenseapp/pages/login_page.dart';
import 'package:aquasenseapp/dashboard_page.dart';
import 'package:aquasenseapp/pages/maintenance_page.dart';
import 'package:aquasenseapp/pages/testnow_page.dart';
import 'package:aquasenseapp/pages/configuration_page.dart';
import 'package:bottom_bar_matu/bottom_bar_matu.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseApi firebaseApi = FirebaseApi();
  await firebaseApi.initNotifications();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: isUserLoggedIn(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          bool isLoggedIn = snapshot.data as bool;

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
            initialRoute: isLoggedIn ? '/dashboard' : '/login',
            routes: {
              '/login': (context) => LoginPage(
                    onLoginSuccess: () {
                      Navigator.pushReplacementNamed(context, '/dashboard');
                    },
                  ),
              '/dashboard': (context) => DashboardScreen(),
            },
          );
        } else {
          return const MaterialApp(
            home: Scaffold(body: Center(child: CircularProgressIndicator())),
          );
        }
      },
    );
  }

  Future<bool> isUserLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token') != null;
  }
}

class AuthChecker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: isUserLoggedIn(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          bool isLoggedIn = snapshot.data as bool;
          return isLoggedIn
              ? DashboardScreen()
              : LoginPage(
                  onLoginSuccess: () {},
                );
        } else {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        }
      },
    );
  }

  Future<bool> isUserLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token') != null;
  }
}

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            BottomBarItem(iconData: Icons.monitor_heart_rounded),
            BottomBarItem(iconData: Icons.water_drop),
            BottomBarItem(iconData: Icons.query_stats_rounded),
            BottomBarItem(iconData: Icons.tune_rounded),
          ],
          onSelect: _onItemTapped,
          color: Colors.blue,
        ),
      ),
    );
  }
}
