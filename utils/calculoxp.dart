// ignore_for_file: constant_identifier_names, non_constant_identifier_names

import 'dart:math';

import '../models/jugador.dart';

// Sistemas de juego soportados
enum SistemaJuego {
  pathfinder1e,
  pathfinder2e,
  dnd5e,
  dnd5e2024,
}

// Enum para compatibilidad con código existente
enum SistemaXP { pathfinder1e, pathfinder2e }

// Tablas oficiales de XP por CR - Pathfinder 1e
const Map<int, int> xpPorCR_PF1e = {
  1: 400,
  2: 600,
  3: 800,
  4: 1200,
  5: 1600,
  6: 2400,
  7: 3200,
  8: 4800,
  9: 6400,
  10: 9600,
  11: 12800,
  12: 19200,
  13: 25600,
  14: 38400,
  15: 51200,
  16: 76800,
  17: 102400,
  18: 153600,
  19: 204800,
  20: 307200,
  21: 409600,
  22: 614400,
  23: 819200,
  24: 1228800,
  25: 1638400,
};

// Tablas oficiales de XP por CR - Pathfinder 2e
const Map<int, int> xpPorCR_PF2e = {
  1: 40,
  2: 60,
  3: 80,
  4: 120,
  5: 160,
  6: 240,
  7: 320,
  8: 480,
  9: 640,
  10: 960,
  11: 1280,
  12: 1920,
  13: 2560,
  14: 3840,
  15: 5120,
  16: 7680,
  17: 10240,
  18: 15360,
  19: 20480,
  20: 30720,
  21: 40960,
  22: 61440,
  23: 81920,
  24: 122880,
  25: 163840,
};

// Tablas oficiales de XP por CR - D&D 5e (incluyendo fraccionarios)
final Map<double, int> xpPorCR_DnD5e = {
  0.0: 10,      // CR 0
  0.125: 25,    // CR 1/8
  0.25: 50,     // CR 1/4
  0.5: 100,     // CR 1/2
  1.0: 200,     // CR 1
  2.0: 450,     // CR 2
  3.0: 700,     // CR 3
  4.0: 1100,    // CR 4
  5.0: 1800,    // CR 5
  6.0: 2300,    // CR 6
  7.0: 2900,    // CR 7
  8.0: 3900,    // CR 8
  9.0: 5000,    // CR 9
  10.0: 5900,   // CR 10
  11.0: 7200,   // CR 11
  12.0: 8400,   // CR 12
  13.0: 10000,  // CR 13
  14.0: 11500,  // CR 14
  15.0: 13000,  // CR 15
  16.0: 15000,  // CR 16
  17.0: 18000,  // CR 17
  18.0: 20000,  // CR 18
  19.0: 22000,  // CR 19
  20.0: 25000,  // CR 20
  21.0: 33000,  // CR 21
  22.0: 41000,  // CR 22
  23.0: 50000,  // CR 23
  24.0: 62000,  // CR 24
  25.0: 75000,  // CR 25
  26.0: 90000,  // CR 26
  27.0: 105000, // CR 27
  28.0: 120000, // CR 28
  29.0: 135000, // CR 29
  30.0: 155000, // CR 30
};

// Tablas de XP por CR - D&D 5.5e/2024 (igual que 5e por ahora)
final Map<double, int> xpPorCR_DnD5e2024 = xpPorCR_DnD5e;

// Multiplicadores de encuentro D&D (número de monstruos)
const Map<int, double> multiplicadoresEncuentro_DnD = {
  1: 1.0,
  2: 1.5,
  3: 2.0,
  4: 2.0,
  5: 2.5,
  6: 2.5,
  7: 3.0,
  8: 3.0,
  9: 3.5,
  10: 3.5,
  11: 4.0,
  12: 4.0,
  13: 4.5,
  14: 4.5,
  15: 5.0,
};

