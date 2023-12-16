// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously, avoid_print

import 'package:aquasenseapp/pages/about_page.dart';
import 'package:aquasenseapp/pages/previous_readings.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  double? pH;
  double? waterLevel;
  double? waterTemp;
  double? waterTurbidity;
  double? phConfig;
  double? tempConfig;
  double? turbidityConfig;

  late DatabaseReference databaseRef;

  @override
  void initState() {
    super.initState();
    initializeFirebase();
    databaseRef = FirebaseDatabase.instance.reference();

    initializeSensorDataListener('ph', (value) {
      setState(() => pH = value);
    });

    initializeSensorDataListener('waterLevel', (value) {
      setState(() => waterLevel = value);
    });

    initializeSensorDataListener('waterTemp', (value) {
      setState(() => waterTemp = value);
    });

    initializeSensorDataListener('waterTurbidity', (value) {
      setState(() => waterTurbidity = value);
    });

    initializeConfigListener('ph_CONFIG', (value) {
      setState(() => phConfig = value);
    });

    initializeConfigListener('temp_CONFIG', (value) {
      setState(() => tempConfig = value);
    });

    initializeConfigListener('turbidity_CONFIG', (value) {
      setState(() => turbidityConfig = value);
    });
  }

  Future<void> initializeFirebase() async {
    try {
      await Firebase.initializeApp();
    } catch (error) {
      print('Error initializing Firebase: $error');
    }
  }

  void initializeSensorDataListener(
      String child, void Function(double) callback) {
    databaseRef.child('SENSOR_DATA').child(child).onValue.listen((event) {
      if (event.snapshot.value != null) {
        double sensorValue = double.parse(event.snapshot.value.toString());
        callback(sensorValue);
      }
    });
  }

  void initializeConfigListener(String child, void Function(double) callback) {
    databaseRef.child('PARAMETERS_CONFIG').child(child).onValue.listen((event) {
      if (event.snapshot.value != null) {
        double configValue = double.parse(event.snapshot.value.toString());
        callback(configValue);
      }
    });
  }

  Future<void> _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      print('Error logging out: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(232, 255, 255, 255),
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
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/logo2.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                color: Colors.blue, // Background color
                child: const SizedBox(), // Empty SizedBox to remove the text
              ),
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
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/images/DASHBOARD.png'),
              const Divider(color: Colors.blue),
              const SizedBox(height: 4),
              const Text(
                'WATER PARAMETERS',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: BoxItem(
                      icon: Icons.opacity,
                      iconColor: const Color.fromRGBO(139, 211, 235, 1),
                      title: 'pH Level',
                      value: pH?.toStringAsFixed(1) ?? '--',
                      phValue: pH,
                      phConfig: phConfig,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: BoxItem(
                      icon: Icons.waves_outlined,
                      iconColor: const Color.fromRGBO(22, 52, 224, 1),
                      title: 'Water Level',
                      value: waterLevel?.toStringAsFixed(1) ?? '--',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: BoxItem(
                      icon: Icons.thermostat_outlined,
                      iconColor: const Color.fromRGBO(218, 0, 0, 1),
                      title: 'Temperature',
                      value: waterTemp?.toStringAsFixed(1) ?? '--',
                      waterTemp: waterTemp,
                      tempConfig: tempConfig,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: BoxItem(
                      icon: Icons.blur_on,
                      iconColor: const Color.fromRGBO(87, 55, 19, 1),
                      title: 'Water Turbidity',
                      value: waterTurbidity?.toStringAsFixed(1) ?? '--',
                      waterTurbidity: waterTurbidity,
                      turbidityConfig: turbidityConfig,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(color: Colors.blue, height: 20),
              const Text(
                'ENVIRONMENT CONTROLS',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: BoxItem(
                      icon: Icons.lightbulb,
                      iconColor: Color.fromRGBO(245, 222, 16, 1),
                      title: 'Lighting',
                      value: '--',
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: BoxItem(
                      icon: Icons.restaurant,
                      iconColor: Colors.green,
                      title: 'Feeding',
                      value: '--',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Divider(color: Colors.blue, height: 20),
              const Text(
                'FILTRATION SYSTEM',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: BoxItem(
                      icon: Icons.whatshot,
                      iconColor: Colors.red,
                      title: 'Heater',
                      value: '--',
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: BoxItem(
                      icon: Icons.lightbulb,
                      iconColor: Colors.purple,
                      title: 'UV Lamp',
                      value: '--',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class BoxItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color? iconColor;
  final double? phValue;
  final double? phConfig;
  final double? waterLevel;
  final double? waterTemp;
  final double? tempConfig;
  final double? waterTurbidity;
  final double? turbidityConfig;

  const BoxItem({
    Key? key,
    required this.icon,
    required this.title,
    required this.value,
    this.iconColor,
    this.phValue,
    this.phConfig,
    this.waterLevel,
    this.waterTemp,
    this.tempConfig,
    this.waterTurbidity,
    this.turbidityConfig,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double? pHdifference = phValue != null && phConfig != null
        ? (phValue! - phConfig!).abs()
        : null;

    // Set the border color based on the pH difference
    Color? pHBorderColor;
    if (pHdifference != null) {
      if (pHdifference <= 1.01) {
        pHBorderColor = Colors.green; // Within +- 1
      } else if (pHdifference > 1.01 && pHdifference < 1.99) {
        pHBorderColor = Colors.orange; // Within +- 1.5
      } else if (pHdifference >= 2) {
        pHBorderColor = Colors.red; // 2 or more
      }
    }

    // Set the border color based on the water level
    Color? waterLevelBorderColor;
    if (waterLevel != null) {
      if (waterLevel! >= 51) {
        waterLevelBorderColor = Colors.green; // 51 and above
      } else if (waterLevel! >= 26 && waterLevel! <= 50) {
        waterLevelBorderColor = Colors.orange; // 26 to 50
      } else if (waterLevel! <= 25) {
        waterLevelBorderColor = Colors.red; // 25 and below
      }
    }

    // Set the border color based on the temperature difference
    Color? temperatureBorderColor;
    double? temperatureDifference = waterTemp != null && tempConfig != null
        ? (waterTemp! - tempConfig!).abs() + 1 // Adding + 1 here
        : null;
    if (temperatureDifference != null) {
      if (temperatureDifference <= 2.01) {
        // Adjusted the values accordingly
        temperatureBorderColor = Colors.green; // Within +- 1
      } else if (temperatureDifference > 2.01 && temperatureDifference < 2.99) {
        temperatureBorderColor = Colors.orange; // Within +- 1.5
      } else if (temperatureDifference >= 3) {
        temperatureBorderColor = Colors.red; // 2 or more
      }
    }
    // Set the border color based on the turbidity difference
    Color? turbidityBorderColor;
    double? turbidityDifference =
        waterTurbidity != null && turbidityConfig != null
            ? (waterTurbidity! - turbidityConfig!).abs()
            : null;
    if (turbidityDifference != null) {
      if (turbidityDifference <= 1.01) {
        turbidityBorderColor = Colors.green; // Within +- 1
      } else if (turbidityDifference > 1.01 && turbidityDifference < 1.99) {
        turbidityBorderColor = Colors.orange; // Within +- 1.5
      } else if (turbidityDifference >= 2) {
        turbidityBorderColor = Colors.red; // 2 or more
      }
    }

    return Material(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: BorderSide(
          color: title == 'pH Level'
              ? pHBorderColor ?? Colors.transparent
              : title == 'Water Level'
                  ? waterLevelBorderColor ?? Colors.transparent
                  : title == 'Temperature'
                      ? temperatureBorderColor ?? Colors.transparent
                      : title == 'Water Turbidity'
                          ? turbidityBorderColor ?? Colors.transparent
                          : Colors.transparent,
          width: 2.0,
        ),
      ),
      elevation: 3.0,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, size: 36, color: iconColor),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
