import 'package:flutter/material.dart';
import 'package:notfallbereit/theme/app_styles.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';

class QRCodeDialog extends StatelessWidget {
  final Map<String, dynamic> emergencyProfile;

  const QRCodeDialog({super.key, required this.emergencyProfile});

  Future<void> downloadQRCode(BuildContext context) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Center(
            child: pw.Column(
              children: [
                pw.Text(
                  "Notfallbereit",
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 20),
                pw.BarcodeWidget(
                  data: emergencyProfile['qr_code_uuid'],
                  barcode: pw.Barcode.qrCode(),
                  width: 250,
                  height: 250,
                ),

                pw.Text(
                  "${emergencyProfile['first_name']} ${emergencyProfile['last_name']}",
                ),
              ],
            ),
          );
        },
      ),
    );

    await Printing.layoutPdf(onLayout: (_) async => pdf.save());
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Dialog(
      backgroundColor: const Color(0xFFA8C3A0),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),

          child: Column(
            children: [
              // Implementation help with faking the AppBar by !ChatGPT!
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 1, top: 12),
                  child: TextButton.icon(
                    onPressed: () => Navigator.pop(context),
                    style: AppStyles.fakeAppBar,
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 24,
                    ),
                    label: const Text('Zurück', style: AppStyles.appBarText),
                  ),
                ),
              ),

              AutoSizeText(
                'QR-Code abrufen',
                style: AppStyles.title,
                maxLines: 2,
                minFontSize: 34,
                textAlign: TextAlign.center,
              ),

              SizedBox(height: screenHeight * 0.05),

              if (screenWidth > 900)
                // Layout help by GPT
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('QR-Code:', style: AppStyles.labelNormalUnderline),

                        SizedBox(height: screenHeight * 0.02),

                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.black, width: 2),
                          ),
                          child: QrImageView(
                            data: emergencyProfile['qr_code_uuid'],
                            size: 250,
                            backgroundColor: Colors.white,
                          ),
                        ),

                        SizedBox(height: screenHeight * 0.08),
                      ],
                    ),

                    ElevatedButton(
                      onPressed: () => downloadQRCode(context),
                      style: AppStyles.button,
                      child: const Text(
                        'QR-Code herunterladen',
                        style: AppStyles.buttonText,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                )
              else
                Column(
                  children: [
                    Text('QR-Code:', style: AppStyles.labelNormalUnderline),

                    SizedBox(height: screenHeight * 0.02),

                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black, width: 2),
                      ),
                      child: QrImageView(
                        data: emergencyProfile['qr_code_uuid'],
                        size: 250,
                        backgroundColor: Colors.white,
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.09),

                    ElevatedButton(
                      onPressed: () => downloadQRCode(context),
                      style: AppStyles.button,
                      child: const Text(
                        'QR-Code herunterladen',
                        style: AppStyles.buttonText,
                        textAlign: TextAlign.center,
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.08),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
