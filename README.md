# Demo Cámara y Galería — Prototipo real en Flutter

Proyecto Flutter funcional (no una simulación en HTML) que implementa
el flujo explicado en la exposición: captura de fotos con la cámara,
selección desde la galería, selección múltiple, historial y manejo
real de permisos en Android e iOS.

## Cómo correrlo

Este zip trae solo la carpeta `lib/` y el `pubspec.yaml` (el código
Dart), no el proyecto nativo completo (`android/`, `ios/`), porque eso
lo genera Flutter automáticamente. Pasos:

```bash
# 1. Crea un proyecto Flutter nuevo
flutter create demo_camara_galeria
cd demo_camara_galeria

# 2. Reemplaza pubspec.yaml y la carpeta lib/ por las de este zip
#    (sobrescribe los archivos generados por flutter create)

# 3. Instala las dependencias
flutter pub get

# 4. Agrega los permisos (ver siguiente sección)

# 5. Corre en un dispositivo o emulador conectado
flutter run
```

## Agregar los permisos

**Android** — copia el contenido de `android_config/AndroidManifest_permisos.xml`
dentro de `<manifest>` en `android/app/src/main/AndroidManifest.xml`.

**iOS** — copia el contenido de `ios_config/Info_permisos.plist`
dentro de `<dict>` en `ios/Runner/Info.plist`.

Sin estos permisos la app se cerrará (iOS) o el picker fallará
silenciosamente (Android) al intentar usar la cámara.

## Estructura del proyecto

```
lib/
  main.dart                  # Punto de entrada, MaterialApp con tema claro/oscuro
  models/
    captured_image.dart      # Modelo de una imagen capturada (archivo, origen, hora)
  services/
    media_service.dart       # Lógica real: permission_handler + image_picker
  widgets/
    permission_badge.dart    # Chip que muestra el estado del permiso
  screens/
    home_screen.dart         # Scaffold con NavigationBar de 4 pestañas
    foto_tab.dart             # Tomar foto / elegir de galería + permisos + subida simulada
    seleccion_tab.dart        # pickMultiImage() — selección y "subida" por lote
    historial_tab.dart        # Lista de imágenes capturadas en la sesión
    ajustes_tab.dart          # Estado del permiso + acceso a Ajustes del sistema
```

## Qué es real y qué es demo

- **Real:** la cámara, la galería, la selección múltiple y la
  solicitud de permisos usan los paquetes oficiales `image_picker` y
  `permission_handler` — esto funciona igual en un dispositivo real.
- **Simulado solo para la demo:** la "subida al backend" (barra de
  progreso con `Future.delayed`). En un proyecto real ahí iría una
  petición HTTP (`http`, `dio`) a tu propio servidor o a un servicio
  como Cloudinary/Firebase Storage.
- **En memoria:** el historial vive en el estado de `HomeScreen`
  (`List<CapturedImage>`) y se pierde al cerrar la app. Para
  persistirlo se podría usar `shared_preferences`, `sqflite` o un
  backend real.

## Dependencias (pubspec.yaml)

- `image_picker` — abrir cámara/galería y seleccionar varias imágenes
- `permission_handler` — solicitar y consultar permisos
- `intl` — formatear la hora en el historial
