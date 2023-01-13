import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class PDFFilePath with ChangeNotifier {
  FilePickerResult? _filePickerResult;

  FilePickerResult? get filePickerResult => _filePickerResult;

  void setPath(FilePickerResult? filePickerResult) {
    _filePickerResult = filePickerResult;
    notifyListeners();
  }
}
