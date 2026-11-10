import '../entities/animal.dart';
import '../repositories/animal_repository.dart';

class AgregarAnimal {
  final AnimalRepository _repository;

  const AgregarAnimal(this._repository);

  Future<void> call(Animal animal) => _repository.agregarAnimal(animal);
}
