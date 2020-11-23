part of flutter_core;

abstract class ISearchItem{
  String getSearchName();
  String getSearchHead();
  bool getSearchSelected();
  void setSearchSelected(bool value);
  int getSearchId();
  String getSearchIntroduction();
}