import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:hive/hive.dart';
import 'package:flutter/services.dart'; // For haptic feedback

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  ScannerScreenState createState() => ScannerScreenState();
}

class ScannerScreenState extends State<ScannerScreen> {
  String scannedData = "Scan a QR code"; // Default text
  final Box<String> scannedCodesBox = Hive.box<String>('scannedCodes');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Code Scanner'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                    color: Theme.of(context).colorScheme.primary, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: MobileScanner(
                onDetect: (BarcodeCapture barcodeCapture) {
                  String scannedCode =
                      barcodeCapture.barcodes.first.rawValue ?? "Unknown";

                  // Provide haptic feedback when a QR code is successfully scanned
                  HapticFeedback.mediumImpact();

                  // Show a SnackBar when a QR code is successfully scanned
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("QR Code Scanned: $scannedCode"),
                      duration: const Duration(seconds: 2),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                    ),
                  );

                  setState(() {
                    scannedData = scannedCode;
                    scannedCodesBox
                        .add(scannedCode); // Store scanned data in Hive
                  });
                },
              ),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    spreadRadius: 1,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                scannedData,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Display stored codes
              final storedCodes = scannedCodesBox.values.toList();
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Scanned Codes'),
                    content: SizedBox(
                      height: 200,
                      width: 300,
                      child: ListView.builder(
                        itemCount: storedCodes.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(storedCodes[index]),
                          );
                        },
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Close'),
                      ),
                    ],
                  );
                },
              );
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text('Show Scanned Codes'),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
