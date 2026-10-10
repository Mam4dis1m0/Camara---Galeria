import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/captured_image.dart';

/// Muestra las imagenes capturadas o subidas durante la sesion.
class HistorialTab extends StatelessWidget {
  final List<CapturedImage> historial;
  final void Function(int index) onEliminar;

  const HistorialTab({
    super.key,
    required this.historial,
    required this.onEliminar,
  });

  @override
  Widget build(BuildContext context) {
    if (historial.isEmpty) {
      return const Center(
        child: Text('Las fotos que tomes o subas aparecerán aquí.'),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: historial.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, i) {
        final item = historial[i];
        return Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(9),
                child: Image.file(
                  item.file,
                  width: 46,
                  height: 46,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.nombreArchivo,
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12.5),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '${item.origen} · ${DateFormat.Hm().format(item.hora)}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, size: 18, color: Colors.red),
                onPressed: () => onEliminar(i),
              ),
            ],
          ),
        );
      },
    );
  }
}
