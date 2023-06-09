import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:aquasenseapp/main.dart';
import 'package:aquasenseapp/pages/waterchange_page.dart';

class MaintenancePage extends StatefulWidget {
  const MaintenancePage({Key? key}) : super(key: key);

  @override
  State<MaintenancePage> createState() => _MaintenancePageState();
}

class _MaintenancePageState extends State<MaintenancePage> {
  String? drip_MODE;
  String? filtrationsystem_MODE;
  String? master_TRIGGER;

  late DatabaseReference _databaseReference;

  @override
  void initState() {
    super.initState();
    _databaseReference = FirebaseDatabase.instance.ref();

    fetchMaintenanceValues();
  }

  void fetchMaintenanceValues() {
    _databaseReference.child('FILTRATION_SYSTEM').child('drip_MODE').onValue.listen((event) {
      setState(() {
        drip_MODE = event.snapshot.value.toString();
      });
    });

    _databaseReference.child('FILTRATION_SYSTEM').child('filtrationsystem_MODE').onValue.listen((event) {
      setState(() {
        filtrationsystem_MODE = event.snapshot.value.toString();
      });
    });

    _databaseReference.child('TRIGGERS').child('master_TRIGGER').onValue.listen((event) {
      setState(() {
        master_TRIGGER = event.snapshot.value.toString();
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
            leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.blue),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MyApp()),
            );
          },
        ),
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
                              _databaseReference
                              .child('MAINTENANCE')
                              .child('waterchange_LEVEL')
                              .set(25);
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => WaterChangePage()),
                              );
                            },
                            child: buildConfigItem('25%', Colors.blue, availableWidth * 0.2, availableHeight * 0.15),
                          ),
                          GestureDetector(
                            onTap: () {
                                _databaseReference
                                .child('MAINTENANCE')
                                .child('waterchange_LEVEL')
                                .set(50);
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => WaterChangePage()),
                              );
                            },
                            child: buildConfigItem('50%', Colors.green, availableWidth * 0.2, availableHeight * 0.15),
                          ),
                          GestureDetector(
                            onTap: () {
                              _databaseReference
                              .child('MAINTENANCE')
                              .child('waterchange_LEVEL')
                              .set(75);
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => WaterChangePage()),
                              );
                            },
                            child: buildConfigItem('75%', Colors.orange, availableWidth * 0.2, availableHeight * 0.15),
                          ),
                          GestureDetector(
                            onTap: () {
                              _databaseReference
                              .child('MAINTENANCE')
                              .child('waterchange_LEVEL')
                              .set(100);
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => WaterChangePage()),
                              );
                            },
                            child: buildConfigItem('100%', Colors.red, availableWidth * 0.2, availableHeight * 0.15),
                          ),
                        ],
                      ),
      
                      SizedBox(height: availableHeight * 0.05),
      
                      buildSwitchItem(Icons.opacity, 'Continuous Drip', drip_MODE ?? "0", 'drip_MODE'),
                      buildSwitchItem(Icons.filter, 'Filtration System', filtrationsystem_MODE ?? "0", 'filtrationsystem_MODE'),
                      buildSwitchItem(Icons.power_settings_new, 'Master Switch', master_TRIGGER ?? "0", 'master_TRIGGER'),
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

  Widget buildSwitchItem(IconData icon, String text, String value, String configKey) {
    return ListTile(
      leading: Icon(icon),
      title: Text(text),
      trailing: Switch(
        value: value == "1",
        onChanged: (newValue) {
          setState(() {
            // Update the string value in the local state
            switch (configKey) {
              case 'drip_MODE':
                drip_MODE = newValue ? "1" : "0";
                break;
              case 'filtrationsystem_MODE':
                filtrationsystem_MODE = newValue ? "1" : "0";
                break;
              case 'master_TRIGGER':
                master_TRIGGER = newValue ? "1" : "0";
                break;
            }

            // Update the string value in the Firebase Realtime Database
            if (configKey == 'master_TRIGGER') {
              _databaseReference.child('TRIGGERS').child(configKey).set(newValue ? "1" : "0");
            } else {
              _databaseReference.child('FILTRATION_SYSTEM').child(configKey).set(newValue ? "1" : "0");
            }
          });
        },
      ),
    );
  }
}
