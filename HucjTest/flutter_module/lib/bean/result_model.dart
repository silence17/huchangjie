/// 1.引入json_annotation
import 'package:json_annotation/json_annotation.dart';

/// 2.指定此类的代码生成文件(格式：part '类名.g.dart';)
part 'result_model.g.dart';

///这个标注是告诉生成器，这个类是需要生成Model类的
/// 3.添加序列化标注
@JsonSerializable()
class Result {
  //定义构造方法
  Result(this.code, this.method, this.requestPrams);

  //定义字段
  @JsonKey(name: 'code')
  int code;
  @JsonKey(name: 'method')
  String method;
  @JsonKey(name: 'requestPrams')
  String requestPrams;

  /// 4.添加反序列化方法(格式：factory 类名.fromJson(Map<String, dynamic> json) => _$类名FromJson(json);)
  Result fromJson(Map<String, dynamic> json) => _$ResultFromJson(json);

  /// 5.添加序列化方法(格式：Map<String, dynamic> toJson() => _$类名ToJson(this);)
  Map<String, dynamic> toJson() => _$ResultToJson(this);

  Result _$ResultFromJson(Map<String, dynamic> json) => Result(
        json['code'] as int,
        json['method'] as String,
        json['requestPrams'] as String,
      );

  Map<String, dynamic> _$ResultToJson(Result instance) => <String, dynamic>{
        'code': instance.code,
        'method': instance.method,
        'requestPrams': instance.requestPrams,
      };
}
