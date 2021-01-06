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

Widget getEditRowEx(
    String label,
    bool canEmpty, {
      Function onChangeMin,
      Function onChangeMax,
      TextEditingController ctrMin,
      TextEditingController ctrMax,
      TextInputType type,
      String hint,
      canRemove: false,
      Function onRemoveRow,
      withDivider: false,
      String currentMinText,
      String currentMaxText,
      String unit,
      double textSize: 14,
      double paddingVertical: 10,
      double paddingHorizontal: 0,
      FocusNode focusNode,
      Function onSubmitMin,
      Function onSubmitMax,
      TextInputAction action,
      bool canInput: true,
    }) {
  if (ctrMin == null) {
    ctrMin = TextEditingController();
  }
  if (currentMinText != null) {
    ctrMin.text = currentMinText;
  }
  if (ctrMax == null) {
    ctrMax = TextEditingController();
  }
  if (currentMaxText != null) {
    ctrMax.text = currentMaxText;
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
                onSubmitted: onSubmitMin,
                focusNode: focusNode,
                onChanged: onChangeMin,
                textAlign: TextAlign.end,
                controller: ctrMin,
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
            Text("  -- "),
            Expanded(
              flex: 1,
              child: TextField(
                onSubmitted: onSubmitMax,
                focusNode: focusNode,
                onChanged: onChangeMax,
                textAlign: TextAlign.end,
                controller: ctrMax,
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

///备注通用Content
///onChange:备注改变触发的调用
Widget remarkContent(void onChange(String remark),{String hintText}) {
  return Column(
    children: [
      Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 30.w, top: 10.w),
        decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1, color: Color.fromARGB(255, 246, 246, 246)),
            )),
        child: Text(
          '备注',
          style: TextStyle(
            fontSize: 15.sp,
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      Container(
        padding: EdgeInsets.only(left: 30.w, top: 10.w),
        child: TextField(
          maxLength: 200,
          keyboardType: TextInputType.multiline,
          maxLines: 3,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hintText??'',
          ),
          onChanged: (value) {
            onChange(value);
          },
        ),
      ),
    ],
  );
}

