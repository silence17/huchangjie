import '../../common/constant.dart';
import 'json_convert_content.dart';

class BaseEntity<T> {

  BaseEntity(this.status, this.msg, this.data);

  BaseEntity.fromJson(Map<String, dynamic> json) {
    status = json[Constant.code] as int?;
    msg = json[Constant.message] as String;
    if (json.containsKey(Constant.data)) {
      data = _generateOBJ(json[Constant.data] as Object?);
    }
  }

  int? status;
  late String msg;
  T? data;

  T? _generateOBJ(Object? json) {
    if (json == null) {
      return null;
    }
    if (T.toString() == 'String') {
      return json.toString() as T;
    } else if (T.toString() == 'Map<dynamic, dynamic>') {
      return json as T;
    } else {
      /// List类型数据由fromJsonAsT判断处理
      return JsonConvert.fromJsonAsT<T>(json);
    }
  }
}