// Thresholds de dificultad D&D 5e por nivel de jugador
const Map<int, Map<String, int>> xpThresholds_DnD5e = {
  1: {'easy': 25, 'medium': 50, 'hard': 75, 'deadly': 100},
  2: {'easy': 50, 'medium': 100, 'hard': 150, 'deadly': 200},
  3: {'easy': 75, 'medium': 150, 'hard': 225, 'deadly': 400},
  4: {'easy': 125, 'medium': 250, 'hard': 375, 'deadly': 500},
  5: {'easy': 250, 'medium': 500, 'hard': 750, 'deadly': 1100},
  6: {'easy': 300, 'medium': 600, 'hard': 900, 'deadly': 1400},
  7: {'easy': 350, 'medium': 750, 'hard': 1100, 'deadly': 1700},
  8: {'easy': 450, 'medium': 900, 'hard': 1400, 'deadly': 2100},
  9: {'easy': 550, 'medium': 1100, 'hard': 1600, 'deadly': 2400},
  10: {'easy': 600, 'medium': 1200, 'hard': 1900, 'deadly': 2800},
  11: {'easy': 800, 'medium': 1600, 'hard': 2400, 'deadly': 3600},
  12: {'easy': 1000, 'medium': 2000, 'hard': 3000, 'deadly': 4500},
  13: {'easy': 1100, 'medium': 2200, 'hard': 3400, 'deadly': 5100},
  14: {'easy': 1250, 'medium': 2500, 'hard': 3800, 'deadly': 5700},
  15: {'easy': 1400, 'medium': 2800, 'hard': 4300, 'deadly': 6400},
  16: {'easy': 1600, 'medium': 3200, 'hard': 4800, 'deadly': 7200},
  17: {'easy': 2000, 'medium': 3900, 'hard': 5900, 'deadly': 8800},
  18: {'easy': 2100, 'medium': 4200, 'hard': 6300, 'deadly': 9500},
  19: {'easy': 2400, 'medium': 4900, 'hard': 7300, 'deadly': 10900},
  20: {'easy': 2800, 'medium': 5700, 'hard': 8500, 'deadly': 12700},
};

// Modificadores de dificultad de encuentro para Pathfinder 1e
const Map<String, double> modificadoresDificultad_PF1e = {
  'trivial': 0.5,
  'facil': 0.75,
  'moderado': 1.0,
  'dificil': 1.5,
  'epico': 2.0,
};

// Modificadores de dificultad de encuentro para Pathfinder 2e
const Map<String, double> modificadoresDificultad_PF2e = {
  'trivial': 0.5,
  'bajo': 0.75,
  'moderado': 1.0,
  'severo': 1.5,
  'extremo': 2.0,
};

// Función para obtener el CR efectivo de una criatura
int obtenerCR(Jugador criatura) {
  if (criatura.esEnemigo) {
    // Monstruos: CR = nivel
    return criatura.nivel;
  } else {
    // Jugadores: CR = nivel - 1 (mínimo 1)
    return (criatura.nivel - 1).clamp(1, criatura.nivel);
  }
}

// Función para obtener CR como double para D&D (soporta fraccionarios)
double obtenerCRDouble(Jugador jugador) {
  if (jugador.esEnemigo) {
    // Para enemigos, usar nivel directamente (puede ser fraccionario en base de datos)
    return jugador.nivel.toDouble();
  } else {
    // Para jugadores, usar nivel-1 como CR (mínimo 0)
    return (jugador.nivel - 1).clamp(0, double.infinity).toDouble();
  }
}

// Función para calcular XP oficial basada en CR de enemigos (PATHFINDER)
int calcularXPOficial({
  required List<Jugador> jugadores,
  required SistemaXP sistema,
  String dificultad = 'moderado',
}) {
  // Obtener solo enemigos vivos para el cálculo
  final enemigos = jugadores.where((j) => j.esEnemigo && j.hp > 0).toList();
  final party = jugadores.where((j) => !j.esEnemigo).toList();
  
  if (enemigos.isEmpty || party.isEmpty) return 0;

  // Seleccionar tabla de XP según el sistema
  final tablaXP = sistema == SistemaXP.pathfinder1e ? xpPorCR_PF1e : xpPorCR_PF2e;
  final modificadores = sistema == SistemaXP.pathfinder1e 
      ? modificadoresDificultad_PF1e 
      : modificadoresDificultad_PF2e;

  // Calcular XP total de todos los enemigos usando CR efectivo
  int xpTotalEnemigos = 0;
  for (final enemigo in enemigos) {
    final cr = obtenerCR(enemigo);
    xpTotalEnemigos += tablaXP[cr] ?? 0;
  }

  // Aplicar modificador de dificultad
  final modificador = modificadores[dificultad] ?? 1.0;
  final xpConModificador = (xpTotalEnemigos * modificador).round();

  // Dividir equitativamente entre miembros del party
  final xpPorJugador = (xpConModificador / party.length).round();

  return xpPorJugador;
}

