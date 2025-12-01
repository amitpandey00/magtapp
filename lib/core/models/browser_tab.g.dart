// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'browser_tab.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BrowserTabAdapter extends TypeAdapter<BrowserTab> {
  @override
  final int typeId = 0;

  @override
  BrowserTab read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BrowserTab(
      id: fields[0] as String,
      url: fields[1] as String,
      title: fields[2] as String,
      createdAt: fields[3] as DateTime,
      lastAccessedAt: fields[4] as DateTime,
      isActive: fields[5] as bool,
      favicon: fields[6] as String?,
      isSummarized: fields[7] as bool,
      isIncognito: fields[8] as bool,
      thumbnail: fields[9] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, BrowserTab obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.url)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.createdAt)
      ..writeByte(4)
      ..write(obj.lastAccessedAt)
      ..writeByte(5)
      ..write(obj.isActive)
      ..writeByte(6)
      ..write(obj.favicon)
      ..writeByte(7)
      ..write(obj.isSummarized)
      ..writeByte(8)
      ..write(obj.isIncognito)
      ..writeByte(9)
      ..write(obj.thumbnail);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BrowserTabAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
