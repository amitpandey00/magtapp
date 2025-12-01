// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'summary.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SummaryAdapter extends TypeAdapter<Summary> {
  @override
  final int typeId = 2;

  @override
  Summary read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Summary(
      id: fields[0] as String,
      sourceId: fields[1] as String,
      sourceType: fields[2] as String,
      originalText: fields[3] as String,
      summaryText: fields[4] as String,
      originalWordCount: fields[5] as int,
      summaryWordCount: fields[6] as int,
      compressionPercentage: fields[7] as double,
      createdAt: fields[8] as DateTime,
      title: fields[9] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Summary obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.sourceId)
      ..writeByte(2)
      ..write(obj.sourceType)
      ..writeByte(3)
      ..write(obj.originalText)
      ..writeByte(4)
      ..write(obj.summaryText)
      ..writeByte(5)
      ..write(obj.originalWordCount)
      ..writeByte(6)
      ..write(obj.summaryWordCount)
      ..writeByte(7)
      ..write(obj.compressionPercentage)
      ..writeByte(8)
      ..write(obj.createdAt)
      ..writeByte(9)
      ..write(obj.title);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SummaryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
