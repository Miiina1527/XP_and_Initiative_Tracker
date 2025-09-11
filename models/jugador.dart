import 'package:hive/hive.dart';

import '../utils/tablaxp.dart';

part 'jugador.g.dart'; // generado automáticamente

@HiveType(typeId: 0)
class Jugador extends HiveObject {
  @HiveField(0)
  String nombre;

  @HiveField(1)
  int hp;

  @HiveField(2)
  int maxHp;

  @HiveField(3)
  int ac;

  @HiveField(4)
  int nivelClase1;

  @HiveField(5)
  int nivelClase2;

  @HiveField(6)
  int nivelClase3;

  @HiveField(7)
  bool esEnemigo;

  @HiveField(8)
  int accionesClase;

  @HiveField(9)
  int accionesHeroicas;

  @HiveField(10)
  int danoHecho;

  @HiveField(11)
  int xp = 0;

  @HiveField(12)
  int xpClase1 = 0;

  @HiveField(13)
  int xpClase2 = 0;

  @HiveField(14)
  int xpClase3 = 0;

  @HiveField(15)
  bool died;

  @HiveField(16)
  int accionesClaseAcumuladas;

  @HiveField(17)
  int accionesHeroicasAcumuladas;

  @HiveField(18)
  int gainedxp = 0;

  @HiveField(19)
  int iniciativa = 0;

  @HiveField(20)
  int xpAcumulada = 0;

  @HiveField(21)
  String? att;

  @HiveField(22)
  String? movs;

  int get nivel => nivelClase1 + nivelClase2 + nivelClase3;

  /// XP usada por cada clase según los niveles actuales
  Map<String, int> get xpPorClase => calcularXpPorClase(
    nivelClase1: nivelClase1,
    nivelClase2: nivelClase2,
    nivelClase3: nivelClase3,
  );

  /// XP sobrante para gastar en el siguiente nivel
  int get xpSobrante => calcularXpSobrante(
    xpTotal: xp,
    nivelClase1: nivelClase1,
    nivelClase2: nivelClase2,
    nivelClase3: nivelClase3,
  );

  Jugador({
    required this.nombre,
    required this.hp,
    required this.maxHp,
    required this.ac,
    required this.nivelClase1,
    required this.nivelClase2,
    required this.nivelClase3,
    required this.esEnemigo,
    this.accionesClase = 0,
    this.accionesHeroicas = 0,
    this.danoHecho = 0,
    this.died = false,
    this.accionesClaseAcumuladas = 0,
    this.accionesHeroicasAcumuladas = 0,
    this.gainedxp = 0,
    this.xpAcumulada = 0,
    this.iniciativa = 0,
    this.xp = 0,
    this.xpClase1 = 0,
    this.xpClase2 = 0,
    this.xpClase3 = 0,
    this.att,
    this.movs,
  });

  // Puedes agregar copyWith si lo necesitas para tu lógica
  Jugador copyWith({
    String? nombre,
    int? hp,
    int? maxHp,
    int? ac,
    int? nivelClase1,
    int? nivelClase2,
    int? nivelClase3,
    bool? esEnemigo,
    int? accionesClase,
    int? accionesHeroicas,
    int? danoHecho,
    bool? died,
    int? accionesClaseAcumuladas,
    int? accionesHeroicasAcumuladas,
    int? gainedxp,
    int? xpAcumulada,
    int? iniciativa,
    int? xp,
    int? xpClase1,
    int? xpClase2,
    int? xpClase3,
    String? att,
    String? movs,
  }) {
    return Jugador(
      nombre: nombre ?? this.nombre,
      hp: hp ?? this.hp,
      maxHp: maxHp ?? this.maxHp,
      ac: ac ?? this.ac,
      nivelClase1: nivelClase1 ?? this.nivelClase1,
      nivelClase2: nivelClase2 ?? this.nivelClase2,
      nivelClase3: nivelClase3 ?? this.nivelClase3,
      esEnemigo: esEnemigo ?? this.esEnemigo,
      accionesClase: accionesClase ?? this.accionesClase,
      accionesHeroicas: accionesHeroicas ?? this.accionesHeroicas,
      danoHecho: danoHecho ?? this.danoHecho,
      died: died ?? this.died,
      accionesClaseAcumuladas: accionesClaseAcumuladas ?? this.accionesClaseAcumuladas,
      accionesHeroicasAcumuladas: accionesHeroicasAcumuladas ?? this.accionesHeroicasAcumuladas,
      gainedxp: gainedxp ?? this.gainedxp,
      xpAcumulada: xpAcumulada ?? this.xpAcumulada,
      iniciativa: iniciativa ?? this.iniciativa,
      xp: xp ?? this.xp,
      xpClase1: xpClase1 ?? this.xpClase1,
      xpClase2: xpClase2 ?? this.xpClase2,
      xpClase3: xpClase3 ?? this.xpClase3,
      att: att ?? this.att,
      movs: movs ?? this.movs,
    );
  }
}