part of flutter_core;

Widget getButtonBarRow({
  bool isBasic,
  Function switchPage,
  Function submit,
  Color theme,
  Color okTheme,
}) {
  return Container(
    decoration: BoxDecoration(color: Colors.white),
    child: Flex(
      direction: Axis.horizontal,
      children: <Widget>[
        isBasic
            ? Expanded(
                flex: 1,
                child: jyFlatButton(
                  height: 40.h,
                  click: () => switchPage(),
                  color: theme,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(0)),
                  ),
                  child:
                      Text('提交客源基本信息', style: TextStyle(color: Colors.white)),
                ),
              )
            : Container(),
        isBasic
            ? Container()
            : Expanded(
                flex: 1,
                child: jyFlatButton(
                  height: 40.w,
                  click: () => switchPage(),
                  color: theme,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(0)),
                  ),
                  child: Text(
                    '上一步',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
        isBasic
            ? Container()
            : Expanded(
                flex: 1,
                child: jyFlatButton(
                  height: 40.w,
                  click: submit,
                  color: okTheme,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(0))),
                  child: Text('完成', style: TextStyle(color: Colors.white)),
                ),
              ),
      ],
    ),
  );
}
