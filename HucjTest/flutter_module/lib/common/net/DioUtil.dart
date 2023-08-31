import 'dart:collection';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_module/common/net/BaseEntity.dart';

import '../utils/error_handle.dart';
import '../utils/log_utils.dart';
import 'Method.dart';

//链接超时时间
Duration _connectTimeout = const Duration(seconds: 15);
Duration _receiveTimeout = const Duration(seconds: 15);
Duration _sendTimeout = const Duration(seconds: 10);
//域名
String _baseUrl = '';
//拦截器
List<Interceptor> _interceptors = [];

void configDio({
  Duration? connectTimeout,
  Duration? receiveTimeout,
  Duration? sendTimeout,
  String? baseUrl,
  List<Interceptor>? interceptors,
}) {
  _connectTimeout = connectTimeout ?? _connectTimeout;
  _receiveTimeout = receiveTimeout ?? _receiveTimeout;
  _sendTimeout = sendTimeout ?? _sendTimeout;
  _baseUrl = baseUrl ?? _baseUrl;
  _interceptors = interceptors ?? _interceptors;
}

/// typedef 定义了一种数据类型，类似Kotlin 方法中传递函数::
typedef NetSuccessCallback<T> = Function(T data);
typedef NetSuccessListCallback<T> = Function(T data);
typedef NetErrorCallback = Function(int code, String msg);

class DioUtil {
  //当使用factory修饰一个构造器时，DartVM不会总是创建一个新的对象，而是返回一个在内存中已经存在的对象。
  //比如它可能会从缓存中返回一个已有的实例，或者是返回子类的实例。
  factory DioUtil() => _singleton;

  //私有构造方法
  DioUtil._() {
    final BaseOptions options = BaseOptions(
      connectTimeout: _connectTimeout,
      receiveTimeout: _receiveTimeout,
      sendTimeout: _sendTimeout,

      /// dio默认json解析，这里指定返回UTF8字符串，自己处理解析。（可也以自定义Transformer实现）
      responseType: ResponseType.plain,
      validateStatus: (_) {
        // 不使用http状态码判断状态，使用AdapterInterceptor来处理（适用于标准REST风格）
        return true;
      },
      baseUrl: _baseUrl,
//      contentType: Headers.formUrlEncodedContentType, // 适用于post form表单提交
    );
    _dio = Dio(options);

    /// 添加拦截器
    void addInterceptor(Interceptor interceptor) {
      _dio.interceptors.add(interceptor);
    }

    for (var element in _interceptors) {
      addInterceptor(element);
    }
  }

  static final DioUtil _singleton = DioUtil._();

  static DioUtil get instance => DioUtil();

  static late Dio _dio;

  Dio get dio => _dio;

  /*
   * 真实的网络请求
   * async 异步函数
   */
  Future<BaseEntity<T>> _request<T>(String method, String url,
      {Object? data,
      Map<String, dynamic>? queryParameters,
      CancelToken? cancelToken,
      Options? options}) async {
    options ??= Options();
    options.method = method;
    _addCommonHeader(options);
    final Response<String> response = await _dio.request<String>(url,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken);

    try {
      final String responseStr = response.data.toString();
      final Map<String, dynamic> map = json.decode(responseStr);
      return BaseEntity<T>.fromJson(map);
    } catch (e) {
      debugPrint(e.toString());
      return BaseEntity<T>(ExceptionHandle.parse_error, '数据解析错误！', null);
    }
  }

  /*
   * open方法，对外公开调用网络请求的方法
   * 异步调用
   */
  Future<dynamic> requestNetwork<T>(
    Method method,
    String url, {
    NetSuccessCallback<T?>? onSuccess,
    NetErrorCallback? onError,
    Object? params,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    Options? options,
  }) {
    return _request<T>(method.value, url,
            data: params,
            queryParameters: queryParameters,
            options: options,
            cancelToken: cancelToken)
        //注册回调
        .then<void>((BaseEntity<T> result) {
      if (result.code == 0) {
        onSuccess?.call(result.data);
      } else {
        _onError(result.code, result.message, onError);
      }
    }, onError: (dynamic e) {
      _cancelLogPrint(e, url);
      final NetError error = ExceptionHandle.handleException(e);
      _onError(error.code, error.msg, onError);
    });
  }

  /*
   * open方法，对外公开调用网络请求的方法
   */
  void asyncRequestNetwork<T>(Method method, String url,
      {NetSuccessCallback<T?>? onSuccess,
      NetErrorCallback? onError,
      Object? params,
      Map<String, dynamic>? queryParameters,
      CancelToken? cancelToken,
      Options? options}) {
    Stream.fromFuture(_request<T>(method.value, url,
            data: params,
            queryParameters: queryParameters,
            options: options,
            cancelToken: cancelToken))
        //通过Stream的asBroadcastStream()或StreamController的broadcast将单订阅的流转换为多订阅流
        .asBroadcastStream()
        .listen((result) {
      if (result.code == 0) {
        if (onSuccess != null) {
          onSuccess(result.data);
        }
      } else {
        _onError(result.code, result.message, onError);
      }
    }, onError: (dynamic e) {
      _cancelLogPrint(e, url);
      final NetError error = ExceptionHandle.handleException(e);
      _onError(error.code, error.msg, onError);
    });
  }

  void _cancelLogPrint(dynamic e, String url) {
    if (e is DioException && CancelToken.isCancel(e)) {
      Log.e('取消请求接口： $url');
    }
  }

  void _onError(int? code, String msg, NetErrorCallback? onError) {
    if (code == null) {
      code = ExceptionHandle.unknown_error;
      msg = '未知异常';
    }
    Log.e('接口请求异常： code: $code, mag: $msg');
    onError?.call(code, msg);
  }

  void _addCommonHeader(Options options) {
    // header["token"] = MMKVUtils.instance.userToken ?: ""
    // header["Authorization"] = MMKVUtils.instance.userToken ?: ""
    // header["platform"] = "2"
    // header["applicationCode"] = "3"
    // header["version"] = CommonUtil.getVersionName()
    // header["fromSource"] = ""
    // // 业务类型1-个人（默认），2-企业
    // header["businessType"] = UserUtil.businessType().toString()
    var params = HashMap<String, dynamic>();
    params['token'] = "";
    params['Authorization'] = "";
    params['platform'] = "2";
    params['applicationCode'] = "3";
    params['version'] = "1.0.0";
    params['fromSource'] = "";
    params['businessType'] = "1";

    options.headers = params;
  }
}
