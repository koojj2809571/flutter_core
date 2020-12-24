part of flutter_core;

class SearchListMultiChoice<T extends ISearchItem> extends StatefulWidget {
  final Map<int, String> selectedIds;
  final BasePageRequest param;
  final SendRequest<BasePageResponse<T>> sendRequest;
  final Function itemWidget;
  final Function okClick;
  final Function backClick;
  final EasyRefreshController refreshCtr;
  final String searchHint;
  final bool canLoadMore;
  final GlobalKey stackKey;
  final bool hasFilter;
  final List<FilterHeaderItem> filterTitleItems;
  final FilterController filterCtr;
  final List<FilterMenuBuilder> filterMenus;
  final NotifyAfterRefresh notify;
  final Color theme;
  final Color okColor;
  final Widget empty;
  final int min;
  final int max;

  SearchListMultiChoice({
    this.selectedIds,
    this.param,
    this.sendRequest,
    this.itemWidget,
    this.okClick,
    this.backClick,
    this.refreshCtr,
    this.searchHint: '相关数据',
    this.canLoadMore: false,
    this.notify,
    this.theme,
    this.okColor,
    this.empty,
    this.min,
    this.max
  })  : this.hasFilter = false,
        this.stackKey = null,
        this.filterTitleItems = null,
        this.filterCtr = null,
        this.filterMenus = null;

  SearchListMultiChoice.withFilter(
      this.stackKey,
      this.filterTitleItems,
      this.filterCtr,
      this.filterMenus, {
        this.selectedIds,
        this.param,
        this.sendRequest,
        this.itemWidget,
        this.okClick,
        this.backClick,
        this.refreshCtr,
        this.searchHint: '相关数据',
        this.canLoadMore: false,
        this.notify,
        this.theme,
        this.okColor,
        this.empty,
        this.min ,
        this.max
      }) : this.hasFilter = true;

  @override
  _SearchListMultiChoiceState createState() => _SearchListMultiChoiceState<T>();
}

