part of flutter_core;

// ignore: must_be_immutable
abstract class BasePage extends StatefulWidget {
  BasePageState basePageState;
  String pagePath;

  BasePage(){
    if(Config.debug) {
      String className = this.toString();
      String path = StackTrace.current.toString().split(className)[1];
      path = path.split(')')[0];
      path = path.split('(')[1];
      pagePath = '$className: ($path)';
    }
  }

  @override
  BasePageState createState() {
    basePageState = getState();
    return basePageState;
  }

  BasePageState getState();

  String getStateName() => basePageState.getWidgetName();
}

abstract class BasePageState<T extends BasePage> extends State<T>
    with WidgetsBindingObserver, BaseFunction, LifeCircle, BaseScaffold {
  bool _onResumed = false; //页面展示标记
  bool _onPause = false; //页面暂停标记

  @override
  void initState() {
    initBaseCommon(this);
    NavigatorManger().addWidget(this);
    WidgetsBinding.instance.addObserver(this);
    if(isAutoHandleHttpResult()) {
      HttpUtil().httpController().addListener(_onController);
    }
    LogUtil.logDebug(tag: '当前页面 =====>', text: widget.pagePath);
    onCreate();
    if (mounted) {}
    super.initState();
  }

  void _onController() {
    if (isAutoHandleHttpResult()) {
      setEmptyWidgetVisible(HttpUtil().httpController().isEmpty);
      setErrorWidgetVisible(HttpUtil().httpController().isError);
      setLoadingWidgetVisible(HttpUtil().httpController().isLoading);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void deactivate() {
    // 以下场景调用该方法:以HomePage(第一页),NextPage(第二页)为例
    // -当前路由栈中入栈其他页面,当前页面在栈中位置是第二个,也就是当前页面被移除屏幕显示的时候
    // >> NextPage(initState) -> NextPage(didChangeDependencies) -> NextPage(build) -> HomePage(deactivate) -> HomePage(build)
    // -当前页面在栈中位置是第二个,当栈顶页面被弹出栈,当前页面重回栈顶
    // >> HomePage(deactivate) -> HomePage(build) -> NextPage(deactivate) -> NextPage(dispose)
    // -当前页面被弹出栈
    // >> HomePage(deactivate) -> HomePage(dispose)
    if (NavigatorManger().isSecondTop(this)) {
      // 当前页面不在栈顶
      if (!_onPause) {
        onPause();
        _onPause = true;
      } else {
        onResume();
        _onPause = false;
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
      child: _buildOnBackPressedWrapper(context),
    );
  }

  @override
  void dispose() {
    onDestroy();
    WidgetsBinding.instance.removeObserver(this);
    _onResumed = false;
    _onPause = false;

    // 取消网络请求
    if(isCancelRequestWhenDispose()) {
      HttpUtil().cancelRequest(context.toString());
    }
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

  /// 点击返回按按钮时执行逻辑
  Widget _buildOnBackPressedWrapper(BuildContext context) {
    return WillPopScope(
      child: _buildAutoHideKeyboardWrapper(context),
      onWillPop: onBackPressed,
    );
  }

  /// 点击页面收起键盘
  Widget _buildAutoHideKeyboardWrapper(BuildContext context) {
    return canClickPageHideKeyboard()
        ? GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            child: _buildProviderWrapper(context),
          )
        : _buildProviderWrapper(context);
  }

  /// 封装状态管理组件
  Widget _buildProviderWrapper(BuildContext context) {
    return !getProvider().empty
        ? MultiProvider(
            providers: getProvider(),
            child: _buildCustomerPageLayout(_buildContentWrapper(context)) ??
                _buildPageLayout(_buildContentWrapper(context)),
          )
        : _buildCustomerPageLayout(_buildContentWrapper(context)) ??
            _buildPageLayout(_buildContentWrapper(context));
  }

  /// 封装错误,空白,加载中组件
  Widget _buildContentWrapper(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            right: 0,
            bottom: 0,
            child: setCustomerPageContent(context: context) ?? setPageContent(context),
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

  Widget _buildCustomerPageLayout(Widget content) {
    if (setCustomerPageContent() == null) return null;
    return Container(
      child: content,
    );
  }

  Widget _buildPageLayout(Widget content) {
    return Scaffold(
      key: baseScaffoldKey,
      appBar: appBar,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      floatingActionButtonAnimator: floatingActionButtonAnimator,
      persistentFooterButtons: persistentFooterButtons,
      drawer: drawer,
      endDrawer: endDrawer,
      bottomNavigationBar: bottomNavigationBar,
      bottomSheet: bottomSheet,
      backgroundColor: backgroundColor,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      primary: primary ?? true,
      drawerDragStartBehavior:
          drawerDragStartBehavior ?? DragStartBehavior.start,
      extendBody: extendBody ?? false,
      extendBodyBehindAppBar: extendBodyBehindAppBar ?? false,
      drawerScrimColor: drawerScrimColor,
      drawerEdgeDragWidth: drawerEdgeDragWidth,
      drawerEnableOpenDragGesture: drawerEnableOpenDragGesture ?? true,
      endDrawerEnableOpenDragGesture: endDrawerEnableOpenDragGesture ?? true,
      body: content,
    );
  }

  /*------------------------------------ 子类实现方法 ------------------------------------*/

  /// 重写修改顶部状态栏文字颜色
  /// [SystemUiOverlayStyle.light]-白色文本图标
  /// [SystemUiOverlayStyle.dark]-黑色文本图标
  SystemUiOverlayStyle get statusMode => SystemUiOverlayStyle.light;

  /// 是否在销毁时取消页面请求
  bool isCancelRequestWhenDispose() => false;

  /// 是否自动处理网络请求对应页面展示
  bool isAutoHandleHttpResult() => false;

  /// 返回true直接退出,当子类需要添加点击返回逻辑时重写该方法,默认true
  Future<bool> onBackPressed() async => true;

  /// 重写改变返回值,true-点击页面时收起键盘,false无此功能,默认false
  bool canClickPageHideKeyboard() => false;

  /// 重写添加状态管理的provider
  List<SingleChildWidget> getProvider() {
    return null;
  }

  /// 不使用Scaffold时重写,页面中可调用或重写
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
  /// [setCustomerPageContent]返回null时页面显示[setPageContent]返回内容,
  /// [setCustomerPageContent]返回不为null时[setPageContent]不生效
  Widget setCustomerPageContent({BuildContext context}) => null;

  /// 使用Scaffold时重写,返回为Scaffold的body,
  /// Scaffold其他参数重写[BaseScaffold]对应字段getter方法.
  ///
  /// 页面中可调用或重写
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
  /// [setCustomerPageContent]返回null时页面显示[setPageContent]返回内容,
  /// [setCustomerPageContent]返回不为null时[setPageContent]不生效
  Widget setPageContent(BuildContext context) => Container();

  /// 重写添加build方法return前需要执行的逻辑
  void buildBeforeReturn() {}
}
