part of flutter_core;

class NavigatorManger {
  List<BasePageState> _activityStack = List();

  NavigatorManger._internal();

  static NavigatorManger _instance = NavigatorManger._internal();

  factory NavigatorManger() => _instance;
  void addWidget(BasePageState baseState) {
    _activityStack.add(baseState);
  }

  void removeWidget(BasePageState baseState) {
    HttpUtil(). removeCancelToken(baseState.context);
    _activityStack.remove(baseState.getWidgetName());
  }

  bool isTopPage(BasePageState baseState) {
    if (_activityStack == null) {
      return false;
    }
    try {
      return baseState.getWidgetName() ==
          _activityStack[_activityStack.length - 1].getWidgetName();
    } catch (exception) {
      return false;
    }
  }

  bool isSecondTop(BasePageState baseState) {
    if (_activityStack == null) {
      return false;
    }
    try {
      return baseState.getWidgetName() ==
          _activityStack[_activityStack.length - 2].getWidgetName();
    } catch (exception) {
      return false;
    }
  }
}