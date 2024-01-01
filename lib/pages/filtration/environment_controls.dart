// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class EnvironmentControls extends StatefulWidget {
  const EnvironmentControls({super.key});

  @override
  _EnvironmentControlsState createState() => _EnvironmentControlsState();
}

class _EnvironmentControlsState extends State<EnvironmentControls> {
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();

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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/EnvironmentalControls.png',
                width: 250,
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: 200, // Set a fixed width for the button
                height: 60, // Set a fixed height for the button
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color(0xFFd42a38)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                  ),
                  onPressed: () => _showControlDialog(),
                  child: const Text(
                    'Lighting',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: 200,
                height: 60,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color(0xFFa4d758)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                  ),
                  onPressed: () => _showFeedingDialog(),
                  child: const Text(
                    'Feeding',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 350,
                height: 60,
                child: Material(
                  // elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: StreamBuilder<DatabaseEvent>(
                        stream: _databaseReference
                            .child('TRIGGERS/lighting_TRIGGER')
                            .onValue,
                        builder: (BuildContext context,
                            AsyncSnapshot<DatabaseEvent> snapshot) {
                          if (snapshot.hasData &&
                              snapshot.data!.snapshot.value != null) {
                            bool isLightOn =
                                (snapshot.data!.snapshot.value == '1');
                            return Text(
                              'Light: ${isLightOn ? 'ON' : 'OFF'}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                              ),
                            );
                          } else {
                            // Handle loading state or error state
                            return const Text('Light status loading...');
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: 350,
                height: 60,
                child: Material(
                  // elevation: 2,
                  child: Center(
                    child: StreamBuilder<DatabaseEvent>(
                      stream: _databaseReference
                          .child('SCHEDULING/feeding_SCHEDULE')
                          .onValue,
                      builder: (BuildContext context,
                          AsyncSnapshot<DatabaseEvent> snapshot) {
                        if (snapshot.hasData &&
                            snapshot.data!.snapshot.value != null) {
                          int feedingFrequency =
                              (snapshot.data!.snapshot.value as int);
                          String feedingText =
                              _getFeedingText(feedingFrequency);
                          return Text(
                            feedingText,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                            ),
                          );
                        } else {
                          // Handle loading state or error state
                          return const Text('Feeding Schedule: N/A');
                        }
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showFeedingDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Feeding Controls'),
          content: Column(
            mainAxisSize: MainAxisSize.min, // Set the size to min
            children: <Widget>[
              _buildDialogButton('Feed Now', () {
                _updateFeedingTrigger('1');
                Navigator.of(context).pop();
              }),
              _buildDialogButton('Schedule', () async {
                int? selectedFrequency = await _showFeedingFrequencyDialog();
                if (selectedFrequency != null) {
                  _updateFeedingSchedule(selectedFrequency);
                  Navigator.of(context).pop();
                }
              }),
              _buildDialogButton('Cancel', () {
                Navigator.of(context).pop();
              }),
            ],
          ),
        );
      },
    );
  }

  Future<int?> _showFeedingFrequencyDialog() async {
    return showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Feeding Frequency'),
          content: Column(
            mainAxisSize: MainAxisSize.min, // Set the size to min
            children: [
              _buildDialogButton(
                  'Once A Day', () => Navigator.of(context).pop(24)),
              _buildDialogButton(
                  'Twice A Day', () => Navigator.of(context).pop(12)),
              _buildDialogButton(
                  '3 Times A Day', () => Navigator.of(context).pop(8)),
              _buildDialogButton(
                  '4 Times A Day', () => Navigator.of(context).pop(6)),
            ],
          ),
        );
      },
    );
  }

  void _updateFeedingTrigger(String value) {
    _databaseReference.child('TRIGGERS/feednow_TRIGGER').set(value);
  }

  void _updateFeedingSchedule(int frequency) {
    _databaseReference.child('SCHEDULING/feeding_SCHEDULE').set(frequency);
  }

  Future<void> _showControlDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Lighting Controls'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                _buildDialogButton('Turn On', () {
                  _updateLightingTrigger('1');
                  Navigator.of(context).pop();
                }),
                _buildDialogButton('Turn Off', () {
                  _updateLightingTrigger('0');
                  Navigator.of(context).pop();
                }),
                _buildDialogButton('Schedule', () async {
                  TimeOfDay? startTime = await _selectTime('Select Start Time');
                  if (startTime != null) {
                    _updateScheduling('lightingStart_SCHEDULE', startTime);
                    TimeOfDay? endTime = await _selectTime('Select End Time');
                    if (endTime != null) {
                      _updateScheduling('lightingEnd_SCHEDULE', endTime);
                      Navigator.of(context).pop();
                    }
                  }
                }),
                _buildDialogButton('Cancel', () {
                  Navigator.of(context).pop();
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  void _updateLightingTrigger(String value) {
    _databaseReference.child('TRIGGERS/lighting_TRIGGER').set(value);
  }

  void _updateScheduling(String node, TimeOfDay time) {
    // Format the time to 24-hour format
    String formattedTime =
        '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';

    _databaseReference.child('SCHEDULING/$node').set(formattedTime);
  }

  Future<TimeOfDay?> _selectTime(String title) async {
    return showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark(), // You can customize the theme
          child: child!,
        );
      },
      helpText: title,
    );
  }

  String _getFeedingText(int frequency) {
    switch (frequency) {
      case 24:
        return 'Feeding Schedule: Once A Day';
      case 12:
        return 'Feeding Schedule: Twice A Day';
      case 8:
        return 'Feeding Schedule: Thrice A Day';
      case 6:
        return 'Feeding Schedule: Four Times A Day';
      default:
        return 'Feeding Schedule: N/A';
    }
  }

  Widget _buildDialogButton(String text, void Function()? onPressed) {
    return TextButton(
      onPressed: onPressed,
      child: Text(text),
    );
  }
}
