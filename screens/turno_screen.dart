import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:easy_localization/easy_localization.dart';

import '../models/jugador.dart';
import '../providers/jugadores_provider.dart';
import '../providers/combate_provider.dart';
import '../utils/calculoxp.dart';

// Provider persistente para manejar el sistema de XP seleccionado (duplicado temporalmente)
class SistemaXPNotifier extends StateNotifier<SistemaXP> {
  static const String _boxName = 'configuracion';
  static const String _sistemaXPKey = 'sistemaXP';
  
  SistemaXPNotifier() : super(SistemaXP.pathfinder1e) {
    _cargarSistema();
  }
  
  Future<void> _cargarSistema() async {
    try {
      final box = await Hive.openBox(_boxName);
      final sistemaGuardado = box.get(_sistemaXPKey);
      if (sistemaGuardado != null) {
        // Convertir string guardado a enum
        if (sistemaGuardado == 'pathfinder2e') {
          state = SistemaXP.pathfinder2e;
        } else {
          state = SistemaXP.pathfinder1e;
        }
      }
    } catch (e) {
      // Si hay error, mantener valor por defecto
      state = SistemaXP.pathfinder1e;
    }
  }
  
  Future<void> cambiarSistema(SistemaXP nuevoSistema) async {
    state = nuevoSistema;
    try {
      final box = await Hive.openBox(_boxName);
      // Guardar como string para simplicidad
      final sistemaString = nuevoSistema == SistemaXP.pathfinder1e 
          ? 'pathfinder1e' 
          : 'pathfinder2e';
      await box.put(_sistemaXPKey, sistemaString);
    } catch (e) {
      // Si hay error al guardar, no afecta la funcionalidad
  debugPrint('Error al guardar sistema XP: $e');
    }
  }
}

final sistemaXPProvider = StateNotifierProvider<SistemaXPNotifier, SistemaXP>(
  (ref) => SistemaXPNotifier(),
);

class TurnoScreen extends ConsumerWidget {
  final int? campaignSlot;

  const TurnoScreen({super.key, this.campaignSlot});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
  final combate = ref.watch(combateProvider);

    final bool hasSlotBox = campaignSlot != null && Hive.isBoxOpen('jugadores_slot_$campaignSlot');
  final jugadoresGlobal = hasSlotBox
    ? ref.watch(jugadoresProviderForSlot(campaignSlot!))
    : ref.watch(jugadoresProvider);
  final jugadoresNotifier = hasSlotBox
    ? ref.read(jugadoresProviderForSlot(campaignSlot!).notifier)
    : ref.read(jugadoresProvider.notifier);

