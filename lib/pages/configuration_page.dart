import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class ConfigurationPage extends StatefulWidget {
  const ConfigurationPage({Key? key}) : super(key: key);

  @override
  State<ConfigurationPage> createState() => _ConfigurationPageState();
}

class _ConfigurationPageState extends State<ConfigurationPage> {
  double? pHSetting;
  double? temperatureSetting;

  late DatabaseReference _databaseReference;

  @override
  void initState() {
    super.initState();
    _databaseReference = FirebaseDatabase.instance.ref().child('configurations');

    fetchConfigurationsValues();
  }

  void fetchConfigurationsValues() {
    _databaseReference.child('pH_setting').onValue.listen(( event) {
      var dataSnapshot = event.snapshot;
      setState(() {
        pHSetting = (dataSnapshot.value as num?)?.toDouble();
      });
    }, onError: (Object? error) {
      // Handle error if necessary
      print(error);
    });

    _databaseReference.child('temperature_setting').onValue.listen(( event) {
      var dataSnapshot = event.snapshot;
      setState(() {
        temperatureSetting = (dataSnapshot.value as num?)?.toDouble();
      });
    }, onError: (Object? error) {
      // Handle error if necessary
      print(error);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Configuration'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              'assets/images/logo2.png',
              width: 30,
              height: 30,
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.settings),
                ),
                Text(
                  'Configure',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Icon(Icons.show_chart),
                  SizedBox(width: 8.0),
                  Text('pH Level'),
                  Expanded(
                    child: Slider(
                      value: mapValueToSlider(pHSetting),
                      min: 0,
                      max: 14,
                      divisions: 140,
                      onChanged: (value) {
                        setState(() {
                          pHSetting = mapSliderToValue(value);
                        });
                      },
                      onChangeEnd: (value) {
                        _databaseReference.child('pH_setting').set(pHSetting);
                      },
                    ),
                  ),
                  Text(
                    '${pHSetting?.toStringAsFixed(2) ?? '0.00'}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Icon(Icons.thermostat),
                  SizedBox(width: 8.0),
                  Text('Temperature'),
                  IconButton(
                    icon: Icon(Icons.remove),
                    onPressed: () => _updateTemperature(false),
                  ),
                  Text('${temperatureSetting ?? 0}°C'),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () => _updateTemperature(true),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Icon(Icons.pets),
                  SizedBox(width: 8.0),
                  Text('Feeding Time'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  double mapValueToSlider(double? value) {
    if (value != null) {
      return (value - 0) * (14 - 0) / (14 - 0) + 0;
    }
    return 0.0;
  }

  double mapSliderToValue(double value) {
    return (value - 0) * (14 - 0) / (14 - 0) + 0;
  }

  void _updateTemperature(bool increment) {
    setState(() {
      if (temperatureSetting != null) {
        temperatureSetting = increment ? temperatureSetting! + 1 : temperatureSetting! - 1;
        _databaseReference.child('temperature_setting').set(temperatureSetting);
      }
    });
  }
}
