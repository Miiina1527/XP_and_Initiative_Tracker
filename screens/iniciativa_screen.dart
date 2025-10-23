import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:easy_localization/easy_localization.dart';
import '../models/jugador.dart';
import '../providers/jugadores_provider.dart';
import '../providers/combate_provider.dart';
import '../utils/calculoxp.dart'; // Importar el enum SistemaJuego
import 'turno_screen.dart';

// Provider persistente para manejar el sistema de juego seleccionado
class SistemaJuegoNotifier extends StateNotifier<SistemaJuego> {
  static const String _boxName = 'configuracion';
  static const String _sistemaJuegoKey = 'sistemaJuego';
  
  SistemaJuegoNotifier() : super(SistemaJuego.pathfinder1e) {
    _cargarSistema();
  }
  
  Future<void> _cargarSistema() async {
    try {
      final box = await Hive.openBox(_boxName);
      final sistemaGuardado = box.get(_sistemaJuegoKey);
      if (sistemaGuardado != null) {
        // Convertir string guardado a enum
        switch (sistemaGuardado) {
          case 'pathfinder1e':
            state = SistemaJuego.pathfinder1e;
            break;
          case 'pathfinder2e':
            state = SistemaJuego.pathfinder2e;
            break;
          case 'dnd5e':
            state = SistemaJuego.dnd5e;
            break;
          case 'dnd5e2024':
            state = SistemaJuego.dnd5e2024;
            break;
          default:
            state = SistemaJuego.pathfinder1e;
        }
      }
    } catch (e) {
      // Si hay error, mantener valor por defecto
      state = SistemaJuego.pathfinder1e;
    }
  }
  
  Future<void> cambiarSistema(SistemaJuego nuevoSistema) async {
    state = nuevoSistema;
    try {
      final box = await Hive.openBox(_boxName);
      // Guardar como string para simplicidad
      String sistemaString;
      switch (nuevoSistema) {
        case SistemaJuego.pathfinder1e:
          sistemaString = 'pathfinder1e';
          break;
        case SistemaJuego.pathfinder2e:
          sistemaString = 'pathfinder2e';
          break;
        case SistemaJuego.dnd5e:
          sistemaString = 'dnd5e';
          break;
        case SistemaJuego.dnd5e2024:
          sistemaString = 'dnd5e2024';
          break;
      }
      await box.put(_sistemaJuegoKey, sistemaString);
    } catch (e) {
      // Si hay error al guardar, no afecta la funcionalidad
    }
  }
}

final sistemaJuegoProvider = StateNotifierProvider<SistemaJuegoNotifier, SistemaJuego>(
  (ref) => SistemaJuegoNotifier(),
);

class IniciativaScreen extends ConsumerStatefulWidget {
  final int? campaignSlot;
  final SistemaJuego? initialSistema;
  final bool hideSistemaSelector;

  const IniciativaScreen({super.key, this.campaignSlot, this.initialSistema, this.hideSistemaSelector = false});

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
  final jugadores = widget.campaignSlot != null && Hive.isBoxOpen('jugadores_slot_${widget.campaignSlot}')
    ? ref.watch(jugadoresProviderForSlot(widget.campaignSlot!))
    : ref.watch(jugadoresProvider);
  final bool hasSlotBox = widget.campaignSlot != null && Hive.isBoxOpen('jugadores_slot_${widget.campaignSlot}');
  final jugadoresNotifier = hasSlotBox
    ? ref.read(jugadoresProviderForSlot(widget.campaignSlot!).notifier)
    : ref.read(jugadoresProvider.notifier);

