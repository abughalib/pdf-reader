import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class AppBarActions extends StatelessWidget {
  AppBarActions({super.key, this.filePickerResult});

  FilePickerResult? filePickerResult;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        IconButton(
          onPressed: () async => {
            filePickerResult = await FilePicker.platform
                .pickFiles(type: FileType.custom, allowedExtensions: ['pdf'])
          },
          icon: const Icon(Icons.file_open),
        )
      ],
    );
  }
}
