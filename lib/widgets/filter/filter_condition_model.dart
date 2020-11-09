part of flutter_core;
class Condition<T> {
  String name;
  dynamic value;
  bool isSelected;

  Condition(
    this.name,
    this.value,
    this.isSelected,
  );

  T get cValue => this.value as T;

  set cValue(T value) => this.value = value;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'name': this.name,
        'value': this.value,
        'isSelected': this.isSelected,
      };

  factory Condition.fromJson(Map<String, dynamic> json) {
    return Condition<T>(
      json['name'] as String,
      json['value'],
      json['isSelected'] as bool,
    );
  }
}
