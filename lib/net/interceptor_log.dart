part of flutter_core;

///日志拦截器
class DioLogInterceptor extends InterceptorsWrapper {
  @override
  Future onRequest(RequestOptions options) async {
    String requestStr = "\n==================== REQUEST ====================\n"
        "- URI:\n${options.uri}\n"
        "- METHOD: ${options.method}\n";

    requestStr += "- HEADER:\n${options.headers.mapToStructureString()}\n";

    final data = options.data;
    if (data != null) {
      if (data is Map) {
        requestStr += "- BODY:\n${data.mapToStructureString()}\n";
      } else if (data is FormData) {
        final formDataMap = Map()
          ..addEntries(data.fields)
          ..addEntries(data.files);
        requestStr += "- BODY:\n${formDataMap.mapToStructureString()}\n";
      } else {
        requestStr += "- BODY:\n${data.toString()}\n";
      }
    }
    LogUtil.segmentationLog(requestStr);
    return options;
  }

  @override
  Future onError(DioError err) async {
    String errorStr = "\n==================== RESPONSE-ERROR ====================\n"
        "- URL:\n${err.request.baseUrl + err.request.path}\n"
        "- METHOD: ${err.request.method}\n";

    errorStr +=
    "- HEADER:\n${err.response?.headers?.map?.mapToStructureString()??'head'}\n";
    if (err.response != null && err.response.data != null) {
      LogUtil.segmentationLog('╔ ${err.toString()}');
      errorStr += "- ERROR:\n${ErrorEntity.createByDioError(err)}\n";
    } else {
      errorStr += "- ERRORTYPE: ${err.type}\n";
      errorStr += "- MSG: ${err.message}\n";
    }
    LogUtil.segmentationLog(errorStr);
    return err;
  }

  @override
  Future onResponse(Response response) async {
    String responseStr =
        "\n==================== RESPONSE ====================\n"
        "- URL:\n${response.request.uri}\n";
    responseStr += "- HEADER:\n{";
    response.headers.forEach(
            (key, list) => responseStr += "\n  " + "\"$key\" : \"$list\",");
    responseStr += "\n}\n";
    responseStr += "- STATUS: ${response.statusCode}\n";

    if (response.data != null) {
      responseStr += "- BODY:\n${_parseResponse(response)}";
    }
    LogUtil.segmentationLog(responseStr);
    return response;
  }

  String _parseResponse(Response response) {
    String responseStr = "";
    var data = response.data;
    if (data is Map)
      responseStr += data.mapToStructureString();
    else if (data is List)
      responseStr += data.listToStructureString();
    else
      responseStr += response.data.toString();

    return responseStr;
  }
}