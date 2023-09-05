// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_info_bean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderInfoBean _$OrderInfoBeanFromJson(Map<String, dynamic> json) =>
    OrderInfoBean(
      (json['curDayTotalAmount'] as num?)?.toDouble(),
      json['curDayTotalOrder'] as int?,
      json['curDayUntreatedOrder'] as int?,
      (json['lastDayTotalAmount'] as num?)?.toDouble(),
      json['lastDayTotalOrder'] as int?,
    );

Map<String, dynamic> _$OrderInfoBeanToJson(OrderInfoBean instance) =>
    <String, dynamic>{
      'curDayTotalAmount': instance.curDayTotalAmount,
      'curDayTotalOrder': instance.curDayTotalOrder,
      'curDayUntreatedOrder': instance.curDayUntreatedOrder,
      'lastDayTotalAmount': instance.lastDayTotalAmount,
      'lastDayTotalOrder': instance.lastDayTotalOrder,
    };
