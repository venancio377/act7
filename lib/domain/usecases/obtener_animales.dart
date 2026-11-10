import '../entities/animal.dart';
import '../repositories/animal_repository.dart';

class ObtenerAnimales {
  final AnimalRepository _repository;

  const ObtenerAnimales(this._repository);

  Future<List<Animal>> call() => _repository.obtenerAnimales();
}
