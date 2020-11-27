part of flutter_core;

///各数据类型功能封装

extension StringUtil on String {
  /// 非空判断包含null
  bool get empty => this == null || this.isEmpty;

  /// 非空判断包含空格
  bool get blank => this.empty || this.trim().isEmpty;
}

extension NumberUtil on num {
  /// 非空判断包含null
  bool get empty => this == null;
}

extension ListUtil on List {
  /// 非空判断包含null
  bool get empty => this == null || this.isEmpty;

  /// 转日志用字符串输出
  String listToStructureString({int indentation = 2}) {
    String result = "";
    String indentationStr = " " * indentation;
    result += "$indentationStr[";
    if(this.isNotEmpty) {
      this.forEach((value) {
        if (value is Map) {
          var temp = value.mapToStructureString(indentation: indentation + 2);
          result += "\n$indentationStr" + "\"$temp\",";
        } else if (value is List) {
          result += value.listToStructureString(indentation: indentation + 2);
        } else {
          result += "\n$indentationStr" + "\"$value\",";
        }
      });
      result = result.substring(0, result.length - 1);
    }
    result += "\n$indentationStr]";

    return result;
  }
}

extension MapUtil on Map {
  /// 非空判断包含null
  bool get empty => this == null || this.isEmpty;

  /// 转日志用字符串输出
  String mapToStructureString({int indentation = 2}) {
    String result = "";
    String indentationStr = " " * indentation;
    result += "{";
    if(this.isNotEmpty) {
      this.forEach((key, value) {
        if (value is Map) {
          var temp = value.mapToStructureString(indentation: indentation + 2);
          result += "\n$indentationStr" + "\"$key\" : $temp,";
        } else if (value is List) {
          result += "\n$indentationStr" +
              "\"$key\" : ${value.listToStructureString(
                  indentation: indentation + 2)},";
        } else {
          result += "\n$indentationStr" + "\"$key\" : \"$value\",";
        }
      });
      result = result.substring(0, result.length - 1);
    }
    result += indentation == 2 ? "\n}" : "\n${" " * (indentation - 1)}}";

    return result;
  }
}

extension BoolUtil on bool {
  /// 非空判断包含null
  bool get empty => this == null;
}
