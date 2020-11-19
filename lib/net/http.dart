part of flutter_core;

class HttpUtil {
  static HttpUtil _instance = HttpUtil._internal();

  factory HttpUtil() => _instance;

  static Map<String, CancelToken> _cancelTokens =
      new Map<String, CancelToken>();

  Dio _dio;

  HttpController _controller;

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
      if (_dio.options.baseUrl !=
          Configuration().getConfiguration<String>(NATIVE_API_HOST)) {
        _dio.options.baseUrl =
            Configuration().getConfiguration<String>(NATIVE_API_HOST);
      }
    }
    return this;
  }

  HttpUtil._internal() {
    Configuration configuration = Configuration();
    _controller = HttpController();
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
      _dio.interceptors.add(DioLogInterceptor());
    }
    // 配置拦截器
    _dio.interceptors
        .addAll(configuration.getConfiguration<List<Interceptor>>(INTERCEPTOR));

    _dio.interceptors.add(ConnectionStatusInterceptor(_controller));
  }

  void cancelRequest(String tokenName) {
    _cancelTokens[tokenName].cancel("cancelled");
  }

  HttpController httpController() => _controller;

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