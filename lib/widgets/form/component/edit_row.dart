part of flutter_core;

Widget getEditRow(
    String label,
    bool canEmpty, {
      Function onChange,
      TextEditingController ctr,
      TextInputType type,
      String hint,
      canRemove: false,
      Function onRemoveRow,
      withDivider: false,
      String currentText,
      String unit,
      double textSize: 14,
      double paddingVertical: 10,
      double paddingHorizontal: 0,
      FocusNode focusNode,
      Function onSubmit,
      TextInputAction action,
      bool canInput: true,
    }) {
  if (ctr == null) {
    ctr = TextEditingController();
  }
  if (currentText != null) {
    ctr.text = currentText;
  }
  return Column(
    children: <Widget>[
      Container(
        padding: EdgeInsets.symmetric(
          horizontal: paddingHorizontal.w,
          vertical: paddingVertical.h,
        ),
        child: Flex(
          direction: Axis.horizontal,
          children: <Widget>[
            canRemove
                ? Expanded(
                flex: 0,
                child: IconButton(
                  icon: Icon(
                    Icons.remove_circle,
                    color: Colors.red,
                  ),
                  onPressed: onRemoveRow,
                ))
                : Container(),
            Expanded(
              flex: 0,
              child: getLabel(label, canEmpty),
            ),
            Expanded(
              flex: 1,
              child: TextField(
                onSubmitted: onSubmit,
                focusNode: focusNode,
                onChanged: onChange,
                textAlign: TextAlign.end,
                controller: ctr,
                autofocus: false,
                enabled: canInput,
                keyboardType: type,
                textInputAction: action,
                style: TextStyle(fontSize: textSize.sp),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(0),
                  hintText: hint,
                  border: InputBorder.none,
                ),
              ),
            ),
            unit != null && unit.isNotEmpty
                ? Expanded(
              flex: 0,
              child: Text(
                unit,
                style: TextStyle(
                  fontSize: textSize.sp,
                  color: Colors.black,
                ),
              ),
            )
                : Container(),
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