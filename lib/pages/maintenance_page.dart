import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class MaintenancePage extends StatefulWidget {
  const MaintenancePage({Key? key}) : super(key: key);

  @override
  State<MaintenancePage> createState() => _MaintenancePageState();
}

class _MaintenancePageState extends State<MaintenancePage> {
  bool? continuousDrip;
  bool? filtrationSystem;
  bool? environmentControls;
  bool? masterSwitch;

  late DatabaseReference _databaseReference;

  @override
  void initState() {
    super.initState();
    _databaseReference = FirebaseDatabase.instance.ref().child('maintenance');

    fetchMaintenanceValues();
  }

  void fetchMaintenanceValues() {
    _databaseReference.child('continuousDrip').onValue.listen((event) {
      setState(() {
        continuousDrip = event.snapshot.value as bool?;
      });
    });

    _databaseReference.child('filtrationSystem').onValue.listen((event) {
      setState(() {
        filtrationSystem = event.snapshot.value as bool?;
      });
    });

    _databaseReference.child('environmentControls').onValue.listen((event) {
      setState(() {
        environmentControls = event.snapshot.value as bool?;
      });
    });

    _databaseReference.child('masterSwitch').onValue.listen((event) {
      setState(() {
        masterSwitch = event.snapshot.value as bool?;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 80,
          backgroundColor: Colors.white,
          // leading: IconButton(
          //   icon: Icon(Icons.arrow_back, color: Colors.blue),
          //   onPressed: () {
          //     Navigator.pop(context);
          //   },
          // ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(child: Container()),
              Image.asset(
                'assets/images/logo2.png',
                height: 60,
              ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 8.0),
          child: Center(
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final availableWidth = constraints.maxWidth;
                final availableHeight = constraints.maxHeight;

                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Image.asset('assets/images/logo2.png'), // Replace with the actual path of your logo
      
                      SizedBox(height: availableHeight * 0.05),
      
                      GestureDetector(
                        onTap: () {
                          // Handle the onTap event for the Water Change item
                          print('Water Change clicked');
                        },
                        child: Container(
                          width: availableWidth * 0.9,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              children: [
                                Icon(Icons.water_drop, size: availableHeight * 0.075, color: Colors.blue,),
                                SizedBox(width: availableWidth * 0.06),
                                Expanded(
                                  child: Text('Water Change', style: TextStyle(fontSize: availableHeight * 0.04, color: Colors.black)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
      
                      SizedBox(height: availableHeight * 0.05),
      
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () {
                              // Handle the onTap event for the 25% item
                              print('25% clicked');
                            },
                            child: buildConfigItem('25%', Colors.blue, availableWidth * 0.2, availableHeight * 0.15),
                          ),
                          GestureDetector(
                            onTap: () {
                              // Handle the onTap event for the 50% item
                              print('50% clicked');
                            },
                            child: buildConfigItem('50%', Colors.green, availableWidth * 0.2, availableHeight * 0.15),
                          ),
                          GestureDetector(
                            onTap: () {
                              // Handle the onTap event for the 75% item
                              print('75% clicked');
                            },
                            child: buildConfigItem('75%', Colors.orange, availableWidth * 0.2, availableHeight * 0.15),
                          ),
                          GestureDetector(
                            onTap: () {
                              // Handle the onTap event for the 100% item
                              print('100% clicked');
                            },
                            child: buildConfigItem('100%', Colors.red, availableWidth * 0.2, availableHeight * 0.15),
                          ),
                        ],
                      ),
      
                      SizedBox(height: availableHeight * 0.05),
      
                      buildSwitchItem(Icons.opacity, 'Continuous Drip', continuousDrip!, 'continuousDrip'),
                      buildSwitchItem(Icons.filter, 'Filtration System', filtrationSystem!, 'filtrationSystem'),
                      buildSwitchItem(Icons.settings, 'Environment Controls', environmentControls!, 'environmentControls'),
                      buildSwitchItem(Icons.power_settings_new, 'Master Switch', masterSwitch!, 'masterSwitch'),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget buildConfigItem(String value, Color color, double width, double height) {
    return Container(
      width: width,
      height: height * 0.6,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          value,
          style: TextStyle(fontSize: height * 0.25, fontWeight: FontWeight.bold, color: Colors.white),
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
