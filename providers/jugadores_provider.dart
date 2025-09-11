import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../models/jugador.dart';
import '../utils/calculoxp.dart';

// Acceso global a la box de Hive
final jugadoresBox = Hive.box<Jugador>('jugadores');

class JugadoresNotifier extends StateNotifier<List<Jugador>> {
  JugadoresNotifier() : super(jugadoresBox.values.toList());

  void agregarJugador(Jugador j) {
    jugadoresBox.add(j);
    state = jugadoresBox.values.toList();
  }

  void actualizarJugador(int index, Jugador j) {
    jugadoresBox.putAt(index, j);
    state = jugadoresBox.values.toList();
  }

  void eliminarJugador(int index) {
    jugadoresBox.deleteAt(index);
    state = jugadoresBox.values.toList();
  }

  void eliminarEnemigos() {
    for (int i = jugadoresBox.length - 1; i >= 0; i--) {
      final jugador = jugadoresBox.getAt(i);
      if (jugador != null && jugador.esEnemigo) {
        jugadoresBox.deleteAt(i);
      }
    }
    state = jugadoresBox.values.toList();
  }

  void guardarYReiniciarAcciones() {
    for (int i = 0; i < state.length; i++) {
      final jugador = state[i];
      final actualizado = jugador.copyWith(
        accionesClaseAcumuladas: jugador.accionesClaseAcumuladas + jugador.accionesClase,
        accionesHeroicasAcumuladas: jugador.accionesHeroicasAcumuladas + jugador.accionesHeroicas,
        accionesClase: 0,
        accionesHeroicas: 0,
      );
      jugadoresBox.putAt(i, actualizado);
    }
    state = jugadoresBox.values.toList();
  }

  /// Calcula la experiencia individual usando la función pura de calculoxp.dart
  /// y la reparte solo en Hive y el provider (no modifica los objetos directamente).
  void calcularYAcumularXpCombate({
    required int crEnemigos,
    required int crParty,
  }) {
    int danoTotal = state.fold(0, (sum, j) => sum + j.danoHecho);

    // Usar la función pura para obtener los XP individuales por nombre
    final xpPorJugador = calcularXPIndividual(
      jugadores: state,
      danoTotal: danoTotal,
      crEnemigos: crEnemigos,
      crParty: crParty,
    );

    for (int i = 0; i < state.length; i++) {
      final jugador = state[i];
      if (!jugador.esEnemigo) {
        final xpGanada = xpPorJugador[jugador.nombre] ?? 0;
        final actualizado = jugador.copyWith(
          gainedxp: jugador.gainedxp + xpGanada,
          danoHecho: 0,
        );
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
    final jugadoresNoEnemigos = jugadores.where((j) => !j.esEnemigo).toList();
    final nivelTotal = jugadoresNoEnemigos.fold(0, (sum, jugador) => sum + jugador.nivel);
    return (nivelTotal / jugadoresNoEnemigos.length).round();
  }

  int calcularCREnemigos(List<Jugador> jugadores) {
    if (jugadores.isEmpty) return 0;
    final enemigos = jugadores.where((j) => j.esEnemigo).toList();
    final nivelTotal = enemigos.fold(0, (sum, enemigo) => sum + enemigo.nivel);
    return (nivelTotal / enemigos.length).round();
  }
}

final jugadoresProvider =
    StateNotifierProvider<JugadoresNotifier, List<Jugador>>(
  (ref) => JugadoresNotifier(),
);
