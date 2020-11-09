part of flutter_core;

// ignore: must_be_immutable
abstract class BasePage extends StatefulWidget {
  BasePageState basePageState;

  @override
  BasePageState createState() {
    basePageState = getState();
    return basePageState;
  }

  BasePageState getState();

  String getStateName() => basePageState.getWidgetName();
}

abstract class BasePageState<T extends BasePage> extends State<T>
    with WidgetsBindingObserver, BaseFunction {
  bool _onResumed = false; //页面展示标记
  bool _onPause = false; //页面暂停标记

  SystemUiOverlayStyle get statusMode => SystemUiOverlayStyle.light;

  @override
  void initState() {
    initBaseCommon(this);
    NavigatorManger().addWidget(this);
    WidgetsBinding.instance.addObserver(this);
    LogUtil.logDebug(tag: '当前页面 =====>', text: getWidgetName());
    onCreate();
    if (mounted) {}
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void deactivate() {
    // 以下场景调用该方法:
    // -当前路由栈中入栈其他页面,当前页面在栈中位置是第二个,也就是当前页面被移除屏幕显示的时候
    // -当前页面在栈中位置是第二个,当栈顶页面被弹出栈,当前页面重回栈顶
    // -当前页面被弹出栈
    if (NavigatorManger().isSecondTop(this)) {
      // 当前页面不在栈顶
      if (!_onPause) {
        onPause();
        _onPause = true;
      } else {
        onResume();
        _onResumed = false;
      }
    }
    if (NavigatorManger().isTopPage(this)) {
      // 当前页面在栈顶
      if (!_onPause) {
        onPause();
      }
    }
    super.deactivate();
  }

  //todo 添加点击收起对话框,点击返回实体按键功能!!!!!!!!!!!!!!!!!!!

  @override
  Widget build(BuildContext context) {
    // 调用场景与deactivate类似, 区别在于每次调用setState后该方法也会被调用
    if (!_onResumed) {
      if (NavigatorManger().isTopPage(this)) {
        _onResumed = true;
        onResume();
      }
    }
    buildBeforeReturn();
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: statusMode,
      child: _buildProviderWrapper(context),
    );
  }

  @override
  void dispose() {
    onDestroy();
    WidgetsBinding.instance.removeObserver(this);
    _onResumed = false;
    _onPause = false;

    // 取消网络请求
    HttpUtil().cancelRequest(context.toString());
    NavigatorManger().removeWidget(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // app前后台切换
    if (state == AppLifecycleState.resumed) {
      if (NavigatorManger().isTopPage(this)) {
        onForeground();
        onResume();
      }
    } else if (state == AppLifecycleState.paused) {
      if (NavigatorManger().isTopPage(this)) {
        onBackground();
        onPause();
      }
    }
    super.didChangeAppLifecycleState(state);
  }

  /// 封装状态管理组件
  _buildProviderWrapper(BuildContext context) {
    return !getProvider().empty
        ? MultiProvider(
            providers: getProvider(),
            child: buildCustomerPage() ?? getPage(_buildContentWrapper(context)),
          )
        : buildCustomerPage() ?? getPage(_buildContentWrapper(context));
  }

  /// 重写添加状态管理的provider
  List<SingleChildWidget> getProvider() {
    return null;
  }

  /// 封装错误,空白,加载中组件
  Widget _buildContentWrapper(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          Positioned(
            child: getContentWidget(context),
          ),
          if (_isErrorWidgetShow)
            Positioned(
              left: 0,
              top: 0,
              right: 0,
              bottom: 0,
              child: _getBaseErrorWidget(),
            ),
          if (_isEmptyWidgetVisible)
            Positioned(
              left: 0,
              top: 0,
              right: 0,
              bottom: 0,
              child: _getBaseEmptyWidget(),
            ),
          if (_isLoadingWidgetShow)
            Positioned(
              left: 0,
              top: 0,
              right: 0,
              bottom: 0,
              child: _getBassLoadingWidget(),
            ),
        ],
      ),
    );
  }

  /// 不使用封装的错误,空白,加载中控件时重写这个方法
  Widget buildCustomerPage() => null;

  /// 使用封装的错误,空白,加载中等控件时重写以下两个方法,使用后可在页面中直接调用或重写
  /// [setErrorContent] - 重写自定义错误控件
  /// [setErrorWidgetVisible] - 控制错误控件显示
  /// [setEmptyWidgetVisible] -  控制空白控件显示
  /// [setLoadingWidgetVisible] - 控制加载中控件显示
  /// [setEmptyWidgetContent] - 重写自定义空白控件
  /// [setErrorImage] - 设置错误图片
  /// [setEmptyImage] - 设置空白图片
  /// [finishDartPageOrApp] - 退出flutterEngine
  /// 等方法.....
  ///
  /// - getPage中返回页面布局推荐使用Scaffold,可添加AppBar,fab,bottomNav等
  /// - getContentWidget中返回页面具体内容,最后这个方法的返回会作为getPage中的参数传入,
  ///   推荐在getPage中返回Scaffold时用做body的值
  Widget getPage(Widget content) {
    return Scaffold(
      body: content,
    );
  }

  Widget getContentWidget(BuildContext context) => null;

  /// 重写添加build方法return前需要执行的逻辑
  void buildBeforeReturn() {}
}
