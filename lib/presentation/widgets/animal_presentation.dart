import 'package:flutter/material.dart';

class AnimalPresentation {
  const AnimalPresentation._();

  static String emoji(String especie) => switch (especie) {
    'Vaca' => '🐄',
    'Gallina' => '🐔',
    'Cerdo' => '🐖',
    'Oveja' => '🐑',
    'Caballo' => '🐎',
    _ => '🐾',
  };

  static IconData icono(String especie) => switch (especie) {
    'Vaca' => Icons.agriculture,
    'Gallina' => Icons.egg_alt,
    'Cerdo' => Icons.pets,
    'Oveja' => Icons.grass,
    'Caballo' => Icons.directions_run,
    _ => Icons.pets,
  };
}
