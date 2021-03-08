part of flutter_core;

Widget getSingleCheckBoxRow<T>(
  String label,
  bool canEmpty,
  T groupValue,
  List<String> selectionTitle,
  List<T> selectionValue, {
  bool withDivider,
  Function onChange,
  paddingTop,
  paddingBottom,
  Color theme,
  double textSize,
  Color textColor,
}) {
  return Column(
    children: <Widget>[
      Container(
        padding: EdgeInsets.only(
            top: paddingTop ?? 6.h, bottom: paddingBottom ?? 6.h),
        child: Flex(
          direction: Axis.horizontal,
          children: <Widget>[
            Expanded(
              flex: 0,
              child: getLabel(label, canEmpty, fontSize: textSize ?? 14.sp),
            ),
            Expanded(
              flex: 1,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: selectionTitle
                      .asMap()
                      .keys
                      .map((e) => Row(
                            children: <Widget>[
                              Radio(
                                activeColor: theme,
                                value: selectionValue[e],
                                groupValue: groupValue,
                                onChanged: onChange,
                              ),
                              Text(
                                selectionTitle[e],
                                style: TextStyle(
                                  fontSize: textSize ?? 14.sp,
                                  color: textColor ?? Color.fromRGBO(171, 171, 171, 1)
                                ),
                              ),
                            ],
                          ))
                      .toList()),
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
