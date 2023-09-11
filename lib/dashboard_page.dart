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
  double? phConfig;

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

    databaseRef
        .child('SENSOR_DATA')
        .child('waterLevel')
        .onValue
        .listen((event) {
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

    databaseRef
        .child('SENSOR_DATA')
        .child('waterTurbidity')
        .onValue
        .listen((event) {
      if (event.snapshot.value != null) {
        double waterTurbidityValue =
            double.parse(event.snapshot.value.toString());
        setState(() {
          waterTurbidity = waterTurbidityValue;
        });
      }
    });

    databaseRef
        .child('PARAMETERS_CONFIG')
        .child('ph_CONFIG')
        .onValue
        .listen((event) {
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
      backgroundColor: Color.fromARGB(232, 255, 255, 255),
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
                icon: const Icon(Icons.info_outline,
                    size: 30, color: Colors.blue),
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
            DrawerHeader(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/logo2.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                color: Colors.blue, // Background color
                child: SizedBox(), // Empty SizedBox to remove the text
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
            Image.asset('assets/images/DASHBOARD.png'),
            Divider(color: Colors.blue),
            SizedBox(height: 4),
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
              'SYSTEM STATUS',
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
                    icon: Icons.local_drink_sharp,
                    iconColor: Color.fromARGB(255, 33, 255, 63),
                    title: 'Filtration System',
                    value: '  ON',
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: BoxItem(
                    icon: Icons.bubble_chart_outlined,
                    iconColor: Color.fromRGBO(0, 153, 255, 1),
                    title: 'Aeration Rate',
                    value: '  ON',
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
                    icon: Icons.security,
                    iconColor: Colors.blue,
                    title: 'AquaGuard',
                    value: '  ACTIVE',
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: BoxItem(
                    icon: Icons.remove_red_eye_outlined,
                    iconColor: Color.fromRGBO(0, 128, 128, 1),
                    title: 'Aquasight',
                    value: '  ACTIVE',
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
    double? difference = phValue != null && phConfig != null
        ? (phValue! - phConfig!).abs()
        : null;

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

    TextStyle valueTextStyle = TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
    );

    // Check the title of the box and customize the text style accordingly
    if (title == 'Filtration System' ||
        title == 'Aeration Rate' ||
        title == 'AquaGuard' ||
        title == 'Aquasight') {
      valueTextStyle = TextStyle(
        color: Color.fromARGB(255, 4, 23, 39),
        fontSize: 20, // Change this to your desired text size
        fontWeight: FontWeight.bold,
      );
    }

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      color: backgroundColor,
      elevation: 10.0,
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
                    style: valueTextStyle, // Apply the text style here
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
