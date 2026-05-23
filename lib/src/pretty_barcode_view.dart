import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:barcode/barcode.dart';
import 'package:flutter/widgets.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart' as pretty_qr;

import 'pretty_barcode_options.dart';

/// A Flutter widget that renders any [Barcode] and uses pretty QR rendering
/// when [barcode] is [Barcode.qrCode].
class PrettyBarcodeView extends StatelessWidget {
  /// Creates a barcode view from String data.
  const PrettyBarcodeView({
    required this.data,
    required this.barcode,
    super.key,
    this.width,
    this.height,
    this.options = const PrettyBarcodeOptions(),
  }) : bytes = null;

  /// Creates a barcode view from bytes.
  const PrettyBarcodeView.bytes({
    required Uint8List this.bytes,
    required this.barcode,
    super.key,
    this.width,
    this.height,
    this.options = const PrettyBarcodeOptions(),
  }) : data = null;

  /// Creates a pretty QR code view.
  PrettyBarcodeView.qr({
    required String this.data,
    super.key,
    this.width,
    this.height,
    PrettyBarcodeOptions options = const PrettyBarcodeOptions(),
    int? typeNumber,
    BarcodeQRCorrectionLevel errorCorrectLevel =
        BarcodeQRCorrectionLevel.medium,
  }) : bytes = null,
       options = options.copyWith(
         qr: options.qr.copyWith(
           typeNumber: () => typeNumber,
           errorCorrectLevel: errorCorrectLevel.toPrettyQrErrorCorrectLevel(),
         ),
       ),
       barcode = Barcode.qrCode(
         typeNumber: typeNumber,
         errorCorrectLevel: errorCorrectLevel,
       );

  /// Creates a Code 128 barcode view.
  PrettyBarcodeView.code128({
    required String this.data,
    super.key,
    this.width,
    this.height,
    this.options = const PrettyBarcodeOptions(),
    bool useCode128A = true,
    bool useCode128B = true,
    bool useCode128C = true,
    bool escapes = false,
  }) : bytes = null,
       barcode = Barcode.code128(
         useCode128A: useCode128A,
         useCode128B: useCode128B,
         useCode128C: useCode128C,
         escapes: escapes,
       );

  /// Creates an EAN-13 barcode view.
  PrettyBarcodeView.ean13({
    required String this.data,
    super.key,
    this.width,
    this.height,
    this.options = const PrettyBarcodeOptions(),
    bool drawEndChar = false,
  }) : bytes = null,
       barcode = Barcode.ean13(drawEndChar: drawEndChar);

  /// Barcode String payload.
  final String? data;

  /// Barcode byte payload.
  final Uint8List? bytes;

  /// Barcode encoder from package:barcode.
  final Barcode barcode;

  /// Requested widget width.
  final double? width;

  /// Requested widget height.
  final double? height;

  /// Paint and QR rendering options.
  final PrettyBarcodeOptions options;

  @override
  Widget build(BuildContext context) {
    final effectiveWidth = width ?? 200;
    final effectiveHeight = height ?? width ?? 200;
    final child = barcode.name == 'QR-Code' && options.qr.enabled
        ? _buildPrettyQr()
        : CustomPaint(
            size: Size(effectiveWidth, effectiveHeight),
            painter: _BarcodePainter(
              barcode: barcode,
              data: data,
              bytes: bytes,
              color: options.color,
              drawText: options.drawText,
              textStyle: DefaultTextStyle.of(
                context,
              ).style.merge(options.textStyle),
              textPadding: options.textPadding,
            ),
          );

    return SizedBox(
      width: effectiveWidth,
      height: effectiveHeight,
      child: ColoredBox(
        color: options.backgroundColor ?? const Color(0x00000000),
        child: child,
      ),
    );
  }

  Widget _buildPrettyQr() {
    final payload = bytes != null
        ? pretty_qr.QrPayload.fromTypedData(bytes!)
        : pretty_qr.QrPayload.fromString(data!);
    final qrCode = pretty_qr.QrCode(
      payload: payload,
      errorCorrectLevel: options.qr.errorCorrectLevel,
      minTypeNumber: options.qr.typeNumber ?? 1,
    );
    if (options.qr.typeNumber != null &&
        qrCode.typeNumber != options.qr.typeNumber) {
      throw ArgumentError(
        'The QR code data is too large for typeNumber '
        '${options.qr.typeNumber}.',
      );
    }
    final qrImage = options.qr.maskPattern == null
        ? pretty_qr.QrImage(qrCode)
        : pretty_qr.QrImage.withMaskPattern(qrCode, options.qr.maskPattern!);

    return pretty_qr.PrettyQrView(
      qrImage: qrImage,
      decoration: options.qr.decoration,
    );
  }
}

class _BarcodePainter extends CustomPainter {
  const _BarcodePainter({
    required this.barcode,
    required this.data,
    required this.bytes,
    required this.color,
    required this.drawText,
    required this.textStyle,
    required this.textPadding,
  });

  final Barcode barcode;
  final String? data;
  final Uint8List? bytes;
  final Color color;
  final bool drawText;
  final TextStyle textStyle;
  final double? textPadding;

  @override
  void paint(Canvas canvas, Size size) {
    final fontSize = textStyle.fontSize ?? size.height * 0.2;
    final recipe = bytes != null
        ? barcode.makeBytes(
            bytes!,
            width: size.width,
            height: size.height,
            drawText: drawText,
            fontHeight: fontSize,
            textPadding: textPadding ?? size.height * 0.05,
          )
        : barcode.make(
            data!,
            width: size.width,
            height: size.height,
            drawText: drawText,
            fontHeight: fontSize,
            textPadding: textPadding ?? size.height * 0.05,
          );

    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = color;

    for (final element in recipe) {
      if (element is BarcodeBar && element.black) {
        canvas.drawRect(
          Rect.fromLTWH(
            element.left,
            element.top,
            element.width,
            element.height,
          ),
          paint,
        );
      } else if (element is BarcodeText) {
        _paintText(canvas, element, fontSize);
      }
    }
  }

  void _paintText(Canvas canvas, BarcodeText text, double fontSize) {
    final paragraphStyle = ui.ParagraphStyle(
      fontFamily: textStyle.fontFamily,
      fontSize: text.height,
      textAlign: _textAlign(text.align),
    );
    final paragraphBuilder = ui.ParagraphBuilder(paragraphStyle)
      ..pushStyle(
        ui.TextStyle(
          color: textStyle.color ?? color,
          fontSize: text.height,
          fontFamily: textStyle.fontFamily,
          fontWeight: textStyle.fontWeight,
          fontStyle: textStyle.fontStyle,
        ),
      )
      ..addText(text.text);
    final paragraph = paragraphBuilder.build()
      ..layout(ui.ParagraphConstraints(width: text.width));

    canvas.drawParagraph(paragraph, Offset(text.left, text.top));
  }

  ui.TextAlign _textAlign(BarcodeTextAlign align) {
    switch (align) {
      case BarcodeTextAlign.left:
        return ui.TextAlign.left;
      case BarcodeTextAlign.center:
        return ui.TextAlign.center;
      case BarcodeTextAlign.right:
        return ui.TextAlign.right;
    }
  }

  @override
  bool shouldRepaint(covariant _BarcodePainter oldDelegate) {
    return oldDelegate.barcode != barcode ||
        oldDelegate.data != data ||
        oldDelegate.bytes != bytes ||
        oldDelegate.color != color ||
        oldDelegate.drawText != drawText ||
        oldDelegate.textStyle != textStyle ||
        oldDelegate.textPadding != textPadding;
  }
}
