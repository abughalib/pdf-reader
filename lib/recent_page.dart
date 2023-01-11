import 'package:flutter/material.dart';
import 'package:pdf_reader/preview.dart';

const gridRowCount = 3;

class RecentPage extends StatelessWidget {
  const RecentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PDFPreview();
    // return GridView.count(
    //   crossAxisCount: gridRowCount,
    //   children: const [PDFPreview()],
    // );
  }
}
