import 'package:flutter/material.dart';
import 'package:pdf_reader/appbar_actions.dart';
import 'package:pdf_reader/recent_page.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Recent'),
          actions: [AppBarActions()],
          backgroundColor: Colors.black87,
        ),
        body: const RecentPage(),
      ),
    );
  }
}
