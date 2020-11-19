part of flutter_core;

class HttpUtil {
  static HttpUtil _instance = HttpUtil._internal();

  factory HttpUtil() => _instance;

  static Map<String, CancelToken> _cancelTokens =
      new Map<String, CancelToken>();

  Dio _dio;

  static HttpUtil getInstance({String baseUrl}) {
    if (baseUrl == null) {
      return _instance._normal();
    } else {
      return _instance._baseUrl(baseUrl);
    }
  }

  //用于指定特定域名
  HttpUtil _baseUrl(String baseUrl) {
    if (_dio != null) {
      _dio.options.baseUrl = baseUrl;
    }
    return this;
  }

  //一般请求，默认域名
  HttpUtil _normal() {
    if (_dio != null) {
      if (_dio.options.baseUrl != Configuration().getConfiguration<String>(NATIVE_API_HOST)) {
        _dio.options.baseUrl = Configuration().getConfiguration<String>(NATIVE_API_HOST);
      }
    }
    return this;
  }

  HttpUtil._internal() {
    Configuration configuration = Configuration();
    BaseOptions options = BaseOptions(
      baseUrl: configuration.getConfiguration<String>(NATIVE_API_HOST),
      connectTimeout: configuration.getConfiguration<int>(CONNECT_TIMEOUT),
      receiveTimeout: configuration.getConfiguration<int>(RECEIVE_TIMEOUT),
      headers:
          configuration.getConfiguration<Map<String, String>>(INITIAL_HEADERS),
      contentType: configuration.getConfiguration<String>(CONTENT_TYPE),
      responseType: configuration.getConfiguration<ResponseType>(RESPONSE_TYPE),
    );

    _dio = new Dio(options);

    // 添加拦截器
    // 日志拦截器
    if (configuration.getConfiguration<bool>(IS_PRINT)) {
      _dio.interceptors.add(log);
    }
    // 配置拦截器
    _dio.interceptors.addAll(
        configuration.getConfiguration<List<Interceptor>>(INTERCEPTOR));

    _dio.interceptors.add(connectionStatus);
  }

  void cancelRequest(String tokenName) {
    _cancelTokens[tokenName].cancel("cancelled");
  }

  HttpController httpController() => controller;

  void removeCancelToken(BuildContext context) {
    _cancelTokens.remove(_getCancelToken(context));
  }

  CancelToken _getCancelToken(BuildContext context) {
    CancelToken cancelToken;
    if (!_cancelTokens.containsKey(context.toString())) {
      cancelToken = CancelToken();
      _cancelTokens[context.toString()] = cancelToken;
    } else {
      cancelToken = _cancelTokens[context.toString()];
    }
    return cancelToken;
  }

  /// restful get 操作
  /// refresh 是否下拉刷新 默认 false
  /// noCache 是否不缓存 默认 true
  /// list 是否列表 默认 false
  /// cacheKey 缓存key
  /// cacheDisk 是否磁盘缓存
  Future get(
    String path, {
    @required BuildContext context,
    dynamic params,
    Options options,
    String otherBaseUrl,
    bool refresh = false,
    bool list = false,
    String cacheKey,
    bool cacheDisk = false,
  }) async {
    Options requestOptions = options ?? Options();
    requestOptions = requestOptions.merge(extra: {
      "context": context,
      "refresh": refresh,
      "list": list,
      "cacheKey": cacheKey,
      "cacheDisk": cacheDisk,
    });
    var response = await _dio.get(
      path,
      queryParameters: params,
      options: requestOptions,
      cancelToken: _getCancelToken(context),
    );
    return response;
  }

  /// restful post 操作
  Future post(
    String path, {
    @required BuildContext context,
    dynamic params,
    Options options,
    bool refresh = false,
    bool list = false,
    String cacheKey,
    bool cacheDisk = false,
  }) async {
    Options requestOptions = options ?? Options();
    requestOptions = requestOptions.merge(extra: {
      "context": context,
      "refresh": refresh,
      "list": list,
      "cacheKey": cacheKey,
      "cacheDisk": cacheDisk,
    });
    var response = await _dio.post(
      path,
      data: params,
      options: requestOptions,
      cancelToken: _getCancelToken(context),
    );
    return response;
  }
}

