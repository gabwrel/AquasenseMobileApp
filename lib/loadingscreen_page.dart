import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:async';

class MyEvent {
  final DataSnapshot snapshot;

  MyEvent(this.snapshot);
}

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
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
        FirebaseDatabase.instance.ref().child('TRIGGERS').child('test_TRIGGER');
    Stream<MyEvent> eventStream =
        databaseReference.onValue.map((event) => MyEvent(event.snapshot));
    _subscription = eventStream.listen((myEvent) {
      var value = myEvent.snapshot.value;
      if (value == null || value == '0') {
        setState(() {
          isLoading = false;
        });
        showCompleteDialog(context); // Show the dialog before navigating back
      }
    });
  }

  void showCompleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Testing Complete'),
          content: Text('Testing has been completed.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                navigateToHome(context);
              },
              child: Text('Ok'),
            ),
          ],
        );
      },
    );
  }

  void navigateToHome(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/dashboard');
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
            // You can choose whether to navigate back directly or not
            // navigateToHome();
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
      body: Column(
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.topCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 150),
                  Image.asset(
                    'assets/images/aquassist.png',
                    height: 170,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Testing Parameters',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                    ),
                  ),
                  SizedBox(height: 50),
                  isLoading
                      ? SpinKitCircle(
                          color: Colors.red,
                          size: 70.0,
                        )
                      : Container(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
