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
      nivelClase1: fields[4] as int,
      nivelClase2: fields[5] as int,
      nivelClase3: fields[6] as int,
      esEnemigo: fields[7] as bool,
      accionesClase: fields[8] as int,
      accionesHeroicas: fields[9] as int,
      danoHecho: fields[10] as int,
      died: fields[15] as bool,
      accionesClaseAcumuladas: fields[16] as int,
      accionesHeroicasAcumuladas: fields[17] as int,
      gainedxp: fields[18] as int,
      xpAcumulada: fields[20] as int,
      iniciativa: fields[19] as int,
      xp: fields[11] as int,
      xpClase1: fields[12] as int,
      xpClase2: fields[13] as int,
      xpClase3: fields[14] as int,
      att: fields[21] as String?,
      movs: fields[22] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Jugador obj) {
    writer
      ..writeByte(23)
      ..writeByte(0)
      ..write(obj.nombre)
      ..writeByte(1)
      ..write(obj.hp)
      ..writeByte(2)
      ..write(obj.maxHp)
      ..writeByte(3)
      ..write(obj.ac)
      ..writeByte(4)
      ..write(obj.nivelClase1)
      ..writeByte(5)
      ..write(obj.nivelClase2)
      ..writeByte(6)
      ..write(obj.nivelClase3)
      ..writeByte(7)
      ..write(obj.esEnemigo)
      ..writeByte(8)
      ..write(obj.accionesClase)
      ..writeByte(9)
      ..write(obj.accionesHeroicas)
      ..writeByte(10)
      ..write(obj.danoHecho)
      ..writeByte(11)
      ..write(obj.xp)
      ..writeByte(12)
      ..write(obj.xpClase1)
      ..writeByte(13)
      ..write(obj.xpClase2)
      ..writeByte(14)
      ..write(obj.xpClase3)
      ..writeByte(15)
      ..write(obj.died)
      ..writeByte(16)
      ..write(obj.accionesClaseAcumuladas)
      ..writeByte(17)
      ..write(obj.accionesHeroicasAcumuladas)
      ..writeByte(18)
      ..write(obj.gainedxp)
      ..writeByte(19)
      ..write(obj.iniciativa)
      ..writeByte(20)
      ..write(obj.xpAcumulada)
      ..writeByte(21)
      ..write(obj.att)
      ..writeByte(22)
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
