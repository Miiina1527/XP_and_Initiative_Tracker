import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:easy_localization/easy_localization.dart';
import '../providers/jugadores_provider.dart';

class DetallesJugadoresScreen extends ConsumerWidget {
  final int? campaignSlot;
  const DetallesJugadoresScreen({super.key, this.campaignSlot});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
  final jugadoresAll = campaignSlot != null && Hive.isBoxOpen('jugadores_slot_$campaignSlot')
    ? ref.watch(jugadoresProviderForSlot(campaignSlot!))
    : ref.watch(jugadoresProvider);
  final jugadores = jugadoresAll.where((j) => !j.esEnemigo).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text("player_details_title".tr()),
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
                    _buildStatRow(Icons.favorite, "hp".tr(),
                        "${jugador.hp} / $maxHp"),
                    _buildProgressBar(porcentajeHP, Colors.red),

                    const SizedBox(height: 8),

                    _buildStatRow(Icons.shield, "ac".tr(), jugador.ac.toString()),
                    _buildStatRow(Icons.star, "level".tr(), jugador.nivel.toString()),
                    _buildStatRow(
                        Icons.flash_on, "initiative".tr(), jugador.iniciativa.toString()),

                    const SizedBox(height: 8),

                    _buildStatRow(Icons.auto_fix_high, "class_actions".tr(),
                        jugador.accionesClase.toString()),
                    _buildStatRow(Icons.workspace_premium, "heroic_actions".tr(),
                        jugador.accionesHeroicas.toString()),

                    const Divider(height: 20),

                    // Datos acumulados
                    Text(
                      "📊 ${"accumulated_data".tr()}",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 6),
                    _buildStatRow(Icons.auto_fix_high_outlined,
                        "accumulated_class_actions".tr(), jugador.accionesClaseAcumuladas.toString()),
                    _buildStatRow(Icons.workspace_premium_outlined,
                        "accumulated_heroic_actions".tr(), jugador.accionesHeroicasAcumuladas.toString()),

                    const SizedBox(height: 8),
                    _buildStatRow(Icons.emoji_events, "xp_gained".tr(),
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
