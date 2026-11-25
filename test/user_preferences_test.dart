import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sera_z/models/garment.dart';
import 'package:sera_z/models/saved_outfit.dart';
import 'package:sera_z/services/user_preferences.dart';

void main() {
  test('preferensi diturunkan dari outfit tersimpan', () {
    const top = Garment(
      id: '1',
      category: 'Atasan',
      colorName: 'Hitam',
      colorValue: Color(0xFF1A1A1A),
      slot: 'top',
      colorFamily: 'black',
      style: 'casual',
    );
    const bottom = Garment(
      id: '2',
      category: 'Bawahan',
      colorName: 'Biru',
      colorValue: Color(0xFF2F5D9E),
      slot: 'bottom',
      colorFamily: 'blue',
      style: 'casual',
    );
    final outfits = [
      SavedOutfit(
        id: 1,
        name: 'A',
        formality: 'semi_formal',
        score: 0.8,
        createdAt: DateTime(2026),
        items: const [top, bottom],
      ),
      SavedOutfit(
        id: 2,
        name: 'B',
        formality: 'semi_formal',
        score: 0.7,
        createdAt: DateTime(2026),
        items: const [top, bottom],
      ),
    ];

    final prefs = UserPreferences.derive(outfits);

    expect(prefs.data['preferred_colors'], contains('black'));
    expect(prefs.data['preferred_formality'], 'semi_formal');
    expect(prefs.data['preferred_styles'], contains('casual'));
    expect(prefs.data['preferred_slots'], containsAll(['top', 'bottom']));
    expect(prefs.data['source'], 'saved_outfits');
  });

  test('json preferensi bisa dibaca ulang', () {
    final prefs = UserPreferences.empty();
    final parsed = UserPreferences.fromJson(prefs.encoded);
    expect(parsed, isNotNull);
    expect(parsed!.data['schema_version'], 1);
  });
}
