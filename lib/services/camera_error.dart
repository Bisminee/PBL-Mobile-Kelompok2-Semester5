import 'package:camera/camera.dart';

/// Pesan error kamera dalam Bahasa Indonesia beserta penanda apakah pengguna
/// perlu membuka pengaturan aplikasi untuk memberi izin.
class CameraErrorInfo {
  const CameraErrorInfo(this.message, {this.permissionDenied = false});

  final String message;
  final bool permissionDenied;
}

/// Menerjemahkan [CameraException] dari plugin kamera ke pesan yang tampil di
/// layar. Deskripsi asli tidak dipakai karena berbahasa Inggris.
CameraErrorInfo describeCameraError(CameraException e) {
  switch (e.code) {
    case 'CameraAccessDenied':
    case 'CameraAccessDeniedWithoutPrompt':
      return const CameraErrorInfo(
        'Izin kamera ditolak. Buka pengaturan untuk mengizinkan akses kamera.',
        permissionDenied: true,
      );
    case 'CameraAccessRestricted':
      return const CameraErrorInfo('Akses kamera dibatasi di perangkat ini.');
    case 'CameraNotFound':
      return const CameraErrorInfo('Kamera tidak ditemukan di perangkat ini.');
    default:
      return const CameraErrorInfo(
        'Kamera tidak bisa digunakan. Coba muat ulang.',
      );
  }
}
