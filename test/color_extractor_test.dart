import 'package:flutter_test/flutter_test.dart';
import 'package:sera_z/services/color_extractor.dart';

void main() {
  test('rgbToFamily untuk warna jelas', () {
    expect(rgbToFamily(0, 0, 0), 'black');
    expect(rgbToFamily(255, 255, 255), 'white');
    expect(rgbToFamily(128, 128, 128), 'gray');
    expect(rgbToFamily(200, 30, 30), 'red');
    expect(rgbToFamily(30, 60, 200), 'blue');
    expect(rgbToFamily(40, 160, 60), 'green');
  });
}
