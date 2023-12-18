// ignore_for_file: library_private_types_in_public_api, file_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class FiltrationSystemPage extends StatefulWidget {
  const FiltrationSystemPage({Key? key});

  @override
  _FiltrationSystemPageState createState() => _FiltrationSystemPageState();
}

class _FiltrationSystemPageState extends State<FiltrationSystemPage> {
  late DatabaseReference _databaseReference;
  late String filtrationAutoMode = '';
  late String uvStatus = '';
  late String lightingStatus = '';
  late String heaterStatus = '';
  late String watersourceStatus = '';
  late String pumpStatus = '';
  late String drainStatus = '';

  @override
  void initState() {
    super.initState();
    _databaseReference = FirebaseDatabase.instance.ref();

    _databaseReference
        .child('FILTRATION_SYSTEM')
        .child('filtration_AUTO')
        .onValue
        .listen((event) {
      setState(() {
        filtrationAutoMode = event.snapshot.value?.toString() ?? '--';
      });
    });

    // Retrieve UV Lamp status from Firebase
    _databaseReference
        .child('FILTRATION_SYSTEM')
        .child('uvLamp_TRIGGER')
        .onValue
        .listen((event) {
      setState(() {
        uvStatus = event.snapshot.value?.toString() ?? '--';
      });
    });

    // Retrieve Filtration System status from Firebase

    _databaseReference
        .child('FILTRATION_SYSTEM')
        .child('lighting_TRIGGER')
        .onValue
        .listen((event) {
      setState(() {
        lightingStatus = event.snapshot.value?.toString() ?? '--';
      });
    });

    _databaseReference
        .child('FILTRATION_SYSTEM')
        .child('heater_TRIGGER')
        .onValue
        .listen((event) {
      setState(() {
        heaterStatus = event.snapshot.value?.toString() ?? '--';
      });
    });

    _databaseReference
        .child('FILTRATION_SYSTEM')
        .child('watersource_TRIGGER')
        .onValue
        .listen((event) {
      setState(() {
        watersourceStatus = event.snapshot.value?.toString() ?? '--';
      });
    });

    _databaseReference
        .child('FILTRATION_SYSTEM')
        .child('pump_TRIGGER')
        .onValue
        .listen((event) {
      setState(() {
        pumpStatus = event.snapshot.value?.toString() ?? '--';
      });
    });

    _databaseReference
        .child('FILTRATION_SYSTEM')
        .child('drain_MODE')
        .onValue
        .listen((event) {
      setState(() {
        drainStatus = event.snapshot.value?.toString() ?? '--';
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
          icon: const Icon(Icons.arrow_back, color: Colors.blue),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/dashboard');
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
      body: Center(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final availableHeight = constraints.maxHeight;

            return SingleChildScrollView(
              child: Column(
                children: [
                  Image.asset('assets/images/filtration.png',
                      height: availableHeight * 0.4),
                  SizedBox(height: availableHeight * 0.05),
                  buildCardRow(
                    'Auto Filtration System',
                    'filtration_AUTO',
                    filtrationAutoMode,
                    Icons.waves_rounded,
                    Colors.green,
                  ),

                  buildCardRow(
                    'UV Lamp',
                    'uvLamp_TRIGGER',
                    uvStatus,
                    Icons.wb_sunny_rounded,
                    Colors.purple,
                  ),

                  buildCardRow(
                    'Lighting',
                    'lighting_TRIGGER',
                    lightingStatus,
                    Icons.tungsten_rounded,
                    Colors.yellow,
                  ),
                  buildCardRow(
                    'Heater',
                    'heater_TRIGGER',
                    heaterStatus,
                    Icons.thermostat_outlined,
                    Colors.red,
                  ),
                  buildCardRow(
                    'Filtration Pump',
                    'pump_TRIGGER',
                    pumpStatus,
                    Icons.sync_rounded,
                    Colors.green,
                  ),
                  buildCardRow(
                    'Water Source',
                    'watersource_TRIGGER',
                    watersourceStatus,
                    Icons.water_drop_rounded,
                    Colors.red,
                  ),
                  buildCardRow(
                    'Drain Valve',
                    'drain_MODE',
                    drainStatus,
                    Icons.stop_circle_rounded,
                    Colors.red,
                  ),
                  // Add more widgets here as needed
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildCardRow(
    String title,
    String databaseKey,
    String status,
    IconData icon,
    Color iconColor, // Add icon color parameter
  ) {
    bool isAutoFiltrationOn = filtrationAutoMode == '1';
    bool isCurrentCardEnabled =
        title == 'Auto Filtration System' || !isAutoFiltrationOn;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Opacity(
        opacity: isCurrentCardEnabled ? 1.0 : 0.5,
        child: Card(
          elevation: 2.0,
          child: ListTile(
            title: Text(
              title,
              style: const TextStyle(
                fontSize: 18, // Adjust the font size
              ),
            ),
            leading: Icon(
              icon,
              color: iconColor, // Use the provided icon color
            ),
            trailing: title == 'Auto Filtration System'
                ? CupertinoSwitch(
                    value: isAutoFiltrationOn,
                    onChanged: (newValue) {
                      _updateAutoFiltrationSystem(newValue);
                    },
                    activeColor: Colors.blue,
                    trackColor: Colors.grey,
                  )
                : IgnorePointer(
                    ignoring: !isCurrentCardEnabled,
                    child: CupertinoSwitch(
                      value: status == '1',
                      onChanged: (newValue) {
                        // Update the switch value in the Firebase Realtime Database
                        _updateSwitchValue(databaseKey, newValue);
                      },
                      activeColor: Colors.blue,
                      trackColor: Colors.grey,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  void _updateAutoFiltrationSystem(bool newValue) {
    // Update the auto filtration system value in the Firebase Realtime Database
    _databaseReference
        .child('FILTRATION_SYSTEM')
        .child('filtration_AUTO')
        .set(newValue ? "1" : "0")
        .then((_) {
      setState(() {
        filtrationAutoMode = newValue ? "1" : "0";
      });
    });
  }

  void _updateSwitchValue(String databaseKey, bool newValue) {
    // Update the switch value in the Firebase Realtime Database
    _databaseReference
        .child('FILTRATION_SYSTEM')
        .child(databaseKey)
        .set(newValue ? "1" : "0")
        .then((_) {
      // Update the local state
      setState(() {});
    });
  }
}