// 异常处理
class ErrorEntity implements Exception {
  int code;
  String message;

  ErrorEntity({this.code, this.message});

  String toString() {
    if (message == null) return "Exception";
    return "Exception: code $code, $message";
  }
}

ErrorEntity createErrorEntity(DioError error) {
  switch (error.type) {
    case DioErrorType.CANCEL:
      {
        return ErrorEntity(code: -1, message: "请求取消");
      }
      break;
    case DioErrorType.CONNECT_TIMEOUT:
      {
        return ErrorEntity(code: -1, message: "连接超时");
      }
      break;
    case DioErrorType.SEND_TIMEOUT:
      {
        return ErrorEntity(code: -1, message: "请求超时");
      }
      break;
    case DioErrorType.RECEIVE_TIMEOUT:
      {
        return ErrorEntity(code: -1, message: "响应超时");
      }
      break;
    case DioErrorType.RESPONSE:
      {
        try {
          int errCode = error.response.statusCode;
          switch (errCode) {
            case 400:
              {
                return ErrorEntity(code: errCode, message: "请求语法错误");
              }
              break;
            case 401:
              {
                return ErrorEntity(code: errCode, message: "没有权限");
              }
              break;
            case 403:
              {
                return ErrorEntity(code: errCode, message: "服务器拒绝执行");
              }
              break;
            case 404:
              {
                return ErrorEntity(code: errCode, message: "无法连接服务器");
              }
              break;
            case 405:
              {
                return ErrorEntity(code: errCode, message: "请求方法被禁止");
              }
              break;
            case 500:
              {
                return ErrorEntity(code: errCode, message: "服务器内部错误");
              }
              break;
            case 502:
              {
                return ErrorEntity(code: errCode, message: "无效的请求");
              }
              break;
            case 503:
              {
                return ErrorEntity(code: errCode, message: "服务器挂了");
              }
              break;
            case 505:
              {
                return ErrorEntity(code: errCode, message: "不支持HTTP协议请求");
              }
              break;
            default:
              {
                // return ErrorEntity(code: errCode, message: "未知错误");
                return ErrorEntity(
                    code: errCode, message: error.response.statusMessage);
              }
          }
        } on Exception catch (_) {
          return ErrorEntity(code: -1, message: "未知错误");
        }
      }
      break;
    default:
      {
        return ErrorEntity(code: -1, message: error.message);
      }
  }
}

InterceptorsWrapper log = InterceptorsWrapper(
  onRequest: (RequestOptions options) {
    LogUtil.logDebug(
      tag: LogUtil.TAG_HTTP_BEGIN,
      text: '${options.method} >>> ${options.path}',
    );
    LogUtil.logDebug(tag: LogUtil.TAG_HTTP_URL, text: options.uri.toString());
    LogUtil.logDebug(
      tag: LogUtil.TAG_HTTP_PARAM,
      text: options.method == 'GET'
          ? options.queryParameters.toString()
          : options.data.toString(),
    );
    LogUtil.logDebug(
      tag: LogUtil.TAG_HTTP_HEAD,
      text: options.headers.toString(),
    );
    return options;
  },
  onResponse: (Response response) {
    LogUtil.logDebug(
      tag: LogUtil.TAG_HTTP_RESPONSE,
      text: response.data.toString(),
    );
    LogUtil.logDebug(
      tag: LogUtil.TAG_HTTP_END,
      text: '${response.statusCode} >>> ${response.statusMessage}',
    );
    return response; // continue
  },
  onError: (DioError e) {
    LogUtil.logDebug(
      tag: LogUtil.TAG_HTTP_END,
      text: '${e.response.statusCode} >>> ${e.message}',
    );
  },
);

HttpController controller = HttpController();

InterceptorsWrapper connectionStatus = InterceptorsWrapper(
  onRequest: (RequestOptions options) {
    controller.startLoading();
    return options;
  },
  onResponse: (Response response) {
    controller.onSuccess();
    return response;
  },
  onError: (DioError e) {
    controller.onError(e);
  },
);
