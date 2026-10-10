import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

/// Chip de color que muestra el estado actual del permiso de camara.
class PermissionBadge extends StatelessWidget {
  final PermissionStatus? estado;

  const PermissionBadge({super.key, required this.estado});

  @override
  Widget build(BuildContext context) {
    late Color color;
    late Color textColor;
    late String texto;

    if (estado == null) {
      color = const Color(0xFFFEF3C7);
      textColor = const Color(0xFF92400E);
      texto = 'PERMISO CÁMARA: no solicitado';
    } else if (estado!.isGranted) {
      color = const Color(0xFFD1FAE5);
      textColor = const Color(0xFF065F46);
      texto = 'PERMISO CÁMARA: concedido';
    } else if (estado!.isPermanentlyDenied) {
      color = const Color(0xFFFEE2E2);
      textColor = const Color(0xFF991B1B);
      texto = 'PERMISO CÁMARA: denegado permanente';
    } else {
      color = const Color(0xFFFEE2E2);
      textColor = const Color(0xFF991B1B);
      texto = 'PERMISO CÁMARA: denegado';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(999)),
      child: Text(
        texto,
        style: TextStyle(color: textColor, fontSize: 11, fontWeight: FontWeight.w700),
      ),
    );
  }
}
