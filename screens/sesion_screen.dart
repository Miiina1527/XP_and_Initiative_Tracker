import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/jugadores_provider.dart';
import '../utils/calculoxp.dart';

class SesionScreen extends ConsumerStatefulWidget {
  const SesionScreen({super.key});

  @override
  ConsumerState<SesionScreen> createState() => _SesionScreenState();
}

class _SesionScreenState extends ConsumerState<SesionScreen> {
  int crParty = 0;
  int totalXP = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final jugadoresNotifier = ref.read(jugadoresProvider.notifier);
      final jugadores = ref.read(jugadoresProvider);

      // Calcular el CR del grupo
      final cr = jugadoresNotifier.calcularCRParty(jugadores);
      setState(() {
        crParty = cr;
      });

      // Calcular la experiencia final para los jugadores
      calcularXPFinal(
        jugadores: jugadores,
        crParty: cr,
      );

      // Actualizar jugadores
      int acumulado = 0;
      for (int i = 0; i < jugadores.length; i++) {
        final actualizado = jugadores[i].copyWith(
          xpAcumulada: jugadores[i].xpAcumulada + jugadores[i].gainedxp,
          gainedxp: 0,
          accionesClaseAcumuladas: 0,
          accionesHeroicasAcumuladas: 0,
          died: false,
        );
        jugadoresNotifier.actualizarJugador(i, actualizado);
      }
      setState(() {
        totalXP = acumulado;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final jugadores = ref.watch(jugadoresProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Terminar Sesión'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF5F0E1), Color(0xFFE0D6C3)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: jugadores.isEmpty
            ? const Center(
                child: Text(
                  'No hay jugadores disponibles.',
                  style: TextStyle(fontSize: 18),
                ),
              )
            : Column(
                children: [
                  const SizedBox(height: 16),

                  // Resumen de la sesión
                  Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    color: Colors.amber[100],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Text(
                            "Resumen de la Sesión",
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          Text("Nivel del Grupo: $crParty"),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Lista de jugadores
                  Expanded(
                    child: ListView.builder(
                      itemCount: jugadores.length,
                      itemBuilder: (context, index) {
                        final jugador = jugadores[index];
                        
                        return Card(
                          margin: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 16),
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Encabezado
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: jugador.esEnemigo
                                          ? Colors.redAccent
                                          : Colors.blueAccent,
                                      child: Icon(
                                        jugador.esEnemigo
                                            ? Icons.warning
                                            : Icons.person,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        jugador.nombre,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 10),

                                // XP y Nivel
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Nivel: ${jugador.nivel}"),
                                    Text("XP Total: ${jugador.xp}"),
                                  ],
                                ),
                                
                                const SizedBox(height: 8),

                                // XP ganada en esta sesión
                                Text(
                                  "+${jugador.xpAcumulada} XP en esta sesión",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // Botón para cerrar sesión
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      icon: const Icon(Icons.logout),
                      label: const Text("Cerrar Sesión"),
                      onPressed: () {
                        Navigator.of(context).popUntil((route) => route.isFirst);
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
  // The duplicate build method below is removed to avoid conflicts.
