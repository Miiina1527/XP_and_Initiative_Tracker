import 'package:hive/hive.dart';

part 'monster.g.dart';

@HiveType(typeId: 1)
class Monster extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  int hp;

  @HiveField(2)
  int ac;

  @HiveField(3)
  int nivel;

  @HiveField(4)
  int xp;

  @HiveField(5)
  int initiative;

  @HiveField(6)
  String? att;

  @HiveField(7)
  String? movs;

  @HiveField(8)
  String type;

  Monster({
    required this.name,
    required this.hp,
    required this.ac,
    required this.nivel,
    required this.xp,
    required this.initiative,
    this.att,
    this.movs,
    required this.type,
  });

  Monster copyWith({
    String? name,
    int? hp,
    int? ac,
    int? nivel,
    int? xp,
    int? initiative,
    String? att,
    String? movs,
    String? type,
  }) {
    return Monster(
      name: name ?? this.name,
      hp: hp ?? this.hp,
      ac: ac ?? this.ac,
      nivel: nivel ?? this.nivel,
      xp: xp ?? this.xp,
      initiative: initiative ?? this.initiative,
      att: att ?? this.att,
      movs: movs ?? this.movs,
      type: type ?? this.type,
    );
  }
}