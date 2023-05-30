import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:aquasenseapp/dashboard_page.dart';

class ConfigurationPage extends StatefulWidget {
  const ConfigurationPage({Key? key}) : super(key: key);

  @override
  State<ConfigurationPage> createState() => _ConfigurationPageState();
}

class _ConfigurationPageState extends State<ConfigurationPage> {
  //chatGPT please retrieve the values continuousDrip, filtrationSystem, environmentControls, masterSwitch and display them in the dashboard.
  bool continuousDrip = false;
  bool filtrationSystem = false;
  bool environmentControls = false;
  bool masterSwitch = false;

  late DatabaseReference _databaseReference;

@override
void initState() {
  super.initState();
  _databaseReference = FirebaseDatabase.instance.ref().child('configurations');

  // Listen for changes in the Firebase Realtime Database
  _databaseReference.child('continuousDrip').onChildChanged.listen((event) {
    setState(() {
      continuousDrip = event.snapshot.value as bool? ?? false;
    });
  });
  _databaseReference.child('filtrationSystem').onChildChanged.listen((event) {
    setState(() {
      filtrationSystem = event.snapshot.value as bool? ?? false;
    });
  });
  _databaseReference.child('environmentControls').onChildChanged.listen((event) {
    setState(() {
      environmentControls = event.snapshot.value as bool? ?? false;
    });
  });
  _databaseReference.child('masterSwitch').onChildChanged.listen((event) {
    setState(() {
      masterSwitch = event.snapshot.value as bool? ?? false;
    });
  });
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.blue),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DashboardPage()),
            );
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(child: Container()), // Add an expanded container to push the image to the right
            Image.asset(
              'assets/images/logo2.png',
              height: 80, // Adjust the logo height as needed
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo2.png'), // Replace with the actual path of your logo

            SizedBox(height: 20),

            GestureDetector(
              onTap: () {
                // Handle the onTap event for the Water Change item
                print('Water Change clicked');
              },
              child: Container(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Icon(Icons.water_drop, size: 50),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text('Water Change', style: TextStyle(fontSize: 20)),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    // Handle the onTap event for the 25% item
                    print('25% clicked');
                  },
                  child: buildConfigItem('25%', Colors.blue),
                ),
                GestureDetector(
                  onTap: () {
                    // Handle the onTap event for the 50% item
                    print('50% clicked');
                  },
                  child: buildConfigItem('50%', Colors.orange),
                ),
                GestureDetector(
                  onTap: () {
                    // Handle the onTap event for the 75% item
                    print('75% clicked');
                  },
                  child: buildConfigItem('75%', Colors.green),
                ),
                GestureDetector(
                  onTap: () {
                    // Handle the onTap event for the 100% item
                    print('100% clicked');
                  },
                  child: buildConfigItem('100%', Colors.red),
                ),
              ],
            ),

            SizedBox(height: 20),

            buildSwitchItem(Icons.opacity, 'Continuous Drip', continuousDrip, 'continuousDrip'),
            buildSwitchItem(Icons.filter, 'Filtration System', filtrationSystem, 'filtrationSystem'),
            buildSwitchItem(Icons.settings, 'Environment Controls', environmentControls, 'environmentControls'),
            buildSwitchItem(Icons.power_settings_new, 'Master Switch', masterSwitch, 'masterSwitch'),
          ],
        ),
      ),
    );
  }

  Widget buildConfigItem(String value, Color color) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          value,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }

  Widget buildSwitchItem(IconData icon, String text, bool value, String configKey) {
    return ListTile(
      leading: Icon(icon),
      title: Text(text),
      trailing: Switch(
        value: value,
        onChanged: (newValue) {
          setState(() {
            // Update the boolean value in the local state
            switch (configKey) {
              case 'continuousDrip':
                continuousDrip = newValue;
                break;
              case 'filtrationSystem':
                filtrationSystem = newValue;
                break;
              case 'environmentControls':
                environmentControls = newValue;
                break;
              case 'masterSwitch':
                masterSwitch = newValue;
                break;
            }

            // Update the boolean value in the Firebase Realtime Database
            _databaseReference.child(configKey).set(newValue);
          });
        },
      ),
    );
  }
}
