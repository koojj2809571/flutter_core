part of flutter_core;

class HttpResponse{
  bool success;
  int code;
  String message;
  Map<String,dynamic> data;

  HttpResponse(this.success, this.code, this.message, this.data);

  factory HttpResponse.fromJson(Map<String,dynamic> json) => _$HttpResponseFromJson(json);
  Map<String,dynamic> toJson() => _$HttpResponseToJson(this);
}

HttpResponse _$HttpResponseFromJson(Map<String, dynamic> json) {
  return HttpResponse(
    json['success'] as bool,
    json['code'] as int,
    json['message'] as String,
    json['data'] as Map<String, dynamic>,
  );
}

Map<String, dynamic> _$HttpResponseToJson(HttpResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'code': instance.code,
      'message': instance.message,
      'data': instance.data,
    };

class EmptyResponse{}