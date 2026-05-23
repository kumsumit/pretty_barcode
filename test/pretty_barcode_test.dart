import 'package:pretty_barcode/pretty_barcode.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('exports barcode encoders', () {
    final svg = PrettyBarcodeSvg(
      barcode: Barcode.code128(),
      data: 'Pretty Barcode',
    ).toSvg();

    expect(svg, contains('<svg'));
    expect(svg, contains('<path'));
  });

  test('exports pretty QR SVG', () {
    final svg = PrettyBarcodeSvg(
      barcode: Barcode.qrCode(),
      data: 'Pretty QR',
    ).toSvg(width: 128, height: 128);

    expect(svg, contains('<svg'));
    expect(svg, contains('shape-rendering="crispEdges"'));
  });

  testWidgets('renders pretty QR path', (tester) async {
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: PrettyBarcodeView(
          barcode: Barcode.qrCode(),
          data: 'Pretty QR',
          width: 128,
          height: 128,
          options: const PrettyBarcodeOptions(
            qr: PrettyBarcodeQrOptions(decoration: PrettyQrDecoration()),
          ),
        ),
      ),
    );

    expect(find.byType(PrettyBarcodeView), findsOneWidget);
    expect(find.byType(PrettyQrView), findsOneWidget);
  });

  testWidgets('renders non-QR barcode path', (tester) async {
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: PrettyBarcodeView(
          barcode: Barcode.code128(),
          data: 'Pretty Barcode',
          width: 240,
          height: 80,
        ),
      ),
    );

    expect(find.byType(PrettyBarcodeView), findsOneWidget);
    expect(find.byType(CustomPaint), findsOneWidget);
  });
}
