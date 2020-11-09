part of flutter_core;
abstract class BasePageRequest{
  int valuePage();
  int valueSize();
  String valueKeywords() => '';

  void setPage(int value);
  void setSize(int value);
  void setKeywords(String key){}
}