import 'package:flutter/material.dart';
import 'package:pdf_reader/appbar_leading.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Recent'),
          actions: [AppBarLeading()],
          backgroundColor: Colors.black87,
        ),
      ),
    );
  }
}
