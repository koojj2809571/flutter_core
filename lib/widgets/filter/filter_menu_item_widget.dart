part of flutter_core;

Widget conditionList<T>(
  List<Condition<T>> items,
  void itemOnTap(Condition<T> condition),
) {
  return ListView.separated(
    // shrinkWrap: true,
    scrollDirection: Axis.vertical,
    itemCount: items.length,
    separatorBuilder: (context, index) => Divider(height: 1.0),
    itemBuilder: (BuildContext context, int index) {
      Condition condition = items[index];
      return GestureDetector(
        onTap: () {
          for (Condition value in items) {
            value.isSelected = false;
          }
          condition.isSelected = true;
          itemOnTap(condition);
        },
        child: Container(
          height: 40,
          child: Row(
            children: <Widget>[
              SizedBox(
                width: 16,
              ),
              Expanded(
                child: Text(
                  condition.name,
                  style: TextStyle(
                    color: condition.isSelected
                        ? Theme.of(context).primaryColor
                        : Colors.black,
                  ),
                ),
              ),
              condition.isSelected
                  ? Icon(
                      Icons.check,
                      color: Theme.of(context).primaryColor,
                      size: 16,
                    )
                  : SizedBox(),
              SizedBox(
                width: 16,
              ),
            ],
          ),
        ),
      );
    },
  );
}

Widget conditionGrid<T>(
  List<Condition<T>> items,
  void itemOnTap(Condition<T> condition),
  void customPriceOk(List<int> price), {
  customRow: false,
  lineCount: 3,
  ratio: 2.0,
  Color theme,
}) {
  TextEditingController minCtr = TextEditingController();
  TextEditingController maxCtr = TextEditingController();
  return Column(
    children: <Widget>[
      Expanded(
        flex: 5,
        child: GridView.builder(
          // shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: lineCount,
            childAspectRatio: ratio,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            Condition item = items[index];
            return InkWell(
              child: Container(
                margin: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: item.isSelected
                      ? theme.withAlpha(50)
                      : Colors.black.withAlpha(20),
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                ),
                alignment: Alignment.center,
                child: Text(
                  items[index].name,
                  style: TextStyle(
                      color:
                          item.isSelected ? theme : Colors.black),
                  textAlign: TextAlign.center,
                ),
              ),
              onTap: () {
                for (Condition value in items) {
                  value.isSelected = false;
                }
                item.isSelected = true;
                itemOnTap(item);
              },
            );
          },
        ),
      ),
      Expanded(
        flex: customRow ? 2 : 0,
        child: Container(
          color: Colors.black12,
          padding: EdgeInsets.symmetric(
            horizontal: (10.w),
            vertical: (5.w),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text('自定义  '),
              Expanded(
                child: Container(
                  child: TextField(
                    controller: minCtr,
                    maxLines: 1,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.all(8.w),
                        isDense: true,
                        hintText: '最小',
                        hintStyle: TextStyle(fontSize: 12.sp),
                        border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 10))),
                  ),
                ),
              ),
              Text('  至  '),
              Expanded(
                child: Container(
                  child: TextField(
                    controller: maxCtr,
                    maxLines: 1,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.all(8.2),
                        isDense: true,
                        hintText: '最大',
                        hintStyle: TextStyle(fontSize: 12.sp),
                        border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 10))),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 10.w),
                child: FlatButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4))),
                  color: theme,
                  child: Text(
                    '确定',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    String min = minCtr.text == null || minCtr.text.isEmpty
                        ? '-1'
                        : minCtr.text;
                    String max = maxCtr.text == null || maxCtr.text.isEmpty
                        ? '-1'
                        : maxCtr.text;
                    List<int> result = [int.parse(min), int.parse(max)];
                    items.forEach((element) {
                      element.isSelected = false;
                    });
                    customPriceOk(result);
                  },
                ),
              ),
            ],
          ),
        ),
      )
    ],
  );
}

Widget conditionListNestWrap<T>(
  List<Condition<T>> items,
  void sureOnTap(),
  void resetOnTap(),
  Color theme,
) {
  return Column(
    children: <Widget>[
      Expanded(
        flex: 6,
        child: Container(
          child: ListView.builder(
              itemCount: items.length,
              scrollDirection: Axis.vertical,
              itemBuilder: (BuildContext context, int index) {
                Condition condition = items[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.only(
                            left: 25.w,
                            top: 15.h,
                            bottom: 5.h),
                        child: Text(
                          condition.name,
                          style: TextStyle(
                              color: Colors.black, fontSize: 15.sp),
                        )),
                    ButtonWrap(condition.cValue, condition.isSelected, theme),
                  ],
                );
              }),
        ),
      ),
      Expanded(
        flex: 1,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FlatButton(
              child: Text(
                '重置',
                style: TextStyle(fontSize: 15.sp),
              ),
              onPressed: () {
                for (Condition item in items) {
                  for (Condition value in item.cValue) {
                    value.isSelected = false;
                  }
                  item.cValue[0].isSelected = true;
                }
                resetOnTap();
              },
            ),
            FlatButton(
              child: Text(
                '确定',
                style: TextStyle(fontSize: 15.sp),
              ),
              onPressed: () {
                sureOnTap();
              },
            ),
          ],
        ),
      ),
    ],
  );
}

class ButtonWrap extends StatefulWidget {
  final List<Condition> listCondition;
  final bool isMultiSelected;
  final Color theme;

  ButtonWrap(this.listCondition, this.isMultiSelected, this.theme);

  @override
  _ButtonWrapState createState() => _ButtonWrapState();
}

class _ButtonWrapState extends State<ButtonWrap> {
  List<Condition> _listCondition;
  Color theme;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _listCondition = widget.listCondition;
    theme = widget.theme;
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 2.0,
      ),
      itemCount: _listCondition.length,
      itemBuilder: (context, index) {
        Condition item = _listCondition[index];
        return InkWell(
          child: Container(
            margin: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: item.isSelected
                  ? theme.withAlpha(50)
                  : Colors.black.withAlpha(20),
              borderRadius: BorderRadius.all(Radius.circular(4)),
            ),
            alignment: Alignment.center,
            child: Text(
              _listCondition[index].name,
              style: TextStyle(
                  color: item.isSelected ? theme : Colors.black),
              textAlign: TextAlign.center,
            ),
          ),
          onTap: () {
            setState(() {
              if (!widget.isMultiSelected) {
                for (Condition value in _listCondition) {
                  value.isSelected = false;
                }
              }
              item.isSelected = !item.isSelected;
            });
          },
        );
      },
    );
  }
}
