/// Tabla de experiencia por nivel (progresión media Pathfinder)
const Map<int, int> tablaXpMediaPathfinder = {
  0: 0,
	1: 1000,
	2: 2000,
	3: 5000,
	4: 9000,
	5: 15000,
	6: 23000,
	7: 35000,
	8: 51000,
	9: 75000,
 10: 105000,
 11: 145000,
 12: 210000,
 13: 300000,
 14: 425000,
 15: 600000,
 16: 850000,
 17: 1200000,
 18: 1700000,
 19: 2400000,
 20: 3550000,
};

/// Calcula cuánta XP se ha usado para cada clase según los niveles y la tabla de XP
Map<String, int> calcularXpPorClase({
	required int nivelClase1,
	required int nivelClase2,
	required int nivelClase3,
}) {
	int xpClase1 = nivelClase1 > 0 ? tablaXpMediaPathfinder[nivelClase1]! : 0;
	int xpClase2 = nivelClase2 > 0 ? (tablaXpMediaPathfinder[nivelClase2]! * 2) : 0;
	int xpClase3 = nivelClase3 > 0 ? (tablaXpMediaPathfinder[nivelClase3]! * 3) : 0;
	return {
		'clase1': xpClase1,
		'clase2': xpClase2,
		'clase3': xpClase3,
	};
}

/// Calcula la XP sobrante para gastar en el siguiente nivel (todas las clases)
int calcularXpSobrante({
	required int xpTotal,
	required int nivelClase1,
	required int nivelClase2,
	required int nivelClase3,
}) {
	final xpPorClase = calcularXpPorClase(
		nivelClase1: nivelClase1,
		nivelClase2: nivelClase2,
		nivelClase3: nivelClase3,
	);
	final xpUsada = xpPorClase.values.fold(0, (a, b) => a + b);
	return xpTotal - xpUsada;
}

/// Calcula la XP necesaria para subir de nivel en una clase específica, considerando el multiplicador
int calcularXpParaSubirNivel({
	required int clase, // 1, 2 o 3
	required int nivelActual,
}) {
	final siguienteNivel = nivelActual + 1;
	final xpSiguienteNivel = tablaXpMediaPathfinder[siguienteNivel] ?? 0;
	final xpActualNivel = tablaXpMediaPathfinder[nivelActual] ?? 0;
	final base = xpSiguienteNivel - xpActualNivel;
	if (clase == 1) return base;
	if (clase == 2) return base * 2;
	if (clase == 3) return base * 3;
	return base;
}
