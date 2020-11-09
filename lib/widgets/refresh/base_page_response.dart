part of flutter_core;
abstract class BasePageResponse<T>{
  int valuePage();
  int valueSize();
  int valueTotal();
  List<T> valueList();
}