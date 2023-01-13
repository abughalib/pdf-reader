import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:pdf_reader/providers/file_pick_provider.dart';
import 'package:provider/provider.dart';

class AppBarActions extends StatelessWidget {
  const AppBarActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        IconButton(
          onPressed: () async => {
            context.read<PDFFilePath>().setPath(await FilePicker.platform
                .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']))
          },
          icon: const Icon(Icons.file_open),
        )
      ],
    );
  }
}
