import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PdfExport {
  static Future<void> generateDailyReport() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          pw.Header(
            level: 0,
            child: pw.Text(
              'AI Railway Bio-Toilet Inspection System',
              style: pw.TextStyle(
                fontSize: 22,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),

          pw.SizedBox(height: 10),

          pw.Text(
            'DAILY INSPECTION REPORT',
            style: pw.TextStyle(
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
            ),
          ),

          pw.Divider(),

          pw.SizedBox(height: 12),

          _infoRow('Date', '07 Jul 2026'),
          _infoRow('Report Type', 'Daily Inspection Report'),

          pw.SizedBox(height: 20),

          pw.Header(level: 1, text: 'Inspection Summary'),

          _infoRow('Trains Inspected', '9'),
          _infoRow('Total Defects', '21'),
          _infoRow('Critical Defects', '4'),
          _infoRow('Average Inspection Time', '24 min'),

          pw.SizedBox(height: 20),

          pw.Header(level: 1, text: 'Most Common Defects'),

          pw.Bullet(text: 'Pipe Not Connected'),
          pw.Bullet(text: 'Pipe Support Absent'),
          pw.Bullet(text: 'Surface Not Clean'),

          pw.SizedBox(height: 25),

          pw.Text(
            'This report is generated using mock inspection data for demonstration purposes only.',
            style: const pw.TextStyle(fontSize: 11),
          ),
        ],
      ),
    );

    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
    );
  }

  static pw.Widget _infoRow(String title, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 4),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(title),
          pw.Text(
            value,
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          ),
        ],
      ),
    );
  }
}