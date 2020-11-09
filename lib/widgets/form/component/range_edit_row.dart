part of flutter_core;

Widget getRangeEditRow({
  String label,
  bool canEmpty,
  Function onBeginChange,
  Function onEndChange,
  TextInputType type,
  String hint,
  String unitText,
  canRemove: false,
  withDivider: false,
  var beginValue,
  var endValue,
}) {
  TextEditingController beginCtr = TextEditingController.fromValue(
    TextEditingValue(
      text: beginValue?.toString() ?? '',
      selection: TextSelection.fromPosition(
        TextPosition(
          affinity: TextAffinity.downstream,
          offset: beginValue.toString()?.length ?? 0,
        ),
      ),
    ),
  );
  TextEditingController endCtr = TextEditingController.fromValue(
    TextEditingValue(
      text: endValue?.toString() ?? '',
      selection: TextSelection.fromPosition(
        TextPosition(
          affinity: TextAffinity.downstream,
          offset: endValue.toString()?.length ?? 0,
        ),
      ),
    ),
  );
  return Column(
    children: <Widget>[
      Container(
        padding: EdgeInsets.only(top: 10, bottom: 10),
        child: Flex(
          direction: Axis.horizontal,
          children: <Widget>[
            Expanded(
              flex: 0,
              child: getLabel(label, canEmpty),
            ),
            Expanded(
              flex: 1,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    width: 60.w,
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: TextField(
                      onChanged: (value) {
                        if (value.isEmpty) {
                          onBeginChange(null);
                        }
                        onBeginChange(int.parse(value));
                      },
                      controller: beginCtr,
                      textAlign: TextAlign.end,
                      autofocus: false,
                      keyboardType: type,
                      style: TextStyle(fontSize: 12.sp),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(0),
                        hintText: '最小值',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Text('   -   '),
                  Container(
                    width: 60.w,
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: TextField(
                      onChanged: (value) {
                        if (value.isEmpty) {
                          onEndChange(null);
                        }
                        onEndChange(int.parse(value));
                      },
                      controller: endCtr,
                      textAlign: TextAlign.end,
                      autofocus: false,
                      keyboardType: type,
                      style: TextStyle(fontSize: 12.sp),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(0),
                        hintText: '最大值',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Text(unitText),
                ],
              ),
            ),
          ],
        ),
      ),
      withDivider
          ? Divider(
        height: 1.h,
        color: Colors.black12,
      )
          : Container(),
    ],
  );
}