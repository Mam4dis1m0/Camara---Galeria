import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

/// Resultado de solicitar un permiso, para que la UI decida
/// que mensaje o pantalla mostrar.
enum PermisoResultado { concedido, denegado, permanentementeDenegado }

/// Centraliza el acceso a camara y galeria, junto con el manejo
/// de permisos en Android e iOS.
class MediaService {
  final ImagePicker _picker = ImagePicker();

  /// Revisa y, si hace falta, solicita el permiso de camara.
  /// Devuelve el estado final para que la pantalla reaccione
  /// (por ejemplo, mostrando un dialogo para ir a Ajustes).
  Future<PermisoResultado> solicitarPermisoCamara() async {
    var estado = await Permission.camera.status;

    if (estado.isGranted) {
      return PermisoResultado.concedido;
    }

    if (estado.isPermanentlyDenied || estado.isRestricted) {
      return PermisoResultado.permanentementeDenegado;
    }

    estado = await Permission.camera.request();

    if (estado.isGranted) {
      return PermisoResultado.concedido;
    } else if (estado.isPermanentlyDenied) {
      return PermisoResultado.permanentementeDenegado;
    } else {
      return PermisoResultado.denegado;
    }
  }

  /// Abre la camara del sistema. Retorna null si el usuario
  /// cancela o si no hay permiso.
  Future<File?> tomarFoto() async {
    final permiso = await solicitarPermisoCamara();
    if (permiso != PermisoResultado.concedido) return null;

    final XFile? foto = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
      maxWidth: 1280,
    );
    return foto == null ? null : File(foto.path);
  }

  /// Abre el selector de fotos del sistema (Photo Picker en Android
  /// reciente / selector nativo en iOS). No requiere permiso explicito
  /// cuando el picker usa el selector del sistema.
  Future<File?> elegirDeGaleria() async {
    final XFile? foto = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    return foto == null ? null : File(foto.path);
  }

  /// Permite elegir varias imagenes de una vez (subida por lote).
  Future<List<File>> elegirVarias() async {
    final List<XFile> archivos = await _picker.pickMultiImage(
      imageQuality: 80,
    );
    return archivos.map((x) => File(x.path)).toList();
  }

  /// Util para la pantalla de Ajustes: abre la configuracion del
  /// sistema cuando el permiso quedo permanentemente denegado.
  Future<void> abrirAjustesSistema() async {
    await openAppSettings();
  }

  /// Consulta el estado actual del permiso sin solicitarlo,
  /// para pintar el badge de estado en la UI.
  Future<PermissionStatus> estadoPermisoCamara() {
    return Permission.camera.status;
  }
}
