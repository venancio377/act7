import 'package:flutter/material.dart';

import '../../domain/entities/animal.dart';
import '../widgets/animal_presentation.dart';

class DetalleAnimalPage extends StatelessWidget {
  final Animal animal;

  const DetalleAnimalPage({super.key, required this.animal});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(animal.nombre)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 64,
                backgroundColor: const Color(0xFFE8F2DC),
                child: Text(
                  AnimalPresentation.emoji(animal.especie),
                  style: const TextStyle(fontSize: 68),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                animal.nombre,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Chip(
                avatar: Icon(
                  AnimalPresentation.icono(animal.especie),
                  size: 18,
                ),
                label: Text(animal.especie),
              ),
              const SizedBox(height: 12),
              const Text(
                'Este animal forma parte de tu granja.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
