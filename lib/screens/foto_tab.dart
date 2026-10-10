import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/captured_image.dart';
import '../services/media_service.dart';
import '../widgets/permission_badge.dart';

/// Pestana principal: tomar una foto o elegir una de la galeria,
/// con manejo real de permisos y una vista previa.
class FotoTab extends StatefulWidget {
  final MediaService mediaService;
  final void Function(CapturedImage) onImagenLista;

  const FotoTab({
    super.key,
    required this.mediaService,
    required this.onImagenLista,
  });

  @override
  State<FotoTab> createState() => _FotoTabState();
}

class _FotoTabState extends State<FotoTab> {
  File? _preview;
  bool _subiendo = false;
  double _progreso = 0;
  PermissionStatus? _estadoPermiso;

  @override
  void initState() {
    super.initState();
    _refrescarPermiso();
  }

  Future<void> _refrescarPermiso() async {
    final estado = await widget.mediaService.estadoPermisoCamara();
    if (mounted) setState(() => _estadoPermiso = estado);
  }

  Future<void> _onTomarFoto() async {
    final resultado = await widget.mediaService.solicitarPermisoCamara();
    await _refrescarPermiso();

    if (resultado == PermisoResultado.permanentementeDenegado) {
      if (!mounted) return;
      _mostrarDialogoAjustes();
      return;
    }
    if (resultado == PermisoResultado.denegado) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permiso de cámara denegado')),
      );
      return;
    }

    final foto = await widget.mediaService.tomarFoto();
    if (foto != null) _procesarImagen(foto, 'cámara');
  }

  Future<void> _onElegirGaleria() async {
    final foto = await widget.mediaService.elegirDeGaleria();
    if (foto != null) _procesarImagen(foto, 'galería');
  }

  void _mostrarDialogoAjustes() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Permiso denegado permanentemente'),
        content: const Text(
          'Activa el permiso de cámara manualmente desde Ajustes '
          'del sistema para poder usar esta función.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cerrar'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              widget.mediaService.abrirAjustesSistema();
            },
            child: const Text('Ir a Ajustes'),
          ),
        ],
      ),
    );
  }

  Future<void> _procesarImagen(File archivo, String origen) async {
    setState(() {
      _preview = archivo;
      _subiendo = true;
      _progreso = 0;
    });

    // Simulacion de subida a un backend (por ejemplo Cloudinary o
    // un endpoint propio). En un caso real aqui iria un
    // http.MultipartRequest o un paquete como dio/http.
    for (var i = 0; i <= 10; i++) {
      await Future.delayed(const Duration(milliseconds: 90));
      if (!mounted) return;
      setState(() => _progreso = i / 10);
    }

    setState(() => _subiendo = false);

    widget.onImagenLista(
      CapturedImage(file: archivo, origen: origen, hora: DateTime.now()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PermissionBadge(estado: _estadoPermiso),
          const SizedBox(height: 12),
          Container(
            height: 220,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Theme.of(context).colorScheme.outlineVariant,
                width: 2,
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: _preview == null
                ? const Center(
                    child: Text(
                      'Aquí se mostrará la vista previa de la foto',
                      textAlign: TextAlign.center,
                    ),
                  )
                : Image.file(_preview!, fit: BoxFit.cover),
          ),
          if (_subiendo) ...[
            const SizedBox(height: 10),
            LinearProgressIndicator(value: _progreso),
            const SizedBox(height: 4),
            Text(
              _progreso < 1 ? 'Subiendo al backend...' : '✔ Subida completa',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: _onTomarFoto,
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Tomar foto'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _onElegirGaleria,
                  icon: const Icon(Icons.photo_library_outlined),
                  label: const Text('Galería'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
