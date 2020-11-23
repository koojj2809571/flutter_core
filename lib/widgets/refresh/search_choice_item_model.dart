part of flutter_core;

class SearchChoiceItem{
  int id;
  bool isSelected;
  String name;
  String head;
  String introduction;

  SearchChoiceItem({this.id, this.isSelected, this.name, this.head, this.introduction});

  factory SearchChoiceItem.fromSearchItem(ISearchItem item) => SearchChoiceItem(
    id: item.getSearchId(),
    isSelected: false,
    name: item.getSearchName(),
    head: item.getSearchHead(),
    introduction: item.getSearchIntroduction(),
  );
}