import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../models/jugador.dart';
import '../utils/calculoxp.dart'; // Importar para usar SistemaXP y funciones oficiales

// Legacy/global box accessor kept for backward compatibility
final jugadoresBox = Hive.box<Jugador>('jugadores');

class JugadoresNotifier extends StateNotifier<List<Jugador>> {
  final Box<Jugador> box;

  // Inicializa el estado con los valores actuales de la box proporcionada
  JugadoresNotifier(this.box) : super(box.values.toList());

  void recargar() {
    state = box.values.toList();
  }

  void agregarJugador(Jugador j) {
    box.add(j);
    recargar();
  }

  void actualizarJugador(int index, Jugador j) {
    box.putAt(index, j);
    recargar();
  }

  void eliminarJugador(int index) {
    box.deleteAt(index);
    recargar();
  }

  // Eliminar enemigos del estado global
  void eliminarEnemigos() {
    for (int i = jugadoresBox.length - 1; i >= 0; i--) {
      final jugador = jugadoresBox.getAt(i);
      if (jugador != null && jugador.esEnemigo) {
        jugadoresBox.deleteAt(i);
      }
    }
    state = jugadoresBox.values.toList();
  }

  // Guardar acciones y reiniciar contadores
  void guardarYReiniciarAcciones() {
    for (int i = 0; i < state.length; i++) {
      final jugador = state[i];
      final actualizado = jugador.copyWith(
        accionesClaseAcumuladas: jugador.accionesClaseAcumuladas + jugador.accionesClase,
        accionesHeroicasAcumuladas: jugador.accionesHeroicasAcumuladas + jugador.accionesHeroicas,
        accionesClase: 0, // Reiniciar acciones actuales
        accionesHeroicas: 0, // Reiniciar acciones actuales
      );
      jugadoresBox.putAt(i, actualizado);
    }
    state = jugadoresBox.values.toList();
  }

  // NUEVO: Calcular experiencia oficial de Pathfinder y D&D
  void calcularYAcumularXpOficial({
    required SistemaJuego sistema,
    String? dificultadManual,
  }) {
    // Calcular dificultad automáticamente
    final dificultad = dificultadManual ?? calcularDificultadUnificada(
      jugadores: state,
      sistema: sistema,
    );

    // Calcular XP por jugador usando el sistema oficial
    final xpPorJugador = calcularXPUnificado(
      jugadores: state,
      sistema: sistema,
      dificultadManual: dificultad,
    );

    // Solo actualizar jugadores del party (no enemigos)
    for (int i = 0; i < state.length; i++) {
      final jugador = state[i];
      
      if (!jugador.esEnemigo) {
        final actualizado = jugador.copyWith(
          gainedxp: jugador.gainedxp + xpPorJugador,
          danoHecho: 0, // Resetear daño después del combate
        );
        jugadoresBox.putAt(i, actualizado);
      } else {
        // Para enemigos, solo resetear daño
        final actualizado = jugador.copyWith(danoHecho: 0);
        jugadoresBox.putAt(i, actualizado);
      }
    }
    
    state = jugadoresBox.values.toList();
  }

  void limpiarJugadores() {
    state = [];
  }

  int calcularCRParty(List<Jugador> jugadores) {
    if (jugadores.isEmpty) return 0;

    // Filtrar solo los jugadores que no son enemigos
    final jugadoresNoEnemigos = jugadores.where((j) => !j.esEnemigo).toList();

    // Calcular el promedio de niveles
    final nivelTotal = jugadoresNoEnemigos.fold(0, (sum, jugador) => sum + jugador.nivel);
    return (nivelTotal / jugadoresNoEnemigos.length).round();
  }

  int calcularCREnemigos(List<Jugador> jugadores) {
    if (jugadores.isEmpty) return 0;

    // Filtrar solo los enemigos
    final enemigos = jugadores.where((j) => j.esEnemigo).toList();

    // Calcular el promedio de niveles de los enemigos
    final nivelTotal = enemigos.fold(0, (sum, enemigo) => sum + enemigo.nivel);
    return (nivelTotal / enemigos.length).round();
  }
}

final jugadoresProvider = StateNotifierProvider<JugadoresNotifier, List<Jugador>>(
  (ref) => JugadoresNotifier(jugadoresBox),
);

// Family provider for per-slot jugadores boxes. Usage: ref.watch(jugadoresProviderForSlot(slot))
final jugadoresProviderForSlot = StateNotifierProvider.family<JugadoresNotifier, List<Jugador>, int>((ref, slot) {
  final boxName = 'jugadores_slot_$slot';
  // Open the box if not already open (synchronously if possible)
  if (!Hive.isBoxOpen(boxName)) {
    Hive.openBox<Jugador>(boxName);
  }
  final box = Hive.box<Jugador>(boxName);
  return JugadoresNotifier(box);
});
