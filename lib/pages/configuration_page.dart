// ignore_for_file: avoid_print, unnecessary_to_list_in_spreads, unnecessary_string_interpolations, use_build_context_synchronously

import 'package:aquasenseapp/pages/about_page.dart';
import 'package:aquasenseapp/pages/previous_readings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class ConfigurationPage extends StatefulWidget {
  const ConfigurationPage({super.key});

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
    'Betta': {'pH': 7.0, 'temperature': 25.0, 'turbidity': 10.0},
    'Discus': {'pH': 6.0, 'temperature': 28.0, 'turbidity': 16.0},
    'Flowerhorn': {'pH': 7.5, 'temperature': 27.0, 'turbidity': 14.0},
    'Goldfish': {'pH': 7.2, 'temperature': 22.0, 'turbidity': 8.0},
    'Guppy': {'pH': 7.5, 'temperature': 24.0, 'turbidity': 15.0},
    'Neon Tetra': {'pH': 6.5, 'temperature': 25.0, 'turbidity': 12.0},
    'Oscar': {'pH': 7.0, 'temperature': 26.0, 'turbidity': 12.0},
    // Add more fish species as needed
  };

  Future<void> _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      print('Error logging out: $e');
    }
  }

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
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Container(
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 100,
              offset: const Offset(0, -2),
            )
          ]),
          child: AppBar(
            elevation: 0,
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
                padding: const EdgeInsets.only(top: 15),
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AboutPage()),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/logo2.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                color: Colors.blue, // Background color
                child: const SizedBox(), // Empty SizedBox to remove the text
              ),
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('About Page'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AboutPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.table_chart),
              title: const Text('Previous Readings'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const PreviousReadings()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () async => await _logout(context),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/ThresholdConfig.png',
              ),
              // Dropdown for selecting fish species
              Container(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Fish Species', style: TextStyle(fontSize: 20)),
                    const SizedBox(width: 120.0),
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
              const Divider(
                color: Colors.grey,
                thickness: 0.5,
              ),
              buildSliderRow(
                icon: Icons.show_chart,
                color: const Color.fromARGB(255, 0, 77, 211),
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
              const Divider(
                color: Colors.grey,
                thickness: 0.5,
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
              const Divider(
                color: Colors.grey,
                thickness: 0.5,
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
              const Divider(
                color: Colors.grey,
                thickness: 0.5,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: 150, // Set a fixed width for the button
                  height: 45, // Set a fixed height for the button
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.blue),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                    ),
                    onPressed: () {
                      // Add your logic for the "Test Now" button
                      pushValueToDatabase();
                    },
                    child: const Text(
                      'Apply',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void pushValueToDatabase() async {
    await Firebase.initializeApp(); // Initialize Firebase
    DatabaseReference databaseReference = FirebaseDatabase.instance.ref();
    databaseReference.child('TRIGGERS').child('fetch_TRIGGER').set('1');
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
        const SizedBox(width: 8.0),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    icon,
                    size: 30,
                    color: color,
                  ),
                  const SizedBox(
                    width: 8.0,
                  ),
                  Text(title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                      )),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: () {
                      if (value > min) {
                        onChanged(value - 0.1);
                        onChangeEnd(value - 0.1);
                      }
                    },
                  ),
                  SizedBox(
                    width: 100, // Adjust the width as needed
                    child: TextField(
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      controller: TextEditingController(
                        text: value.toStringAsFixed(2),
                      ),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 10.0,
                          horizontal: 12.0,
                        ),
                        isDense: true, // Reduces the height of the input field
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: const BorderSide(
                            color: Color.fromARGB(255, 197, 197, 197),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: const BorderSide(
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      onSubmitted: (String newValue) {
                        double parsedValue = double.parse(newValue);
                        parsedValue = parsedValue.clamp(min, max);
                        onChanged(parsedValue);
                        onChangeEnd(parsedValue);
                      },
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      if (value < max) {
                        onChanged(value + 0.1);
                        onChangeEnd(value + 0.1);
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: 8.0),
      ],
    );
  }
}
