part of flutter_core;

typedef Widget SearchItem(
    SearchChoiceItem item, Map<int, SearchChoiceItem> selectedItem);

class SearchListMultiChoice<T extends ISearchItem> extends StatefulWidget {
  final List<int> selectedIds;
  final BasePageRequest param;
  final SendRequest<BasePageResponse<T>> sendRequest;
  final SearchItem itemWidget;
  final Function okClick;
  final EasyRefreshController controller;
  final String searchHint;
  final bool canLoadMore;
  final NotifyAfterRefresh notify;
  final Color theme;
  final Color okColor;

  SearchListMultiChoice({
    this.selectedIds,
    this.param,
    this.sendRequest,
    this.itemWidget,
    this.okClick,
    this.controller,
    this.searchHint: '相关数据',
    this.canLoadMore: false,
    this.notify,
    this.theme,
    this.okColor,
  });

  @override
  _SearchListMultiChoiceState createState() => _SearchListMultiChoiceState<T>();
}

class _SearchListMultiChoiceState<T extends ISearchItem>
    extends State<SearchListMultiChoice> {
  List<SearchChoiceItem> searchItemList;
  TextEditingController searchCtr;
  BasePageRequest param;
  SendRequest<BasePageResponse<T>> sendRequest;
  Map<int, SearchChoiceItem> selectedItem = {};
  EasyRefreshController refreshController;

  @override
  void initState() {
    super.initState();
    refreshController = EasyRefreshController();
    sendRequest = widget.sendRequest;
    searchCtr = TextEditingController();
    param = widget.param;
    searchItemList = [];
    widget.selectedIds.forEach((element) {
      selectedItem[element] = SearchChoiceItem();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _selectContent(),
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
        onPressed: () {
          ExtendedNavigator.root.pop({'result': false});
        },
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
      backgroundColor: widget.okColor,
      onPressed: () {
        List<int> idResults = [];
        List<String> nameResults = [];
        selectedItem.values.forEach((element) {
          idResults.add(element.id);
          nameResults.add(element.name);
        });
        ExtendedNavigator.root
            .pop({'result': true, 'ids': idResults, 'names': nameResults});
      },
    );
  }

  Widget _refreshContentList() {
    return EasyRefresh.custom(
      emptyWidget: searchItemList == null || searchItemList.length == 0
          ? Container()
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
            searchItemList = value
                .valueList()
                .map((e) => SearchChoiceItem.fromSearchItem(e))
                .toList();
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
      onLoad: widget.canLoadMore ? () async {
        LogUtil.logDebug(text: '执行load');
        param.setPage(param.valuePage() + 1);
        await sendRequest().then((value) {
          setState(() {
            searchItemList.addAll(value
                ?.valueList()
                ?.map((e) => SearchChoiceItem.fromSearchItem(e))
                ?.toList());
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
      } : null,
      slivers: _slivers(),
    );
  }

  List<Widget> _slivers(){
    List<Widget> slivers = [];
    if(searchItemList.length != 0 || selectedItem.length != 0){
      slivers.add(SliverGrid.extent(
        maxCrossAxisExtent: 120.w,
        childAspectRatio: 2,
        children: _selectedItems(),
      ));
    }
    slivers.add(SliverList(
      delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
          return Container(
            child: searchItemList == null
                ? Container()
                : widget.itemWidget(searchItemList[index], selectedItem),
          );
        },
        childCount: searchItemList != null ? searchItemList.length : 0,
      ),
    ));
    return slivers;
  }

  List<Widget> _selectedItems() {
    return selectedItem.values.toList().map(
      (e) {
        return Container(
          margin: EdgeInsets.symmetric(
            horizontal: 5.w,
          ),
          alignment: Alignment.center,
          child: OutlineButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            borderSide: BorderSide(color: widget.theme, width: 1.w),
            onPressed: () {
              setState(() {
                selectedItem.remove(e.id);
                searchItemList.forEach((element) {
                  if (element.id == e.id) {
                    element.isSelected = false;
                  }},
                );
              });
            },
            child: Text(
              e.name,
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
