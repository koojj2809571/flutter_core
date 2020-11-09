part of flutter_core;

class FilterController extends ChangeNotifier{
  double filterBarHeight;
  int lastShowIndex = 0;
  bool isShow = false;
  bool isShowHideAnimation = false;

  void show(int index){
    isShow = true;
    lastShowIndex = index;
    notifyListeners();
  }

  void hide({bool isShowHideAnimation = true}) {
    this.isShowHideAnimation = isShowHideAnimation;
    isShow = false;
    notifyListeners();
  }
}