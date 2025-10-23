import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hive/hive.dart';
import '../providers/jugadores_provider.dart';
import '../models/jugador.dart';
import '../utils/calculoxp.dart'; // Para detectar sistema de juego

class SesionScreen extends ConsumerStatefulWidget {
  final int? campaignSlot;
  const SesionScreen({super.key, this.campaignSlot});

  @override
  ConsumerState<SesionScreen> createState() => _SesionScreenState();
}

class _SesionScreenState extends ConsumerState<SesionScreen> {
  int crParty = 0;
  SistemaJuego? sistemaDetectado;

  // Configuración de XP por acciones según sistema
  static const Map<SistemaJuego, Map<String, int>> xpPorAcciones = {
    SistemaJuego.pathfinder1e: {
      'accionClase': 25,
      'accionHeroica': 50,
    },
    SistemaJuego.pathfinder2e: {
      'accionClase': 2,
      'accionHeroica': 4,
    },
    SistemaJuego.dnd5e: {
      'accionClase': 15,
      'accionHeroica': 30,
    },
    SistemaJuego.dnd5e2024: {
      'accionClase': 15,
      'accionHeroica': 30,
    },
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
    final hasSlotBox = widget.campaignSlot != null && Hive.isBoxOpen('jugadores_slot_${widget.campaignSlot}');
    final jugadoresNotifier = hasSlotBox
      ? ref.read(jugadoresProviderForSlot(widget.campaignSlot!).notifier)
      : ref.read(jugadoresProvider.notifier);
    final jugadores = hasSlotBox
      ? ref.read(jugadoresProviderForSlot(widget.campaignSlot!))
      : ref.read(jugadoresProvider);

      // Calcular el CR del grupo
      final cr = jugadoresNotifier.calcularCRParty(jugadores);
      setState(() {
        crParty = cr;
      });

      jugadoresNotifier.guardarYReiniciarAcciones();

      // Aplicar XP por acciones acumuladas antes de guardar
      _aplicarXpPorAcciones();

    });
  }

  // Función simple para obtener XP requerido por nivel (sistema estándar)
  int _getXPParaNivel(int nivel) {
    // Tabla estándar D&D 5e/Pathfinder simplificada
    const xpPorNivel = {
      1: 0,
      2: 300,
      3: 900,
      4: 2700,
      5: 6500,
      6: 14000,
      7: 23000,
      8: 34000,
      9: 48000,
      10: 64000,
      11: 85000,
      12: 100000,
      13: 120000,
      14: 140000,
      15: 165000,
      16: 195000,
      17: 225000,
      18: 265000,
      19: 305000,
      20: 355000,
    };
    return xpPorNivel[nivel] ?? 355000;
  }

  // Detectar sistema de juego basado en los jugadores
  SistemaJuego _detectarSistema(List<Jugador> jugadores) {
    if (jugadores.isEmpty) return SistemaJuego.pathfinder1e; // Default
    
    // Heurística: si hay enemigos con niveles muy altos, probablemente sea Pathfinder
    // Si hay niveles fraccionarios (almacenados como 0), probablemente sea D&D
    final enemigos = jugadores.where((j) => j.esEnemigo).toList();
    if (enemigos.isNotEmpty) {
      final nivelesEnemigos = enemigos.map((e) => e.nivel).toList();
      final tieneNivelesBajos = nivelesEnemigos.any((nivel) => nivel <= 0);
      
      if (tieneNivelesBajos) {
        return SistemaJuego.dnd5e; // Default para D&D
      }
    }
    
    // Default Pathfinder 1e
    return SistemaJuego.pathfinder1e;
  }

  // Obtener nombre legible del sistema
  String _getNombreSistema(SistemaJuego sistema) {
    switch (sistema) {
      case SistemaJuego.pathfinder1e:
        return "system_pathfinder_1e".tr();
      case SistemaJuego.pathfinder2e:
        return "system_pathfinder_2e".tr();
      case SistemaJuego.dnd5e:
        return "system_dnd_5e_2014".tr();
      case SistemaJuego.dnd5e2024:
        return "system_dnd_5e_2024".tr();
    }
  }

  // Aplicar XP por acciones acumuladas
  void _aplicarXpPorAcciones() {
  final jugadores = widget.campaignSlot != null && Hive.isBoxOpen('jugadores_slot_${widget.campaignSlot}')
  ? ref.read(jugadoresProviderForSlot(widget.campaignSlot!))
  : ref.read(jugadoresProvider);
    final sistema = _detectarSistema(jugadores);
    final config = xpPorAcciones[sistema]!;
    
  final jugadoresNotifier = widget.campaignSlot != null && Hive.isBoxOpen('jugadores_slot_${widget.campaignSlot}')
    ? ref.read(jugadoresProviderForSlot(widget.campaignSlot!).notifier)
    : ref.read(jugadoresProvider.notifier);
    
    for (int i = 0; i < jugadores.length; i++) {
      final jugador = jugadores[i];
      if (jugador.esEnemigo) continue; // Solo jugadores, no enemigos
      
      final xpAccionesClase = jugador.accionesClaseAcumuladas * config['accionClase']!;
      final xpAccionesHeroicas = jugador.accionesHeroicasAcumuladas * config['accionHeroica']!;
      final xpTotalAcciones = xpAccionesClase + xpAccionesHeroicas;
      
      if (xpTotalAcciones > 0) {
        final actualizado = jugador.copyWith(
          xp: jugador.xp + xpTotalAcciones,
          gainedxp: jugador.gainedxp + xpTotalAcciones,
        );
        jugadoresNotifier.actualizarJugador(i, actualizado);
      }
    }
    
    setState(() {
      sistemaDetectado = sistema;
    });
  }

  @override
  Widget build(BuildContext context) {
    final jugadores = widget.campaignSlot != null && Hive.isBoxOpen('jugadores_slot_${widget.campaignSlot}')
      ? ref.watch(jugadoresProviderForSlot(widget.campaignSlot!))
      : ref.watch(jugadoresProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text("end_of_session".tr()),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          // Header con información del party
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Column(
              children: [
                Text(
                  "${"party_cr".tr()}: $crParty",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "${"players".tr()}: ${jugadores.length}",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                ),
                if (sistemaDetectado != null) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade100,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.orange.shade300),
                    ),
                    child: Text(
                      "${"detected_system".tr()}: ${_getNombreSistema(sistemaDetectado!)}",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.orange.shade800,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Lista de jugadores con sistema oficial simplificado
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: jugadores.length,
              itemBuilder: (context, index) {
                final jugador = jugadores[index];
                final nivelActual = jugador.nivel;
                final xpActual = jugador.xp;
                final xpParaSiguienteNivel = _getXPParaNivel(nivelActual + 1);
                final xpNivelActual = _getXPParaNivel(nivelActual);
                final xpProgreso = xpActual - xpNivelActual;
                final xpNecesario = xpParaSiguienteNivel - xpNivelActual;
                final progreso = xpNecesario > 0 ? (xpProgreso / xpNecesario).clamp(0.0, 1.0) : 1.0;
                final puedeSubir = xpActual >= xpParaSiguienteNivel && nivelActual < 20;

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Nombre y nivel del jugador
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                jugador.nombre,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade100,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                "${"level".tr()} $nivelActual",
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // XP ganado en esta sesión
                        if (jugador.gainedxp > 0) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.green.shade100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              "+${jugador.gainedxp} ${"xp_gained_this_session".tr()}",
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.green,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],

                        // Desglose de XP por acciones (si hay sistema detectado)
                        if (sistemaDetectado != null && 
                            (jugador.accionesClaseAcumuladas > 0 || jugador.accionesHeroicasAcumuladas > 0)) ...[
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.purple.shade50,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.purple.shade200),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "bonus_xp_for_actions".tr(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.purple.shade800,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                if (jugador.accionesClaseAcumuladas > 0)
                                  Text(
                                    "• ${jugador.accionesClaseAcumuladas} ${"class_actions_count".tr()} = +${jugador.accionesClaseAcumuladas * xpPorAcciones[sistemaDetectado]!['accionClase']!} XP",
                                    style: const TextStyle(fontSize: 11),
                                  ),
                                if (jugador.accionesHeroicasAcumuladas > 0)
                                  Text(
                                    "• ${jugador.accionesHeroicasAcumuladas} ${"heroic_actions_count".tr()} = +${jugador.accionesHeroicasAcumuladas * xpPorAcciones[sistemaDetectado]!['accionHeroica']!} XP",
                                    style: const TextStyle(fontSize: 11),
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],

                        // Progreso de nivel (sistema oficial)
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${"progress_to_level".tr()} ${nivelActual + 1}",
                                    style: const TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                  const SizedBox(height: 4),
                                  LinearProgressIndicator(
                                    value: progreso,
                                    minHeight: 10,
                                    backgroundColor: Colors.grey[300],
                                    color: puedeSubir ? Colors.green : Colors.blue,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "XP: $xpActual / $xpParaSiguienteNivel",
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            // Botón de subir nivel
                            if (puedeSubir)
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  minimumSize: const Size(80, 36),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: () {
                                  final hasSlot = widget.campaignSlot != null && Hive.isBoxOpen('jugadores_slot_${widget.campaignSlot}');
                                  final jugadoresNotifierLocal = hasSlot
                                    ? ref.read(jugadoresProviderForSlot(widget.campaignSlot!).notifier)
                                    : ref.read(jugadoresProvider.notifier);
                                  final actualizado = jugador.copyWith(
                                    nivel: nivelActual + 1,
                                  );
                                  jugadoresNotifierLocal.actualizarJugador(index, actualizado);
                                },
                                child: Text(
                                  "level_up_button".tr(),
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                              ),
                          ],
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
              label: Text("close_session".tr()),
              onPressed: () {
                final hasSlot = widget.campaignSlot != null && Hive.isBoxOpen('jugadores_slot_${widget.campaignSlot}');
                final jugadoresNotifier = hasSlot
                  ? ref.read(jugadoresProviderForSlot(widget.campaignSlot!).notifier)
                  : ref.read(jugadoresProvider.notifier);
                final jugadores = hasSlot
                  ? ref.read(jugadoresProviderForSlot(widget.campaignSlot!))
                  : ref.read(jugadoresProvider);

                // Limpiar datos de sesión
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

                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            ),
          ),
        ],
      ),
    );
  }
}