    if (!combate.combateActivo || combate.ordenIniciativa.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text("turn_title".tr())),
        body: Center(child: Text("no_active_combat".tr())),
      );
    }

    final nombreEnTurno = combate.ordenIniciativa[combate.turnoActual].nombre;
    final idxActual =
        jugadoresGlobal.indexWhere((j) => j.nombre == nombreEnTurno);
    final pjActual = idxActual >= 0
        ? jugadoresGlobal[idxActual]
        : combate.ordenIniciativa[combate.turnoActual];

    final enemigosVivos =
        jugadoresGlobal.where((j) => j.esEnemigo && j.hp > 0);
    if (enemigosVivos.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _terminarCombate(context, ref);
      });
    }

    final int maxHp = pjActual.maxHp;
    final double porcentajeHP =
        maxHp > 0 ? (pjActual.hp / maxHp).clamp(0.0, 1.0) : 0;

    return Scaffold(
      appBar: AppBar(
        title: Text('${"turn_of".tr()} ${pjActual.nombre}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.flag),
            tooltip: "end_combat_tooltip".tr(),
            onPressed: () {
              _terminarCombate(context, ref);
              for (var jugador in jugadoresGlobal) {
                jugador.accionesClaseAcumuladas += 10; 
              }
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF5F0E1), Color(0xFFE0D6C3)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 28,
                          backgroundColor: Colors.redAccent,
                          child:
                              Icon(Icons.shield, color: Colors.white, size: 28),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                pjActual.nombre,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text("🛡️ AC: ${pjActual.ac}   ⭐ Nivel: ${pjActual.nivel}"),
                              Text("⚡ ${"class_button".tr()}: ${pjActual.accionesClase}   🔥 ${"heroic_button".tr()}: ${pjActual.accionesHeroicas}"),
                              Text("⚔️ ${"damage_dealt".tr()}: ${pjActual.danoHecho}"),
                              if (pjActual.att != null && pjActual.att!.isNotEmpty)
                                Text('${"attack".tr()}: ${pjActual.att}'),
                              if (pjActual.movs != null && pjActual.movs!.isNotEmpty)
                                Text('${"moves".tr()}: ${pjActual.movs}'),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text("❤️ HP: ${pjActual.hp} / $maxHp"),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: porcentajeHP,
                        minHeight: 14,
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
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                if (!pjActual.esEnemigo) ...[
                  ElevatedButton.icon(
                      onPressed: () {
                        jugadoresNotifier.actualizarJugador(
                          idxActual,
                          pjActual.copyWith(accionesClase: pjActual.accionesClase + 1),
                        );
                      },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                    ),
                    icon: const Icon(Icons.bolt),
                    label: Text("class_action".tr()),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      jugadoresNotifier.actualizarJugador(
                        idxActual,
                        pjActual.copyWith(accionesHeroicas: pjActual.accionesHeroicas + 1),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                    ),
                    icon: const Icon(Icons.star),
                    label: Text("heroic_action".tr()),
                  ),
                ],
                ElevatedButton.icon(
                  onPressed: () =>
                      _dialogoDanioEnemigo(context, ref, pjActual, idxActual),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                  ),
                  icon: const Icon(Icons.local_fire_department),
                  label: Text("deal_damage".tr()),
                ),
                ElevatedButton.icon(
                  onPressed: () =>
                      _dialogoCurar(context, ref, pjActual, idxActual),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[700],
                  ),
                  icon: const Icon(Icons.healing),
                  label: Text("heal".tr()),
                ),
                ElevatedButton.icon(
                  onPressed: () => _dialogoAtaqueOportunidad(
                      context, ref, pjActual, idxActual),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                  ),
                  icon: const Icon(Icons.flash_on),
                  label: Text("opportunity_attack".tr()),
                ),
              ],
            ),
            const Spacer(),
            ElevatedButton.icon(
                onPressed: () {
                  final quedanEnemigos = jugadoresGlobal.any((j) => j.esEnemigo && j.hp > 0);

                  if (!quedanEnemigos) {
                    _terminarCombate(context, ref);
                    return;
                  }
                  ref.read(combateProvider.notifier).siguienteTurno();
                },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.navigate_next),
              label: Text(
                "next_turn_button".tr(),
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _terminarCombate(BuildContext context, WidgetRef ref) {
    final bool hasSlotBox = campaignSlot != null && Hive.isBoxOpen('jugadores_slot_$campaignSlot');
    final jugadoresNotifier = hasSlotBox
        ? ref.read(jugadoresProviderForSlot(campaignSlot!).notifier)
        : ref.read(jugadoresProvider.notifier);
    final sistemaXP = ref.read(sistemaXPProvider);

    // Detectar automáticamente el sistema basado en enemigos presentes
    final jugadores = hasSlotBox
        ? ref.read(jugadoresProviderForSlot(campaignSlot!))
        : ref.read(jugadoresProvider);
    final enemigos = jugadores.where((j) => j.esEnemigo).toList();
    
    SistemaJuego sistemaJuego;
    
    if (enemigos.isNotEmpty) {
      // Detectar sistema basado en niveles de enemigos (heurística simple)
      final nivelesEnemigos = enemigos.map((e) => e.nivel).toList();
      final tieneNivelesFraccionarios = nivelesEnemigos.any((nivel) => nivel < 1);
      
      if (tieneNivelesFraccionarios) {
        // Probablemente D&D (CR 0.25, 0.5, etc. se almacenan como 0)
        sistemaJuego = SistemaJuego.dnd5e;
      } else {
        // Convertir SistemaXP a SistemaJuego para sistemas de Pathfinder
        sistemaJuego = sistemaXP == SistemaXP.pathfinder1e 
            ? SistemaJuego.pathfinder1e 
            : SistemaJuego.pathfinder2e;
      }
    } else {
      // Sin enemigos, usar sistema por defecto
      sistemaJuego = sistemaXP == SistemaXP.pathfinder1e 
          ? SistemaJuego.pathfinder1e 
          : SistemaJuego.pathfinder2e;
    }

    // Usar el método oficial con el sistema detectado
    jugadoresNotifier.calcularYAcumularXpOficial(
      sistema: sistemaJuego,
    );

    jugadoresNotifier.guardarYReiniciarAcciones();
    jugadoresNotifier.eliminarEnemigos();
    ref.read(combateProvider.notifier).terminarCombate();
    Navigator.pop(context);
  }

  void _dialogoDanioEnemigo(
      BuildContext context, WidgetRef ref, Jugador atacante, int idxAtacante) {
    final bool hasSlotBox = campaignSlot != null && Hive.isBoxOpen('jugadores_slot_$campaignSlot');
    final jugadores = hasSlotBox
        ? ref.read(jugadoresProviderForSlot(campaignSlot!))
        : ref.read(jugadoresProvider);
    _abrirDialogoHP(context, ref, jugadores, atacante, idxAtacante,
        esCuracion: false);
  }

  void _dialogoCurar(
      BuildContext context, WidgetRef ref, Jugador curador, int idxCurador) {
    final bool hasSlotBox = campaignSlot != null && Hive.isBoxOpen('jugadores_slot_$campaignSlot');
    final jugadores = hasSlotBox
        ? ref.read(jugadoresProviderForSlot(campaignSlot!))
        : ref.read(jugadoresProvider);
    _abrirDialogoHP(context, ref, jugadores, curador, idxCurador,
        esCuracion: true);
  }

  void _dialogoAtaqueOportunidad(
      BuildContext context, WidgetRef ref, Jugador objetivo, int idxObjetivo) {
    final bool hasSlotBox = campaignSlot != null && Hive.isBoxOpen('jugadores_slot_$campaignSlot');
    final jugadores = hasSlotBox
        ? ref.read(jugadoresProviderForSlot(campaignSlot!))
        : ref.read(jugadoresProvider);
    final posiblesAtacantes = jugadores.where((j) => j.nombre != objetivo.nombre).toList();

    int? idxAtacante =
        posiblesAtacantes.isNotEmpty ? jugadores.indexOf(posiblesAtacantes[0]) : null;
    final cantidadCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: [
                const Icon(Icons.flash_on, color: Colors.purple),
                const SizedBox(width: 8),
                Text("opportunity_attack".tr()),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButton<int>(
                  value: idxAtacante,
                  isExpanded: true,
                  items: posiblesAtacantes.map((jugador) {
                    final idx = jugadores.indexOf(jugador);
                    return DropdownMenuItem<int>(
                      value: idx,
                      child: Text(jugador.nombre),
                    );
                  }).toList(),
                  onChanged: (v) {
                    if (v != null) setState(() => idxAtacante = v);
                  },
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: cantidadCtrl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "attack_damage".tr(),
                    border: const OutlineInputBorder(),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("cancel".tr()),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                ),
                onPressed: () {
                  final cantidad = int.tryParse(cantidadCtrl.text) ?? 0;
                  if (idxAtacante == null) return;

                  final atacante = jugadores[idxAtacante!];

                  final bool hasSlotBoxLocal = campaignSlot != null && Hive.isBoxOpen('jugadores_slot_$campaignSlot');
                  final jugadoresNotifier = hasSlotBoxLocal
                      ? ref.read(jugadoresProviderForSlot(campaignSlot!).notifier)
                      : ref.read(jugadoresProvider.notifier);

                  jugadoresNotifier.actualizarJugador(
                    idxAtacante!,
                    atacante.copyWith(
                      danoHecho: atacante.danoHecho + cantidad,
                    ),
                  );

                  int nuevoHP = (objetivo.hp - cantidad).clamp(0, objetivo.maxHp);

                  jugadoresNotifier.actualizarJugador(
                    idxObjetivo,
                    objetivo.copyWith(hp: nuevoHP, died: nuevoHP == 0),
                  );

                  Navigator.pop(context);
                },
                child: Text("apply".tr()),
              ),
            ],
          ),
        );
      },
    );
  }

  void _abrirDialogoHP(BuildContext context, WidgetRef ref,
      List<Jugador> jugadores, Jugador actor, int idxActor,
      {required bool esCuracion}) {
    final party = jugadores.where((j) => !j.esEnemigo).toList();
    final enemigos = jugadores.where((j) => j.esEnemigo).toList();

    if (party.isEmpty && enemigos.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("no_players_in_list".tr())),
      );
      return;
    }

    int idxObjetivo = 0;
    final cantidadCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: [
                Icon(
                  esCuracion ? Icons.healing : Icons.local_fire_department,
                  color: esCuracion ? Colors.green : Colors.red,
                ),
                const SizedBox(width: 8),
                Text(esCuracion ? "heal".tr() : "deal_damage".tr()),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButton<int>(
                  value: idxObjetivo,
                  isExpanded: true,
                  items: [
                    DropdownMenuItem<int>(
                      enabled: false,
                      child: Text(
                        "party_members".tr(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.grey),
                      ),
                    ),
                    ...party.map((jugador) {
                      final idx = jugadores.indexOf(jugador);
                      return DropdownMenuItem<int>(
                        value: idx,
                        child: Text('${jugador.nombre} (HP ${jugador.hp})'),
                      );
                    }),
                    const DropdownMenuItem<int>(
                      enabled: false,
                      child: Text(
                        'Enemigos',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.grey),
                      ),
                    ),
                    ...enemigos.map((jugador) {
                      final idx = jugadores.indexOf(jugador);
                      return DropdownMenuItem<int>(
                        value: idx,
                        child: Text('${jugador.nombre} (HP ${jugador.hp})'),
                      );
                    }),
                  ],
                  onChanged: (v) {
                    if (v != null) setState(() => idxObjetivo = v);
                  },
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: cantidadCtrl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: esCuracion
                        ? 'Cantidad de curación'
                        : 'Cantidad de daño',
                    border: const OutlineInputBorder(),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('cancel'.tr()),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: esCuracion ? Colors.green : Colors.redAccent,
                ),
                onPressed: () {
                  final cantidad = int.tryParse(cantidadCtrl.text) ?? 0;
                  final objetivo = jugadores[idxObjetivo];

                  final bool hasSlotBoxLocal = campaignSlot != null && Hive.isBoxOpen('jugadores_slot_$campaignSlot');
                  final jugadoresNotifier = hasSlotBoxLocal
                      ? ref.read(jugadoresProviderForSlot(campaignSlot!).notifier)
                      : ref.read(jugadoresProvider.notifier);

                  if (!esCuracion) {
                    jugadoresNotifier.actualizarJugador(
                      idxActor,
                      actor.copyWith(danoHecho: actor.danoHecho + cantidad),
                    );
                  }

                  int nuevoHP = esCuracion
                      ? (objetivo.hp + cantidad).clamp(0, objetivo.maxHp)
                      : (objetivo.hp - cantidad).clamp(0, objetivo.maxHp);

                  jugadoresNotifier.actualizarJugador(
                    idxObjetivo,
                    objetivo.copyWith(hp: nuevoHP, died: nuevoHP == 0),
                  );

                  Navigator.pop(context);
                },
                child: Text('apply'.tr()),
              ),
            ],
          ),
        );
      },
    );
  }
}