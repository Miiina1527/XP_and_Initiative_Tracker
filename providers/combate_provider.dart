import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/jugador.dart';

class CombateState {
  final List<Jugador> ordenIniciativa;
  final int turnoActual;
  final bool combateActivo;

  CombateState({
    this.ordenIniciativa = const [],
    this.turnoActual = 0,
    this.combateActivo = false,
  });

  CombateState copiarCon({
    List<Jugador>? ordenIniciativa,
    int? turnoActual,
    bool? combateActivo,
  }) {
    return CombateState(
      ordenIniciativa: ordenIniciativa ?? this.ordenIniciativa,
      turnoActual: turnoActual ?? this.turnoActual,
      combateActivo: combateActivo ?? this.combateActivo,
    );
  }
}

class CombateNotifier extends StateNotifier<CombateState> {
  CombateNotifier() : super(CombateState());

  /// Inicia el combate con la lista de jugadores
  void iniciarCombate(List<Jugador> jugadores) {
    if (state.combateActivo) {
      throw Exception('Ya hay un combate activo. Termina el combate actual antes de iniciar uno nuevo.');
    }

    final ordenIniciativa = jugadores
        .where((j) => j.hp > 0)
        .toList()
      ..sort((a, b) => b.iniciativa.compareTo(a.iniciativa));

    state = CombateState(
      combateActivo: true,
      ordenIniciativa: ordenIniciativa,
      turnoActual: 0,
    );
  }

  void siguienteTurno() {
    if (state.ordenIniciativa.isEmpty) return;
    int siguiente = (state.turnoActual + 1) % state.ordenIniciativa.length;
    state = state.copiarCon(turnoActual: siguiente);
  }

  void terminarCombate() {
    state = CombateState(
      combateActivo: false,
      ordenIniciativa: [],
      turnoActual: 0,
    );
  }

  bool enemigosDerrotados() {
    return state.ordenIniciativa
        .where((j) => j.esEnemigo)
        .every((j) => j.hp <= 0);
  }

  void actualizarOrdenIniciativa(List<dynamic> nuevaOrden) {
    state = state.copiarCon(ordenIniciativa: nuevaOrden.cast<Jugador>());
  }
}

final combateProvider = StateNotifierProvider<CombateNotifier, CombateState>((ref) {
  return CombateNotifier();
});
