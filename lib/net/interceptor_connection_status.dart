part of flutter_core;

class ConnectionStatusInterceptor extends InterceptorsWrapper{

  HttpController _controller;

  ConnectionStatusInterceptor(this._controller);

  @override
  Future onRequest(RequestOptions options) async {
    _controller.startLoading();
    return options;
  }

  @override
  Future onError(DioError err) async {
    _controller.onError(err);
    return ErrorEntity.createByDioError(err);
  }

  @override
  Future onResponse(Response response) async {
    _controller.onSuccess();
    return response;
  }
}