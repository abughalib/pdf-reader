import 'package:flutter/material.dart';

const gridRowCount = 3;

class RecentPage extends StatelessWidget {
  const RecentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: gridRowCount,
      children: const [],
    );
  }
}