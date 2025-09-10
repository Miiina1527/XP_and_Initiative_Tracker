import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../models/jugador.dart';

// Acceso global a la box de Hive
final jugadoresBox = Hive.box<Jugador>('jugadores');

class JugadoresNotifier extends StateNotifier<List<Jugador>> {
  // Inicializa el estado con los valores actuales de Hive
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

  // Calcular experiencia del combate y acumularla
  void calcularYAcumularXpCombate({
    required int crEnemigos,
    required int crParty,
  }) {
    // Calcular el daño total infligido por todos los jugadores
    int totalDanio = 0;
    for (final jugador in state) {
      totalDanio += jugador.danoHecho;
    }

    // Calcular el multiplicador basado en la diferencia de CR
    int multiplicador = (crEnemigos - crParty);
    if (multiplicador < 1) multiplicador = 1;

    // Iterar sobre cada jugador para calcular su experiencia
    for (int i = 0; i < state.length; i++) {
      final jugador = state[i];
      // Calcular el porcentaje de daño hecho por el jugador
      double porcentajeDanio = totalDanio > 0 ? jugador.danoHecho / totalDanio : 0;

      // Calcular las acciones realizadas por el jugador
      int acciones = jugador.accionesClase + (2 * jugador.accionesHeroicas);

      // Calcular la experiencia ganada por el jugador
      int xpJugador = ((porcentajeDanio * 100).round() + acciones) * multiplicador;

      final actualizado = jugador.copyWith(
        gainedxp: jugador.gainedxp + xpJugador,
        danoHecho: 0,
      );
      jugadoresBox.putAt(i, actualizado);
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

final jugadoresProvider =
    StateNotifierProvider<JugadoresNotifier, List<Jugador>>(
  (ref) => JugadoresNotifier(),
);
