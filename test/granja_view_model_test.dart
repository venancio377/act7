import 'package:flutter_test/flutter_test.dart';
import 'package:granja/data/repositories/animal_repository_memoria.dart';
import 'package:granja/domain/entities/animal.dart';
import 'package:granja/domain/usecases/agregar_animal.dart';
import 'package:granja/domain/usecases/obtener_animales.dart';
import 'package:granja/presentation/viewmodels/granja_view_model.dart';

void main() {
  late GranjaViewModel viewModel;

  setUp(() {
    final repository = AnimalRepositoryMemoria();
    viewModel = GranjaViewModel(
      ObtenerAnimales(repository),
      AgregarAnimal(repository),
    );
  });

  tearDown(() => viewModel.dispose());

  test('carga los animales iniciales y cuenta sus especies', () async {
    await viewModel.cargar();

    expect(viewModel.animales, hasLength(5));
    expect(viewModel.cantidadEspecies, 5);
    expect(viewModel.cargando, isFalse);
    expect(viewModel.error, isNull);
  });

  test('filtra por especie y por texto de búsqueda', () async {
    await viewModel.cargar();
    viewModel.cambiarFiltro('Gallina');
    viewModel.buscar('pep');

    expect(viewModel.animalesFiltrados, [
      const Animal(nombre: 'Pepa', especie: 'Gallina'),
    ]);
  });

  test('agrega un animal a través del caso de uso', () async {
    await viewModel.cargar();
    const animal = Animal(nombre: 'Molly', especie: 'Oveja');

    expect(await viewModel.agregar(animal), isTrue);
    expect(viewModel.animales, contains(animal));
    expect(viewModel.animales, hasLength(6));
  });
}
