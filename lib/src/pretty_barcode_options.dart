import 'package:flutter/widgets.dart';
import 'package:barcode/barcode.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart' as pretty_qr;

/// QR rendering options for [PrettyBarcodeView].
class PrettyBarcodeQrOptions {
  /// Creates QR rendering options.
  const PrettyBarcodeQrOptions({
    this.enabled = true,
    this.decoration = const pretty_qr.PrettyQrDecoration(),
    this.errorCorrectLevel = pretty_qr.QrErrorCorrectLevel.medium,
    this.typeNumber,
    this.maskPattern,
  }) : assert(typeNumber == null || (typeNumber >= 1 && typeNumber <= 40)),
       assert(maskPattern == null || (maskPattern >= 0 && maskPattern <= 7));

  /// Render QR codes with `pretty_qr_code`.
  ///
  /// When false, QR codes use the generic `barcode` painter.
  final bool enabled;

  /// Decoration used by the pretty QR renderer.
  final pretty_qr.PrettyQrDecoration decoration;

  /// Error correction level used by the pretty QR renderer.
  final pretty_qr.QrErrorCorrectLevel errorCorrectLevel;

  /// QR version number, or null for automatic sizing.
  final int? typeNumber;

  /// QR mask pattern, or null for automatic selection.
  final int? maskPattern;

  /// Creates a copy with changed fields.
  PrettyBarcodeQrOptions copyWith({
    bool? enabled,
    pretty_qr.PrettyQrDecoration? decoration,
    pretty_qr.QrErrorCorrectLevel? errorCorrectLevel,
    ValueGetter<int?>? typeNumber,
    ValueGetter<int?>? maskPattern,
  }) {
    return PrettyBarcodeQrOptions(
      enabled: enabled ?? this.enabled,
      decoration: decoration ?? this.decoration,
      errorCorrectLevel: errorCorrectLevel ?? this.errorCorrectLevel,
      typeNumber: typeNumber == null ? this.typeNumber : typeNumber(),
      maskPattern: maskPattern == null ? this.maskPattern : maskPattern(),
    );
  }

  /// Creates options from a `package:barcode` QR correction level.
  PrettyBarcodeQrOptions withBarcodeCorrectionLevel(
    BarcodeQRCorrectionLevel value,
  ) {
    return copyWith(errorCorrectLevel: value.toPrettyQrErrorCorrectLevel());
  }

  @override
  int get hashCode {
    return Object.hash(
      enabled,
      decoration,
      errorCorrectLevel,
      typeNumber,
      maskPattern,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is PrettyBarcodeQrOptions &&
        other.enabled == enabled &&
        other.decoration == decoration &&
        other.errorCorrectLevel == errorCorrectLevel &&
        other.typeNumber == typeNumber &&
        other.maskPattern == maskPattern;
  }
}

/// Conversion helpers between `barcode` and `pretty_qr_code` QR levels.
extension PrettyBarcodeQrCorrectionLevel on BarcodeQRCorrectionLevel {
  /// Converts to the equivalent `pretty_qr_code` error correction level.
  pretty_qr.QrErrorCorrectLevel toPrettyQrErrorCorrectLevel() {
    switch (this) {
      case BarcodeQRCorrectionLevel.low:
        return pretty_qr.QrErrorCorrectLevel.low;
      case BarcodeQRCorrectionLevel.medium:
        return pretty_qr.QrErrorCorrectLevel.medium;
      case BarcodeQRCorrectionLevel.quartile:
        return pretty_qr.QrErrorCorrectLevel.quartile;
      case BarcodeQRCorrectionLevel.high:
        return pretty_qr.QrErrorCorrectLevel.high;
    }
  }
}

/// Common barcode layout and paint options.
class PrettyBarcodeOptions {
  /// Creates common barcode options.
  const PrettyBarcodeOptions({
    this.color = const Color(0xff000000),
    this.backgroundColor,
    this.drawText = true,
    this.textStyle,
    this.textPadding,
    this.qr = const PrettyBarcodeQrOptions(),
  }) : assert(textPadding == null || textPadding >= 0);

  /// Foreground color for generic barcode formats.
  final Color color;

  /// Optional background color.
  final Color? backgroundColor;

  /// Draw human-readable text for barcode formats that support it.
  final bool drawText;

  /// Text style for human-readable barcode text.
  final TextStyle? textStyle;

  /// Padding between bars and human-readable barcode text.
  final double? textPadding;

  /// QR rendering options.
  final PrettyBarcodeQrOptions qr;

  /// Creates a copy with changed fields.
  PrettyBarcodeOptions copyWith({
    Color? color,
    ValueGetter<Color?>? backgroundColor,
    bool? drawText,
    ValueGetter<TextStyle?>? textStyle,
    ValueGetter<double?>? textPadding,
    PrettyBarcodeQrOptions? qr,
  }) {
    return PrettyBarcodeOptions(
      color: color ?? this.color,
      backgroundColor: backgroundColor == null
          ? this.backgroundColor
          : backgroundColor(),
      drawText: drawText ?? this.drawText,
      textStyle: textStyle == null ? this.textStyle : textStyle(),
      textPadding: textPadding == null ? this.textPadding : textPadding(),
      qr: qr ?? this.qr,
    );
  }

  @override
  int get hashCode {
    return Object.hash(
      color,
      backgroundColor,
      drawText,
      textStyle,
      textPadding,
      qr,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is PrettyBarcodeOptions &&
        other.color == color &&
        other.backgroundColor == backgroundColor &&
        other.drawText == drawText &&
        other.textStyle == textStyle &&
        other.textPadding == textPadding &&
        other.qr == qr;
  }
}
