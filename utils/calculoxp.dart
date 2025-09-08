import 'dart:math';

import '../models/jugador.dart';

int calcularXPEncuentro({
  required List<Jugador> jugadores,
  required int danoTotal,
}) {
  const int xpBase = 100;

  // Calcular CR del grupo y de los enemigos
  final crParty = calcularCRParty(jugadores);
  final crEnemigo = calcularCREnemigos(jugadores);

  // Determinar el multiplicador basado en la diferencia de CR
  int multiplicadorCR = (crEnemigo > crParty) ? (crEnemigo - crParty) : 1;

  int totalXP = 0;

  for (var jugador in jugadores) {
    if (jugador.esEnemigo) continue; // Ignorar enemigos

    double porcentajeDano = danoTotal > 0 ? jugador.danoHecho / danoTotal : 0.0;
    double porcentajeAcciones = jugador.accionesClase * 0.01 + jugador.accionesHeroicas * 0.02;

    int xp = (xpBase * (porcentajeDano + porcentajeAcciones)).round();
    xp *= multiplicadorCR;

    totalXP += xp;
  }

  return totalXP;
}

double modificadorFinal({
  required Jugador jugador,
  required int crParty,
}) {
  int accionesTotales = jugador.accionesClaseAcumuladas + jugador.accionesHeroicasAcumuladas;
  double nivelFactor = 1 / pow(2, (jugador.nivel - crParty));
  double mod = accionesTotales * nivelFactor;
  if (jugador.died == true) {
    mod *= 0.5;
  }
  return mod;
}

// Define calcularCRParty to calculate the party's CR
int calcularCRParty(List<Jugador> jugadores) {
  // Example: sum the levels of all non-enemy players and divide by their count
  final party = jugadores.where((j) => !j.esEnemigo).toList();
  if (party.isEmpty) return 1;
  int totalNivel = party.fold(0, (sum, j) => sum + j.nivel);
  return (totalNivel / party.length).round();
}

// Define calcularCREnemigos to calculate the enemies' CR
int calcularCREnemigos(List<Jugador> jugadores) {
  // Example: sum the levels of all enemies and divide by their count
  final enemigos = jugadores.where((j) => j.esEnemigo).toList();
  if (enemigos.isEmpty) return 1;
  int totalNivel = enemigos.fold(0, (sum, j) => sum + j.nivel);
  return (totalNivel / enemigos.length).round();
}

void calcularXPFinal({
  required List<Jugador> jugadores,
  required int crParty,
}) {
  for (var jugador in jugadores) {
    // Calcular el modificador final
    double modFinal = modificadorFinal(
      jugador: jugador,
      crParty: crParty,
    );

    // Calcular la nueva experiencia
    int nuevaXP = (jugador.xp + (jugador.gainedxp * modFinal)).round();

    // Actualizar los valores del jugador
    jugador.gainedxp = (nuevaXP - jugador.xp);
    jugador.xp = nuevaXP;
  }
}

