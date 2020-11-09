part of flutter_core;

class SearchChoiceItem{
  int id;
  bool isSelected;
  String name;
  String head;
  String introduction;

  SearchChoiceItem({this.id, this.isSelected, this.name, this.head, this.introduction});

  factory SearchChoiceItem.fromSearchItem(ISearchItem item) => SearchChoiceItem(
    id: item.getId(),
    isSelected: false,
    name: item.getName(),
    head: item.getHead(),
    introduction: item.getIntroduction(),
  );
}