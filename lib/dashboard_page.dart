import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String pH = '';
  String waterLevel = '';
  String waterTemp = '';
  String waterTurbidity = '';

  late DatabaseReference databaseRef;

  @override
  void initState() {
    super.initState();
    initializeFirebase();
    databaseRef = FirebaseDatabase.instance.reference();

    databaseRef.child('pH').onValue.listen((event) {
      if (event.snapshot.value != null) {
        setState(() {
          pH = event.snapshot.value.toString();
        });
      }
    });

    databaseRef.child('waterLevel').onValue.listen((event) {
      if (event.snapshot.value != null) {
        setState(() {
          waterLevel = event.snapshot.value.toString();
        });
      }
    });

    databaseRef.child('waterTemp').onValue.listen((event) {
      if (event.snapshot.value != null) {
        setState(() {
          waterTemp = event.snapshot.value.toString();
        });
      }
    });

    databaseRef.child('waterTurbidity').onValue.listen((event) {
      if (event.snapshot.value != null) {
        setState(() {
          waterTurbidity = event.snapshot.value.toString();
        });
      }
    });
  }

  Future<void> initializeFirebase() async {
    try {
      await Firebase.initializeApp();
    } catch (error) {
      print('Error initializing Firebase: $error');
    }
  }

  @override
  void dispose() {
    databaseRef.onValue.drain();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('pH: $pH'),
            Text('Water Level: $waterLevel'),
            Text('Water Temperature: $waterTemp'),
            Text('Water Turbidity: $waterTurbidity'),
          ],
        ),
      ),
    );
  }
}
