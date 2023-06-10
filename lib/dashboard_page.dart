import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';

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
  double? phConfig; // Added phConfig variable

  late DatabaseReference databaseRef;

  @override
  void initState() {
    super.initState();
    initializeFirebase();
    databaseRef = FirebaseDatabase.instance.ref();

    databaseRef.child('SENSOR_DATA').child('ph').onValue.listen((event) {
      if (event.snapshot.value != null) {
        double phValue = double.parse(event.snapshot.value.toString());
        setState(() {
          pH = phValue;
        });
      }
    });

    databaseRef.child('SENSOR_DATA').child('waterLevel').onValue.listen((event) {
      if (event.snapshot.value != null) {
        double waterLevelValue = double.parse(event.snapshot.value.toString());
        setState(() {
          waterLevel = waterLevelValue;
        });
      }
    });

    databaseRef.child('SENSOR_DATA').child('waterTemp').onValue.listen((event) {
      if (event.snapshot.value != null) {
        double waterTempValue = double.parse(event.snapshot.value.toString());
        setState(() {
          waterTemp = waterTempValue;
        });
      }
    });

    databaseRef.child('SENSOR_DATA').child('waterTurbidity').onValue.listen((event) {
      if (event.snapshot.value != null) {
        double waterTurbidityValue = double.parse(event.snapshot.value.toString());
        setState(() {
          waterTurbidity = waterTurbidityValue;
        });
      }
    });

    databaseRef.child('PARAMETERS_CONFIG').child('ph_CONFIG').onValue.listen((event) {
      if (event.snapshot.value != null) {
        double phConfigValue = double.parse(event.snapshot.value.toString());
        setState(() {
          phConfig = phConfigValue;
        });
      }
    });
  }

  Future<void> initializeFirebase() async {
    try {
      await Firebase.initializeApp();
    } catch (error) {
      print('Error initializing Firebase: $error');
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
            padding: const EdgeInsets.only(top: 45),
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
                icon: const Icon(Icons.refresh, size: 30, color: Colors.blue),
                onPressed: () {
                  // TODO: Implement refresh functionality
                },
              ),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Aquasense',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                // TODO: Implement Home navigation
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('User'),
              onTap: () {
                // TODO: Implement User navigation
              },
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('About Page'),
              onTap: () {
                // TODO: Implement About Page navigation
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                // TODO: Implement Logout functionality
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'DASHBOARD',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            Divider(color: Colors.blue),
            SizedBox(height: 8),
            Text(
              'WATER PARAMETERS',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: BoxItem(
                    icon: Icons.opacity,
                    iconColor: Color.fromRGBO(139, 211, 235, 1),
                    title: 'pH Level',
                    value: pH?.toStringAsFixed(1) ?? '--',
                    phValue: pH,
                    phConfig: phConfig,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: BoxItem(
                    icon: Icons.waves_outlined,
                    iconColor: Color.fromRGBO(22, 52, 224, 1),
                    title: 'Water Level',
                    value: waterLevel?.toStringAsFixed(1) ?? '--',
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: BoxItem(
                    icon: Icons.thermostat_outlined,
                    iconColor: Color.fromRGBO(218, 0, 0, 1),
                    title: 'Temperature',
                    value: waterTemp?.toStringAsFixed(1) ?? '--',
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: BoxItem(
                    icon: Icons.blur_on,
                    iconColor: Color.fromRGBO(87, 55, 19, 1),
                    title: 'Water Turbidity',
                    value: waterTurbidity?.toStringAsFixed(1) ?? '--',
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Divider(color: Colors.blue, height: 20),
            Text(
              'ENVIRONMENT CONTROLS',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 16),
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
            Divider(color: Colors.blue, height: 20),
            Text(
              'FILTRATION SYSTEM',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 16),
            Row(
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
            SizedBox(height: 16),
          ],
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

  const BoxItem({
    Key? key,
    required this.icon,
    required this.title,
    required this.value,
    this.iconColor,
    this.phValue,
    this.phConfig,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Calculate the pH difference
    double? difference = phValue != null && phConfig != null ? (phValue! - phConfig!).abs() : null;

    // Set the background color based on the pH difference
    Color? backgroundColor;
    if (difference != null) {
      if (difference <= 1.01) {
        backgroundColor = Colors.green; // Within +- 1
      } else if (difference > 1.01 && difference < 1.99) {
        backgroundColor = Colors.orange; // Within +- 1.5
      } else if (difference >= 2) {
        backgroundColor = Colors.red; // 2 or more
      }
    }

    return Card(
      color: backgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(8),
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
                      fontSize: 16 ,
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
