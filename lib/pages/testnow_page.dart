import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:aquasenseapp/loadingscreen_page.dart';

class TestNowPage extends StatelessWidget {
  const TestNowPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        toolbarHeight: 80,
        backgroundColor: Colors.white,
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Center(
              child: Image.asset(
                'assets/images/aquassist.png',
                height: 170,
              ),
            ),
          ),
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                  const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
              ),
              onPressed: () {
                pushValueToDatabase();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const LoadingScreen()),
                );
              },
              child: const Text(
                'Test Now',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void pushValueToDatabase() async {
    await Firebase.initializeApp(); // Initialize Firebase
    DatabaseReference databaseReference = FirebaseDatabase.instance.ref();
    databaseReference.child('TRIGGERS').child('test_TRIGGER').set('1');
  }
}
