// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_info_bean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserInfoBean _$UserInfoBeanFromJson(Map<String, dynamic> json) => UserInfoBean(
      json['id'] as String?,
      json['platform'] as int?,
      json['userName'] as String?,
      json['nickName'] as String?,
      json['realName'] as String?,
      json['phone'] as String?,
      json['portrait'] as String?,
      json['sex'] as int?,
      json['status'] as int?,
      json['updateTime'] as int?,
      json['createTime'] as int?,
      json['lastLoginTime'] as int?,
      json['vipGradeId'] as int?,
      json['imgUrl'] as String,
    );

Map<String, dynamic> _$UserInfoBeanToJson(UserInfoBean instance) =>
    <String, dynamic>{
      'id': instance.id,
      'platform': instance.platform,
      'userName': instance.userName,
      'nickName': instance.nickName,
      'realName': instance.realName,
      'phone': instance.phone,
      'portrait': instance.portrait,
      'sex': instance.sex,
      'status': instance.status,
      'updateTime': instance.updateTime,
      'createTime': instance.createTime,
      'lastLoginTime': instance.lastLoginTime,
      'vipGradeId': instance.vipGradeId,
      'imgUrl': instance.imgUrl,
    };
