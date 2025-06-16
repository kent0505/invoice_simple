import 'dart:io';
import 'dart:typed_data';
import 'package:invoice_simple/core/utils.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

Future<Map<String, Uint8List?>> loadAndValidateImages(dynamic invoice) async {
  Uint8List? signatureBytes;
  Uint8List? invoiceBytes;

  try {
    if (invoice.businessAccount.imageSignature != null &&
        invoice.businessAccount.imageSignature!.trim().isNotEmpty) {
      final signaturePath = invoice.businessAccount.imageSignature!.trim();
      final signatureFile = File(signaturePath);

      if (await signatureFile.exists()) {
        final rawBytes = await signatureFile.readAsBytes();

        if (rawBytes.isNotEmpty && _isValidImageFormat(rawBytes)) {
          signatureBytes = rawBytes;
          logger('✅ Signature loaded: ${rawBytes.length} bytes');
        } else {
          logger('❌ Invalid signature format');
        }
      } else {
        logger('❌ Signature file not found: $signaturePath');
      }
    }
  } catch (e) {
    logger('❌ Error loading signature: $e');
  }

  try {
    if (invoice.imagePath.trim().isNotEmpty) {
      final imagePath = invoice.imagePath.trim();
      final imageFile = File(imagePath);

      if (await imageFile.exists()) {
        final rawBytes = await imageFile.readAsBytes();

        if (rawBytes.isNotEmpty && _isValidImageFormat(rawBytes)) {
          invoiceBytes = rawBytes;
          logger('✅ Invoice image loaded: ${rawBytes.length} bytes');
        } else {
          logger('❌ Invalid invoice image format');
        }
      } else {
        logger('❌ Invoice image file not found: $imagePath');
      }
    }
  } catch (e) {
    logger('❌ Error loading invoice image: $e');
  }

  return {
    'signature': signatureBytes,
    'invoice': invoiceBytes,
  };
}

bool _isValidImageFormat(Uint8List bytes) {
  if (bytes.length < 4) return false;

  if (bytes[0] == 0x89 &&
      bytes[1] == 0x50 &&
      bytes[2] == 0x4E &&
      bytes[3] == 0x47) {
    return true;
  }

  // JPEG signature: FF D8 FF
  if (bytes[0] == 0xFF && bytes[1] == 0xD8 && bytes[2] == 0xFF) {
    return true;
  }

  // WebP signature: 52 49 46 46 (RIFF)
  if (bytes[0] == 0x52 &&
      bytes[1] == 0x49 &&
      bytes[2] == 0x46 &&
      bytes[3] == 0x46) {
    return true;
  }

  return false;
}

pw.Widget buildSafeImage(
    Uint8List imageBytes, double width, double height, String label) {
  try {
    return pw.ClipRRect(
      horizontalRadius: 4,
      verticalRadius: 4,
      child: pw.Image(
        pw.MemoryImage(imageBytes),
        width: width,
        height: height,
        fit: pw.BoxFit.cover,
        dpi: 150,
      ),
    );
  } catch (e) {
    logger('❌ Error creating image widget for $label: $e');

    return pw.Container(
      width: width,
      height: height,
      decoration: pw.BoxDecoration(
        color: PdfColors.grey100,
        border: pw.Border.all(color: PdfColors.grey400, width: 1),
        borderRadius: pw.BorderRadius.circular(4),
      ),
      child: pw.Center(
        child: pw.Column(
          mainAxisAlignment: pw.MainAxisAlignment.center,
          children: [
            pw.Text(
              '📷',
              style: pw.TextStyle(fontSize: width * 0.3),
            ),
            pw.SizedBox(height: 2),
            pw.Text(
              'Image Error',
              style: pw.TextStyle(fontSize: 6, color: PdfColors.grey600),
            ),
          ],
        ),
      ),
    );
  }
}

pw.Widget buildImagesRow(Uint8List? signatureBytes, Uint8List? invoiceBytes) {
  if (signatureBytes == null && invoiceBytes == null) {
    return pw.SizedBox.shrink();
  }

  return pw.Container(
    margin: pw.EdgeInsets.symmetric(vertical: 10),
    child: pw.Row(
      mainAxisAlignment: _getMainAxisAlignment(signatureBytes, invoiceBytes),
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        if (invoiceBytes != null) ...[
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Invoice Image:',
                style: pw.TextStyle(
                  fontSize: 10,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.grey700,
                ),
              ),
              pw.SizedBox(height: 5),
              buildSafeImage(invoiceBytes, 150, 150, 'Invoice'),
            ],
          ),
        ],
        if (signatureBytes != null) ...[
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.SizedBox(height: 35),
              pw.Text(
                'Signature:',
                style: pw.TextStyle(
                  fontSize: 15,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Text(
                '____________________',
                style: pw.TextStyle(fontSize: 12),
              ),
              pw.SizedBox(height: 5),
              buildSafeImage(signatureBytes, 60, 40, 'Signature'),
            ],
          ),
        ],
      ],
    ),
  );
}

pw.MainAxisAlignment _getMainAxisAlignment(
  Uint8List? signatureBytes,
  Uint8List? invoiceBytes,
) {
  if (signatureBytes != null && invoiceBytes != null) {
    return pw.MainAxisAlignment.spaceBetween;
  } else if (signatureBytes != null) {
    return pw.MainAxisAlignment.end;
  } else {
    return pw.MainAxisAlignment.start;
  }
}
