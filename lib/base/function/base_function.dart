part of flutter_core;

abstract class BaseFunction {
  State _stateBaseFunction;
  BuildContext _contextBaseFunction;

  bool _isErrorWidgetShow = false;

  String _errorContentMessage = "网络错误啦~~~";

  String _errImgPath = Configuration().getConfiguration<String>(ERROR_IMAGE_PATH);

  bool _isLoadingWidgetShow = false;

  bool _isEmptyWidgetVisible = false;

  String _emptyWidgetContent = "暂无数据~";

  String _emptyImgPath = Configuration().getConfiguration<String>(EMPTY_IMAGE_PATH);

  FontWeight _fontWidget = FontWeight.w600; //错误页面和空页面的字体粗度

  double bottomVertical = 0; //作为内部页面距离底部的高度

  ///返回屏幕高度
  double get screenH => 1.hp;

  ///返回屏幕宽度
  double get screenW => 1.wp;

  ///返回状态栏高度
  double get statusBarH => MediaQuery.of(_contextBaseFunction).padding.top;

  ///返回appbar高度，也就是导航栏高度
  double get appBarHeight => kToolbarHeight;

  ///返回中间可绘制区域，也就是 我们子类 buildWidget 可利用的空间高度
  double get mainHeight => screenH - bottomVertical;

  Widget _getBaseErrorWidget() => getErrorWidget();

  Widget _getBassLoadingWidget() => getLoadingWidget();

  Widget _getBaseEmptyWidget() => getEmptyWidget();

  void initBaseCommon(State state) {
    _stateBaseFunction = state;
    _contextBaseFunction = state.context;
  }

  ///暴露的错误页面方法，可以自己重写定制
  Widget getErrorWidget() {
    return Container(
      //错误页面中心可以自己调整
      padding: EdgeInsets.fromLTRB(0, 0, 0, 200),
      color: Colors.white,
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: InkWell(
          onTap: onClickErrorWidget,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (!_errImgPath.empty)
                Image(
                  image: AssetImage(_errImgPath),
                  width: 150,
                  height: 150,
                ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Text(
                  _errorContentMessage,
                  style: TextStyle(
                    fontWeight: _fontWidget,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ///点击错误页面后执行逻辑
  void onClickErrorWidget() {
  }

  Widget getLoadingWidget() {
    return Container(
      color: Colors.black12,
      width: double.infinity,
      height: double.infinity,
      child: Container(
        color: Colors.black12,
        child: Center(
          child: CupertinoActivityIndicator(radius: 15),
        ),
      ),
    );
  }

  Widget getEmptyWidget() {
    return Container(
      //错误页面中心可以自己调整
      padding: EdgeInsets.fromLTRB(0, 0, 0, 200),
      color: Colors.white,
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (!_emptyImgPath.empty)
                Image(
                  color: Colors.black12,
                  image: AssetImage(_emptyImgPath),
                  width: 150,
                  height: 150,
                ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Text(_emptyWidgetContent,
                    style: TextStyle(
                      fontWeight: _fontWidget,
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }

  ///关闭最后一个 flutter 页面 ， 如果是原生跳过来的则回到原生，否则关闭app
  void finishDartPageOrApp() {
    SystemNavigator.pop();
  }

  ///设置错误提示信息
  void setErrorContent(String content) {
    if (content != null) {
      if (_stateBaseFunction != null && _stateBaseFunction.mounted) {
        // ignore: invalid_use_of_protected_member
        _stateBaseFunction.setState(() {
          _errorContentMessage = content;
        });
      }
    }
  }

  ///设置错误页面显示或者隐藏
  void setErrorWidgetVisible(bool isVisible) {
    if (_stateBaseFunction != null && _stateBaseFunction.mounted) {
      // ignore: invalid_use_of_protected_member
      _stateBaseFunction.setState(() {
        if (isVisible) {
          //如果可见 说明 空页面要关闭
          _isEmptyWidgetVisible = false;
        }
        // 不管如何loading页面要关闭，
        _isLoadingWidgetShow = false;
        _isErrorWidgetShow = isVisible;
      });
    }
  }

  ///设置空页面显示或者隐藏
  void setEmptyWidgetVisible(bool isVisible) {
    if (_stateBaseFunction != null && _stateBaseFunction.mounted) {
      // ignore: invalid_use_of_protected_member
      _stateBaseFunction.setState(() {
        if (isVisible) {
          //如果可见 说明 错误页面关闭
          _isErrorWidgetShow = false;
        }

        // 不管如何loading页面关闭，
        _isLoadingWidgetShow = false;
        _isEmptyWidgetVisible = isVisible;
      });
    }
  }

  void setLoadingWidgetVisible(bool isVisible) {
    if (_stateBaseFunction != null && _stateBaseFunction.mounted) {
      _stateBaseFunction.setState(() {
        _isLoadingWidgetShow = isVisible;
      });
    }
  }

  ///设置空页面内容
  void setEmptyWidgetContent(String content) {
    if (content != null) {
      if (_stateBaseFunction != null && _stateBaseFunction.mounted) {
        // ignore: invalid_use_of_protected_member
        _stateBaseFunction.setState(() {
          _emptyWidgetContent = content;
        });
      }
    }
  }

  ///设置错误页面图片
  void setErrorImage(String imagePath) {
    if (imagePath != null) {
      if (_stateBaseFunction != null && _stateBaseFunction.mounted) {
        // ignore: invalid_use_of_protected_member
        _stateBaseFunction.setState(() {
          _errImgPath = imagePath;
        });
      }
    }
  }

  ///设置空页面图片
  void setEmptyImage(String imagePath) {
    if (imagePath != null) {
      if (_stateBaseFunction != null && _stateBaseFunction.mounted) {
        // ignore: invalid_use_of_protected_member
        _stateBaseFunction.setState(() {
          _emptyImgPath = imagePath;
        });
      }
    }
  }

  ///弹对话框
  void showToastDialog(String message,
      {String title = "提示", String negativeText = "确定", Function callBack}) {
    if (_contextBaseFunction != null) {
      if (message != null && message.isNotEmpty) {
        showDialog<Null>(
            context: _contextBaseFunction, //BuildContext对象
            barrierDismissible: false,
            builder: (BuildContext context) {
              return new MessageDialog(
                title: title,
                negativeText: negativeText,
                message: message,
                onCloseEvent: () {
                  Navigator.pop(context);
                  if (callBack != null) {
                    callBack();
                  }
                },
              );
              //调用对话框);
            });
      }
    }
  }

  String getWidgetName() => getWidgetNameByClass(_contextBaseFunction);

  String getWidgetNameByClass(BuildContext context) {
    if (_contextBaseFunction == null) {
      return "";
    }
    String className = _contextBaseFunction.toString();
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

  ///弹吐司
  void showToast(
    String content, {
    Toast length = Toast.LENGTH_SHORT,
    ToastGravity gravity = ToastGravity.BOTTOM,
    Color backColor = Colors.black54,
    Color textColor = Colors.white,
  }) {
    ToastUtils.showToast(
      content,
      length: length,
      gravity: gravity,
      backColor: backColor,
      textColor: textColor,
    );
  }

  void showLoading() {
    showDialog(
      context: _contextBaseFunction,
      builder: (BuildContext context) {
        return Material(
          color: Colors.black.withOpacity(0.05),
          child: WillPopScope(
            child: Center(
              child: CupertinoActivityIndicator(radius: 40,),
            ),
            onWillPop: () => Future.value(false),
          ),
        );
      },
    );
  }

  void stopLoading() {
    Navigator.of(_contextBaseFunction).pop();
  }
}
