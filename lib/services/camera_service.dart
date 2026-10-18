import 'package:camera/camera.dart';

/// Holds the list of cameras available on the device.
///
/// Initialized once in `main()` before the app starts.
class CameraService {
  CameraService._();

  static List<CameraDescription> cameras = <CameraDescription>[];

  static Future<void> init() async {
    try {
      cameras = await availableCameras();
    } on CameraException {
      cameras = <CameraDescription>[];
    }
  }
}
