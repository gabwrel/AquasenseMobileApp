import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:aquasenseapp/main.dart';
import 'package:firebase_core/firebase_core.dart';

class MyEvent {
  final DataSnapshot snapshot;

  MyEvent(this.snapshot);
}

class WaterChangePage extends StatefulWidget {
  const WaterChangePage({Key? key}) : super(key: key);

  @override
  _WaterChangePageState createState() => _WaterChangePageState();
}

class _WaterChangePageState extends State<WaterChangePage> {
  late StreamSubscription<MyEvent> _subscription;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    listenToValueChanges();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  void listenToValueChanges() async {
    await Firebase.initializeApp();
    DatabaseReference databaseReference =
        FirebaseDatabase.instance.ref().child('MAINTENANCE').child('waterchange_LEVEL');
    Stream<MyEvent> eventStream = databaseReference.onValue
        .map((event) => MyEvent(event.snapshot));
    _subscription = eventStream.listen((myEvent) {
      var value = myEvent.snapshot.value;
      if (value == null || value == 0) {
        setState(() {
          isLoading = false;
        });
        navigateToHome();
      }
    });
  }

  void navigateToHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MyApp()),
    );
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
      Navigator.pop(context);
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
        child: isLoading
            ? SpinKitCircle(
                color: Colors.blue,
                size: 50.0,
              )
            : null, // Show the spinner only if isLoading is true
      ),
    );
  }
}