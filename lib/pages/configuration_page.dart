import 'package:flutter/material.dart';
import 'package:aquasenseapp/dashboard_page.dart';

class ConfigurationPage extends StatefulWidget {
  const ConfigurationPage({Key? key}) : super(key: key);

  @override
  State<ConfigurationPage> createState() => _ConfigurationPageState();
}

class _ConfigurationPageState extends State<ConfigurationPage> {
  bool continuousDrip = false;
  bool filtrationSystem = false;
  bool environmentControls = false;
  bool masterSwitch = false;

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

            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.water_drop, size: 50),
                      SizedBox(width: 10),
                      Text('Water Change', style: TextStyle(fontSize: 20)),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildConfigItem('25%', Colors.blue),
                      buildConfigItem('50%', Colors.orange),
                      buildConfigItem('75%', Colors.green),
                      buildConfigItem('100%', Colors.red),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            buildSwitchItem(Icons.opacity, 'Continuous Drip', continuousDrip),
            buildSwitchItem(Icons.filter, 'Filtration System', filtrationSystem),
            buildSwitchItem(Icons.settings, 'Environment Controls', environmentControls),
            buildSwitchItem(Icons.power_settings_new, 'Master Switch', masterSwitch),
          ],
        ),
      ),
    );
  }

  Widget buildConfigItem(String value, Color color) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          value,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }

  Widget buildSwitchItem(IconData icon, String text, bool value) {
    return ListTile(
      leading: Icon(icon),
      title: Text(text),
      trailing: Switch(
        value: value,
        onChanged: (newValue) {
          setState(() {
            switch (text) {
              case 'Continuous Drip':
                continuousDrip = newValue;
                break;
              case 'Filtration System':
                filtrationSystem = newValue;
                break;
              case 'Environment Controls':
                environmentControls = newValue;
                break;
              case 'Master Switch':
                masterSwitch = newValue;
                break;
            }
          });
        },
      ),
    );
  }
}
