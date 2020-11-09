part of flutter_core;

typedef Future<T> SendRequest<T>();
typedef void NotifyAfterRefresh<T>(BasePageResponse<T> response);

class RefreshList<R> extends StatefulWidget {
  final BasePageRequest param;
  final SendRequest<BasePageResponse<R>> sendRequest;
  final Function itemWidget;
  final Function itemClick;
  final EasyRefreshController controller;
  final NotifyAfterRefresh notify;
  final Widget empty;
  final Widget error;

  RefreshList({
    this.param,
    this.sendRequest,
    this.itemWidget,
    this.itemClick,
    this.controller,
    this.notify,
    this.empty,
    this.error,
  });

  @override
  _RefreshListState createState() => _RefreshListState<R>();
}

class _RefreshListState<R> extends State<RefreshList> {
  EasyRefreshController _refreshController;
  BasePageRequest param;
  SendRequest<BasePageResponse<R>> sendRequest;
  Function itemWidget;

  BasePageResponse<R> data;

  @override
  void initState() {
    super.initState();
    _refreshController = widget.controller ?? EasyRefreshController();
    param = widget.param;
    sendRequest = widget.sendRequest;
    itemWidget = widget.itemWidget;
  }

  @override
  Widget build(BuildContext context) {
    return _refreshLoadList();
  }

  Widget _refreshLoadList() {
    return EasyRefresh.custom(
      emptyWidget: data == null ||
              data.valueList() == null ||
              data.valueList().length == 0
          ? widget.empty
          : null,
      firstRefresh: true,
      firstRefreshWidget: Container(
        color: Colors.white,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      controller: _refreshController,
      header: MaterialHeader(),
      footer: MaterialFooter(),
      onRefresh: () async {
        param.setPage(0);
        await sendRequest().then((value) {
          if(widget.notify != null) widget.notify(value);
          setState(() {
            this.data = value;
          });
          _refreshController.finishRefresh(
            success: true,
          );
        }).catchError((onError) {
          print(onError);
          _refreshController.finishRefresh(success: false);
          setState(() {
            this.data = null;
          });
        });
      },
      onLoad: () async {
        param.setPage(param.valuePage() + 1);
        await sendRequest().then((value) {
          setState(() {
            this.data.valueList().addAll(value.valueList());
          });
          _refreshController.finishLoad(
            success: true,
            noMore:data.valueList().length >= data.valueTotal(),
          );
        }).catchError((onError) {
          _refreshController.finishLoad(success: false);
          setState(() {
            this.data = null;
          });
        });
      },
      slivers: <Widget>[
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return GestureDetector(
                child: Container(
                  child: data.valueList() == null
                      ? widget.empty
                      : itemWidget(data.valueList()[index]),
                ),
                onTap: () {
                  if (widget.itemClick != null) {
                    widget.itemClick(data.valueList()[index]);
                  }
                },
              );
            },
            childCount: data != null && data.valueList() != null
                ? data.valueList().length
                : 0,
          ),
        ),
      ],
    );
  }
}
