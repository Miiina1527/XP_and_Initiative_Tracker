import 'package:hive/hive.dart';

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
  int nivel;

  @HiveField(5)
  bool esEnemigo;

  @HiveField(6)
  int accionesClase;

  @HiveField(7)
  int accionesHeroicas;

  @HiveField(8)
  int danoHecho;

  @HiveField(9)
  int xp = 0;

  @HiveField(10)
  bool died;

  @HiveField(11)
  int accionesClaseAcumuladas;

  @HiveField(12)
  int accionesHeroicasAcumuladas;

  @HiveField(13)
  int gainedxp = 0;

  @HiveField(14)
  int iniciativa = 0;
  
  @HiveField(15)
  int xpAcumulada = 0;

  Jugador({
    required this.nombre,
    required this.hp,
    required this.maxHp,
    required this.ac,
    required this.nivel,
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
  });

  // Puedes agregar copyWith si lo necesitas para tu lógica
  Jugador copyWith({
    String? nombre,
    int? hp,
    int? maxHp,
    int? ac,
    int? nivel,
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
  }) {
    return Jugador(
      nombre: nombre ?? this.nombre,
      hp: hp ?? this.hp,
      maxHp: maxHp ?? this.maxHp,
      ac: ac ?? this.ac,
      nivel: nivel ?? this.nivel,
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
    );
  }
}
