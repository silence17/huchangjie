import 'package:flutter_module/common/net/i_net_json_2_bean.dart';
import 'package:flutter_module/common/utils/log_utils.dart';

import '../../bean/order_info_bean.dart';

JsonConvert jsonConvert = JsonConvert();

class JsonConvert {
  T? convert<T>(dynamic value) {
    if (value == null) {
      return null;
    }
    return asT<T>(value);
  }

  List<T?>? convertList<T>(List<dynamic>? value) {
    if (value == null) {
      return null;
    }
    try {
      return value.map((dynamic e) => asT<T>(e)).toList();
    } catch (e, stackTrace) {
      print('asT<$T> $e $stackTrace');
      return <T>[];
    }
  }

  List<T>? convertListNotNull<T>(dynamic value) {
    if (value == null) {
      return null;
    }
    try {
      return (value as List<dynamic>).map((dynamic e) => asT<T>(e)!).toList();
    } catch (e, stackTrace) {
      print('asT<$T> $e $stackTrace');
      return <T>[];
    }
  }

  T? asT<T extends Object?>(dynamic value) {
    if (value is T) {
      return value;
    }
    final String type = T.toString();
    try {
      final String valueS = value.toString();

      switch (type) {
        case "String":
          return valueS as T;
        case "int":
          final int? intValue = int.tryParse(valueS);
          if (intValue == null) {
            return double.tryParse(valueS)?.toInt() as T?;
          } else {
            return intValue as T;
          }
        case "double":
          return double.parse(valueS) as T;
        case "DateTime":
          DateTime.parse(valueS) as T;
        case "bool":
          if (valueS == '0' || valueS == '1') {
            return (valueS == '1') as T;
          }
          return (valueS == 'true') as T;
        default:
          return JsonConvert.fromJsonAsT<T>(value);
      }
    } catch (e, stackTrace) {
      Log.e('asT<$T> $e $stackTrace');
    }
    return null;
  }

  //Go back to a single instance by type
  static M? _fromJsonSingle<M>(Map<String, dynamic> json) {
    final String type = M.toString();
    // if(type == (BankEntity).toString()){
    // 	return BankEntity.fromJson(json) as M;
    // }

    print("$type not found");

    return null;
  }

  //list is returned by type
  static M? _getListChildType<M>(List<dynamic> data) {
    if(<OrderInfoBean>[] is M){
      return data.map<OrderInfoBean>((e) => OrderInfoBean.fromJson(e)).toList() as M;
    }

    print("${M.toString()} not found");

    return null;
  }

  static M? fromJsonAsT<M>(dynamic json) {
    if (json == null) {
      return null;
    }
    if (json is List) {
      return _getListChildType<M>(json);
    } else if (M is INetJson2Bean<M>) {
      return (M as INetJson2Bean<M>).fromJson(json);
    } else {
      return json;
    }
  }
}
