part of flutter_core;
class FilterMenuWithAnimationBuilder {
  final Widget dropDownWidget;
  final double dropDownHeight;

  FilterMenuWithAnimationBuilder({
    @required this.dropDownWidget,
    @required this.dropDownHeight,
  });
}

class FilterMenuWithAnimation extends StatefulWidget {
  final FilterController controller;
  final List<FilterMenuWithAnimationBuilder> menus;
  final int animationMilliseconds;
  final Color maskColor;
  final DropdownMenuChange dropdownMenuChanging;
  final DropdownMenuChange dropdownMenuChanged;

  FilterMenuWithAnimation({
    Key key,
    @required this.controller,
    @required this.menus,
    this.animationMilliseconds = 500,
    this.maskColor = const Color.fromRGBO(0, 0, 0, 0.5),
    this.dropdownMenuChanging,
    this.dropdownMenuChanged,
  }):super(key:key);

  @override
  _FilterMenuWithAnimationState createState() => _FilterMenuWithAnimationState();
}

class _FilterMenuWithAnimationState extends State<FilterMenuWithAnimation> with SingleTickerProviderStateMixin{

  bool _isShowDropDownItemWidget = false;
  bool _isShowMask = false;
  bool _isControllerDisposed = false;
  Animation<double> _animation;
  AnimationController _controller;

  double _maskColorOpacity;

  double _dropDownHeight;

  int _currentMenuIndex;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onController);
    _controller = new AnimationController(duration: Duration(milliseconds: widget.animationMilliseconds), vsync: this);
  }

  void _onController(){
    _showDropDownItemWidget();
  }

  @override
  Widget build(BuildContext context) {
    _controller.duration = Duration(milliseconds: widget.animationMilliseconds);
    return _buildDropDownWidget();
  }

  @override
  void dispose() {
    _animation?.removeListener(_animationListener);
    _animation?.removeStatusListener(_animationStatusListener);
    widget.controller?.removeListener(_onController);
    _controller?.dispose();
    _isControllerDisposed = true;
    super.dispose();
  }

  void _showDropDownItemWidget(){
    _currentMenuIndex = widget.controller.lastShowIndex;
    if (_currentMenuIndex >= widget.menus.length || widget.menus[_currentMenuIndex] == null) {
      return;
    }

    _isShowDropDownItemWidget = !_isShowDropDownItemWidget;
    if (widget.dropdownMenuChanging != null) {
      widget.dropdownMenuChanging(_isShowDropDownItemWidget, _currentMenuIndex);
    }
    if (!_isShowMask) {
      _isShowMask = true;
    }

    _dropDownHeight = widget.menus[_currentMenuIndex].dropDownHeight;

    _animation?.removeListener(_animationListener);
    _animation?.removeStatusListener(_animationStatusListener);
    _animation = new Tween(begin: 0.0, end: _dropDownHeight).animate(_controller)
      ..addListener(_animationListener)
      ..addStatusListener(_animationStatusListener);

    if (_isControllerDisposed) return;

    if (widget.controller.isShow) {
      _controller.forward();
    } else if (widget.controller.isShowHideAnimation) {
      _controller.reverse();
    } else {
      _controller.value = 0;
    }
  }

  void _animationStatusListener(AnimationStatus status) {
    switch (status) {
      case AnimationStatus.dismissed:
        _isShowMask = false;
        if (widget.dropdownMenuChanged != null) {
          widget.dropdownMenuChanged(false, _currentMenuIndex);
        }
        break;
      case AnimationStatus.forward:
        break;
      case AnimationStatus.reverse:
        break;
      case AnimationStatus.completed:
        if (widget.dropdownMenuChanged != null) {
          widget.dropdownMenuChanged(true, _currentMenuIndex);
        }
        break;
    }
  }

  void _animationListener() {
    var heightScale = _animation.value / _dropDownHeight;
    _maskColorOpacity = widget.maskColor.opacity * heightScale;
    setState(() {});
  }

  Widget _mask() {
    if (_isShowMask) {
      return GestureDetector(
        onTap: () {
          widget.controller.hide();
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: widget.maskColor.withOpacity(_maskColorOpacity),
        ),
      );
    } else {
      return Container(
        height: 0,
      );
    }
  }

  Widget _buildDropDownWidget() {

    int lastShowIndex = widget.controller.lastShowIndex;

    if(lastShowIndex > widget.menus.length){
      return Container();
    }

    return Positioned(
      width: MediaQuery.of(context).size.width,
      top: widget.controller.filterBarHeight,
      left: 0,
      child: Column(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: _animation == null ? 0 : _animation.value,
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: widget.menus[lastShowIndex].dropDownWidget,
          ),
          _mask(),
        ],
      ),
    );
  }
}