// Función para determinar automáticamente la dificultad del encuentro (PATHFINDER)
String calcularDificultadEncuentro({
  required List<Jugador> jugadores,
  required SistemaXP sistema,
}) {
  final enemigos = jugadores.where((j) => j.esEnemigo && j.hp > 0).toList();
  final party = jugadores.where((j) => !j.esEnemigo).toList();
  
  if (enemigos.isEmpty || party.isEmpty) return 'moderado';

  // Calcular XP total de todos los enemigos (sin modificadores) usando CR efectivo
  final tablaXP = sistema == SistemaXP.pathfinder1e ? xpPorCR_PF1e : xpPorCR_PF2e;
  int xpTotalEnemigos = 0;
  for (final enemigo in enemigos) {
    final cr = obtenerCR(enemigo);
    xpTotalEnemigos += tablaXP[cr] ?? 0;
  }

  // Calcular nivel promedio del party usando CR efectivo
  final crPartyPromedio = party.fold(0.0, (sum, j) => sum + obtenerCR(j)) / party.length;
  
  // XP esperada para encuentro moderado según el CR promedio del party
  final xpModeradoPorJugador = tablaXP[crPartyPromedio.round()] ?? 0;
  final xpModeradoTotal = xpModeradoPorJugador * party.length;
  
  // Evitar división por cero
  if (xpModeradoTotal == 0) return 'moderado';
  
  // Comparar XP del encuentro vs XP esperada para determinar dificultad
  final ratio = xpTotalEnemigos / xpModeradoTotal;
  
  if (ratio <= 0.5) return 'trivial';
  if (ratio <= 0.75) return sistema == SistemaXP.pathfinder1e ? 'facil' : 'bajo';
  if (ratio <= 1.25) return 'moderado';
  if (ratio <= 1.75) return sistema == SistemaXP.pathfinder1e ? 'dificil' : 'severo';
  return sistema == SistemaXP.pathfinder1e ? 'epico' : 'extremo';
}

// ========= FUNCIONES ESPECÍFICAS PARA D&D 5E =========

// Función para calcular XP usando el sistema D&D 5e
int calcularXPDnD5e({
  required List<Jugador> jugadores,
  required SistemaJuego sistema,
  String? dificultadManual,
}) {
  final enemigos = jugadores.where((j) => j.esEnemigo && j.hp > 0).toList();
  final party = jugadores.where((j) => !j.esEnemigo).toList();
  
  if (enemigos.isEmpty || party.isEmpty) return 0;

  // Obtener tabla apropiada según el sistema
  final tablaXP = sistema == SistemaJuego.dnd5e ? xpPorCR_DnD5e : xpPorCR_DnD5e2024;

  // 1. Calcular XP base de todos los enemigos
  int xpBaseTotal = 0;
  for (final enemigo in enemigos) {
    final cr = obtenerCRDouble(enemigo);
    xpBaseTotal += tablaXP[cr]?.toInt() ?? 0;
  }

  // 2. Aplicar multiplicador de encuentro basado en número de enemigos
  final numEnemigos = enemigos.length;
  final multiplicador = multiplicadoresEncuentro_DnD[numEnemigos] ?? 
      (numEnemigos > 15 ? 5.0 : 4.5); // Para más de 15 enemigos

  final xpAjustado = (xpBaseTotal * multiplicador).round();

  // 3. Dividir entre jugadores del party
  final xpPorJugador = (xpAjustado / party.length).round();

  return xpPorJugador;
}

