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
  String? drain_MODE;
  String? source_MODE;
  String? master_TRIGGER;

  late DatabaseReference _databaseReference;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _databaseReference = FirebaseDatabase.instance.ref();

    fetchMaintenanceValues();
  }

  void fetchMaintenanceValues() {
    _databaseReference
        .child('FILTRATION_SYSTEM')
        .child('drip_MODE')
        .onValue
        .listen((event) {
      setState(() {
        drip_MODE = event.snapshot.value.toString();
      });
    });

    _databaseReference
        .child('FILTRATION_SYSTEM')
        .child('filtrationsystem_MODE')
        .onValue
        .listen((event) {
      setState(() {
        filtrationsystem_MODE = event.snapshot.value.toString();
      });
    });

    _databaseReference
        .child('MAINTENANCE')
        .child('relayDrain_TRIGGER')
        .onValue
        .listen((event) {
      setState(() {
        drain_MODE = event.snapshot.value.toString();
      });
    });

    _databaseReference
        .child('MAINTENANCE')
        .child('relaySource_TRIGGER')
        .onValue
        .listen((event) {
      setState(() {
        source_MODE = event.snapshot.value.toString();
      });
    });

    _databaseReference
        .child('TRIGGERS')
        .child('master_TRIGGER')
        .onValue
        .listen((event) {
      setState(() {
        master_TRIGGER = event.snapshot.value.toString();
        isLoading = false; // Data fetching is complete
      });
    });
  }

  void handleWaterChange(String waterchangeLevel) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content:
              Text('Are you sure to initiate $waterchangeLevel% water change?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                _databaseReference
                    .child('MAINTENANCE')
                    .child('waterchange_LEVEL')
                    .set(waterchangeLevel);
                _databaseReference
                    .child('TRIGGERS')
                    .child('waterchange_TRIGGER')
                    .set('1');
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WaterChangePage()),
                );
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
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
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(), // Show a loading indicator
              )
            : Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 8.0),
                child: Center(
                  child: LayoutBuilder(
                    builder:
                        (BuildContext context, BoxConstraints constraints) {
                      final availableWidth = constraints.maxWidth;
                      final availableHeight = constraints.maxHeight;

                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 30,
                            ),
                            Image.asset(
                              'assets/images/logo.png',
                              height: 100,
                            ), // Replace with the actual path of your logo
                            Image.asset(
                              'assets/images/MAINTENANCE.png',
                              height: 80,
                            ), // Replace with the actual path of your logo

                            SizedBox(height: availableHeight * 0.05),

                            GestureDetector(
                              onTap: () {
                                // Handle the onTap event for the Water Change item
                                print('Water Change clicked');
                              },
                              child: Container(
                                width: availableWidth * 0.9,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Row(
                                    children: [
                                      Icon(Icons.water_drop,
                                          size: availableHeight * 0.075,
                                          color: Colors.blue),
                                      SizedBox(width: availableWidth * 0.06),
                                      Expanded(
                                        child: Text('Water Change',
                                            style: TextStyle(
                                                fontSize:
                                                    availableHeight * 0.04,
                                                color: Colors.black)),
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
                                    handleWaterChange('25');
                                  },
                                  child: buildConfigItem(
                                      '25%',
                                      Colors.blue,
                                      availableWidth * 0.2,
                                      availableHeight * 0.15),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    handleWaterChange('50');
                                  },
                                  child: buildConfigItem(
                                      '50%',
                                      Colors.green,
                                      availableWidth * 0.2,
                                      availableHeight * 0.15),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    handleWaterChange('75');
                                  },
                                  child: buildConfigItem(
                                      '75%',
                                      Colors.orange,
                                      availableWidth * 0.2,
                                      availableHeight * 0.15),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    handleWaterChange('100');
                                  },
                                  child: buildConfigItem(
                                      '100%',
                                      Colors.red,
                                      availableWidth * 0.2,
                                      availableHeight * 0.15),
                                ),
                              ],
                            ),

                            SizedBox(height: availableHeight * 0.05),
                            Divider(
                              color: Colors.blue,
                              thickness: 1,
                            ),
                            buildSwitchItem(Icons.opacity, 'Continuous Drip',
                                drip_MODE ?? "0", 'drip_MODE', Colors.blue),
                            Divider(
                              color: Colors.blue,
                              thickness: 1,
                            ),
                            buildSwitchItem(
                                Icons.filter,
                                'Filtration System',
                                filtrationsystem_MODE ?? "0",
                                'filtrationsystem_MODE',
                                Colors.green),
                            Divider(
                              color: Colors.blue,
                              thickness: 1,
                            ),
                            buildSwitchItem(Icons.adjust, 'Water Source',
                                source_MODE ?? "0", 'source_MODE', Colors.blue),
                            Divider(
                              color: Colors.blue,
                              thickness: 1,
                            ),
                            buildSwitchItem(
                                Icons.hourglass_bottom,
                                'Drain Valve',
                                drain_MODE ?? "0",
                                'drain_MODE',
                                Colors.blue),
                            Divider(
                              color: Colors.blue,
                              thickness: 1,
                            ),
                            buildSwitchItem(
                                Icons.power_settings_new,
                                'Master Switch',
                                master_TRIGGER ?? "0",
                                'master_TRIGGER',
                                Colors.red),
                            Divider(
                              color: Colors.blue,
                              thickness: 1,
                            ),
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

  Widget buildConfigItem(
      String value, Color color, double width, double height) {
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
          style: TextStyle(
              fontSize: height * 0.25,
              fontWeight: FontWeight.bold,
              color: Colors.white),
        ),
      ),
    );
  }

  Widget buildSwitchItem(IconData icon, String text, String value,
      String configKey, Color iconColor) {
    return ListTile(
      leading: Icon(
        icon,
        color: iconColor,
      ),
      title: Text(
        text,
        style: TextStyle(fontSize: 18),
      ),
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
              _databaseReference
                  .child('TRIGGERS')
                  .child(configKey)
                  .set(newValue ? "1" : "0");
            } else {
              _databaseReference
                  .child('FILTRATION_SYSTEM')
                  .child(configKey)
                  .set(newValue ? "1" : "0");
            }
          });
        },
      ),
    );
  }
}
