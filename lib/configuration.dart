part of flutter_core;

/// 是否打印网络日志
const String IS_PRINT = 'IS_PRINT';

/// 请求基地址,可以包含子路径
const String NATIVE_API_HOST = 'NATIVE_API_HOST';

/// 连接服务器超时时间，单位是毫秒.
const String CONNECT_TIMEOUT = 'CONNECT_TIMEOUT';

/// 响应流上前后两次接受到数据的间隔，单位为毫秒。
const String RECEIVE_TIMEOUT = 'RECEIVE_TIMEOUT';

/// 拦截器
const String INTERCEPTOR = 'INTERCEPTOR';

/// Http请求头.
const String INITIAL_HEADERS = 'INITIAL_HEADERS';

/// 请求体
/// -请求的Content-Type，默认值是"application/json; charset=utf-8".
///  如果您想以"application/x-www-form-urlencoded"格式编码请求数据,
///  可以设置此选项为 `Headers.formUrlEncodedContentType`,  这样[Dio]
///  就会自动编码请求体.
const String CONTENT_TYPE = 'CONTENT_TYPE';

/// 响应体
/// -[responseType] 表示期望以那种格式(方式)接受响应数据。
///  目前 [ResponseType] 接受三种类型 `JSON`, `STREAM`, `PLAIN`.
///
/// -默认值是 `JSON`, 当响应头中content-type为"application/json"时，dio 会自动将响应内容转化为json对象。
///  如果想以二进制方式接受响应数据，如下载一个二进制文件，那么可以使用 `STREAM`.
///
/// -如果想以文本(字符串)格式接收响应数据，请使用 `PLAIN`.
const String RESPONSE_TYPE = 'RESPONSE_TYPE';

class Configuration{
  static const Map<String,dynamic> CONFIGURATION = {};
  static const List<Interceptor> INTERCEPTORS = [];

  factory Configuration() =>_getInstance();
  static Configuration get instance => _getInstance();
  static Configuration _instance;

  Configuration._internal() {
    CONFIGURATION[CONTENT_TYPE] = Headers.formUrlEncodedContentType;
    CONFIGURATION[RESPONSE_TYPE] = ResponseType.json;
  }
  static Configuration _getInstance() {
    if (_instance == null) {
      _instance = Configuration._internal();
    }
    return _instance;
  }

  Map<String,dynamic> getNetConfigs(){
    return CONFIGURATION;
  }

  void printHttpLog(bool isPrint){
    CONFIGURATION[IS_PRINT] = isPrint;
  }

  void setInitialHeaders(Map<String,String> headers){
    CONFIGURATION[INITIAL_HEADERS] = headers;
  }

  void setHost(String host){
    CONFIGURATION[NATIVE_API_HOST] = host;
  }

  void setContentType(String type){
    CONFIGURATION[CONTENT_TYPE] = type;
  }

  void setResponseType(String type){
    CONFIGURATION[RESPONSE_TYPE] = type;
  }

  void setConnectTimeout(int delayed){
    CONFIGURATION[CONNECT_TIMEOUT] = delayed;
  }

  void setReceiveTimeout(int delayed){
    CONFIGURATION[RECEIVE_TIMEOUT] = delayed;
  }

  void setInterceptor(InterceptorsWrapper interceptor){
    INTERCEPTORS.add(interceptor);
    CONFIGURATION[INTERCEPTOR] = INTERCEPTORS;
  }

  void setInterceptors(List<InterceptorsWrapper> interceptors){
    INTERCEPTORS.addAll(interceptors);
    CONFIGURATION[INTERCEPTOR] = INTERCEPTORS;
  }

  T getConfiguration<T>(String key) {
    if (CONFIGURATION[key] == null) {
      throw Exception("$key IS NULL");
    }
    return CONFIGURATION[key] as T;
  }
}