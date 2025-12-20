import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../../../../core/constants/app_colors.dart';

class PdfViewerPage extends StatelessWidget {
  final Uint8List pdfBytes;
  final String title;

  const PdfViewerPage({
    super.key,
    required this.pdfBytes,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: SfPdfViewer.memory(
        pdfBytes,
        onDocumentLoadFailed: (details) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to load PDF: ${details.description}')),
          );
        },
      ),
    );
  }
}
