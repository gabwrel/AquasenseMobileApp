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

  @override
  void initState() {
    super.initState();
    _databaseReference = FirebaseDatabase.instance.reference().child('PARAMETERS_CONFIG');

    fetchConfigurationsValues();
  }

  void fetchConfigurationsValues() {
    _databaseReference.child('ph_CONFIG').onValue.listen((event) {
      var dataSnapshot = event.snapshot;
      setState(() {
        pHSetting = double.tryParse(dataSnapshot.value as String? ?? '');
      });
    }, onError: (Object? error) {
      // Handle error if necessary
      print(error);
    });

    _databaseReference.child('temp_CONFIG').onValue.listen((event) {
      var dataSnapshot = event.snapshot;
      setState(() {
        temperatureSetting = double.tryParse(dataSnapshot.value as String? ?? '');
      });
    }, onError: (Object? error) {
      // Handle error if necessary
      print(error);
    });

    _databaseReference.child('turbidity_CONFIG').onValue.listen((event) {
      var dataSnapshot = event.snapshot;
      setState(() {
        turbiditySetting = double.tryParse(dataSnapshot.value as String? ?? '');
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
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'CONFIGURATION',
              style: TextStyle(
                fontSize: 45,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            Divider(color: Colors.red),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.show_chart),
                  SizedBox(width: 8.0),
                  Text('pH Level'),
                  Expanded(
                    child: SliderVerticalWidget(
                      value: pHSetting ?? 0.0,
                      min: 0,
                      max: 14,
                      divisions: 140,
                      onChanged: (value) {
                        setState(() {
                          pHSetting = value;
                        });
                      },
                      onChangeEnd: (value) {
                        _databaseReference.child('ph_CONFIG').set(pHSetting?.toString() ?? '');
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.thermostat),
                  SizedBox(width: 8.0),
                  Text('Temperature'),
                  Expanded(
                    child: Slider(
                      value: temperatureSetting ?? 25.0,
                      min: 20,
                      max: 32,
                      divisions: 120,
                      onChanged: (value) {
                        setState(() {
                          temperatureSetting = value;
                        });
                      },
                      onChangeEnd: (value) {
                        _databaseReference.child('temp_CONFIG').set(temperatureSetting?.toString() ?? '');
                      },
                    ),
                  ),
                  Text(
                    '${temperatureSetting?.toStringAsFixed(2) ?? '0.00'}',
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.opacity),
                  SizedBox(width: 8.0),
                  Text('Turbidity'),
                  Expanded(
                    child: Slider(
                      value: turbiditySetting ?? 0.0,
                      min: 0,
                      max: 100,
                      divisions: 100,
                      onChanged: (value) {
                        setState(() {
                          turbiditySetting = value;
                        });
                      },
                      onChangeEnd: (value) {
                        _databaseReference.child('turbidity_CONFIG').set(turbiditySetting?.toString() ?? '');
                      },
                    ),
                  ),
                  Text(
                    '${turbiditySetting?.toStringAsFixed(2) ?? '0.00'}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
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

class SliderVerticalWidget extends StatefulWidget {
  final double value;
  final double min;
  final double max;
  final int divisions;
  final ValueChanged<double>? onChanged;
  final ValueChanged<double>? onChangeEnd;

  SliderVerticalWidget({
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    this.onChanged,
    this.onChangeEnd,
  });

  @override
  _SliderVerticalWidgetState createState() => _SliderVerticalWidgetState();
}

class _SliderVerticalWidgetState extends State<SliderVerticalWidget> {
  late double value;

  @override
  void initState() {
    super.initState();
    value = widget.value;
  }

  @override
  void didUpdateWidget(covariant SliderVerticalWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    value = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    final double min = widget.min;
    final double max = widget.max;

    // Define the color scheme based on 'ph_CONFIG' value ranges
    Color getColor(double value) {
      if (value >= 0 && value <= 3) {
        return Colors.red;
      } else if (value > 3 && value < 6) {
        return Colors.orange;
      } else if (value > 6 && value < 7.99) {
        return Colors.green;
      } else if (value >= 8 && value <= 11) {
        return Colors.blue;
      } else if (value > 11 && value <= 14) {
        return Colors.purple;
      }
      return Colors.grey; // Default color for values outside the specified ranges
    }

    return Container(
      width: 40, // Fixed width for the slider
      child: Column(
        children: [
          Expanded(
            child: RotatedBox(
              quarterTurns: 3,
              child: Slider(
                value: value,
                min: min,
                max: max,
                divisions: widget.divisions,
                onChanged: (newValue) {
                  setState(() {
                    value = newValue;
                  });
                  widget.onChanged?.call(newValue);
                },
                onChangeEnd: (newValue) {
                  widget.onChangeEnd?.call(newValue);
                },
                activeColor: getColor(value),
              ),
            ),
          ),
          Text(
            '${value.toStringAsFixed(2)}', // Display the current value
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
