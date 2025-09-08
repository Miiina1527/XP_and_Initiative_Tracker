import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/jugadores_provider.dart';

class AccionesScreen extends ConsumerWidget {
  const AccionesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jugadores = ref.watch(jugadoresProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Acciones')),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF5F0E1), Color(0xFFE0D6C3)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(14),
        child: ListView.builder(
          itemCount: jugadores.length,
          itemBuilder: (context, index) {
            final jugador = jugadores[index];
            final int maxHp = jugador.maxHp > 0 ? jugador.maxHp : 1;
            final double porcentajeHP =
                (jugador.hp / maxHp).clamp(0.0, 1.0);

            return Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: jugador.esEnemigo
                          ? Colors.redAccent
                          : Colors.blueAccent,
                      child: Icon(
                        jugador.esEnemigo
                            ? Icons.warning
                            : Icons.person,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            jugador.nombre +
                                (jugador.esEnemigo ? " (Enemigo)" : ""),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text("❤️ HP: ${jugador.hp} / $maxHp"),
                          const SizedBox(height: 4),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: LinearProgressIndicator(
                              value: porcentajeHP,
                              minHeight: 10,
                              backgroundColor: Colors.grey[300],
                              valueColor: AlwaysStoppedAnimation<Color>(
                                porcentajeHP > 0.5
                                    ? Colors.green
                                    : (porcentajeHP > 0.25
                                        ? Colors.orange
                                        : Colors.red),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Clase: ${jugador.accionesClase} | Heroica: ${jugador.accionesHeroicas}',
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      children: [
                        if (!jugador.esEnemigo) ...[
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 6),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            icon: const Icon(Icons.school, size: 18),
                            label: const Text("Clase"),
                            onPressed: () {
                              final nuevoClase =
                                  jugador.accionesClase + 1;
                              ref
                                  .read(jugadoresProvider.notifier)
                                  .actualizarJugador(
                                    index,
                                    jugador.copyWith(
                                        accionesClase: nuevoClase),
                                  );
                            },
                          ),
                          const SizedBox(height: 6),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.amber,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 6),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            icon: const Icon(Icons.star, size: 18),
                            label: const Text("Heroica"),
                            onPressed: () {
                              final nuevoHeroicas =
                                  jugador.accionesHeroicas + 1;
                              ref
                                  .read(jugadoresProvider.notifier)
                                  .actualizarJugador(
                                    index,
                                    jugador.copyWith(
                                        accionesHeroicas:
                                            nuevoHeroicas),
                                  );
                            },
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
