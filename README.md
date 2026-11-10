# Mi Granja

Aplicación Flutter para consultar y registrar animales de una granja. Incluye
animales de ejemplo, búsqueda por nombre o especie, filtro, registro de animales
y una pantalla de detalle.

## Arquitectura

El proyecto separa las responsabilidades en tres capas:

- `lib/domain`: entidad `Animal`, contrato del repositorio y casos de uso. No
  depende de Flutter ni de la capa de datos.
- `lib/data`: implementación en memoria del repositorio. Los registros duran
  mientras la aplicación está abierta; todavía no se guardan al cerrar.
- `lib/presentation`: vistas y `GranjaViewModel`, que conecta la interfaz con
  los casos de uso.
- `lib/main.dart`: composición de dependencias e inicio de la aplicación.

## Ejecutar

Desde esta carpeta:

```bash
flutter pub get
flutter run
```

Para validar el proyecto:

```bash
flutter analyze
flutter test
```
