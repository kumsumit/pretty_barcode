# pretty_barcode

`pretty_barcode` combines the broad encoder support of `package:barcode` with
the QR styling system from `package:pretty_qr_code`.

It is a Flutter package:

- all barcode encoders from `package:barcode` are re-exported
- all pretty QR decorations, shapes, quiet zones, and QR primitives are
  re-exported
- `PrettyBarcodeView` renders any barcode type
- `PrettyBarcodeSvg` exports any barcode type to SVG
- QR codes use `PrettyQrView` by default, so they can use smooth, rounded,
  dotted, image, and quiet-zone styling
- non-QR formats are painted with the generic drawing operations from
  `package:barcode`

## Usage

```dart
import 'package:flutter/widgets.dart';
import 'package:pretty_barcode/pretty_barcode.dart';

class TicketCode extends StatelessWidget {
  const TicketCode({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PrettyBarcodeView(
          barcode: Barcode.code128(),
          data: 'ORDER-12345',
          width: 260,
          height: 90,
        ),
        PrettyBarcodeView.qr(
          data: 'https://example.com/order/12345',
          width: 180,
          height: 180,
          options: PrettyBarcodeOptions(
            qr: PrettyBarcodeQrOptions(
              decoration: PrettyQrDecoration.fromPreset(
                PrettyQrDecorationPreset.smooth,
                color: const Color(0xff136f63),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
```

## SVG

```dart
final svg = PrettyBarcodeSvg(
  barcode: Barcode.code128(),
  data: 'ORDER-12345',
).toSvg(width: 260, height: 90);

final qrSvg = PrettyBarcodeSvg(
  barcode: Barcode.qrCode(),
  data: 'https://example.com/order/12345',
  options: PrettyBarcodeOptions(
    qr: PrettyBarcodeQrOptions(
      decoration: PrettyQrDecoration.fromPreset(
        PrettyQrDecorationPreset.smooth,
      ),
    ),
  ),
).toSvg(width: 180, height: 180);
```

## Options

Use `PrettyBarcodeOptions` for common rendering options:

- `color`
- `backgroundColor`
- `drawText`
- `textStyle`
- `textPadding`
- `qr`

Use `PrettyBarcodeQrOptions` for QR-specific rendering:

- `enabled`
- `decoration`
- `errorCorrectLevel`
- `typeNumber`
- `maskPattern`

## Current Scope

The first bridge keeps the two original packages intact and composes them:

- `Barcode.code128()`, `Barcode.ean13()`, `Barcode.pdf417()`,
  `Barcode.dataMatrix()`, and the rest come from `package:barcode`.
- QR styling comes from `package:pretty_qr_code`.
- The package currently uses local path dependencies while it is being
  developed in this workspace.
