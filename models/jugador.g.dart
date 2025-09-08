// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'jugador.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class JugadorAdapter extends TypeAdapter<Jugador> {
  @override
  final int typeId = 0;

  @override
  Jugador read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Jugador(
      nombre: fields[0] as String,
      hp: fields[1] as int,
      maxHp: fields[2] as int,
      ac: fields[3] as int,
      nivel: fields[4] as int,
      esEnemigo: fields[5] as bool,
      accionesClase: fields[6] as int,
      accionesHeroicas: fields[7] as int,
      danoHecho: fields[8] as int,
      died: fields[9] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Jugador obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.nombre)
      ..writeByte(1)
      ..write(obj.hp)
      ..writeByte(2)
      ..write(obj.maxHp)
      ..writeByte(3)
      ..write(obj.ac)
      ..writeByte(4)
      ..write(obj.nivel)
      ..writeByte(5)
      ..write(obj.esEnemigo)
      ..writeByte(6)
      ..write(obj.accionesClase)
      ..writeByte(7)
      ..write(obj.accionesHeroicas)
      ..writeByte(8)
      ..write(obj.danoHecho)
      ..writeByte(9)
      ..write(obj.died);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JugadorAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
