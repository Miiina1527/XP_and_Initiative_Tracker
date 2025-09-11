import 'dart:math';
import '../models/jugador.dart';

/// Devuelve un Map con la XP ganada por cada jugador (solo party, no enemigos).
Map<String, int> calcularXPIndividual({
  required List<Jugador> jugadores,
  required int danoTotal,
  required int crEnemigos,
  required int crParty,
}) {
  final result = <String, int>{};
  int multiplicador = (crEnemigos - crParty);
  if (multiplicador < 1) multiplicador = 1;

  for (final jugador in jugadores) {
    if (jugador.esEnemigo) continue;
    double porcentajeDanio = danoTotal > 0 ? jugador.danoHecho / danoTotal : 0.0;
    int acciones = jugador.accionesClase + (2 * jugador.accionesHeroicas);
    int xp = ((porcentajeDanio * 100).round() + acciones) * multiplicador;
    result[jugador.nombre] = xp;
  }
  return result;
}

int calcularXPEncuentro({
  required List<Jugador> jugadores,
  required int danoTotal,
}) {
  const int xpBase = 100;
  final crParty = calcularCRParty(jugadores);
  final crEnemigo = calcularCREnemigos(jugadores);
  int multiplicadorCR = (crEnemigo > crParty) ? (crEnemigo - crParty) : 1;
  int totalXP = 0;

  for (var jugador in jugadores) {
    if (jugador.esEnemigo) continue;
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

int calcularCRParty(List<Jugador> jugadores) {
  final party = jugadores.where((j) => !j.esEnemigo).toList();
  if (party.isEmpty) return 1;
  int totalNivel = party.fold(0, (sum, j) => sum + j.nivel);
  return (totalNivel / party.length).round();
}

int calcularCREnemigos(List<Jugador> jugadores) {
  final enemigos = jugadores.where((j) => j.esEnemigo).toList();
  if (enemigos.isEmpty) return 1;
  int totalNivel = enemigos.fold(0, (sum, j) => sum + j.nivel);
  return (totalNivel / enemigos.length).round();
}

/// Esta función solo modifica en RAM, úsala solo para XP final acumulada al cerrar sesión.
/// Para el reparto XP de combate, usa calcularXPIndividual + provider.
void calcularXPFinal({
  required List<Jugador> jugadores,
  required int crParty,
}) {
  for (var jugador in jugadores) {
    double modFinal = modificadorFinal(
      jugador: jugador,
      crParty: crParty,
    );
    int nuevaXP = (jugador.xp + (jugador.gainedxp * modFinal)).round();
    jugador.gainedxp = (nuevaXP - jugador.xp);
    jugador.xp = nuevaXP;
    jugador.xpAcumulada += jugador.gainedxp;
  }
}