class _SearchListMultiChoiceState<T extends ISearchItem>
    extends State<SearchListMultiChoice> {
  List<T> searchItemList;
  TextEditingController searchCtr;
  BasePageRequest param;
  SendRequest<BasePageResponse<T>> sendRequest;
  EasyRefreshController refreshController;
  Map<int, String> selectedIds;

  @override
  void initState() {
    super.initState();
    refreshController = widget.refreshCtr ?? EasyRefreshController();
    sendRequest = widget.sendRequest;
    searchCtr = TextEditingController();
    param = widget.param;
    searchItemList = [];
    selectedIds = widget.selectedIds;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: widget.hasFilter ? _withFilterSelectContent() : _selectContent(),
      floatingActionButton: _okButton(),
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
        onPressed: widget.backClick,
      ),
      title: TextField(
        controller: searchCtr,
        textInputAction: TextInputAction.search,
        onSubmitted: (value) {
          param.setKeywords(value);
          setState(() {
            searchItemList.clear();
            param.setPage(0);
            refreshController.callRefresh();
          });
        },
        decoration: InputDecoration(
          hintText: '搜索${widget.searchHint}',
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
              searchCtr.clear();
            },
          ),
        ),
      ),
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.white,
    );
  }

  Widget _withFilterSelectContent() {
    return Stack(
      key: widget.stackKey,
      children: [
        Column(
          children: [
            FilterBar(
              height: 50.h,
              stackKey: widget.stackKey,
              items: widget.filterTitleItems,
              controller: widget.filterCtr,
              onItemTap: (index) {},
              style: TextStyle(color: Color(0xFF666666), fontSize: 14),
              dividerColor: Colors.white,
              dropDownStyle: TextStyle(
                fontSize: 14,
                color: widget.theme,
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(color: Colors.white),
                child: _refreshContentList(),
              ),
            )
          ],
        ),
        FilterMenu(
          controller: widget.filterCtr,
          dropdownMenuChanging: (isShow, index) {
            setState(() {});
          },
          dropdownMenuChanged: (isShow, index) {
            setState(() {});
          },
          menus: widget.filterMenus,
        ),
      ],
    );
  }

  Widget _selectContent() {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      child: _refreshContentList(),
    );
  }

  Widget _okButton() {
    return FloatingActionButton(
      elevation: 5,
      child: Icon(
        Icons.check,
        size: 30.w,
      ),
      backgroundColor: Colors.lightGreen,
      onPressed: widget.okClick,
    );
  }

  Widget _refreshContentList() {
    return EasyRefresh.custom(
      emptyWidget: searchItemList == null || searchItemList.length == 0
          ? widget.empty ?? Container()
          : null,
      firstRefresh: true,
      firstRefreshWidget: Container(
        color: Colors.white,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      controller: refreshController,
      header: MaterialHeader(),
      footer: MaterialFooter(),
      onRefresh: () async {
        LogUtil.logDebug(text: '执行refresh');
        param.setPage(0);
        await sendRequest().then((value) {
          if(widget.notify != null) widget.notify(value);
          setState(() {
            searchItemList = value?.valueList()?.map((T item) {
              if (selectedIds.keys.contains(item.getSearchId())) {
                item.setSearchSelected(true);
              }
              return item;
            })?.toList() ??
                [];
          });
          refreshController.finishRefresh(success: true);
        }).catchError((onError) {
          print(onError);
          refreshController.finishRefresh(success: false);
          setState(() {
            this.searchItemList = null;
          });
        });
      },
      onLoad: widget.canLoadMore
          ? () async {
        LogUtil.logDebug(text: '执行load');
        param.setPage(param.valuePage() + 1);
        await sendRequest().then((value) {
          setState(() {
            searchItemList.addAll(value?.valueList()?.map((T item) {
              if (selectedIds.keys.contains(item.getSearchId())) {
                item.setSearchSelected(true);
              }
              return item;
            })?.toList() ??
                []);
          });
          refreshController.finishLoad(
            success: true,
            noMore: searchItemList.length >= value.valueTotal(),
          );
        }).catchError((onError) {
          refreshController.finishLoad(success: false);
          setState(() {
            this.searchItemList = null;
          });
        });
      }
          : null,
      slivers: _slivers(),
    );
  }

  List<Widget> _slivers() {
    List<Widget> slivers = [];
    if ((searchItemList !=null && searchItemList.length != 0) || selectedIds.length != 0) {
      slivers.add(SliverGrid.extent(
        maxCrossAxisExtent: 120.w,
        childAspectRatio: 2,
        children: _selectedItems(),
      ));
    }
    slivers.add(
      SliverList(
        delegate: SliverChildBuilderDelegate(
              (context, index) {
            return Container(
              child: searchItemList == null || searchItemList.length == 0
                  ? Container()
                  : widget.itemWidget(searchItemList[index], selectedIds,widget.max),
            );
          },
          childCount: searchItemList != null ? searchItemList.length : 0,
        ),
      ),
    );
    return slivers;
  }

  List<Widget> _selectedItems() {
    return selectedIds.keys.toList().map(
          (id) {
        return Container(
          margin: EdgeInsets.symmetric(
            horizontal: 5.w,
          ),
          alignment: Alignment.center,
          child: OutlineButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            borderSide: BorderSide(color: widget.theme, width: 1),
            onPressed: () {
              setState(
                    () {
                  selectedIds.remove(id);
                  searchItemList.forEach(
                        (ISearchItem element) {
                      if (element.getSearchId() == id) {
                        element.setSearchSelected(false);
                      }
                    },
                  );
                },
              );
            },
            child: Text(
              selectedIds[id],
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: widget.theme,
                fontSize: 10.sp,
              ),
            ),
          ),
        );
      },
    ).toList();
  }
}
