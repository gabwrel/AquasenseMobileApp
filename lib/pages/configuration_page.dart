import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:aquasenseapp/main.dart';

class ConfigurationPage extends StatefulWidget {
  const ConfigurationPage({Key? key}) : super(key: key);

  @override
  State<ConfigurationPage> createState() => _ConfigurationPageState();
}

class _ConfigurationPageState extends State<ConfigurationPage> {
  double? pHSetting;
  double? temperatureSetting;
  double? turbiditySetting;

  late DatabaseReference _databaseReference;

  String selectedFish = 'Custom'; // Default fish selection

  // Define fish species and their configurations
  final Map<String, Map<String, double>> fishConfigurations = {
    'Angelfish': {'pH': 6.8, 'temperature': 27.0, 'turbidity': 14.0},
    'Arowana': {'pH': 6.5, 'temperature': 28.0, 'turbidity': 16.0},
    'Bangus': {'pH': 7.0, 'temperature': 28.0, 'turbidity': 15.0},
    'Betta': {'pH': 7.0, 'temperature': 25.0, 'turbidity': 10.0},
    'Discus': {'pH': 6.0, 'temperature': 28.0, 'turbidity': 16.0},
    'Flowerhorn': {'pH': 7.5, 'temperature': 27.0, 'turbidity': 14.0},
    'Goldfish': {'pH': 7.2, 'temperature': 22.0, 'turbidity': 8.0},
    'Guppy': {'pH': 7.5, 'temperature': 24.0, 'turbidity': 15.0},
    'Neon Tetra': {'pH': 6.5, 'temperature': 25.0, 'turbidity': 12.0},
    'Oscar': {'pH': 7.0, 'temperature': 26.0, 'turbidity': 12.0},
    'Tilapia': {'pH': 7.2, 'temperature': 25.0, 'turbidity': 10.0},
    // Add more fish species as needed
  };

  @override
  void initState() {
    super.initState();
    _databaseReference =
        FirebaseDatabase.instance.ref().child('PARAMETERS_CONFIG');

    // Set initial configurations based on the default selected fish
    updateFishConfiguration(selectedFish);

    // Fetch current configuration values from Firebase
    fetchConfigurationsValues();
  }

  void fetchConfigurationsValues() {
    _databaseReference.child('ph_CONFIG').onValue.listen((event) {
      var dataSnapshot = event.snapshot;
      setState(() {
        pHSetting = double.tryParse(dataSnapshot.value as String? ?? '0.0');
      });
    }, onError: (Object? error) {
      // Handle error if necessary
      print(error);
    });

    _databaseReference.child('temp_CONFIG').onValue.listen((event) {
      var dataSnapshot = event.snapshot;
      setState(() {
        temperatureSetting =
            double.tryParse(dataSnapshot.value as String? ?? '0.0');
      });
    }, onError: (Object? error) {
      // Handle error if necessary
      print(error);
    });

    _databaseReference.child('turbidity_CONFIG').onValue.listen((event) {
      var dataSnapshot = event.snapshot;
      setState(() {
        turbiditySetting =
            double.tryParse(dataSnapshot.value as String? ?? '0.0');
      });
    }, onError: (Object? error) {
      // Handle error if necessary
      print(error);
    });
  }

  void updateFishConfiguration(String selectedFish) {
    final Map<String, double>? config = fishConfigurations[selectedFish];

    if (config != null) {
      setState(() {
        pHSetting = config['pH'];
        temperatureSetting = config['temperature'];
        turbiditySetting = config['turbidity'];
      });

      // Update Firebase database with new configuration values
      _databaseReference
          .child('ph_CONFIG')
          .set(pHSetting?.toStringAsFixed(2) ?? '0.0');
      _databaseReference
          .child('temp_CONFIG')
          .set(temperatureSetting?.toStringAsFixed(2) ?? '0.0');
      _databaseReference
          .child('turbidity_CONFIG')
          .set(turbiditySetting?.toStringAsFixed(2) ?? '0.0');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Generate the list of fish species dynamically
    List<String> fishSpecies = ['Custom', ...fishConfigurations.keys.toList()];

    return Scaffold(
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
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                'assets/images/CONFIGURATION.png',
                height: 80,
              ),
              // Dropdown for selecting fish species
              Container(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Fish Species', style: TextStyle(fontSize: 20)),
                    SizedBox(width: 8.0),
                    DropdownButton<String>(
                      value: selectedFish,
                      items: fishSpecies.map<DropdownMenuItem<String>>(
                        (String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        },
                      ).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          selectedFish = value ?? 'Custom';
                          updateFishConfiguration(selectedFish);
                        });
                      },
                    ),
                  ],
                ),
              ),
              Divider(
                color: Colors.grey,
                thickness: 1.5,
              ),
              buildSliderRow(
                icon: Icons.show_chart,
                color: Color.fromARGB(255, 0, 77, 211),
                title: 'pH Level',
                value: pHSetting ?? 0.0,
                min: 0,
                max: 14,
                onChanged: (value) {
                  setState(() {
                    pHSetting = value;
                  });
                },
                onChangeEnd: (value) {
                  _databaseReference
                      .child('ph_CONFIG')
                      .set(pHSetting?.toStringAsFixed(2) ?? '0.0');
                },
              ),
              Divider(
                color: Colors.grey,
                thickness: 1.5,
              ),
              buildSliderRow(
                icon: Icons.thermostat,
                color: Colors.red,
                title: 'Temperature',
                value: temperatureSetting ?? 25.0,
                min: 20,
                max: 32,
                onChanged: (value) {
                  setState(() {
                    temperatureSetting = value;
                  });
                },
                onChangeEnd: (value) {
                  _databaseReference
                      .child('temp_CONFIG')
                      .set(temperatureSetting?.toStringAsFixed(2) ?? '0.0');
                },
              ),
              Divider(
                color: Colors.grey,
                thickness: 1.5,
              ),
              buildSliderRow(
                icon: Icons.blur_on_rounded,
                color: Colors.green,
                title: 'Turbidity',
                value: turbiditySetting ?? 0.0,
                min: 0,
                max: 100,
                onChanged: (value) {
                  setState(() {
                    turbiditySetting = value;
                  });
                },
                onChangeEnd: (value) {
                  _databaseReference
                      .child('turbidity_CONFIG')
                      .set(turbiditySetting?.toStringAsFixed(2) ?? '0.0');
                },
              ),
              Divider(
                color: Colors.grey,
                thickness: 1.5,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSliderRow({
    required IconData icon,
    required Color color,
    required String title,
    required double value,
    required double min,
    required double max,
    required ValueChanged<double> onChanged,
    required ValueChanged<double> onChangeEnd,
  }) {
    return Row(
      children: [
        SizedBox(width: 8.0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: 30,
                  color: color,
                ),
                Text(title, style: TextStyle(fontSize: 20)),
              ],
            ),
            Slider(
              value: value,
              min: min,
              max: max,
              divisions: ((max - min) * 100).toInt(),
              onChanged: onChanged,
              onChangeEnd: onChangeEnd,
            ),
          ],
        ),
        Expanded(
          child: Container(),
        ),
        Text(
          '${value.toStringAsFixed(2)}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ],
    );
  }
}
