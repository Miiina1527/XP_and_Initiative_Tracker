import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/jugador.dart';
import '../providers/jugadores_provider.dart';
import '../providers/combate_provider.dart';
import 'turno_screen.dart';

class IniciativaScreen extends ConsumerStatefulWidget {
  const IniciativaScreen({super.key});

  @override
  ConsumerState<IniciativaScreen> createState() => _IniciativaScreenState();
}

class _IniciativaScreenState extends ConsumerState<IniciativaScreen> {
  final Map<int, TextEditingController> _controllers = {};

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final jugadores = ref.watch(jugadoresProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F0E6), // tono pergamino
      appBar: AppBar(
        title: const Text('⚔️ Iniciativa'),
        backgroundColor: const Color(0xFF8B5E3C), // marrón cálido
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Expanded(
              child: jugadores.isEmpty
                  ? const Center(
                      child: Text(
                        'No hay personajes registrados.\nAgrega algunos en "Datos".',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                      ),
                    )
                  : ListView.builder(
                      itemCount: jugadores.length,
                      itemBuilder: (context, index) {
                        final jugador = jugadores[index];

                        if (!_controllers.containsKey(index)) {
                          _controllers[index] = TextEditingController(
                            text: jugador.iniciativa.toString(),
                          );
                        }

                        final controller = _controllers[index]!;

                        return Card(
                          color: const Color(0xFFFFF8E7), // beige más claro
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: const BorderSide(color: Color(0xFF8B5E3C), width: 1),
                          ),
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: jugador.esEnemigo
                                  ? Colors.red.shade300
                                  : Colors.green.shade300,
                              child: Text(
                                jugador.nombre.isNotEmpty
                                    ? jugador.nombre[0].toUpperCase()
                                    : '?',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            title: Text(
                              jugador.nombre,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              jugador.esEnemigo ? "Enemigo" : "Jugador",
                              style: TextStyle(
                                color: jugador.esEnemigo
                                    ? Colors.red.shade600
                                    : Colors.green.shade600,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            trailing: SizedBox(
                              width: 90,
                              child: TextField(
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: '⚔️ Ini',
                                  border: OutlineInputBorder(),
                                  isDense: true,
                                ),
                                controller: controller,
                                onChanged: (v) {
                                  final ini = int.tryParse(v) ?? 0;
                                  ref.read(jugadoresProvider.notifier).actualizarJugador(
                                        index,
                                        jugador.copyWith(iniciativa: ini),
                                      );
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              icon: const Icon(Icons.sports_martial_arts, size: 20),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8B5E3C),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: jugadores.isEmpty
                  ? null
                  : () {
                      final jugadoresConIniciativa = List<Jugador>.from(jugadores);
                      jugadoresConIniciativa.sort(
                          (a, b) => b.iniciativa.compareTo(a.iniciativa));

                      ref
                          .read(combateProvider.notifier)
                          .iniciarCombate(jugadoresConIniciativa);

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const TurnoScreen()),
                      );
                    },
              label: const Text(
                'Iniciar Combate',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
