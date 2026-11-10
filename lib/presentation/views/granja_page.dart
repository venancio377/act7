import 'package:flutter/material.dart';

import '../../domain/entities/animal.dart';
import '../viewmodels/granja_view_model.dart';
import '../widgets/animal_presentation.dart';
import 'detalle_animal_page.dart';

class GranjaPage extends StatefulWidget {
  final GranjaViewModel viewModel;

  const GranjaPage({super.key, required this.viewModel});

  @override
  State<GranjaPage> createState() => _GranjaPageState();
}

class _GranjaPageState extends State<GranjaPage> {
  final _busquedaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.viewModel.cargar();
  }

  @override
  void dispose() {
    _busquedaController.dispose();
    super.dispose();
  }

  Future<void> _mostrarFormulario() async {
    final animal = await showDialog<Animal>(
      context: context,
      builder: (context) => const _AgregarAnimalDialog(),
    );
    if (animal == null || !mounted) return;

    final agregado = await widget.viewModel.agregar(animal);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          agregado
              ? '${animal.nombre} se agregó a la granja'
              : widget.viewModel.error ?? 'Ocurrió un error inesperado.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.viewModel,
      builder: (context, _) {
        final vm = widget.viewModel;
        if (vm.cargando) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (vm.error != null && vm.animales.isEmpty) {
          return Scaffold(
            appBar: AppBar(title: const Text('Mi Granja')),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(vm.error!, textAlign: TextAlign.center),
                    const SizedBox(height: 12),
                    FilledButton(
                      onPressed: vm.cargar,
                      child: const Text('Reintentar'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        final filtrados = vm.animalesFiltrados;
        return Scaffold(
          appBar: AppBar(
            title: const Text('Mi Granja'),
            actions: [
              IconButton(
                tooltip: 'Agregar animal',
                onPressed: _mostrarFormulario,
                icon: const Icon(Icons.add),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F2DC),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '¡Bienvenido a tu granja! 🌱',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text('Lleva el registro de tus animales en un solo lugar.'),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _ResumenCard(
                    titulo: 'Animales',
                    valor: '${vm.animales.length}',
                    icono: Icons.pets,
                  ),
                  const SizedBox(width: 12),
                  _ResumenCard(
                    titulo: 'Especies',
                    valor: '${vm.cantidadEspecies}',
                    icono: Icons.category_outlined,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _busquedaController,
                decoration: InputDecoration(
                  labelText: 'Buscar animal',
                  hintText: 'Nombre o especie',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _busquedaController.text.isEmpty
                      ? null
                      : IconButton(
                          tooltip: 'Limpiar búsqueda',
                          onPressed: () {
                            _busquedaController.clear();
                            vm.buscar('');
                          },
                          icon: const Icon(Icons.close),
                        ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                onChanged: vm.buscar,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: vm.filtroEspecie,
                decoration: InputDecoration(
                  labelText: 'Filtrar por especie',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                items: ['Todos', ...GranjaViewModel.especies]
                    .map(
                      (especie) => DropdownMenuItem(
                        value: especie,
                        child: Text(especie),
                      ),
                    )
                    .toList(),
                onChanged: (valor) {
                  if (valor != null) vm.cambiarFiltro(valor);
                },
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Mis animales',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text('${filtrados.length} registrados'),
                ],
              ),
              const SizedBox(height: 8),
              if (filtrados.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 36),
                  child: Column(
                    children: [
                      Icon(Icons.search_off, size: 44, color: Colors.grey),
                      SizedBox(height: 8),
                      Text('No encontramos animales con esa búsqueda.'),
                    ],
                  ),
                )
              else
                ...filtrados.map(
                  (animal) => Card(
                    color: Colors.white,
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 4,
                      ),
                      leading: CircleAvatar(
                        backgroundColor: const Color(0xFFE8F2DC),
                        child: Text(
                          AnimalPresentation.emoji(animal.especie),
                          style: const TextStyle(fontSize: 24),
                        ),
                      ),
                      title: Text(
                        animal.nombre,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(animal.especie),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => DetalleAnimalPage(animal: animal),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: _mostrarFormulario,
            icon: const Icon(Icons.add),
            label: const Text('Agregar animal'),
          ),
        );
      },
    );
  }
}

class _ResumenCard extends StatelessWidget {
  final String titulo;
  final String valor;
  final IconData icono;

  const _ResumenCard({
    required this.titulo,
    required this.valor,
    required this.icono,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(icono, color: const Color(0xFF558B2F), size: 28),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    valor,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(titulo),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AgregarAnimalDialog extends StatefulWidget {
  const _AgregarAnimalDialog();

  @override
  State<_AgregarAnimalDialog> createState() => _AgregarAnimalDialogState();
}

class _AgregarAnimalDialogState extends State<_AgregarAnimalDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  String _especie = GranjaViewModel.especies.first;

  @override
  void dispose() {
    _nombreController.dispose();
    super.dispose();
  }

  void _guardar() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.of(context)
        .pop(Animal(nombre: _nombreController.text.trim(), especie: _especie));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Agregar animal'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nombreController,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: 'Nombre',
                hintText: 'Ej. Lola',
              ),
              validator: (valor) => valor == null || valor.trim().isEmpty
                  ? 'Escribe el nombre del animal'
                  : null,
              onFieldSubmitted: (_) => _guardar(),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _especie,
              decoration: const InputDecoration(labelText: 'Especie'),
              items: GranjaViewModel.especies
                  .map(
                    (especie) =>
                        DropdownMenuItem(value: especie, child: Text(especie)),
                  )
                  .toList(),
              onChanged: (valor) {
                if (valor != null) setState(() => _especie = valor);
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        FilledButton(onPressed: _guardar, child: const Text('Guardar')),
      ],
    );
  }
}
