import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

import 'package:barcode/barcode.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart' as pretty_qr;

import 'pretty_barcode_options.dart';

/// SVG export helpers for `pretty_barcode`.
///
/// Non-QR formats are exported through `package:barcode`.
///
/// QR codes are exported through `pretty_qr_code`'s portable QR SVG exporter.
/// That exporter preserves the QR matrix, color, background, and quiet zone,
/// but Flutter-only module shapes and embedded images are available only in
/// [PrettyBarcodeView].
class PrettyBarcodeSvg {
  /// Creates an SVG exporter from String data.
  const PrettyBarcodeSvg({
    required this.data,
    required this.barcode,
    this.options = const PrettyBarcodeOptions(),
  }) : bytes = null;

  /// Creates an SVG exporter from byte data.
  const PrettyBarcodeSvg.bytes({
    required Uint8List this.bytes,
    required this.barcode,
    this.options = const PrettyBarcodeOptions(),
  }) : data = null;

  /// Barcode String payload.
  final String? data;

  /// Barcode byte payload.
  final Uint8List? bytes;

  /// Barcode encoder from package:barcode.
  final Barcode barcode;

  /// Paint and QR export options.
  final PrettyBarcodeOptions options;

  /// Exports the barcode as SVG.
  String toSvg({
    double x = 0,
    double y = 0,
    double width = 200,
    double height = 80,
    bool fullSvg = true,
    String fontFamily = 'monospace',
    double? fontHeight,
    double? textPadding,
    double baseline = .75,
  }) {
    if (barcode.name == 'QR-Code' && options.qr.enabled) {
      return _qrToSvg(size: width < height ? width : height, fullSvg: fullSvg);
    }

    if (bytes != null) {
      return barcode.toSvgBytes(
        bytes!,
        x: x,
        y: y,
        width: width,
        height: height,
        drawText: options.drawText,
        fontFamily: fontFamily,
        fontHeight: fontHeight,
        textPadding: textPadding ?? options.textPadding,
        color: _rgb(options.color),
        fullSvg: fullSvg,
        baseline: baseline,
      );
    }

    return barcode.toSvg(
      data!,
      x: x,
      y: y,
      width: width,
      height: height,
      drawText: options.drawText,
      fontFamily: fontFamily,
      fontHeight: fontHeight,
      textPadding: textPadding ?? options.textPadding,
      color: _rgb(options.color),
      fullSvg: fullSvg,
      baseline: baseline,
    );
  }

  String _qrToSvg({required double size, required bool fullSvg}) {
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
    final svg = qrImage.toSvg(
      size: size.round(),
      dark: options.color,
      background: options.backgroundColor,
      quietZone:
          options.qr.decoration.quietZone ??
          pretty_qr.PrettyQrQuietZone.standard,
    );

    if (fullSvg) {
      return svg;
    }

    final bodyStart = svg.indexOf('>') + 1;
    final bodyEnd = svg.lastIndexOf('</svg>');
    return svg.substring(bodyStart, bodyEnd);
  }

  int _rgb(Color color) {
    return color.toARGB32() & 0x00ffffff;
  }

  /// Exports UTF-8 SVG bytes.
  Uint8List toSvgUtf8({
    double x = 0,
    double y = 0,
    double width = 200,
    double height = 80,
    bool fullSvg = true,
    String fontFamily = 'monospace',
    double? fontHeight,
    double? textPadding,
    double baseline = .75,
  }) {
    return Uint8List.fromList(
      utf8.encode(
        toSvg(
          x: x,
          y: y,
          width: width,
          height: height,
          fullSvg: fullSvg,
          fontFamily: fontFamily,
          fontHeight: fontHeight,
          textPadding: textPadding,
          baseline: baseline,
        ),
      ),
    );
  }
}
