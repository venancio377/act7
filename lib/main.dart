import 'package:flutter/material.dart';

import 'data/repositories/animal_repository_memoria.dart';
import 'domain/usecases/agregar_animal.dart';
import 'domain/usecases/obtener_animales.dart';
import 'presentation/viewmodels/granja_view_model.dart';
import 'presentation/views/granja_page.dart';

void main() {
  final repository = AnimalRepositoryMemoria();
  final viewModel = GranjaViewModel(
    ObtenerAnimales(repository),
    AgregarAnimal(repository),
  );
  runApp(GranjaApp(viewModel: viewModel));
}

class GranjaApp extends StatelessWidget {
  final GranjaViewModel viewModel;

  const GranjaApp({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    const verde = Color(0xFF558B2F);
    return MaterialApp(
      title: 'Mi Granja',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: verde),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF7F8F3),
        appBarTheme: const AppBarTheme(
          backgroundColor: verde,
          foregroundColor: Colors.white,
        ),
      ),
      home: GranjaPage(viewModel: viewModel),
    );
  }
}
