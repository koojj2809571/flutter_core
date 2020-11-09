part of flutter_core;

Widget imagePickerRow({
  String title,
  String val,
  Function onClick,
  List<Widget> images,
  Color border
}) {
  return Container(
    padding: EdgeInsets.symmetric(
      vertical: 10.h
    ),
    decoration: BoxDecoration(
      border: Border(
        bottom: BorderSide(width: 1.w, color: border),
      ),
    ),
    child: Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(bottom: 10.w),
          child: GestureDetector(
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 0,
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
                    child: Icon(Icons.add_a_photo),
                  ),
                ),
              ],
            ),
            onTap: onClick,
          ),
        ),
        Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Wrap(
                alignment: WrapAlignment.spaceAround,
                direction: Axis.horizontal,
                children: images,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}