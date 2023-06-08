import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:aquasenseapp/dashboard_page.dart';

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
    _databaseReference.child('pH_setting').onValue.listen((event) {
      var dataSnapshot = event.snapshot;
      setState(() {
        pHSetting = (dataSnapshot.value as num?)?.toDouble();
      });
    }, onError: (Object? error) {
      // Handle error if necessary
      print(error);
    });

    _databaseReference.child('temperature_setting').onValue.listen((event) {
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
                        _databaseReference.child('temperature_setting').set(temperatureSetting);
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
  void didUpdateWidget(SliderVerticalWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    value = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    final double min = widget.min;
    final double max = widget.max;

    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        trackHeight: 80,
        thumbShape: SliderComponentShape.noOverlay,
        overlayShape: SliderComponentShape.noOverlay,
        valueIndicatorShape: SliderComponentShape.noOverlay,
        trackShape: RectangularSliderTrackShape(),
        activeTickMarkColor: Colors.transparent,
        inactiveTickMarkColor: Colors.transparent,
      ),
      child: Container(
        height: 360,
        child: Column(
          children: [
            buildSideLabel(max),
            const SizedBox(height: 16),
            Expanded(
              child: Stack(
                children: [
                  RotatedBox(
                    quarterTurns: 3,
                    child: Slider(
                      value: value,
                      min: min,
                      max: max,
                      divisions: widget.divisions,
                      label: value.round().toString(),
                      onChanged: (newValue) {
                        setState(() {
                          value = newValue;
                        });
                        if (widget.onChanged != null) {
                          widget.onChanged!(newValue);
                        }
                      },
                      onChangeEnd: (newValue) {
                        if (widget.onChangeEnd != null) {
                          widget.onChangeEnd!(newValue);
                        }
                      },
                    ),
                  ),
                  Center(
                    child: Text(
                      '${value.round()}',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            buildSideLabel(min),
          ],
        ),
      ),
    );
  }

  Widget buildSideLabel(double value) => Text(
        value.round().toString(),
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      );
}
