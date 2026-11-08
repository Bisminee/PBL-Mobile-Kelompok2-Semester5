import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter/material.dart' show Rect;
import 'package:image/image.dart' as img;

/// Sisi hasil crop. Cukup untuk layar detail dan thumbnail.
const int croppedPhotoSide = 1024;

/// Kotak crop ternormalisasi 0..1 terhadap gambar asli.
class CropSpec {
  const CropSpec({
    this.left = 0,
    this.top = 0,
    this.width = 1,
    this.height = 1,
  });

  final double left;
  final double top;
  final double width;
  final double height;

  static const full = CropSpec();
}

/// Mengubah kotak crop dalam piksel menjadi [CropSpec] yang dijepit ke batas
/// gambar, sehingga nilai di luar area tidak pernah tersimpan.
CropSpec cropSpecFromRect(Rect rect, int imageWidth, int imageHeight) {
  if (imageWidth <= 0 || imageHeight <= 0) return CropSpec.full;
  final left = (rect.left / imageWidth).clamp(0.0, 1.0);
  final top = (rect.top / imageHeight).clamp(0.0, 1.0);
  final width = (rect.width / imageWidth).clamp(0.0, 1.0 - left);
  final height = (rect.height / imageHeight).clamp(0.0, 1.0 - top);
  return CropSpec(left: left, top: top, width: width, height: height);
}

/// Ukuran gambar tanpa menyimpan hasil decode. Dipakai untuk memetakan kotak
/// crop dari layar ke koordinat gambar.
({int width, int height})? imageSizeOf(Uint8List bytes) {
  final decoded = img.decodeImage(bytes);
  if (decoded == null) return null;
  return (width: decoded.width, height: decoded.height);
}

/// Putar gambar 90 derajat searah jarum jam. Mengembalikan null bila gagal.
///
/// Rotasi dilakukan sebelum crop lewat `CropController.image`, karena widget
/// crop tidak menyediakan tombol putar sendiri.
Uint8List? rotatePhoto(Uint8List bytes) {
  final decoded = img.decodeImage(bytes);
  if (decoded == null) return null;
  final src = img.bakeOrientation(decoded);
  final rotated = img.copyRotate(src, angle: 90);
  return img.encodeJpg(rotated, quality: 92);
}

/// Mengecilkan hasil crop ke sisi maksimal [maxSide]. Gambar yang lebih kecil
/// tidak diperbesar agar tidak kehilangan ketajaman.
Uint8List? shrinkCropped(Uint8List bytes, {int maxSide = croppedPhotoSide}) {
  final decoded = img.decodeImage(bytes);
  if (decoded == null) return null;
  final longest = math.max(decoded.width, decoded.height);
  final resized = longest <= maxSide
      ? decoded
      : img.copyResize(
          decoded,
          width: decoded.width >= decoded.height ? maxSide : null,
          height: decoded.height > decoded.width ? maxSide : null,
        );
  return img.encodeJpg(resized, quality: 90);
}
