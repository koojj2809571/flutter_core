part of flutter_core;
class FilterMenuBuilder {
  final Widget dropDownWidget;
  final bool isShowMask ;

  FilterMenuBuilder({
    @required this.dropDownWidget,
    this.isShowMask = true,
  });
}

typedef DropdownMenuChange = void Function(bool isShown, int index);

class FilterMenu extends StatefulWidget {
  final FilterController controller;
  final List<FilterMenuBuilder> menus;
  final Color maskColor;
  final DropdownMenuChange dropdownMenuChanging;
  final DropdownMenuChange dropdownMenuChanged;

  FilterMenu({
    Key key,
    @required this.controller,
    @required this.menus,
    this.maskColor = const Color.fromRGBO(0, 0, 0, 0.5),
    this.dropdownMenuChanging,
    this.dropdownMenuChanged,
  }):super(key:key);

  @override
  _FilterMenuState createState() => _FilterMenuState();
}

class _FilterMenuState extends State<FilterMenu>{

  bool _isShowDropDownItemWidget = false;
  bool _isShowMask = false;

  double _maskColorOpacity;

  int _currentMenuIndex;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onController);
  }

  void _onController(){
    _showDropDownItemWidget();
  }

  @override
  Widget build(BuildContext context) {
    return widget.controller.isShow ? _buildDropDownWidget() : Container();
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_onController);
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
    // if (!_isShowMask) {
    //    _isShowMask = true;
    // }
    _isShowMask = widget.menus[_currentMenuIndex].isShowMask;

  }

  Widget _mask() {
    if (_isShowMask) {
      return Expanded(
        flex: 5,
        child:GestureDetector(
        onTap: () {
          widget.controller.hide();
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: widget.maskColor,
        ),
      ),);
    } else {
      return Expanded(
        flex: 0,
          child: Container(
        height: 0,
      )) ;
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
      bottom: 0,
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 10,
            child:Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: widget.menus[lastShowIndex].dropDownWidget,
          ),),

          _mask(),
        ],
      ),
    );
  }
}
