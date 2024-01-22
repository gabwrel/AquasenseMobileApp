// ignore_for_file: avoid_print

import 'package:aquasenseapp/main.dart';
import 'package:aquasenseapp/pages/about_page.dart';
import 'package:aquasenseapp/pages/filtration/continousDrip_page.dart';
import 'package:aquasenseapp/pages/filtration/environment_controls.dart';
import 'package:aquasenseapp/pages/filtration/filtrationSystem_page.dart';
import 'package:aquasenseapp/pages/filtration/masterSwitch_page.dart';
import 'package:aquasenseapp/pages/filtration/waterChange_page.dart';
import 'package:aquasenseapp/pages/previous_readings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MaintenancePage extends StatelessWidget {
  const MaintenancePage({super.key});

  Future<void> _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      // ignore: use_build_context_synchronously
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      print('Error logging out: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Container(
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 100,
              offset: const Offset(0, -2),
            )
          ]),
          child: AppBar(
            elevation: 0,
            toolbarHeight: 80,
            backgroundColor: Colors.white,
            leading: Builder(
              builder: (BuildContext context) {
                return Center(
                  child: IconButton(
                    icon: const Icon(Icons.menu, size: 30, color: Colors.blue),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  ),
                );
              },
            ),
            flexibleSpace: Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Image.asset(
                  'assets/images/logo2.png',
                  height: 80,
                ),
              ),
            ),
            actions: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: IconButton(
                    icon: const Icon(Icons.info_outline,
                        size: 30, color: Colors.blue),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AboutPage()),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      drawer: Drawer(
        child: Center(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const SizedBox(height: 32),
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text('Home'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DashboardScreen()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.info),
                title: const Text('About Page'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AboutPage()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.table_chart),
                title: const Text('Previous Readings'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PreviousReadings()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Logout'),
                onTap: () async => await _logout(context),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/AquassistMaintenance.png',
                  height: 120,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MaintenanceCard(
                      icon: Icons.water_drop,
                      title: 'Water\nChange',
                      iconColor: Colors.blue,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const WaterChangePage()),
                        );
                      },
                    ),
                    const SizedBox(width: 20),
                    MaintenanceCard(
                      icon: Icons.filter_alt_rounded,
                      title: 'Filtration\nSystem',
                      iconColor: Colors.green,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const FiltrationSystemPage()),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MaintenanceCard(
                      icon: Icons.water_drop_outlined,
                      title: 'Continuous\nDrip',
                      iconColor: Colors.grey,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ContinousDripPage()),
                        );
                      },
                    ),
                    const SizedBox(width: 20),
                    MaintenanceCard(
                      icon: Icons.power_settings_new,
                      title: 'Master\nSwitch',
                      iconColor: Colors.red,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MasterSwitchPage()),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MaintenanceCard(
                      icon: Icons.access_alarm,
                      title: 'Environmental\nControls',
                      iconColor: Colors.purple,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const EnvironmentControls()),
                        );
                      },
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MaintenanceCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color iconColor;
  final VoidCallback onTap;

  const MaintenanceCard({
    super.key,
    required this.icon,
    required this.title,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 150,
        height: 150,
        child: Card(
          elevation: 4.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 40,
                color: iconColor,
              ),
              const SizedBox(height: 5), // Adjust the spacing
              Center(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16, // Adjust the font size
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
