part of flutter_core;

/// 当使用Scaffold作为页面脚手架时重写以下字段getter方法
abstract class BaseScaffold {
  Key baseScaffoldKey;
  PreferredSizeWidget appBar;
  Widget floatingActionButton;
  FloatingActionButtonLocation floatingActionButtonLocation;
  FloatingActionButtonAnimator floatingActionButtonAnimator;
  List<Widget> persistentFooterButtons;
  Widget drawer;
  Widget endDrawer;
  Widget bottomNavigationBar;
  Widget bottomSheet;
  Color backgroundColor;
  bool resizeToAvoidBottomInset;
  bool primary;
  DragStartBehavior drawerDragStartBehavior;
  bool extendBody;
  bool extendBodyBehindAppBar;
  Color drawerScrimColor;
  double drawerEdgeDragWidth;
  bool drawerEnableOpenDragGesture;
  bool endDrawerEnableOpenDragGesture;
}
