import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/jugadores_provider.dart';
import '../utils/calculoxp.dart';
import '../utils/tablaxp.dart';
import '../models/jugador.dart';

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


      // Acumular acciones antes de calcular la experiencia final
      List<Jugador> jugadoresActualizados = [];
      for (int i = 0; i < jugadores.length; i++) {
        final jugador = jugadores[i];
        final actualizado = jugador.copyWith(
          accionesClaseAcumuladas: jugador.accionesClaseAcumuladas + jugador.accionesClase,
          accionesHeroicasAcumuladas: jugador.accionesHeroicasAcumuladas + jugador.accionesHeroicas,
          accionesClase: 0,
          accionesHeroicas: 0,
        );
        jugadoresNotifier.actualizarJugador(i, actualizado);
        jugadoresActualizados.add(actualizado);
      }

      // Calcular la experiencia final para los jugadores usando la lista actualizada
      calcularXPFinal(
        jugadores: jugadoresActualizados,
        crParty: cr,
      );

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
                                 const SizedBox(height: 12),

                                 // Barra Clase 1 - Amber
                                 Builder(
                                   builder: (context) {
                                     final nivelClase = jugador.nivelClase1;
                                     final xpParaSubir = calcularXpPorClase(
                                       nivelClase1: nivelClase + 1,
                                       nivelClase2: jugador.nivelClase2,
                                       nivelClase3: jugador.nivelClase3,
                                     )["clase1"] ?? 0;
                                     final xpDisponible = jugador.xp - (calcularXpPorClase(
                                       nivelClase1: nivelClase,
                                       nivelClase2: jugador.nivelClase2,
                                       nivelClase3: jugador.nivelClase3,
                                     )["clase2"] ?? 0) - (calcularXpPorClase(
                                       nivelClase1: nivelClase,
                                       nivelClase2: jugador.nivelClase2,
                                       nivelClase3: jugador.nivelClase3,
                                     )["clase3"] ?? 0);
                                     final progreso = xpParaSubir > 0
                                         ? (xpDisponible / xpParaSubir).clamp(0.0, 1.0)
                                         : 1.0;
                                     final puedeSubir = xpDisponible >= xpParaSubir;
                                     return Column(
                                       crossAxisAlignment: CrossAxisAlignment.start,
                                       children: [
                                         Row(
                                           children: [
                                             const Expanded(
                                               child: Text(
                                                 'Clase 1: Nivel',
                                                 style: TextStyle(fontWeight: FontWeight.w500),
                                               ),
                                             ),
                                             Text('$nivelClase'),
                                             ElevatedButton(
                                               style: ElevatedButton.styleFrom(
                                                 backgroundColor: puedeSubir ? Colors.green : Colors.grey,
                                                 minimumSize: const Size(36, 36),
                                                 padding: EdgeInsets.zero,
                                                 shape: RoundedRectangleBorder(
                                                   borderRadius: BorderRadius.circular(8),
                                                 ),
                                               ),
                                               onPressed: puedeSubir
                                                   ? () {
                                                       final jugadoresNotifier = ref.read(jugadoresProvider.notifier);
                                                       final actualizado = jugador.copyWith(
                                                         nivelClase1: nivelClase + 1,
                                                         xp: (jugador.xp - xpParaSubir).toInt(),
                                                       );
                                                       jugadoresNotifier.actualizarJugador(index, actualizado);
                                                     }
                                                   : null,
                                               child: const Icon(Icons.arrow_upward, color: Colors.white, size: 20),
                                             ),
                                           ],
                                         ),
                                         const SizedBox(height: 4),
                                         LinearProgressIndicator(
                                           value: progreso,
                                           minHeight: 10,
                                           backgroundColor: Colors.grey[300],
                                           color: Colors.amber,
                                         ),
                                         Padding(
                                           padding: const EdgeInsets.symmetric(vertical: 2.0),
                                           child: Text(
                                             'XP: ${xpDisponible.toInt()} / $xpParaSubir (Falta: ${(xpParaSubir - xpDisponible).toInt()})',
                                             style: const TextStyle(fontSize: 12),
                                           ),
                                         ),
                                         const SizedBox(height: 8),
                                       ],
                                     );
                                   },
                                 ),

                                 // Barra Clase 2 - Pink
                                 Builder(
                                   builder: (context) {
                                     final nivelClase = jugador.nivelClase2;
                                     final xpParaSubir = calcularXpPorClase(
                                       nivelClase1: jugador.nivelClase1,
                                       nivelClase2: nivelClase + 1,
                                       nivelClase3: jugador.nivelClase3,
                                     )["clase2"] ?? 0;
                                     final xpDisponible = jugador.xp - (calcularXpPorClase(
                                       nivelClase1: jugador.nivelClase1,
                                       nivelClase2: nivelClase,
                                       nivelClase3: jugador.nivelClase3,
                                     )["clase1"] ?? 0) - (calcularXpPorClase(
                                       nivelClase1: jugador.nivelClase1,
                                       nivelClase2: nivelClase,
                                       nivelClase3: jugador.nivelClase3,
                                     )["clase3"] ?? 0);
                                     final progreso = xpParaSubir > 0
                                         ? (xpDisponible / xpParaSubir).clamp(0.0, 1.0)
                                         : 1.0;
                                     final puedeSubir = xpDisponible >= xpParaSubir;
                                     return Column(
                                       crossAxisAlignment: CrossAxisAlignment.start,
                                       children: [
                                         Row(
                                           children: [
                                             const Expanded(
                                               child: Text(
                                                 'Clase 2: Nivel',
                                                 style: TextStyle(fontWeight: FontWeight.w500),
                                               ),
                                             ),
                                             Text('$nivelClase'),
                                             ElevatedButton(
                                               style: ElevatedButton.styleFrom(
                                                 backgroundColor: puedeSubir ? Colors.green : Colors.grey,
                                                 minimumSize: const Size(36, 36),
                                                 padding: EdgeInsets.zero,
                                                 shape: RoundedRectangleBorder(
                                                   borderRadius: BorderRadius.circular(8),
                                                 ),
                                               ),
                                               onPressed: puedeSubir
                                                   ? () {
                                                       final jugadoresNotifier = ref.read(jugadoresProvider.notifier);
                                                       final actualizado = jugador.copyWith(
                                                         nivelClase2: nivelClase + 1,
                                                         xp: (jugador.xp - xpParaSubir).toInt(),
                                                       );
                                                       jugadoresNotifier.actualizarJugador(index, actualizado);
                                                     }
                                                   : null,
                                               child: const Icon(Icons.arrow_upward, color: Colors.white, size: 20),
                                             ),
                                           ],
                                         ),
                                         const SizedBox(height: 4),
                                         LinearProgressIndicator(
                                           value: progreso,
                                           minHeight: 10,
                                           backgroundColor: Colors.grey[300],
                                           color: Colors.pink,
                                         ),
                                         Padding(
                                           padding: const EdgeInsets.symmetric(vertical: 2.0),
                                           child: Text(
                                             'XP: ${xpDisponible.toInt()} / $xpParaSubir (Falta: ${(xpParaSubir - xpDisponible).toInt()})',
                                             style: const TextStyle(fontSize: 12),
                                           ),
                                         ),
                                         const SizedBox(height: 8),
                                       ],
                                     );
                                   },
                                 ),

                                 // Barra Clase 3 - Cyan
                                 Builder(
                                   builder: (context) {
                                     final nivelClase = jugador.nivelClase3;
                                     final xpParaSubir = calcularXpPorClase(
                                       nivelClase1: jugador.nivelClase1,
                                       nivelClase2: jugador.nivelClase2,
                                       nivelClase3: nivelClase + 1,
                                     )["clase3"] ?? 0;
                                     final xpDisponible = jugador.xp - (calcularXpPorClase(
                                       nivelClase1: jugador.nivelClase1,
                                       nivelClase2: jugador.nivelClase2,
                                       nivelClase3: nivelClase,
                                     )["clase1"] ?? 0) - (calcularXpPorClase(
                                       nivelClase1: jugador.nivelClase1,
                                       nivelClase2: jugador.nivelClase2,
                                       nivelClase3: nivelClase,
                                     )["clase2"] ?? 0);
                                     final progreso = xpParaSubir > 0
                                         ? (xpDisponible / xpParaSubir).clamp(0.0, 1.0)
                                         : 1.0;
                                     final puedeSubir = xpDisponible >= xpParaSubir;
                                     return Column(
                                       crossAxisAlignment: CrossAxisAlignment.start,
                                       children: [
                                         Row(
                                           children: [
                                             const Expanded(
                                               child: Text(
                                                 'Clase 3: Nivel',
                                                 style: TextStyle(fontWeight: FontWeight.w500),
                                               ),
                                             ),
                                             Text('$nivelClase'),
                                             ElevatedButton(
                                               style: ElevatedButton.styleFrom(
                                                 backgroundColor: puedeSubir ? Colors.green : Colors.grey,
                                                 minimumSize: const Size(36, 36),
                                                 padding: EdgeInsets.zero,
                                                 shape: RoundedRectangleBorder(
                                                   borderRadius: BorderRadius.circular(8),
                                                 ),
                                               ),
                                               onPressed: puedeSubir
                                                   ? () {
                                                       final jugadoresNotifier = ref.read(jugadoresProvider.notifier);
                                                       final actualizado = jugador.copyWith(
                                                         nivelClase3: nivelClase + 1,
                                                         xp: (jugador.xp - xpParaSubir).toInt(),
                                                       );
                                                       jugadoresNotifier.actualizarJugador(index, actualizado);
                                                     }
                                                   : null,
                                               child: const Icon(Icons.arrow_upward, color: Colors.white, size: 20),
                                             ),
                                           ],
                                         ),
                                         const SizedBox(height: 4),
                                         LinearProgressIndicator(
                                           value: progreso,
                                           minHeight: 10,
                                           backgroundColor: Colors.grey[300],
                                           color: Colors.cyan,
                                         ),
                                         Padding(
                                           padding: const EdgeInsets.symmetric(vertical: 2.0),
                                           child: Text(
                                             'XP: ${xpDisponible.toInt()} / $xpParaSubir (Falta: ${(xpParaSubir - xpDisponible).toInt()})',
                                             style: const TextStyle(fontSize: 12),
                                           ),
                                         ),
                                         const SizedBox(height: 8),
                                       ],
                                     );
                                   },
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
                        final jugadoresNotifier = ref.read(jugadoresProvider.notifier);
                        final jugadores = ref.read(jugadoresProvider);
                        int acumulado = 0;
                        for (int i = 0; i < jugadores.length; i++) {
                          final actualizado = jugadores[i].copyWith(
                            xpAcumulada: 0,
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
