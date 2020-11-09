part of flutter_core;

class SearchRefreshListPage<T> extends StatefulWidget {

  final BasePageRequest param;
  final SendRequest<BasePageResponse<T>> sendRequest;
  final Function itemWidget;
  final Function itemClick;
  final Function onSearch;
  final EasyRefreshController controller;
  final String searchHint;
  final bool hasDropdownButton;
  final List<DropdownMenuItem> menuItems;
  final Function onTypeChange;
  final int dropdownValue;

  SearchRefreshListPage({
    this.param,
    this.sendRequest,
    this.itemWidget,
    this.itemClick,
    this.onSearch,
    this.controller,
    this.searchHint: '输入关键字搜索',
    this.hasDropdownButton: false,
    this.menuItems,
    this.onTypeChange,
    this.dropdownValue,
  });

  @override
  _SearchRefreshListPageState createState() => _SearchRefreshListPageState<T>();
}

class _SearchRefreshListPageState<T> extends State<SearchRefreshListPage> {
  TextEditingController ctr;
  BasePageRequest param;
  EasyRefreshController controller;

  @override
  void initState() {
    super.initState();
    ctr = TextEditingController();
    param = widget.param;
    controller = widget.controller ?? EasyRefreshController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: RefreshList<T>(
        param: param,
        sendRequest: widget.sendRequest,
        itemWidget: widget.itemWidget,
        itemClick: widget.itemClick,
        controller: controller,
      ),
    );
  }

  Widget _appBar() {
    return AppBar(
      brightness: Brightness.light,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: Colors.black,
        ),
        onPressed: () {
          ExtendedNavigator.root.pop();
        },
      ),
      title: Row(
        children: <Widget>[
          widget.hasDropdownButton ? DropdownButton(
            value: widget.dropdownValue,
            underline: Container(),
            items: widget.menuItems,
            onChanged: widget.onTypeChange,
          ) : Container(),
          Expanded(
            child: TextField(
              controller: ctr,
              textInputAction: TextInputAction.search,
              onSubmitted: widget.onSearch,
              decoration: InputDecoration(
                hintText: widget.searchHint,
                hintStyle: TextStyle(
                  fontSize: 14.sp,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  size: 18.w,
                ),
                suffix: IconButton(
                  icon: Icon(
                    Icons.cancel,
                    color: Colors.black12,
                    size: 15.w,
                  ),
                  onPressed: () {
                    ctr.clear();
                  },
                ),
              ),
            ),
          )
        ],
      ),
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.white,
    );
  }
}
