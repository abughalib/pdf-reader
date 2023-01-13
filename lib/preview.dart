import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf_reader/providers/file_pick_provider.dart';
import 'package:pdf_reader/show_definition.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PDFPreview extends StatelessWidget {
  const PDFPreview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: const OfflinePDFViewer(),
      ),
    );
  }
}

class OfflinePDFViewer extends StatefulWidget {
  const OfflinePDFViewer({Key? key}) : super(key: key);

  @override
  State<OfflinePDFViewer> createState() => _OfflinePDFViewerState();
}

class _OfflinePDFViewerState extends State<OfflinePDFViewer> {
  late PdfViewerController _pdfViewerController;
  String selectedText = "";

  @override
  void initState() {
    _pdfViewerController = PdfViewerController();
    super.initState();
  }

  OverlayEntry? _overlayEntry;

  _showDefinition() async {
    _pdfViewerController.clearSelection();
    if (selectedText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: SizedBox(
            child: Text("Nothing selected"),
          ),
        ),
      );
    } else {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          contentPadding: const EdgeInsets.symmetric(horizontal: 10.0),
          titlePadding: const EdgeInsets.all(10.0),
          title: Text(selectedText),
          scrollable: true,
          content: ShowDefinition(selectedWord: selectedText),
        ),
      );
    }
  }

  void _showContextMenu(
      BuildContext context, PdfTextSelectionChangedDetails details) {
    final OverlayState? overlayState = Overlay.of(context);
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: details.globalSelectedRegion!.center.dy - 55,
        left: details.globalSelectedRegion!.bottomLeft.dx,
        child: Row(
          children: <Widget>[
            MaterialButton(
              onPressed: () {
                Clipboard.setData(
                  ClipboardData(text: details.selectedText),
                );
                _pdfViewerController.clearSelection();
              },
              color: Colors.white,
              elevation: 10,
              child: const Text(
                'Copy',
                style: TextStyle(fontSize: 17),
              ),
            ),
            MaterialButton(
              onPressed: () => _showDefinition(),
              color: Colors.white,
              child: const Text(
                'Define',
                style: TextStyle(fontSize: 17),
              ),
            ),
          ],
        ),
      ),
    );
    overlayState?.insert(_overlayEntry!);
  }

  @override
  Widget build(BuildContext context) {
    // TODO for web
    // Byte Streaming
    // Uint8List uploadFile = result.files.single.bytes;
    //
    // String filename = basename(result.files.single.name);
    //
    // fs.Reference storageRef = fs.FirebaseStorage.instance.ref().child('$dirpath$filename');
    //
    // final fs.UploadTask uploadTask = storageRef.putData(uploadFile);
    //
    // final fs.TaskSnapshot downloadUrl = await uploadTask;
    //
    // final String attachUrl = (await downloadUrl.ref.getDownloadURL());

    FilePickerResult? filePickerResult =
        context.watch<PDFFilePath>().filePickerResult;

    if (filePickerResult == null || filePickerResult.paths.isEmpty) {
      // TODO show better message no file selection
      return const SizedBox(
        child: Text("No File Selected"),
      );
    } else {
      PlatformFile pdf =
          context.watch<PDFFilePath>().filePickerResult!.files.single;
      return SfPdfViewer.file(
        // TODO better error handle if the file is corrupted
        // Single PDF File Selection
        File(pdf.path!),
        onTextSelectionChanged: (PdfTextSelectionChangedDetails details) {
          if (details.selectedText == null && _overlayEntry != null) {
            _overlayEntry!.remove();
            _overlayEntry = null;
          } else if (details.selectedText != null && _overlayEntry == null) {
            _showContextMenu(context, details);
            String selectedTexts = details.selectedText ?? "";
            String firstWord = selectedTexts.trim().split(" ").first;
            final String selectedTextTrimmed =
                firstWord.replaceAll(RegExp(r'[^a-zA-Z]'), '');
            selectedText = selectedTextTrimmed;
          }
        },
        controller: _pdfViewerController,
      );
    }
  }
}
