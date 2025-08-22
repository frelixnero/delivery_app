// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_summary.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OrderSummaryAdapter extends TypeAdapter<OrderSummary> {
  @override
  final int typeId = 0;

  @override
  OrderSummary read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OrderSummary(
      orderId: fields[0] as String,
      orderDate: fields[1] as DateTime,
      isCompleted: fields[2] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, OrderSummary obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.orderId)
      ..writeByte(1)
      ..write(obj.orderDate)
      ..writeByte(2)
      ..write(obj.isCompleted);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderSummaryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
