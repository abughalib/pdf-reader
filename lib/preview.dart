import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf_reader/show_definition.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PDFPreview extends StatefulWidget {
  const PDFPreview({Key? key}) : super(key: key);

  @override
  State<PDFPreview> createState() => _PDFPreviewState();
}

class _PDFPreviewState extends State<PDFPreview> {
  late PdfViewerController _pdfViewerController;
  String selectedText = "";

  @override
  void initState() {
    _pdfViewerController = PdfViewerController();
    super.initState();
  }

  OverlayEntry? _overlayEntry;

  Future<String?> _showDefinition() async {
    _pdfViewerController.clearSelection();
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('Define $selectedText'),
        content: ShowDefinition(selectedWord: selectedText),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: const Text('OK'),
          ),
        ],
      ),
    );
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
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: SfPdfViewer.network(
          'https://cdn.syncfusion.com/content/PDFViewer/flutter-succinctly.pdf',
          onTextSelectionChanged: (PdfTextSelectionChangedDetails details) {
            if (details.selectedText == null && _overlayEntry != null) {
              _overlayEntry!.remove();
              _overlayEntry = null;
            } else if (details.selectedText != null && _overlayEntry == null) {
              _showContextMenu(context, details);
              String selectedTexts = details.selectedText ?? "";
              String firstWord = selectedTexts.split(" ").first.trim();
              final String selectedTextTrimmed =
                  firstWord.replaceAll(RegExp('[^a-zA-Z]'), '');
              selectedText = selectedTextTrimmed;
            }
          },
          controller: _pdfViewerController,
        ),
      ),
    );
  }
}
