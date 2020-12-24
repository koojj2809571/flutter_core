part of flutter_core;

const SINGLE_COLUMN_SELECT_TYPE = 'SINGLE_SELECT_TYPE';
const MULTI_COLUMN_SELECT_TYPE = 'MULTI_COLUMN_SELECT_TYPE';
const ARRAY_COLUMN_SELECT_TYPE = 'ARRAY_COLUMN_SELECT_TYPE';
const MULTI_CHOICE_TYPE = 'MULTI_CHOICE_TYPE';
const DATE_TIME_TYPE = 'DATE_TIME_TYPE';
const GO_NEW_PAGE = 'go_new_page';

enum SelectType {

  SINGLE_COLUMN_SELECT_TYPE,

  MULTI_COLUMN_SELECT_TYPE,

  ARRAY_COLUMN_SELECT_TYPE,

  MULTI_CHOICE_TYPE,

  DATE_TIME_TYPE,

  GO_NEW_PAGE,

}

Widget getSelectRow({
  String label,
  bool canEmpty = true,
  bool withDivider = false,
  String selectedItem,
  SelectType selectType,
  Function onSelect,
  BuildContext context,
  List data,
  String datas,
  GlobalKey<ScaffoldState> key,
  double height,
  double fontSize,
  Color textColor,
  Color hintColor = Colors.white12,
}) {
  return Column(
    children: <Widget>[
      Container(
        // padding: EdgeInsets.only(top: 20, bottom: 20),
        height: height,
        alignment: Alignment.center,
        child:
        Row(
          children: <Widget>[
            getLabel(label, canEmpty,textColor: textColor,fontSize: fontSize ??14.w),
            SizedBox(width: 20,),
            Expanded(
              child: InkWell(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Expanded(child:Text(
                      selectedItem ?? '请选择',
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        fontSize: fontSize ??14.w,
                        // fontWeight: FontWeight.bold,
                        color: selectedItem != null ? textColor : hintColor,
                      ),
                    ),
                    ),
                    Icon(
                      Icons.navigate_next,
                      color:textColor,
                    ),
                  ],
                ),
                onTap: () {
                  switch (selectType) {
                    case SelectType.SINGLE_COLUMN_SELECT_TYPE:
                      showPickerModal(context, data, onSelect);
                      break;
                    case SelectType.MULTI_COLUMN_SELECT_TYPE:
                      showPickerModalRange(context, data, onSelect);
                      break;
                    case SelectType.MULTI_CHOICE_TYPE:
                      showMultiChoiceBottomSheet(context, data).then((value) {
                        if (value != null) {
                          onSelect(value);
                        }
                      });
                      break;
                    case SelectType.ARRAY_COLUMN_SELECT_TYPE:
                      showPickerArray(context, datas, onSelect);
                      break;
                    case SelectType.GO_NEW_PAGE:
                      onSelect();
                      break;
                    case SelectType.DATE_TIME_TYPE:
                      showPickerDateTime(context, onSelect);
                      break;
                  }
                },
              ),
            ),
          ],
        ),
      ),
      withDivider
          ? Divider(
        height: 1,
        color: Colors.black12,
      )
          : Container(),
    ],
  );
}