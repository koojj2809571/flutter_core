part of flutter_core;

///各数据类型功能封装

extension StringUtil on String {
  /// 非空判断包含null
  bool get empty => this == null || this.isEmpty;

  /// 非空判断包含空格
  bool get blank => this.empty || this.trim().isEmpty;

  void log() {
    print(this);
  }

  void logDebug({String tag: LogUtil.TAG_TEST}) {
    LogUtil.log(tag: tag, text: this);
  }

  void toast({
    Toast length = Toast.LENGTH_SHORT,
    ToastGravity gravity = ToastGravity.BOTTOM,
    Color backColor = Colors.black54,
    Color textColor = Colors.white,
  }) {
    ToastUtils.showToast(
      this,
      length: length,
      gravity: gravity,
      backColor: backColor,
      textColor: textColor,
    );
  }

  String get MD5 {
    var content = new Utf8Encoder().convert(this);
    var digest = md5.convert(content);
    // 这里其实就是 digest.toString()
    return hex.encode(digest.bytes);
  }

  List<int> get upperCaseIndex {
    List<int> indexes = [];
    for (int i = 0; i < this.codeUnits.length; i++) {
      int value = this.codeUnits[i];
      if (value >= 65 && value <= 90) {
        indexes.add(i);
      }
    }
    return indexes;
  }

  String splitUpperCaseWith(String start, String split) {
    if (start == null || split == null) return null;
    List<int> indexes = this.upperCaseIndex;
    if (indexes[0] != 0) {
      indexes.insert(0, 0);
    }

    var temp = <String>[];
    for (int i = 0; i < indexes.length; i++) {
      int end = i == indexes.length - 1 ? this.length : indexes[i + 1];
      temp.add(this.toLowerCase().substring(indexes[i], end));
    }
    return '$start${temp.join(split)}';
  }
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
    if (this.isNotEmpty) {
      this.forEach((value) {
        if (value is Map) {
          var temp = value.mapToStructureString(indentation: indentation + 2);
          result += "\n$indentationStr" + "$temp,";
        } else if (value is List) {
          result += value.listToStructureString(indentation: indentation + 2);
        } else {
          String temp = (value is String) ? "\"$value\"," : "$value,";
          result += "\n$indentationStr" + temp;
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
    if (this.isNotEmpty) {
      this.forEach((key, value) {
        if (value is Map) {
          var temp = value.mapToStructureString(indentation: indentation + 2);
          result += "\n$indentationStr" + "\"$key\" : $temp,";
        } else if (value is List) {
          result += "\n$indentationStr" +
              "\"$key\" : ${value.listToStructureString(indentation: indentation + 2)},";
        } else {
          String temp = (value is String) ? "\"$value\"," : "$value,";
          result += "\n$indentationStr" + "\"$key\" : " + temp;
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
