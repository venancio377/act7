import 'package:flutter/foundation.dart';

import '../../domain/entities/animal.dart';
import '../../domain/usecases/agregar_animal.dart';
import '../../domain/usecases/obtener_animales.dart';

class GranjaViewModel extends ChangeNotifier {
  final ObtenerAnimales _obtenerAnimales;
  final AgregarAnimal _agregarAnimal;

  GranjaViewModel(this._obtenerAnimales, this._agregarAnimal);

  static const especies = [
    'Vaca',
    'Gallina',
    'Cerdo',
    'Oveja',
    'Caballo',
    'Otro',
  ];

  List<Animal> _animales = [];
  String _busqueda = '';
  String _filtroEspecie = 'Todos';
  bool _cargando = false;
  String? _error;

  List<Animal> get animales => List.unmodifiable(_animales);
  String? get error => _error;
  bool get cargando => _cargando;
  String get filtroEspecie => _filtroEspecie;
  int get cantidadEspecies => _animales.map((a) => a.especie).toSet().length;

  List<Animal> get animalesFiltrados {
    final consulta = _busqueda.toLowerCase();
    return _animales.where((animal) {
      final coincideEspecie =
          _filtroEspecie == 'Todos' || animal.especie == _filtroEspecie;
      final coincideBusqueda =
          animal.nombre.toLowerCase().contains(consulta) ||
          animal.especie.toLowerCase().contains(consulta);
      return coincideEspecie && coincideBusqueda;
    }).toList();
  }

  Future<void> cargar() async {
    _cargando = true;
    _error = null;
    notifyListeners();
    try {
      _animales = await _obtenerAnimales();
    } catch (error) {
      _error = 'No se pudieron cargar los animales: $error';
    } finally {
      _cargando = false;
      notifyListeners();
    }
  }

  void buscar(String consulta) {
    _busqueda = consulta.trim();
    notifyListeners();
  }

  void cambiarFiltro(String especie) {
    _filtroEspecie = especie;
    notifyListeners();
  }

  Future<bool> agregar(Animal animal) async {
    _error = null;
    try {
      await _agregarAnimal(animal);
      _animales = [..._animales, animal];
      notifyListeners();
      return true;
    } catch (error) {
      _error = 'No se pudo agregar ${animal.nombre}: $error';
      notifyListeners();
      return false;
    }
  }
}
