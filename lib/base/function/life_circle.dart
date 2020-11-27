part of flutter_core;

abstract class LifeCircle{

  String name;

  void setComponentName(String name) => this.name = name;

  ///初始化一些变量 相当于android onCreate,初始化数据操作
  void onCreate();

  ///相当于onResume,只要页面来到栈顶,都会调用此方法,网络请求可以放在这个方法
  void onResume();

  ///页面被覆盖,暂停
  void onPause();

  ///app切回到后台
  void onBackground() {
    LogUtil.logDebug(text: "$name-回到后台");
  }

  ///app切回到前台
  void onForeground() {
    LogUtil.logDebug(text: "$name-回到前台");
  }

  ///页面注销方法
  void onDestroy() {
    LogUtil.logDebug(text: "$name-销毁");
  }
}