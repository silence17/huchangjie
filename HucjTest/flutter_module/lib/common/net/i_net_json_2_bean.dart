abstract class INetJson2Bean<T> {

  T fromJson(Map<String, dynamic> json);

  Map<String, dynamic> toJson();
}
