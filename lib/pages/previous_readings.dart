import 'package:flutter/material.dart';

class PreviousReadings extends StatefulWidget {
  const PreviousReadings({super.key});

  @override
  State<PreviousReadings> createState() => _PreviousReadingsState();
}

class _PreviousReadingsState extends State<PreviousReadings> {
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
      body: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Title
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Previous Readings',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Placeholder content
          Expanded(
            child: Center(
              child: Text(
                'Placeholder Content',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
