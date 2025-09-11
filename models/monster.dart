import 'package:hive/hive.dart';

part 'monster.g.dart';

@HiveType(typeId: 2)
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

  factory Monster.fromMap(Map<String, dynamic> map) => Monster(
        name: map['name'] ?? '',
        hp: map['hp'] ?? 0,
        ac: map['ac'] ?? 10,
        nivel: map['nivel'] ?? map['level'] ?? 1,
        xp: map['xp'] ?? 0,
        initiative: map['initiative'] ?? 0,
        att: map['att'],
        movs: map['movs'],
        type: map['type'] ?? '-',
      );

  Map<String, dynamic> toMap() => {
        'name': name,
        'hp': hp,
        'ac': ac,
        'nivel': nivel,
        'xp': xp,
        'initiative': initiative,
        'att': att,
        'movs': movs,
        'type': type,
      };
}
