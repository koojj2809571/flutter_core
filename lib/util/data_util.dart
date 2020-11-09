part of flutter_core;

///各数据类型功能封装

extension StringUtil on String{
  bool get empty => this == null || this.isEmpty;
  bool get blank => this.empty || this.trim().isEmpty;
}

extension NumberUtil on num{
  bool get empty => this == null;
}

extension ListUtil on List{
  bool get empty => this == null || this.isEmpty;
}

extension MapUtil on Map{
  bool get empty => this == null || this.isEmpty;
}

extension BoolUtil on bool{
  bool get empty => this == null;
}