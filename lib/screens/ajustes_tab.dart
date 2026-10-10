import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../services/media_service.dart';

/// Pantalla de ajustes: muestra el estado real del permiso de
/// camara y permite abrir la configuracion del sistema.
class AjustesTab extends StatefulWidget {
  final MediaService mediaService;

  const AjustesTab({super.key, required this.mediaService});

  @override
  State<AjustesTab> createState() => _AjustesTabState();
}

class _AjustesTabState extends State<AjustesTab> {
  PermissionStatus? _estado;

  @override
  void initState() {
    super.initState();
    _cargarEstado();
  }

  Future<void> _cargarEstado() async {
    final estado = await widget.mediaService.estadoPermisoCamara();
    if (mounted) setState(() => _estado = estado);
  }

  String _etiqueta(PermissionStatus? e) {
    if (e == null) return 'Desconocido';
    if (e.isGranted) return 'Concedido';
    if (e.isPermanentlyDenied) return 'Denegado permanente';
    if (e.isDenied) return 'Denegado';
    return e.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Estado de permisos', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 10),
          _filaAjuste('Cámara', _etiqueta(_estado)),
          const SizedBox(height: 8),
          _filaAjuste('Galería / Fotos', 'Concedido (Photo Picker)'),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: _cargarEstado,
            icon: const Icon(Icons.refresh),
            label: const Text('Actualizar estado'),
          ),
          const SizedBox(height: 10),
          FilledButton.tonalIcon(
            onPressed: () async {
              await widget.mediaService.abrirAjustesSistema();
            },
            icon: const Icon(Icons.settings_outlined),
            label: const Text('Abrir Ajustes del sistema'),
          ),
          const SizedBox(height: 14),
          Text(
            'Si el permiso quedó en "Denegado permanente", Android/iOS ya '
            'no permiten volver a solicitarlo desde la app: la única '
            'salida es redirigir al usuario a Ajustes, como hace el botón '
            'de arriba (openAppSettings() de permission_handler).',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _filaAjuste(String label, String valor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(label), Text(valor, style: const TextStyle(fontWeight: FontWeight.w600))],
      ),
    );
  }
}
