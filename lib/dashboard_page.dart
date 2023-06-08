import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:aquasenseapp/stored_data_page.dart' as stored;
import 'package:aquasenseapp/database_helper.dart' as aquasense_helper;
import 'package:intl/intl.dart';


class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String pH = '';
  String waterLevel = '';
  String waterTemp = '';
  String waterTurbidity = '';

  late DatabaseReference databaseRef;
  final aquasense_helper.DatabaseHelper _databaseHelper = aquasense_helper.DatabaseHelper();

  @override
  void initState() {
    super.initState();
    initializeFirebase();
    databaseRef = FirebaseDatabase.instance.reference();

    databaseRef.child('pH').onValue.listen((event) {
  if (event.snapshot.value != null) {
    double phValue = double.parse(event.snapshot.value.toString());
    setState(() {
      pH = phValue.toStringAsFixed(2);
    });
    String formattedDateTime = _getFormattedDateTime();
    _storeDataLocally('pH', pH, formattedDateTime);
  }
});

databaseRef.child('waterLevel').onValue.listen((event) {
  if (event.snapshot.value != null) {
    String waterLevelValue = event.snapshot.value.toString();
    setState(() {
      waterLevel = waterLevelValue;
    });
    String formattedDateTime = _getFormattedDateTime();
    _storeDataLocally('waterLevel', waterLevel, formattedDateTime);
  }
});

databaseRef.child('waterTemp').onValue.listen((event) {
  if (event.snapshot.value != null) {
    double waterTempValue = double.parse(event.snapshot.value.toString());
    setState(() {
      waterTemp = waterTempValue.toString();
    });
    String formattedDateTime = _getFormattedDateTime();
    _storeDataLocally('waterTemp', waterTemp, formattedDateTime);
  }
});

databaseRef.child('waterTurbidity').onValue.listen((event) {
  if (event.snapshot.value != null) {
    double waterTurbidityValue = double.parse(event.snapshot.value.toString());
    setState(() {
      waterTurbidity = waterTurbidityValue.toString();
    });
    String formattedDateTime = _getFormattedDateTime();
    _storeDataLocally('waterTurbidity', waterTurbidity, formattedDateTime);
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

  String _getFormattedDateTime() {
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
  }

  void _storeDataLocally(String parameter, String value, String dateTime) {
    Map<String, dynamic> row = {
      'parameter': parameter,
      'value': value,
      'dateTime': dateTime,
    };
    _databaseHelper.insert(row);
  }

  void _navigateToStoredDataPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => stored.StoredDataPage()),
    );
  }

  @override
  void dispose() {
    databaseRef.onValue.drain();
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
            padding: const EdgeInsets.only(top: 40),
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
                    title: 'pH Level',
                    value: '$pH',
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: BoxItem(
                    icon: Icons.waves_outlined,
                    title: 'Water Level',
                    value: '$waterLevel',
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
                    title: 'Temperature',
                    value: '$waterTemp',
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: BoxItem(
                    icon: Icons.blur_on,
                    title: 'Water Turbidity',
                    value: '$waterTurbidity',
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Divider(color: Colors.blue),
            Text(
              'ENVIRONMENT CONTROLS',
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
                    icon: Icons.lightbulb ,
                    iconColor: Colors.yellow,
                    title: 'Lighting',
                    value: '--',
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: BoxItem(
                    icon: Icons.restaurant,
                    title: 'Feeding',
                    value: '--',
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Divider(color: Colors.blue),
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
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToStoredDataPage,
        child: Icon(Icons.storage),
      ),
    );
  }
}

class BoxItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color? iconColor; 

  const BoxItem({
    Key? key,
    required this.icon,
    required this.title,
    required this.value,
    this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
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
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
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
