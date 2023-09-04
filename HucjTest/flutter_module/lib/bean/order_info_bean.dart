import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

import '../common/net/i_net_json_2_bean.dart';

/// 2.指定此类的代码生成文件(格式：part '类名.g.dart';)
part 'order_info_bean.g.dart';

/// notifyListeners();

@JsonSerializable()
class OrderInfoBean extends ChangeNotifier implements INetJson2Bean<OrderInfoBean> {

  //当日订单总金额
  @JsonKey(name: 'curDayTotalAmount')
  String? curDayTotalAmount;

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


  OrderInfoBean(
      this.curDayTotalAmount,
      this.curDayTotalOrder,
      this.curDayUntreatedOrder,
      this.lastDayTotalAmount,
      this.lastDayTotalOrder);

  factory OrderInfoBean.fromJson(Map<String, dynamic> json) =>
      _$OrderInfoBeanFromJson(json);

  Map<String, dynamic> toJson() => _$OrderInfoBeanToJson(this);


  @override
  OrderInfoBean fromJson(Map<String, dynamic> json) {
    return OrderInfoBean.fromJson(json);
  }
}
