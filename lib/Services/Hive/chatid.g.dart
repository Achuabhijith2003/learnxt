// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chatid.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChatidAdapter extends TypeAdapter<Chatid> {
  @override
  final int typeId = 0;

  @override
  Chatid read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Chatid(
      fields[0] as int,
      fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Chatid obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.totalchat)
      ..writeByte(1)
      ..write(obj.docid);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatidAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
