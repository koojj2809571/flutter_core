part of flutter_core;
typedef OnItemTap<T> = void Function(T value);

class FilterBar extends StatefulWidget {
  final Color barBgColor;
  final double borderWidth;
  final Color borderColor;
  final TextStyle style;
  final TextStyle dropDownStyle;
  final double iconSize;
  final Color iconColor;
  final Color iconDropDownColor;

  final double height;
  final double dividerHeight;
  final Color dividerColor;
  final FilterController controller;
  final OnItemTap onItemTap;
  final List<FilterHeaderItem> items;
  final GlobalKey stackKey;

  FilterBar({
    Key key,
    this.barBgColor = Colors.white,
    this.borderWidth = 1,
    this.borderColor = const Color(0xFFeeede6),
    this.style = const TextStyle(color: Color(0xFF666666), fontSize: 13),
    this.dropDownStyle,
    this.iconSize = 20,
    this.iconColor = const Color(0xFFafada7),
    this.iconDropDownColor,
    this.height = 40,
    this.dividerHeight = 20,
    this.dividerColor = const Color(0xFFeeede6),
    @required this.controller,
    this.onItemTap,
    @required this.items,
    @required this.stackKey,
  }) : super(key: key);

  @override
  _FilterBarState createState() => _FilterBarState();
}

class _FilterBarState extends State<FilterBar> {
  bool _isShowConditionItem = false;
  double _screenWidth;
  int _menuCount;
  GlobalKey _filterBarKey = GlobalKey();
  TextStyle _dropDownStyle;
  Color _iconDropDownColor;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onController);
  }

  void _onController() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    _dropDownStyle = widget.dropDownStyle ??
        TextStyle(color: Theme.of(context).primaryColor, fontSize: 13);
    _iconDropDownColor =
        widget.iconDropDownColor ?? Theme.of(context).primaryColor;

    MediaQueryData mediaQuery = MediaQuery.of(context);
    _screenWidth = mediaQuery.size.width;
    _menuCount = widget.items.length;

    return Container(
      key: _filterBarKey,
      height: widget.height,
      decoration: BoxDecoration(
        border: Border.all(
          color: widget.borderColor,
          width: widget.borderWidth,
        ),
      ),
      child: GridView.count(
        crossAxisCount: _menuCount,
        physics: NeverScrollableScrollPhysics(),
        childAspectRatio: (_screenWidth / _menuCount) / widget.height,
        children: widget.items.map<Widget>((item) {
          return _menuItem(item);
        }).toList(),
      ),
    );
  }

  Widget _menuItem(FilterHeaderItem item) {
    int index = widget.items.indexOf(item);
    int lastShowIndex = widget.controller.lastShowIndex;
    _isShowConditionItem = index == lastShowIndex && widget.controller.isShow;

    return GestureDetector(
      onTap: () {
        final RenderBox overlay =
            widget.stackKey.currentContext.findRenderObject();
        final RenderBox dropDownItemRenderBox =
            _filterBarKey.currentContext.findRenderObject();
        var position =
            dropDownItemRenderBox.localToGlobal(Offset.zero, ancestor: overlay);
        var size = dropDownItemRenderBox.size;

        widget.controller.filterBarHeight = size.height + position.dy;

        if (index == lastShowIndex) {
          if (widget.controller.isShow) {
            widget.controller.hide();
          } else {
            widget.controller.show(index);
          }
        } else {
          if (widget.controller.isShow) {
            widget.controller.hide(isShowHideAnimation: false);
          }
          widget.controller.show(index);
        }

        if (widget.onItemTap != null) {
          widget.onItemTap(index);
        }

        setState(() {});
      },
      child: Container(
        decoration: BoxDecoration(
          color: widget.barBgColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    child: Text(
                      item.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: _isShowConditionItem
                          ? _dropDownStyle
                          : widget.style.merge(item.textStyle),
                    ),
                  ),
                  Icon(
                    !_isShowConditionItem
                        ? item.iconData ?? Icons.arrow_drop_down
                        : item.iconData ?? Icons.arrow_drop_up,
                    color: _isShowConditionItem
                        ? _iconDropDownColor
                        : item?.textStyle?.color ?? widget.iconColor,
                    size: item.iconSize ?? widget.iconSize,
                  ),
                  index == widget.items.length - 1
                      ? Container()
                      : Container(
                          height: widget.dividerHeight,
                          decoration: BoxDecoration(
                            border: Border(
                              right: BorderSide(
                                  color: widget.dividerColor, width: 1),
                            ),
                          ),
                        )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class FilterHeaderItem {
  String title;
  final IconData iconData;
  final double iconSize;
  final TextStyle textStyle;

  FilterHeaderItem({this.title, this.iconData, this.iconSize, this.textStyle});
}