    // If this screen was opened with an initialSistema from campaign, ensure provider reflects it
    if (widget.initialSistema != null) {
      // Map calculoxp.SistemaJuego to local SistemaJuego enum used in this file
      // They are the same type; just call the notifier
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(sistemaJuegoProvider.notifier).cambiarSistema(widget.initialSistema!);
      });
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F0E6), // tono pergamino
      appBar: AppBar(
        title: Text("initiative_title".tr()),
        backgroundColor: const Color(0xFF8B5E3C), // marrón cálido
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            // Selector de Sistema de XP (can be hidden when opened from a campaign)
            if (!widget.hideSistemaSelector)
              Card(
              color: const Color(0xFFFFF8E7),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: Color(0xFF8B5E3C), width: 2),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.auto_awesome,
                          color: Colors.amber.shade700,
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "experience_system".tr(),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF8B5E3C),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (!widget.hideSistemaSelector)
                      Consumer(
                      builder: (context, ref, child) {
                        final sistemaActual = ref.watch(sistemaJuegoProvider);
                        
                        return Column(
                          children: [
                            // Primera fila: Pathfinder 1e y 2e
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: sistemaActual == SistemaJuego.pathfinder1e 
                                          ? const Color(0xFF8B5E3C)
                                          : Colors.grey.shade300,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(8),
                                      onTap: () => ref.read(sistemaJuegoProvider.notifier).cambiarSistema(SistemaJuego.pathfinder1e),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.shield,
                                                  color: sistemaActual == SistemaJuego.pathfinder1e 
                                                      ? Colors.white 
                                                      : Colors.grey.shade600,
                                                  size: 20,
                                                ),
                                                const SizedBox(width: 6),
                                                Text(
                                                  "system_pathfinder_1e".tr(),
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14,
                                                    color: sistemaActual == SistemaJuego.pathfinder1e 
                                                        ? Colors.white 
                                                        : Colors.grey.shade600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              "generous_xp".tr(),
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: sistemaActual == SistemaJuego.pathfinder1e 
                                                    ? Colors.white70 
                                                    : Colors.grey.shade500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: sistemaActual == SistemaJuego.pathfinder2e 
                                          ? const Color(0xFF8B5E3C)
                                          : Colors.grey.shade300,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(8),
                                      onTap: () => ref.read(sistemaJuegoProvider.notifier).cambiarSistema(SistemaJuego.pathfinder2e),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.shield,
                                                  color: sistemaActual == SistemaJuego.pathfinder2e 
                                                      ? Colors.white 
                                                      : Colors.grey.shade600,
                                                  size: 20,
                                                ),
                                                const SizedBox(width: 6),
                                                Text(
                                                  "system_pathfinder_2e".tr(),
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14,
                                                    color: sistemaActual == SistemaJuego.pathfinder2e 
                                                        ? Colors.white 
                                                        : Colors.grey.shade600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              "balanced_xp".tr(),
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: sistemaActual == SistemaJuego.pathfinder2e 
                                                    ? Colors.white70 
                                                    : Colors.grey.shade500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            // Segunda fila: D&D 5e y D&D 5.5e (2024)
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: sistemaActual == SistemaJuego.dnd5e 
                                          ? const Color(0xFFDC143C)
                                          : Colors.grey.shade300,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(8),
                                      onTap: () => ref.read(sistemaJuegoProvider.notifier).cambiarSistema(SistemaJuego.dnd5e),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.casino,
                                                  color: sistemaActual == SistemaJuego.dnd5e 
                                                      ? Colors.white 
                                                      : Colors.grey.shade600,
                                                  size: 20,
                                                ),
                                                const SizedBox(width: 6),
                                                Text(
                                                  "system_dnd_5e_2014".tr(),
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14,
                                                    color: sistemaActual == SistemaJuego.dnd5e 
                                                        ? Colors.white 
                                                        : Colors.grey.shade600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              '2014 Edition',
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: sistemaActual == SistemaJuego.dnd5e 
                                                    ? Colors.white70 
                                                    : Colors.grey.shade500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: sistemaActual == SistemaJuego.dnd5e2024 
                                          ? const Color(0xFFDC143C)
                                          : Colors.grey.shade300,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(8),
                                      onTap: () => ref.read(sistemaJuegoProvider.notifier).cambiarSistema(SistemaJuego.dnd5e2024),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.casino,
                                                  color: sistemaActual == SistemaJuego.dnd5e2024 
                                                      ? Colors.white 
                                                      : Colors.grey.shade600,
                                                  size: 20,
                                                ),
                                                const SizedBox(width: 6),
                                                Text(
                                                  "system_dnd_5e_2024".tr(),
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14,
                                                    color: sistemaActual == SistemaJuego.dnd5e2024 
                                                        ? Colors.white 
                                                        : Colors.grey.shade600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              '2024 Edition',
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: sistemaActual == SistemaJuego.dnd5e2024 
                                                    ? Colors.white70 
                                                    : Colors.grey.shade500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                      ),
                    const SizedBox(height: 8),
                    Consumer(
                      builder: (context, ref, child) {
                        final sistemaActual = ref.watch(sistemaJuegoProvider);
                        final jugadores = widget.campaignSlot != null && Hive.isBoxOpen('jugadores_slot_${widget.campaignSlot}')
                            ? ref.watch(jugadoresProviderForSlot(widget.campaignSlot!))
                            : ref.watch(jugadoresProvider);
                        
                        // Calcular dificultad automática si hay jugadores
                        String dificultad = 'moderado';
                        if (jugadores.isNotEmpty) {
                          dificultad = calcularDificultadUnificada(
                            jugadores: jugadores,
                            sistema: sistemaActual,
                          );
                        }
                        
                        return Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.amber.shade50,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: Colors.amber.shade200),
                          ),
                          child: Text(
                            '${"estimated_difficulty".tr()}: ${dificultad.toUpperCase()}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.amber.shade800,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: jugadores.isEmpty
                  ? Center(
                      child: Text(
                        "no_characters_registered".tr(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
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
                              jugador.esEnemigo ? "enemy".tr() : "player".tr(),
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
                                      final hasSlotBox = widget.campaignSlot != null && Hive.isBoxOpen('jugadores_slot_${widget.campaignSlot}');
                                      if (hasSlotBox) {
                                        jugadoresNotifier.actualizarJugador(
                                          index,
                                          jugador.copyWith(iniciativa: ini),
                                        );
                                      } else {
                                        jugadoresNotifier.actualizarJugador(
                                          index,
                                          jugador.copyWith(iniciativa: ini),
                                        );
                                      }
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
                        MaterialPageRoute(builder: (_) => TurnoScreen(campaignSlot: widget.campaignSlot)),
                      );
                    },
              label: Text(
                "start_combat_button".tr(),
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
