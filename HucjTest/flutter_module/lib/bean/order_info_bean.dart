import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

/// 2.指定此类的代码生成文件(格式：part '类名.g.dart';)
part 'order_info_bean.g.dart';

/// notifyListeners();

@JsonSerializable()
class OrderInfoBean extends ChangeNotifier {
  OrderInfoBean();

  //当日订单总金额
  @JsonKey(name: 'curDayTotalAmount')
  String? curDayTotalAmount = "--";

  //当日订单总数
  @JsonKey(name: 'curDayTotalOrder')
  String? curDayTotalOrder;

  //当日未处理订单
  @JsonKey(name: 'curDayUntreatedOrder')
  String? curDayUntreatedOrder;

  //昨日订单总金额
  @JsonKey(name: 'lastDayTotalAmount')
  String? lastDayTotalAmount;

  //昨日订单总数
  @JsonKey(name: 'lastDayTotalOrder')
  String? lastDayTotalOrder;

  OrderInfoBean fromJson(Map<String, dynamic> json) => OrderInfoBean()
    ..curDayTotalAmount = json['curDayTotalAmount'] as String?
    ..curDayTotalOrder = json['curDayTotalOrder'] as String?
    ..curDayUntreatedOrder = json['curDayUntreatedOrder'] as String?
    ..lastDayTotalAmount = json['lastDayTotalAmount'] as String?
    ..lastDayTotalOrder = json['lastDayTotalOrder'] as String?;

  Map<String, dynamic> toJson(OrderInfoBean instance) => <String, dynamic>{
        'curDayTotalAmount': instance.curDayTotalAmount,
        'curDayTotalOrder': instance.curDayTotalOrder,
        'curDayUntreatedOrder': instance.curDayUntreatedOrder,
        'lastDayTotalAmount': instance.lastDayTotalAmount,
        'lastDayTotalOrder': instance.lastDayTotalOrder,
      };
}
