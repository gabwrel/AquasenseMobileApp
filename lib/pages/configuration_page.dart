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
    _databaseReference =
        FirebaseDatabase.instance.ref().child('PARAMETERS_CONFIG');

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
            Image.asset(
              'assets/images/CONFIGURATION.png',
              height: 80,
            ),
            Container(
              padding: EdgeInsets.all(2.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.show_chart,
                    color: Color.fromARGB(255, 0, 77, 211),
                  ),
                  SizedBox(width: 8.0),
                  Text('pH Level', style: TextStyle(fontSize: 20)),
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
                        _databaseReference
                            .child('ph_CONFIG')
                            .set(pHSetting?.toString() ?? '0.0');
                      },
                    ),
                  ),
                  Text(
                    '${pHSetting?.toStringAsFixed(2) ?? '0.00'}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              color: Colors.grey,
              thickness: 1.5,
            ),
            Container(
              padding: EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.thermostat,
                    size: 30,
                    color: Colors.red,
                  ),
                  SizedBox(width: 8.0),
                  Text('Temperature', style: TextStyle(fontSize: 20)),
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
                        _databaseReference
                            .child('temp_CONFIG')
                            .set(temperatureSetting?.toString() ?? '0.0');
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
            Divider(
              color: Colors.grey,
              thickness: 1.5,
            ),
            Container(
              padding: EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.blur_on_rounded,
                    size: 30,
                    color: Colors.green,
                  ),
                  SizedBox(width: 8.0),
                  Text('Turbidity', style: TextStyle(fontSize: 20)),
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
                        _databaseReference
                            .child('turbidity_CONFIG')
                            .set(turbiditySetting?.toString() ?? '0.0');
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
            Divider(
              color: Colors.grey,
              thickness: 1.5,
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
  Color sliderColor = Colors.red;

  @override
  void initState() {
    super.initState();
    value = widget.value;
    updateSliderColor();
  }

  @override
  void didUpdateWidget(SliderVerticalWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    value = widget.value;
    updateSliderColor();
  }

  void updateSliderColor() {
    if (value >= 0 && value <= 1) {
      sliderColor = Color(0xFFff9f99);
    } else if (value > 1 && value <= 2) {
      sliderColor = Color(0xFFffcc99);
    } else if (value > 2 && value <= 3) {
      sliderColor = Color(0xFFffe999);
    } else if (value > 3 && value <= 4) {
      sliderColor = Color(0xFFfffa99);
    } else if (value > 4 && value <= 5) {
      sliderColor = Color(0xFFf8ff96);
    } else if (value > 5 && value <= 6) {
      sliderColor = Color(0xFFf0fe86);
    } else if (value > 6 && value <= 7) {
      sliderColor = Color(0xFF71ff6f);
    } else if (value > 7 && value <= 8) {
      sliderColor = Color(0xFF99ffe0);
    } else if (value > 8 && value <= 9) {
      sliderColor = Color(0xFF99fffd);
    } else if (value > 9 && value <= 10) {
      sliderColor = Color(0xFFd6fffe);
    } else if (value > 10 && value <= 11) {
      sliderColor = Color(0xFF99baff);
    } else if (value > 11 && value <= 12) {
      sliderColor = Color(0xFF838afe);
    } else if (value > 12 && value <= 13) {
      sliderColor = Color(0xFFd483fe);
    } else if (value > 13) {
      sliderColor = Color(0xFFc660ff);
    }
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
        overlayColor: sliderColor.withOpacity(0.4),
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
                          updateSliderColor();
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
                      activeColor: sliderColor,
                    ),
                  ),
                  Center(
                    child: Text(
                      '${value.round()}',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
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
