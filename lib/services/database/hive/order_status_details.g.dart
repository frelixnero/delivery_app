// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_status_details.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OrderStatusDetailsAdapter extends TypeAdapter<OrderStatusDetails> {
  @override
  final int typeId = 1;

  @override
  OrderStatusDetails read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OrderStatusDetails(
      currentStatus: fields[0] as String,
      lastUpdate: fields[1] as DateTime?,
      trackingNumber: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, OrderStatusDetails obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.currentStatus)
      ..writeByte(1)
      ..write(obj.lastUpdate)
      ..writeByte(2)
      ..write(obj.trackingNumber);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderStatusDetailsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
