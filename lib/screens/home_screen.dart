import 'package:flutter/material.dart';
import '../models/captured_image.dart';
import '../services/media_service.dart';
import 'foto_tab.dart';
import 'seleccion_tab.dart';
import 'historial_tab.dart';
import 'ajustes_tab.dart';

/// Pantalla principal: contiene las 4 pestanas y el estado
/// compartido (historial de imagenes) de la demo.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final MediaService _mediaService = MediaService();
  final List<CapturedImage> _historial = [];
  int _tabIndex = 0;

  void _agregarUna(CapturedImage img) {
    setState(() => _historial.insert(0, img));
  }

  void _agregarVarias(List<CapturedImage> imgs) {
    setState(() => _historial.insertAll(0, imgs));
  }

  void _eliminar(int index) {
    setState(() => _historial.removeAt(index));
  }

  @override
  Widget build(BuildContext context) {
    final pantallas = [
      FotoTab(mediaService: _mediaService, onImagenLista: _agregarUna),
      SeleccionTab(mediaService: _mediaService, onImagenesListas: _agregarVarias),
      HistorialTab(historial: _historial, onEliminar: _eliminar),
      AjustesTab(mediaService: _mediaService),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Demo · Cámara y Galería'),
        centerTitle: false,
      ),
      body: IndexedStack(index: _tabIndex, children: pantallas),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tabIndex,
        onDestinationSelected: (i) => setState(() => _tabIndex = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.camera_alt_outlined), label: 'Foto'),
          NavigationDestination(icon: Icon(Icons.photo_library_outlined), label: 'Selección'),
          NavigationDestination(icon: Icon(Icons.history), label: 'Historial'),
          NavigationDestination(icon: Icon(Icons.settings_outlined), label: 'Ajustes'),
        ],
      ),
    );
  }
}
