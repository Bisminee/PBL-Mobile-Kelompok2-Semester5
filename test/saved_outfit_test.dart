import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sera_z/models/garment.dart';
import 'package:sera_z/models/saved_outfit.dart';

void main() {
  const top = Garment(
    id: '1',
    category: 'Atasan',
    colorName: 'Hitam',
    colorValue: Color(0xFF1A1A1A),
    slot: 'top',
  );
  const bottom = Garment(
    id: '2',
    category: 'Bawahan',
    colorName: 'Biru',
    colorValue: Color(0xFF2F5D9E),
    slot: 'bottom',
  );

  test('outfit tersimpan bisa dibuka sebagai detail outfit', () {
    final saved = SavedOutfit(
      id: 7,
      name: 'Paduan Kantor',
      formality: 'formal',
      score: 0.84,
      createdAt: DateTime(2026, 11, 23),
      items: const [bottom, top],
    );

    final outfit = saved.toOutfit();

    expect(outfit, isNotNull);
    expect(outfit!.title, 'Paduan Kantor');
    expect(outfit.top.id, '1');
    expect(outfit.bottom.id, '2');
    expect(outfit.score, 0.84);
  });

  test('outfit tanpa pasangan tidak bisa dibuka sebagai detail', () {
    final saved = SavedOutfit(
      id: 8,
      name: 'Tidak Lengkap',
      formality: 'non_formal',
      score: 0.5,
      createdAt: DateTime(2026, 11, 23),
      items: const [top],
    );

    expect(saved.toOutfit(), isNull);
  });
}
