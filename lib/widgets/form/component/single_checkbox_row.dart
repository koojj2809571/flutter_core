part of flutter_core;

Widget getSingleCheckBoxRow<T>(
  String label,
  bool canEmpty,
  T groupValue,
  List<String> selectionTitle,
  List<T> selectionValue, {
  bool withDivider,
  Function onChange,
  paddingTop: 10.0,
  paddingBottom: 10.0,
  Color theme,
}) {
  return Column(
    children: <Widget>[
      Container(
        padding: EdgeInsets.only(top: paddingTop, bottom: paddingBottom),
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
                              Text(selectionTitle[e]),
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
