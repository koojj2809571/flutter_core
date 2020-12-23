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

abstract class BaseFragmentState<T extends BaseFragment> extends State<T> {

  State state;
  BuildContext rootContext;

  @override
  void initState() {
    super.initState();
    LogUtil.logDebug(tag: '碎片 =====>', text: widget.componentPath);
  }

  @override
  Widget build(BuildContext context) {
    return Container();
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
}
