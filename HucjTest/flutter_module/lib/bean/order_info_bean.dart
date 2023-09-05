import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

/// 2.指定此类的代码生成文件(格式：part '类名.g.dart';)
part 'order_info_bean.g.dart';


@JsonSerializable()
class OrderInfoBean extends ChangeNotifier {
  //当日订单总金额
  @JsonKey(name: 'curDayTotalAmount')
  double? curDayTotalAmount;

  //当日订单总数
  @JsonKey(name: 'curDayTotalOrder')
  int? curDayTotalOrder;

  //当日未处理订单
  @JsonKey(name: 'curDayUntreatedOrder')
  int? curDayUntreatedOrder;

  //昨日订单总金额
  @JsonKey(name: 'lastDayTotalAmount')
  double? lastDayTotalAmount;

  //昨日订单总数
  @JsonKey(name: 'lastDayTotalOrder')
  int? lastDayTotalOrder;

  OrderInfoBean.only();

  OrderInfoBean(
      this.curDayTotalAmount,
      this.curDayTotalOrder,
      this.curDayUntreatedOrder,
      this.lastDayTotalAmount,
      this.lastDayTotalOrder);

  void setDate(OrderInfoBean data) {
    curDayTotalAmount = data.curDayTotalAmount;
    curDayTotalOrder = data.curDayTotalOrder;
    curDayUntreatedOrder = data.curDayUntreatedOrder;
    lastDayTotalAmount = data.lastDayTotalAmount;
    lastDayTotalOrder = data.lastDayTotalOrder;
    notifyListeners();
  }

  @override
  String toString() {
    return 'OrderInfoBean{curDayTotalAmount: $curDayTotalAmount, curDayTotalOrder: $curDayTotalOrder, curDayUntreatedOrder: $curDayUntreatedOrder, lastDayTotalAmount: $lastDayTotalAmount, lastDayTotalOrder: $lastDayTotalOrder}';
  }

  factory OrderInfoBean.fromJson(Map<String, dynamic> json) =>
      _$OrderInfoBeanFromJson(json);

  Map<String, dynamic> toJson() => _$OrderInfoBeanToJson(this);
}
