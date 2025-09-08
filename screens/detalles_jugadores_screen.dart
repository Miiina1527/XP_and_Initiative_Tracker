import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/jugadores_provider.dart';

class DetallesJugadoresScreen extends ConsumerWidget {
  const DetallesJugadoresScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jugadores = ref.watch(jugadoresProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles de los Jugadores'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF5F0E1), Color(0xFFE0D6C3)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView.builder(
          itemCount: jugadores.length,
          itemBuilder: (context, index) {
            final jugador = jugadores[index];
            final int maxHp = jugador.maxHp > 0 ? jugador.maxHp : 1;
            final double porcentajeHP =
                (jugador.hp / maxHp).clamp(0.0, 1.0);
            (jugador.xp / (jugador.nivel * 100)).clamp(0.0, 1.0);

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Encabezado con avatar e info básica
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: jugador.esEnemigo
                              ? Colors.redAccent
                              : Colors.blueAccent,
                          child: Icon(
                            jugador.esEnemigo ? Icons.warning : Icons.person,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Text(
                            jugador.nombre,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (jugador.died)
                          const Icon(Icons.close, color: Colors.red, size: 28),
                      ],
                    ),

                    const SizedBox(height: 14),

                    // Datos con íconos
                    _buildStatRow(Icons.favorite, "HP",
                        "${jugador.hp} / $maxHp"),
                    _buildProgressBar(porcentajeHP, Colors.red),

                    const SizedBox(height: 8),

                    _buildStatRow(Icons.shield, "AC", jugador.ac.toString()),
                    _buildStatRow(Icons.star, "Nivel", jugador.nivel.toString()),

                    _buildStatRow(
                        Icons.flash_on, "Iniciativa", jugador.iniciativa.toString()),

                    const SizedBox(height: 8),

                    _buildStatRow(Icons.auto_fix_high, "Acciones Clase",
                        jugador.accionesClase.toString()),
                    _buildStatRow(Icons.workspace_premium, "Acciones Heroicas",
                        jugador.accionesHeroicas.toString()),

                    const Divider(height: 20),

                    // Datos acumulados
                    Text(
                      "📊 Datos Acumulados",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 6),
                    _buildStatRow(Icons.auto_fix_high_outlined,
                        "Clase Acumuladas", jugador.accionesClaseAcumuladas.toString()),
                    _buildStatRow(Icons.workspace_premium_outlined,
                        "Heroicas Acumuladas", jugador.accionesHeroicasAcumuladas.toString()),

                    const SizedBox(height: 8),
                    _buildStatRow(Icons.emoji_events, "XP Ganada",
                        jugador.gainedxp.toString()),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildStatRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey[700]),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              "$label:",
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Text(value),
        ],
      ),
    );
  }

  Widget _buildProgressBar(double value, Color color) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: LinearProgressIndicator(
        value: value,
        minHeight: 8,
        backgroundColor: Colors.grey[300],
        valueColor: AlwaysStoppedAnimation<Color>(color),
      ),
    );
  }
}
