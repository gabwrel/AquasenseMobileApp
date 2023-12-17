// ignore_for_file: file_names

import 'package:flutter/material.dart';

class MasterSwitchPage extends StatefulWidget {
  const MasterSwitchPage({super.key});

  @override
  State<MasterSwitchPage> createState() => _MasterSwitchPageState();
}

class _MasterSwitchPageState extends State<MasterSwitchPage> {
  @override
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
          padding: const EdgeInsets.all(22.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo2.png',
                height: 150,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
