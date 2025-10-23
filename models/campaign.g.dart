// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'campaign.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CampaignAdapter extends TypeAdapter<Campaign> {
  @override
  final int typeId = 10;

  @override
  Campaign read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Campaign(
      slot: fields[0] as int,
      name: fields[1] as String,
      system: fields[2] as String,
      createdAt: fields[3] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Campaign obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.slot)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.system)
      ..writeByte(3)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CampaignAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
