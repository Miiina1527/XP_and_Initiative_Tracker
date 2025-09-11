// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'monster.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MonsterAdapter extends TypeAdapter<Monster> {
  @override
  final int typeId = 1;

  @override
  Monster read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Monster(
      name: fields[0] as String,
      hp: fields[1] as int,
      ac: fields[2] as int,
      nivel: fields[3] as int,
      xp: fields[4] as int,
      initiative: fields[5] as int,
      att: fields[6] as String?,
      movs: fields[7] as String?,
      type: fields[8] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Monster obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.hp)
      ..writeByte(2)
      ..write(obj.ac)
      ..writeByte(3)
      ..write(obj.nivel)
      ..writeByte(4)
      ..write(obj.xp)
      ..writeByte(5)
      ..write(obj.initiative)
      ..writeByte(6)
      ..write(obj.att)
      ..writeByte(7)
      ..write(obj.movs)
      ..writeByte(8)
      ..write(obj.type);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MonsterAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
