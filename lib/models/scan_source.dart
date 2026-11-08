/// Asal foto yang sedang diproses.
enum ScanSource { camera, gallery }

/// Argumen rute pratinjau foto. Dipakai `go_router` lewat `extra`.
class PreviewArgs {
  const PreviewArgs(this.path, this.source);

  final String path;
  final ScanSource source;
}
