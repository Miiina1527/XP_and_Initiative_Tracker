import 'package:hive/hive.dart';

part 'campaign.g.dart';

@HiveType(typeId: 10)
class Campaign {
  @HiveField(0)
  final int slot; // 0..3

  @HiveField(1)
  String name;

  @HiveField(2)
  String system; // 'pf1', 'pf2', 'dnd5', etc.

  @HiveField(3)
  DateTime createdAt;

  Campaign({
    required this.slot,
    required this.name,
    required this.system,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}