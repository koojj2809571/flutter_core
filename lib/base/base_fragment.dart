part of flutter_core;

// ignore: must_be_immutable
abstract class BaseFragment extends StatefulWidget {
  BaseFragmentState baseComponentsState;
  String componentPath;

  BaseFragment(){
    if(Config.debug) {
      String className = this.toString();
      String path = StackTrace.current.toString().split(className)[1];
      path = path.split(')')[0];
      path = path.split('(')[1];
      componentPath = '$className: ($path)';
    }
  }

  @override
  BaseFragmentState createState() {
    baseComponentsState = getState();
    return baseComponentsState;
  }

  BaseFragmentState getState();

  String getStateName() => baseComponentsState.getWidgetName();
}

abstract class BaseFragmentState<T extends BaseFragment> extends State<T>
  with WidgetsBindingObserver, LifeCircle{

  State state;
  BuildContext rootContext;

  bool _onFirstResumed = false;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    onCreate();
    if (mounted) {}
    LogUtil.logDebug(tag: '碎片 =====>', text: widget.componentPath);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void deactivate() {
    onPause();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    buildBeforeReturn(context);
    // 调用场景与deactivate类似, 区别在于每次调用setState后该方法也会被调用
    if (!_onFirstResumed) {
      _onFirstResumed = true;
      onResumeIsFirst(isFirst: true);
      onResume();
    }

    return Container();
  }

  @override
  void dispose() {
    onDestroy();
    WidgetsBinding.instance.removeObserver(this);
    _onFirstResumed = false;
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
  }

  String getWidgetName() => getWidgetNameByClass(this.context);

  String getWidgetNameByClass(BuildContext context) {
    if (this.context == null) {
      return "";
    }
    String className = this.context.toString();
    if (className == null) {
      return "";
    }

    if (Config.debug) {
      try {
        className = className.substring(0, className.indexOf("("));
      } catch (err) {
        className = "";
      }
      return className;
    }

    return className;
  }

  /// 重写添加build方法return前需要执行的逻辑
  void buildBeforeReturn(BuildContext context) {}
}
