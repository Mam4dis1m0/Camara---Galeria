import 'dart:io';
import 'package:flutter/material.dart';
import '../models/captured_image.dart';
import '../services/media_service.dart';

/// Pestana de seleccion multiple: elegir varias imagenes de la
/// galeria a la vez y "subirlas" juntas (pickMultiImage).
class SeleccionTab extends StatefulWidget {
  final MediaService mediaService;
  final void Function(List<CapturedImage>) onImagenesListas;

  const SeleccionTab({
    super.key,
    required this.mediaService,
    required this.onImagenesListas,
  });

  @override
  State<SeleccionTab> createState() => _SeleccionTabState();
}

class _SeleccionTabState extends State<SeleccionTab> {
  List<File> _seleccion = [];
  bool _subiendo = false;

  Future<void> _elegirVarias() async {
    final archivos = await widget.mediaService.elegirVarias();
    if (archivos.isNotEmpty) {
      setState(() => _seleccion = archivos);
    }
  }

  Future<void> _subirSeleccion() async {
    setState(() => _subiendo = true);
    await Future.delayed(const Duration(milliseconds: 700));

    final ahora = DateTime.now();
    final imagenes = _seleccion
        .map((f) => CapturedImage(
              file: f,
              origen: 'galería (multi)',
              hora: ahora,
            ))
        .toList();

    widget.onImagenesListas(imagenes);

    if (!mounted) return;
    setState(() {
      _subiendo = false;
      _seleccion = [];
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${imagenes.length} imágenes subidas')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Elige varias imágenes de la galería a la vez, como al '
            'subir varias evidencias en una sola operación.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: _elegirVarias,
            icon: const Icon(Icons.add_photo_alternate_outlined),
            label: const Text('Elegir varias imágenes'),
          ),
          const SizedBox(height: 14),
          if (_seleccion.isEmpty)
            const Expanded(
              child: Center(child: Text('Aún no has elegido imágenes.')),
            )
          else
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 6,
                  mainAxisSpacing: 6,
                ),
                itemCount: _seleccion.length,
                itemBuilder: (_, i) => ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(_seleccion[i], fit: BoxFit.cover),
                ),
              ),
            ),
          if (_seleccion.isNotEmpty) ...[
            const SizedBox(height: 10),
            FilledButton.icon(
              onPressed: _subiendo ? null : _subirSeleccion,
              icon: _subiendo
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.upload_outlined),
              label: Text(_subiendo ? 'Subiendo...' : 'Subir seleccionadas'),
            ),
          ],
        ],
      ),
    );
  }
}
