import 'package:flutter/material.dart';
import 'package:pdf_reader/appbar_actions.dart';
import 'package:pdf_reader/providers/file_pick_provider.dart';
import 'package:pdf_reader/recent_page.dart';
import 'package:provider/provider.dart';

void main() async {
  runApp(MultiProvider(
    providers: [ChangeNotifierProvider(create: (_) => PDFFilePath())],
    child: const App(),
  ));
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Recent'),
          actions: const [AppBarActions()],
          backgroundColor: Colors.black87,
        ),
        body: const RecentPage(),
      ),
    );
  }
}
