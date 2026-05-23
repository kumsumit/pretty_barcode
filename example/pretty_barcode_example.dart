import 'package:pretty_barcode/pretty_barcode.dart';

void main() {
  final code128 = PrettyBarcodeSvg(
    barcode: Barcode.code128(),
    data: 'Pretty Barcode',
  ).toSvg();
  final qr = PrettyBarcodeSvg(
    barcode: Barcode.qrCode(),
    data: 'https://example.com',
    options: PrettyBarcodeOptions(
      qr: PrettyBarcodeQrOptions(
        decoration: PrettyQrDecoration.fromPreset(
          PrettyQrDecorationPreset.smooth,
        ),
      ),
    ),
  ).toSvg(width: 200, height: 200);

  print('Code 128 SVG length: ${code128.length}');
  print('QR SVG length: ${qr.length}');
}
