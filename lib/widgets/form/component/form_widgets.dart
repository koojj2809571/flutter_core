part of flutter_core;

Widget getLabel(
  String label,
  bool canEmpty,
 {double fontSize = 14,
 Color textColor = Colors.black}
) {
  return Text.rich(
    TextSpan(
      style: TextStyle(fontSize: fontSize, color: textColor),
      children: [
        TextSpan(text: canEmpty ? '' : '*', style: TextStyle(color: Colors.red)),
        TextSpan(text: label),

      ],
    ),
  );
}

void showPickerDateTime(BuildContext context, Function onConfirm) {
  DatePicker.showDatePicker(
    context,
    showTitleActions: true,
    minTime: DateTime.now(),
    onConfirm: onConfirm,
    locale: LocaleType.zh,
  );
}

void showPickerModal(BuildContext context, List data, Function onConfirm) {
  Picker(
    adapter: PickerDataAdapter(pickerdata: data),
    changeToFirst: true,
    cancelText: '取消',
    confirmText: '确定 ',
    hideHeader: false,
    onConfirm: onConfirm,
  ).showModal(context);
}

void showPickerModalRange(BuildContext context, List data, Function onConfirm) {
  Picker(
    adapter: PickerDataAdapter<String>(pickerdata: data),
    changeToFirst: true,
    hideHeader: false,
    cancelText: '取消',
    confirmText: '确定 ',
    onConfirm: onConfirm,
  ).showModal(context); //_scaffoldKey.currentState);
}

void showPickerArray(BuildContext context, String data, Function onConfirm) {
  Picker(
    adapter: PickerDataAdapter<String>(
        pickerdata: new JsonDecoder().convert(data), isArray: true),
    changeToFirst: true,
    hideHeader: false,
    cancelText: '取消',
    confirmText: '确定 ',
    onConfirm: onConfirm,
  ).showModal(context); //_scaffoldKey.currentState);
}

Widget infoRow(String title, String value,
    [String hitValue1,
    Function onClick1,
    String hitValue2,
    Function onClick2,
    String hitValue3,
    Function onClick3]) {
  return Container(
    margin: EdgeInsets.only(left: 15.w),
    alignment: Alignment.centerLeft,
    padding: EdgeInsets.only(bottom: 10.h),
    child: Text.rich(
      TextSpan(children: [
        TextSpan(
          text: '$title :  ',
          style: TextStyle(
            color: Colors.black12,
            fontSize: 10.sp,
          ),
        ),
        TextSpan(
          text: value,
          style: TextStyle(
            color: Colors.black,
            fontSize: 10.sp,
          ),
        ),
        TextSpan(
          text: hitValue1,
          style: TextStyle(
            color: Color.fromARGB(
              255,
              244,
              162,
              58,
            ),
            fontSize: 13.sp,
          ),
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              if (onClick1 != null) {
                onClick1();
              }
            },
        ),
        TextSpan(
          text: hitValue2,
          style: TextStyle(
            color: Color.fromARGB(
              255,
              244,
              162,
              58,
            ),
            fontSize: 13.sp,
          ),
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              if (onClick2 != null) {
                onClick2();
              }
            },
        ),
        TextSpan(
          text: hitValue3,
          style: TextStyle(
            color: Color.fromARGB(
              255,
              244,
              162,
              58,
            ),
            fontSize: 13.sp,
          ),
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              if (onClick3 != null) {
                onClick3();
              }
            },
        ),
      ]),
    ),
  );
}

Widget selectListRow({
  String title,
  String val,
  Function onClick,
  Color border,
}) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 10.h),
    decoration: BoxDecoration(
      border: Border(
        bottom: BorderSide(
          width: 1,
          color: border,
        ),
      ),
    ),
    child: GestureDetector(
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 3,
            child: Container(
              alignment: Alignment.centerLeft,
              child: Text('$title'),
            ),
          ),
          Expanded(
            flex: 6,
            child: Container(
              alignment: Alignment.centerRight,
              child: Text(
                '$val',
                style: TextStyle(
                    color: val == '请选择' ? Colors.black12 : Colors.black),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.center,
              child: Icon(Icons.keyboard_arrow_right),
            ),
          ),
        ],
      ),
      onTap: onClick,
    ),
  );
}
