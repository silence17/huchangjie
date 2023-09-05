import 'dart:collection';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_module/bean/user_info_bean.dart';
import 'package:flutter_module/common/api_url.dart';
import 'package:flutter_module/common/mvp/base_page_presenter.dart';
import 'package:flutter_module/common/net/Method.dart';
import 'package:flutter_module/common/utils/log_utils.dart';
import 'package:oktoast/oktoast.dart';

import '../bean/order_info_bean.dart';
import '../contact/my_center_contact.dart';

class MyCenterPresenter extends BasePagePresenter<MyCenterContact> {
  UserInfoBean userInfo = UserInfoBean.origin();
  OrderInfoBean orderInfo = OrderInfoBean.only();

  @override
  void initState() {
    super.initState();

    //addPostFrameCallback就是在每一帧绘制完成后再回调执行一些自己的方法
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Log.d(" MyCenterPresenter request");

      var params = HashMap<String, String>();
      params['enterpriseId'] = '48564973adff4f95bec1adb2ee8d0c47';

      var options = Options();
      options.contentType = Headers.jsonContentType;
      //发起网络请求
      asyncRequestNetwork<OrderInfoBean>(Method.get,
          url: ApiUlr.crm_order_info,
          queryParameters: params,
          onSuccess: (data) {
            if (data == null) return;

            orderInfo.setDate(data);
            Log.e(orderInfo.toString());
          },
          onError: (code, msg) => {showToast(msg)});
    });
  }

  @override
  void dispose() {
    super.dispose();
  }
}
