import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PDFPreview extends StatefulWidget {
  const PDFPreview({Key? key}) : super(key: key);

  @override
  State<PDFPreview> createState() => _PDFPreviewState();
}

class _PDFPreviewState extends State<PDFPreview> {
  late PdfViewerController _pdfViewerController;

  @override
  void initState() {
    _pdfViewerController = PdfViewerController();
    super.initState();
  }

  late OverlayEntry _overlayEntry;

  void _showContextMenu(
      BuildContext context, PdfTextSelectionChangedDetails details) {
    final OverlayState? overlaystate = Overlay.of(context);
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: details.globalSelectedRegion!.center.dy - 55,
        left: details.globalSelectedRegion!.bottomLeft.dx,
        child: MaterialButton(
          onPressed: () {
            Clipboard.setData(ClipboardData(text: details.selectedText));
            _pdfViewerController.clearSelection();
          },
          color: Colors.white,
          elevation: 10,
          child: const Text(
            'Copy',
            style: TextStyle(fontSize: 17),
          ),
        ),
      ),
    );
    overlaystate?.insert(_overlayEntry);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SfPdfViewer.network(
            'https://cdn.syncfusion.com/content/PDFViewer/flutter-succinctly.pdf'),
      ),
    );
  }
}
