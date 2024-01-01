// ignore_for_file: file_names, use_build_context_synchronously, avoid_print

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class WaterChangePage extends StatefulWidget {
  const WaterChangePage({super.key});

  @override
  State<WaterChangePage> createState() => _WaterChangePageState();
}

class _WaterChangePageState extends State<WaterChangePage> {
  late DatabaseReference _databaseReference;
  DateTime? selectedDateTime;
  late String waterChangeSchedule;

  @override
  void initState() {
    super.initState();
    _databaseReference = FirebaseDatabase.instance.ref();

    _databaseReference.child('MAINTENANCE').child('schedule').set('');

    _databaseReference
        .child('MAINTENANCE')
        .child('schedule')
        .onValue
        .listen((event) {
      setState(() {
        waterChangeSchedule = event.snapshot.value?.toString() ?? 'N/A';
      });
    });
  }

  void onPressed() {
    // Function to clear the water change schedule
    _databaseReference.child('MAINTENANCE').child('schedule').set('');
  }

  void _scheduleWaterChange(String waterChangeLevel) async {
    await _selectDateTime(context);

    if (selectedDateTime != null) {
      String unixTime = selectedDateTime!.millisecondsSinceEpoch.toString();
      _databaseReference.child('MAINTENANCE').child('schedule').set(unixTime);
      _databaseReference
          .child('MAINTENANCE')
          .child('waterchange_LEVEL')
          .set(waterChangeLevel);
      Navigator.of(context).pop();
    }
  }

  void handleWaterChange(String waterChangeLevel) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmation'),
          content:
              Text('Are you sure to initiate $waterChangeLevel% water change?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                _databaseReference
                    .child('MAINTENANCE')
                    .child('waterchange_LEVEL')
                    .set(waterChangeLevel);
                _databaseReference
                    .child('TRIGGERS')
                    .child('waterchange_TRIGGER')
                    .set('1');
                _databaseReference
                    .child('MAINTENANCE')
                    .child('schedule')
                    .set('0');
                Navigator.of(context).pop();
              },
              child: const Text('Perform Now'),
            ),
            TextButton(
              onPressed: () {
                _scheduleWaterChange(
                    waterChangeLevel); // Pass the waterChangeLevel
              },
              child: const Text('Schedule'),
            ),
          ],
        );
      },
    );
  }

  String _calculateTimeUntilNextWaterChange(Object? scheduleUnix) {
    if (scheduleUnix == null) {
      return 'N/A';
    }

    int schedule = int.tryParse(scheduleUnix.toString()) ?? 0;
    int nowUnix = DateTime.now().millisecondsSinceEpoch;
    int difference = schedule - nowUnix;

    if (difference <= 0) {
      return 'N/A';
    }

    Duration duration = Duration(milliseconds: difference);

    int days = duration.inDays;
    int hours = duration.inHours.remainder(24);
    int minutes = duration.inMinutes.remainder(60);

    return '$days day/s, $hours hours, $minutes minutes';
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        setState(() {
          selectedDateTime = DateTime(
            picked.year,
            picked.month,
            picked.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
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
        body: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Center(
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final availableWidth = constraints.maxWidth;
                final availableHeight = constraints.maxHeight;

                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Image.asset('assets/images/waterchange.png',
                          height: availableHeight * 0.4),
                      SizedBox(height: availableHeight * 0.05),
                      const Text(
                        "Select the desired water change volume",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          print('Water Change clicked');
                        },
                        child: SizedBox(
                          width: availableWidth * 0.9,
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                          ),
                        ),
                      ),
                      SizedBox(height: availableHeight * 0.05),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () {
                              handleWaterChange('10');
                            },
                            child: buildConfigItem(
                              '10%',
                              Colors.blue,
                              availableWidth * 0.2,
                              availableHeight * 0.15,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              handleWaterChange('25');
                            },
                            child: buildConfigItem(
                              '25%',
                              Colors.green,
                              availableWidth * 0.2,
                              availableHeight * 0.15,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              handleWaterChange('50');
                            },
                            child: buildConfigItem(
                              '50%',
                              Colors.orange,
                              availableWidth * 0.2,
                              availableHeight * 0.15,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              handleWaterChange('75');
                            },
                            child: buildConfigItem(
                              '75%',
                              Colors.red,
                              availableWidth * 0.2,
                              availableHeight * 0.15,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: availableHeight * 0.05),
                      SizedBox(
                        width: 350, // Adjust the width as needed
                        height: 60, // Adjust the height as needed
                        child: Material(
                          elevation: 0, // Set the elevation value as needed
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: StreamBuilder<DatabaseEvent>(
                                stream: _databaseReference
                                    .child('MAINTENANCE')
                                    .child('schedule')
                                    .onValue,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData &&
                                      snapshot.data!.snapshot.value != null) {
                                    String scheduleText =
                                        _calculateTimeUntilNextWaterChange(
                                            snapshot.data!.snapshot.value);
                                    return Text(
                                      'Next Water Change in: $scheduleText',
                                      style: const TextStyle(fontSize: 16),
                                    );
                                  } else {
                                    return const Text(
                                      'Next Water Change in: N/A',
                                      style: TextStyle(fontSize: 16),
                                    );
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: availableHeight * 0.05),
                      SizedBox(
                        width: 200,
                        height: 60,
                        child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.red),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ))),
                            onPressed: onPressed,
                            child: const Text(
                              "Clear Schedule",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            )),
                      )
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
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
