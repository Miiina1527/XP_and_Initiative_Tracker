import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/jugador.dart';
import '../providers/jugadores_provider.dart';
import '../providers/combate_provider.dart';
import '../utils/calculoxp.dart';

class TurnoScreen extends ConsumerWidget {
  const TurnoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final combate = ref.watch(combateProvider);
    final jugadoresGlobal = ref.watch(jugadoresProvider);

    if (!combate.combateActivo || combate.ordenIniciativa.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Turno')),
        body: const Center(child: Text('No hay combate activo')),
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
        title: Text('Turno de ${pjActual.nombre}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.flag),
            tooltip: 'Terminar combate',
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
                              Text("⚡ Clase: ${pjActual.accionesClase}   🔥 Heroicas: ${pjActual.accionesHeroicas}"),
                              Text("⚔️ Daño Hecho: ${pjActual.danoHecho}"),
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
                      ref.read(jugadoresProvider.notifier).actualizarJugador(
                            idxActual,
                            pjActual.copyWith(
                                accionesClase: pjActual.accionesClase + 1),
                          );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                    ),
                    icon: const Icon(Icons.bolt),
                    label: const Text('Acción de Clase'),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      ref.read(jugadoresProvider.notifier).actualizarJugador(
                            idxActual,
                            pjActual.copyWith(
                                accionesHeroicas: pjActual.accionesHeroicas + 1),
                          );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                    ),
                    icon: const Icon(Icons.star),
                    label: const Text('Acción Heroica'),
                  ),
                ],
                ElevatedButton.icon(
                  onPressed: () =>
                      _dialogoDanioEnemigo(context, ref, pjActual, idxActual),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                  ),
                  icon: const Icon(Icons.local_fire_department),
                  label: const Text('Hacer Daño'),
                ),
                ElevatedButton.icon(
                  onPressed: () =>
                      _dialogoCurar(context, ref, pjActual, idxActual),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[700],
                  ),
                  icon: const Icon(Icons.healing),
                  label: const Text('Curar'),
                ),
                ElevatedButton.icon(
                  onPressed: () => _dialogoAtaqueOportunidad(
                      context, ref, pjActual, idxActual),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                  ),
                  icon: const Icon(Icons.flash_on),
                  label: const Text('Ataque Oportunidad'),
                ),
              ],
            ),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: () {
                final quedanEnemigos = ref.read(jugadoresProvider).any(
                    (j) => j.esEnemigo && j.hp > 0);

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
              label: const Text(
                "Siguiente Turno",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _terminarCombate(BuildContext context, WidgetRef ref) {
    final jugadoresNotifier = ref.read(jugadoresProvider.notifier);
    final jugadores = ref.read(jugadoresProvider);

    final int crEnemigo = calcularCREnemigos(jugadores);
    final int crParty = calcularCRParty(jugadores);

    jugadoresNotifier.guardarYReiniciarAcciones();
    jugadoresNotifier.calcularYAcumularXpCombate(
      crEnemigos: crEnemigo,
      crParty: crParty,
    );
    jugadoresNotifier.eliminarEnemigos();
    ref.read(combateProvider.notifier).terminarCombate();
    Navigator.pop(context);
  }

  void _dialogoDanioEnemigo(
      BuildContext context, WidgetRef ref, Jugador atacante, int idxAtacante) {
    final jugadores = ref.read(jugadoresProvider);
    _abrirDialogoHP(context, ref, jugadores, atacante, idxAtacante,
        esCuracion: false);
  }

  void _dialogoCurar(
      BuildContext context, WidgetRef ref, Jugador curador, int idxCurador) {
    final jugadores = ref.read(jugadoresProvider);
    _abrirDialogoHP(context, ref, jugadores, curador, idxCurador,
        esCuracion: true);
  }

  void _dialogoAtaqueOportunidad(
      BuildContext context, WidgetRef ref, Jugador objetivo, int idxObjetivo) {
    final jugadores = ref.read(jugadoresProvider);
    final posiblesAtacantes =
        jugadores.where((j) => j.nombre != objetivo.nombre).toList();

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
              children: const [
                Icon(Icons.flash_on, color: Colors.purple),
                SizedBox(width: 8),
                Text('Ataque de Oportunidad'),
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
                  decoration: const InputDecoration(
                    labelText: 'Daño del ataque',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                ),
                onPressed: () {
                  final cantidad = int.tryParse(cantidadCtrl.text) ?? 0;
                  if (idxAtacante == null) return;

                  final atacante = jugadores[idxAtacante!];

                  ref.read(jugadoresProvider.notifier).actualizarJugador(
                        idxAtacante!,
                        atacante.copyWith(
                          danoHecho: atacante.danoHecho + cantidad,
                        ),
                      );

                  int nuevoHP =
                      (objetivo.hp - cantidad).clamp(0, objetivo.maxHp);

                  ref.read(jugadoresProvider.notifier).actualizarJugador(
                        idxObjetivo,
                        objetivo.copyWith(
                          hp: nuevoHP,
                          died: nuevoHP == 0,
                        ),
                      );

                  Navigator.pop(context);
                },
                child: const Text('Aplicar'),
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
        const SnackBar(content: Text('No hay jugadores en la lista')),
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
                Text(esCuracion ? 'Curar' : 'Hacer Daño'),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButton<int>(
                  value: idxObjetivo,
                  isExpanded: true,
                  items: [
                    const DropdownMenuItem<int>(
                      enabled: false,
                      child: Text(
                        'Miembros de la Party',
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
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: esCuracion ? Colors.green : Colors.redAccent,
                ),
                onPressed: () {
                  final cantidad = int.tryParse(cantidadCtrl.text) ?? 0;
                  final objetivo = jugadores[idxObjetivo];

                  if (!esCuracion) {
                    ref.read(jugadoresProvider.notifier).actualizarJugador(
                          idxActor,
                          actor.copyWith(
                              danoHecho: actor.danoHecho + cantidad),
                        );
                  }

                  int nuevoHP = esCuracion
                      ? (objetivo.hp + cantidad).clamp(0, objetivo.maxHp)
                      : (objetivo.hp - cantidad).clamp(0, objetivo.maxHp);

                  ref.read(jugadoresProvider.notifier).actualizarJugador(
                        idxObjetivo,
                        objetivo.copyWith(
                          hp: nuevoHP,
                          died: nuevoHP == 0,
                        ),
                      );

                  Navigator.pop(context);
                },
                child: const Text('Aplicar'),
              ),
            ],
          ),
        );
      },
    );
  }
}
