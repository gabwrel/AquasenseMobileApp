// app_bar.dart

import 'package:aquasenseapp/pages/about_page.dart';
import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(80);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.12),
          blurRadius: 100,
          offset: const Offset(0, -2),
        )
      ]),
      child: AppBar(
        elevation: 0,
        toolbarHeight: 80,
        backgroundColor: Colors.white,
        leading: Builder(
          builder: (BuildContext context) {
            return Center(
              child: IconButton(
                icon: const Icon(Icons.menu, size: 30, color: Colors.blue),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
            );
          },
        ),
        flexibleSpace: Align(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Image.asset(
              'assets/images/logo2.png',
              height: 80,
            ),
          ),
        ),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: IconButton(
                icon: const Icon(Icons.info_outline,
                    size: 30, color: Colors.blue),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AboutPage()),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
