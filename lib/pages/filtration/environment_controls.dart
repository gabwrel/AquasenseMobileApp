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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/EnvironmentalControls.png',
              width: 250,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 200, // Set a fixed width for the button
              height: 60, // Set a fixed height for the button
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
          ],
        ),
      ),
    );
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

  Widget _buildDialogButton(String text, void Function()? onPressed) {
    return TextButton(
      onPressed: onPressed,
      child: Text(text),
    );
  }
}
