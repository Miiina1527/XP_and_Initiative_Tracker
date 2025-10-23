import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../providers/jugadores_provider.dart';

class CombateScreen extends ConsumerWidget {
  final int? campaignSlot;
  const CombateScreen({super.key, this.campaignSlot});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // If a campaignSlot is provided and the per-slot jugadores box is open, read from provider family
    final jugadores = (campaignSlot != null && Hive.isBoxOpen('jugadores_slot_$campaignSlot'))
        ? ref.watch(jugadoresProviderForSlot(campaignSlot!))
        : ref.watch(jugadoresProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Iniciativa y Combate')),
      body: ListView.builder(
        itemCount: jugadores.length,
        itemBuilder: (context, index) {
          final j = jugadores[index];
          return ListTile(
            title: Text(j.nombre),
            subtitle: Text(
                'Daño: ${j.danoHecho} | Acciones clase: ${j.accionesClase} | Acciones heroicas: ${j.accionesHeroicas}'),
            trailing: IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                // Aquí agregar lógica para sumar acciones o daño
              },
            ),
          );
        },
      ),
    );
  }
}
