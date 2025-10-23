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
      died: fields[10] as bool,
      accionesClaseAcumuladas: fields[11] as int,
      accionesHeroicasAcumuladas: fields[12] as int,
      gainedxp: fields[13] as int,
      xpAcumulada: fields[15] as int,
      iniciativa: fields[14] as int,
      xp: fields[9] as int,
      att: fields[16] as String?,
      movs: fields[17] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Jugador obj) {
    writer
      ..writeByte(18)
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
      ..write(obj.xp)
      ..writeByte(10)
      ..write(obj.died)
      ..writeByte(11)
      ..write(obj.accionesClaseAcumuladas)
      ..writeByte(12)
      ..write(obj.accionesHeroicasAcumuladas)
      ..writeByte(13)
      ..write(obj.gainedxp)
      ..writeByte(14)
      ..write(obj.iniciativa)
      ..writeByte(15)
      ..write(obj.xpAcumulada)
      ..writeByte(16)
      ..write(obj.att)
      ..writeByte(17)
      ..write(obj.movs);
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
