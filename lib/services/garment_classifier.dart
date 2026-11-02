// YOLO11n-cls (TFLite): jenis pakaian + confidence.
// Model : assets/models/yolo11n_cls.tflite  (input [1, 3, 224, 224] float32 NCHW, output [1, 15] softmax)
// Label : assets/models/labels.txt (urutan = names di model)
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter/services.dart' show rootBundle;
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

class Prediction {
  const Prediction(this.label, this.confidence);
  final String label;

  /// Softmax top-1, 0..1. Bukan probabilitas terkalibrasi (lihat confidentThreshold di outfit_engine.dart).
  final double confidence;
}

/// Ukuran sisi input model. Harus sama dengan --imgsz saat training dan export.
const int modelImageSize = 224;

/// Decode foto, perbaiki rotasi EXIF, resize sisi pendek ke 224, center crop, lalu susun tensor NCHW 0..1.
///
/// Fungsi top-level agar bisa dijalankan lewat compute(): decode foto 12 MP memakan 1-2 detik dan
/// akan membekukan UI bila dijalankan di isolate utama. Mengembalikan null bila gambar tidak terbaca.
Float32List? preprocessForModel(Uint8List bytes) {
  final decoded = img.decodeImage(bytes);
  if (decoded == null) return null;
  // Foto kamera HP sering membawa rotasi di EXIF; tanpa ini foto vertikal terbaca miring.
  final src = img.bakeOrientation(decoded);
  final scale =
      modelImageSize / (src.width < src.height ? src.width : src.height);
  final resized = img.copyResize(
    src,
    width: (src.width * scale).round(),
    height: (src.height * scale).round(),
  );
  final cropped = img.copyCrop(
    resized,
    x: (resized.width - modelImageSize) ~/ 2,
    y: (resized.height - modelImageSize) ~/ 2,
    width: modelImageSize,
    height: modelImageSize,
  );
  const plane = modelImageSize * modelImageSize;
  // NCHW: seluruh piksel R, lalu seluruh G, lalu seluruh B.
  final out = Float32List(3 * plane);
  for (var y = 0; y < modelImageSize; y++) {
    for (var x = 0; x < modelImageSize; x++) {
      final p = cropped.getPixel(x, y);
      final i = y * modelImageSize + x;
      out[i] = p.r / 255.0;
      out[plane + i] = p.g / 255.0;
      out[2 * plane + i] = p.b / 255.0;
    }
  }
  return out;
}

class GarmentClassifier {
  GarmentClassifier._(this._interp, this.labels);

  final Interpreter _interp;
  final List<String> labels;

  static Future<GarmentClassifier> load() async {
    final interp = await Interpreter.fromAsset(
      'assets/models/yolo11n_cls.tflite',
    );
    // labels.txt dibuat di Windows sehingga baris berakhir CRLF. Tanpa trim, label menjadi "shoes\r".
    final raw = await rootBundle.loadString('assets/models/labels.txt');
    final labels = raw
        .split(RegExp(r'\r?\n'))
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
    final outShape = interp.getOutputTensor(0).shape;
    if (outShape.last != labels.length) {
      throw StateError(
        'Jumlah output model (${outShape.last}) tidak sama dengan jumlah label (${labels.length})',
      );
    }
    return GarmentClassifier._(interp, labels);
  }

  /// Top-k prediksi dari tensor hasil [preprocessForModel]. Inferensi 224x224 ringan, aman di isolate utama.
  List<Prediction> predictInput(Float32List input, {int k = 3}) {
    final shaped = input.reshape([1, 3, modelImageSize, modelImageSize]);
    final output = List.filled(labels.length, 0.0).reshape([1, labels.length]);
    _interp.run(shaped, output);
    var probs = List<double>.from(
      (output[0] as List).map((e) => (e as num).toDouble()),
    );
    final sum = probs.fold<double>(0, (a, b) => a + b);
    // Model hasil export sudah softmax (jumlah 1). Berjaga bila export lain mengeluarkan logit.
    if ((sum - 1).abs() > 0.01) {
      final mx = probs.reduce((a, b) => a > b ? a : b);
      final ex = probs.map((v) => math.exp(v - mx)).toList();
      final s = ex.fold<double>(0, (a, b) => a + b);
      probs = ex.map((v) => v / s).toList();
    }
    final idx = List.generate(labels.length, (i) => i)
      ..sort((a, b) => probs[b].compareTo(probs[a]));
    return idx.take(k).map((i) => Prediction(labels[i], probs[i])).toList();
  }

  void close() => _interp.close();
}
