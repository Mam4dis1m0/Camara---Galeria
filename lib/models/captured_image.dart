import 'dart:io';

/// Representa una imagen capturada o elegida durante la sesion,
/// junto con el origen (camara o galeria) y la hora de captura.
class CapturedImage {
  final File file;
  final String origen; // "camara" | "galeria" | "galeria (multi)"
  final DateTime hora;

  CapturedImage({
    required this.file,
    required this.origen,
    required this.hora,
  });

  String get nombreArchivo => file.path.split('/').last;

  Future<int> get tamanoBytes async => file.length();
}