// Función para determinar dificultad de encuentro D&D 5e
String calcularDificultadDnD5e({
  required List<Jugador> jugadores,
  required SistemaJuego sistema,
}) {
  final enemigos = jugadores.where((j) => j.esEnemigo && j.hp > 0).toList();
  final party = jugadores.where((j) => !j.esEnemigo).toList();
  
  if (enemigos.isEmpty || party.isEmpty) return 'medium';

  // Calcular XP ajustado del encuentro
  final tablaXP = sistema == SistemaJuego.dnd5e ? xpPorCR_DnD5e : xpPorCR_DnD5e2024;
  
  int xpBaseTotal = 0;
  for (final enemigo in enemigos) {
    final cr = obtenerCRDouble(enemigo);
    xpBaseTotal += tablaXP[cr]?.toInt() ?? 0;
  }

  final multiplicador = multiplicadoresEncuentro_DnD[enemigos.length] ?? 
      (enemigos.length > 15 ? 5.0 : 4.5);
  final xpAjustado = (xpBaseTotal * multiplicador).round();

  // Calcular thresholds basados en niveles del party
  int easyThreshold = 0, mediumThreshold = 0, hardThreshold = 0, deadlyThreshold = 0;
  
  for (final jugador in party) {
    final nivel = jugador.nivel.clamp(1, 20);
    final thresholds = xpThresholds_DnD5e[nivel] ?? xpThresholds_DnD5e[1]!;
    
    easyThreshold += thresholds['easy']!;
    mediumThreshold += thresholds['medium']!;
    hardThreshold += thresholds['hard']!;
    deadlyThreshold += thresholds['deadly']!;
  }

  // Determinar dificultad
  if (xpAjustado >= deadlyThreshold) {
    return 'deadly';
  } else if (xpAjustado >= hardThreshold) {
    return 'hard';
  } else if (xpAjustado >= mediumThreshold) {
    return 'medium';
  } else if (xpAjustado >= easyThreshold) {
    return 'easy';
  } else {
    return 'trivial'; // Por debajo del threshold easy
  }
}

// ========= FUNCIONES UNIFICADAS =========

// Función unificada para calcular XP (Pathfinder y D&D)
int calcularXPUnificado({
  required List<Jugador> jugadores,
  required SistemaJuego sistema,
  String? dificultadManual,
}) {
  switch (sistema) {
    case SistemaJuego.pathfinder1e:
      return calcularXPOficial(
        jugadores: jugadores,
        sistema: SistemaXP.pathfinder1e,
        dificultad: dificultadManual ?? 'moderado',
      );
    case SistemaJuego.pathfinder2e:
      return calcularXPOficial(
        jugadores: jugadores,
        sistema: SistemaXP.pathfinder2e,
        dificultad: dificultadManual ?? 'moderado',
      );
    case SistemaJuego.dnd5e:
    case SistemaJuego.dnd5e2024:
      return calcularXPDnD5e(
        jugadores: jugadores,
        sistema: sistema,
        dificultadManual: dificultadManual,
      );
  }
}

// Función unificada para calcular dificultad (Pathfinder y D&D)
String calcularDificultadUnificada({
  required List<Jugador> jugadores,
  required SistemaJuego sistema,
}) {
  switch (sistema) {
    case SistemaJuego.pathfinder1e:
      return calcularDificultadEncuentro(
        jugadores: jugadores,
        sistema: SistemaXP.pathfinder1e,
      );
    case SistemaJuego.pathfinder2e:
      return calcularDificultadEncuentro(
        jugadores: jugadores,
        sistema: SistemaXP.pathfinder2e,
      );
    case SistemaJuego.dnd5e:
    case SistemaJuego.dnd5e2024:
      return calcularDificultadDnD5e(
        jugadores: jugadores,
        sistema: sistema,
      );
  }
}

// ========= FUNCIONES LEGACY (para compatibilidad) =========

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
    jugador.xpAcumulada += jugador.gainedxp;
  }
}