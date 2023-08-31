import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_info_bean.g.dart';

@JsonSerializable()
class UserInfoBean extends ChangeNotifier {
  @JsonKey(name: 'id')
  String? id;

  @JsonKey(name: 'platform')
  int? platform;

  @JsonKey(name: 'userName')
  String? userName;

  @JsonKey(name: 'nickName')
  String? nickName;

  @JsonKey(name: 'realName')
  String? realName;

  @JsonKey(name: 'phone')
  String? phone;

  @JsonKey(name: 'portrait')
  String? portrait;

  @JsonKey(name: 'sex')
  int? sex;

  @JsonKey(name: 'status')
  int? status;

  @JsonKey(name: 'updateTime')
  int? updateTime;

  @JsonKey(name: 'createTime')
  int? createTime;

  @JsonKey(name: 'lastLoginTime')
  int? lastLoginTime;

  @JsonKey(name: 'vipGradeId')
  int? vipGradeId;

  @JsonKey(name: 'imgUrl')
  String imgUrl;

  UserInfoBean.origin()
      : imgUrl = "https://profile-avatar.csdnimg.cn/35b5a8d0b6e146baa62e82811854c88c_jie_sil.jpg";

  UserInfoBean(this.id,this.platform,this.userName,this.nickName,this.realName,this.phone,this.portrait,this.sex,this.status,this.updateTime,this.createTime,this.lastLoginTime,this.vipGradeId,this.imgUrl);

  factory UserInfoBean.fromJson(Map<String, dynamic> srcJson) =>
      _$UserInfoBeanFromJson(srcJson);

  Map<String, dynamic> toJson() => _$UserInfoBeanToJson(this);
}