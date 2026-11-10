import '../../domain/entities/animal.dart';
import '../../domain/repositories/animal_repository.dart';

class AnimalRepositoryMemoria implements AnimalRepository {
  final List<Animal> _animales = [
    const Animal(nombre: 'Lola', especie: 'Vaca'),
    const Animal(nombre: 'Pepa', especie: 'Gallina'),
    const Animal(nombre: 'Toby', especie: 'Cerdo'),
    const Animal(nombre: 'Nube', especie: 'Oveja'),
    const Animal(nombre: 'Relámpago', especie: 'Caballo'),
  ];

  @override
  Future<List<Animal>> obtenerAnimales() async => List.unmodifiable(_animales);

  @override
  Future<void> agregarAnimal(Animal animal) async {
    _animales.add(animal);
  }
}
