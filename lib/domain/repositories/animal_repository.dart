import '../entities/animal.dart';

abstract interface class AnimalRepository {
  Future<List<Animal>> obtenerAnimales();
  Future<void> agregarAnimal(Animal animal);
}
