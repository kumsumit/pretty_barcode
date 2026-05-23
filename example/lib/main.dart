import 'package:flutter/widgets.dart';
import 'package:pretty_barcode/pretty_barcode.dart';

void main() {
  runApp(const PrettyBarcodeExample());
}

class PrettyBarcodeExample extends StatelessWidget {
  const PrettyBarcodeExample({super.key});

  @override
  Widget build(BuildContext context) {
    return WidgetsApp(
      color: const Color(0xffffffff),
      builder: (context, child) {
        return const Directionality(
          textDirection: TextDirection.ltr,
          child: _ExamplePage(),
        );
      },
    );
  }
}

class _ExamplePage extends StatelessWidget {
  const _ExamplePage();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xffffffff),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 360),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                PrettyBarcodeView.code128(
                  data: 'ORDER-12345',
                  width: 320,
                  height: 96,
                ),
                const SizedBox(height: 32),
                PrettyBarcodeView.qr(
                  data: 'https://example.com/order/12345',
                  width: 220,
                  height: 220,
                  options: PrettyBarcodeOptions(
                    qr: PrettyBarcodeQrOptions(
                      decoration: PrettyQrDecoration.fromPreset(
                        PrettyQrDecorationPreset.smooth,
                        color: Color(0xff136f63),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
