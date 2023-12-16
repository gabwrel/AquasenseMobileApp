// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously, avoid_print

import 'package:aquasenseapp/pages/about_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:aquasenseapp/pages/previous_readings.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

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
  String? lightingStatus;
  String? heaterStatus;
  String? uvStatus;
  String? filtrationStatus;
  String? aerationStatus;
  String? dripStatus;
  String? pumpStatus;

  late DatabaseReference databaseRef;

  @override
  void initState() {
    super.initState();
    initializeFirebase();
    databaseRef = FirebaseDatabase.instance.ref();

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

    fetchMaintenanceValues();
  }

  void fetchMaintenanceValues() {
    databaseRef
        .child('FILTRATION_SYSTEM')
        .child('lighting_TRIGGER')
        .onValue
        .listen((event) {
      setState(() {
        lightingStatus = event.snapshot.value?.toString() ?? '--';
      });
    });

    databaseRef
        .child('FILTRATION_SYSTEM')
        .child('heater_TRIGGER')
        .onValue
        .listen((event) {
      setState(() {
        heaterStatus = event.snapshot.value?.toString() ?? '--';
      });
    });

    databaseRef
        .child('FILTRATION_SYSTEM')
        .child('uvLamp_TRIGGER')
        .onValue
        .listen((event) {
      setState(() {
        uvStatus = event.snapshot.value?.toString() ?? '--';
      });
    });

    databaseRef
        .child('FILTRATION_SYSTEM')
        .child('filtrationsystem_MODE')
        .onValue
        .listen((event) {
      setState(() {
        filtrationStatus = event.snapshot.value?.toString() ?? '--';
      });
    });

    databaseRef
        .child('FILTRATION_SYSTEM')
        .child('aeration_TRIGGER')
        .onValue
        .listen((event) {
      setState(() {
        aerationStatus = event.snapshot.value?.toString() ?? '--';
      });
    });

    databaseRef
        .child('FILTRATION_SYSTEM')
        .child('drip_MODE')
        .onValue
        .listen((event) {
      setState(() {
        dripStatus = event.snapshot.value?.toString() ?? '--';
      });
    });

    databaseRef
        .child('FILTRATION_SYSTEM')
        .child('pump_TRIGGER')
        .onValue
        .listen((event) {
      setState(() {
        pumpStatus = event.snapshot.value?.toString() ?? '--';
      });
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
                  Expanded(
                    child: BoxItem(
                      icon: Icons.waves_outlined,
                      iconColor: const Color.fromRGBO(22, 52, 224, 1),
                      title: 'Water Level',
                      value: waterLevel?.toStringAsFixed(1) ?? '--',
                      waterLevelBorderColor: getWaterLevelBorderColor(),
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
                      value: '${waterTemp?.toStringAsFixed(1) ?? '--'} °C',
                      waterTempBorderColor: getTemperatureBorderColor(),
                    ),
                  ),
                  Expanded(
                    child: BoxItem(
                      icon: Icons.blur_on,
                      iconColor: const Color.fromRGBO(87, 55, 19, 1),
                      title: 'Water Turbidity',
                      value:
                          '${waterTurbidity?.toStringAsFixed(1) ?? '--'} NTU',
                      turbidityBorderColor: getTurbidityBorderColor(),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: BoxItem(
                      icon: Icons.lightbulb,
                      iconColor: const Color.fromRGBO(245, 222, 16, 1),
                      title: 'Lighting',
                      value: lightingStatus == "1" ? "Active" : "Inactive",
                    ),
                  ),
                  const Expanded(
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: BoxItem(
                      icon: Icons.thermostat_outlined,
                      iconColor: getHeaterIconColor(),
                      title: 'Heater',
                      value: heaterStatus == "1" ? "Active" : "Inactive",
                    ),
                  ),
                  Expanded(
                    child: BoxItem(
                      icon: Icons.lightbulb,
                      iconColor: Colors.purple,
                      title: 'UV Lamp',
                      value: uvStatus == "1" ? "Active" : "Inactive",
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
                      icon: Icons.autorenew,
                      iconColor: getFiltrationModeIconColor(),
                      title: 'Filtration Mode',
                      value: filtrationStatus == "1" ? "Active" : "Inactive",
                    ),
                  ),
                  Expanded(
                    child: BoxItem(
                      icon: Icons.air_rounded,
                      iconColor: getAerationIconColor(),
                      title: 'Aeration',
                      value: aerationStatus == "1" ? "Active" : "Inactive",
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
                      icon: Icons.format_list_numbered,
                      iconColor: getContinuousDripIconColor(),
                      title: 'Continuous Drip',
                      value: dripStatus == "1" ? "Active" : "Inactive",
                    ),
                  ),
                  Expanded(
                    child: BoxItem(
                      icon: Icons.autorenew,
                      iconColor: getRecirculatingPumpIconColor(),
                      title: 'Pump',
                      value: pumpStatus == "1" ? "Active" : "Inactive",
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to get water level border color
  Color? getWaterLevelBorderColor() {
    if (waterLevel != null) {
      if (waterLevel! >= 51) {
        return Colors.green; // 51 and above
      } else if (waterLevel! >= 26 && waterLevel! <= 50) {
        return Colors.orange; // 26 to 50
      } else if (waterLevel! <= 25) {
        return Colors.red; // 25 and below
      }
    }
    return null;
  }

  // Helper method to get temperature border color
  Color? getTemperatureBorderColor() {
    double? temperatureDifference = waterTemp != null && tempConfig != null
        ? (waterTemp! - tempConfig!).abs() + 1
        : null;
    if (temperatureDifference != null) {
      if (temperatureDifference <= 2.01) {
        return Colors.green; // Within +- 1
      } else if (temperatureDifference > 2.01 && temperatureDifference < 2.99) {
        return Colors.orange; // Within +- 1.5
      } else if (temperatureDifference >= 3) {
        return Colors.red; // 2 or more
      }
    }
    return null;
  }

  // Helper method to get turbidity border color
  Color? getTurbidityBorderColor() {
    double? turbidityDifference =
        waterTurbidity != null && turbidityConfig != null
            ? (waterTurbidity! - turbidityConfig!).abs()
            : null;
    if (turbidityDifference != null) {
      if (turbidityDifference <= 1.01) {
        return Colors.green; // Within +- 1
      } else if (turbidityDifference > 1.01 && turbidityDifference < 1.99) {
        return Colors.orange; // Within +- 1.5
      } else if (turbidityDifference >= 2) {
        return Colors.red; // 2 or more
      }
    }
    return null;
  }

  // Helper method to get heater icon color
  Color? getHeaterIconColor() {
    // Implement your logic based on heater status
    return Colors.red; // Placeholder color, change as needed
  }

  // Helper method to get filtration mode icon color
  Color? getFiltrationModeIconColor() {
    // Implement your logic based on filtration mode status
    return Colors.green; // Placeholder color, change as needed
  }

  // Helper method to get aeration icon color
  Color? getAerationIconColor() {
    // Implement your logic based on aeration status
    return Colors.blue; // Placeholder color, change as needed
  }

  // Helper method to get continuous drip icon color
  Color? getContinuousDripIconColor() {
    // Implement your logic based on continuous drip status
    return Colors.blue; // Placeholder color, change as needed
  }

  // Helper method to get recirculating pump icon color
  Color? getRecirculatingPumpIconColor() {
    // Implement your logic based on recirculating pump status
    return Colors.blue; // Placeholder color, change as needed
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
  final Color? waterLevelBorderColor;
  final Color? waterTempBorderColor;
  final Color? turbidityBorderColor;

  const BoxItem({
    super.key,
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
    this.waterLevelBorderColor,
    this.waterTempBorderColor,
    this.turbidityBorderColor,
  });

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

    return FractionallySizedBox(
      widthFactor: .87, // Adjust the width factor as needed
      child: Material(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: BorderSide(
            color: title == 'pH Level'
                ? pHBorderColor ?? Colors.transparent
                : title == 'Water Level'
                    ? waterLevelBorderColor ?? Colors.transparent
                    : title == 'Temperature'
                        ? waterTempBorderColor ?? Colors.transparent
                        : title == 'Water Turbidity'
                            ? turbidityBorderColor ?? Colors.transparent
                            : Colors.transparent,
            width: 2.0,
          ),
        ),
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon, size: 28, color: iconColor),
              const SizedBox(width: 4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      value,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
