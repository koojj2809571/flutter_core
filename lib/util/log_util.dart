part of flutter_core;

class LogUtil{

  static const String TAG_TEST = '测试';
  static const String TAG_HTTP_BEGIN = 'HTTP日志=====请求开始';
  static const String TAG_HTTP_PARAM = 'HTTP日志=====请求参数';
  static const String TAG_HTTP_TOKEN = 'HTTP日志=====请求Token';
  static const String TAG_HTTP_HEAD = 'HTTP日志=====请求Headers';
  static const String TAG_HTTP_URL = 'HTTP日志=====请求URL';
  static const String TAG_HTTP_RESPONSE = 'HTTP日志=====响应';
  static const String TAG_HTTP_END = 'HTTP日志=====请求结束';
  

  static void logDebug({tag:TAG_TEST,text:''}){
    if(Config.debug){
      log(tag: tag,text: text.toString());
    }
  }

  static void log({String tag,String text}){
    print('$tag:$text');
  }
}