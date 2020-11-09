part of flutter_core;

const SINGLE_COLUMN_SELECT_TYPE = 'SINGLE_SELECT_TYPE';
const MULTI_COLUMN_SELECT_TYPE = 'MULTI_COLUMN_SELECT_TYPE';
const ARRAY_COLUMN_SELECT_TYPE = 'ARRAY_COLUMN_SELECT_TYPE';
const MULTI_CHOICE_TYPE = 'MULTI_CHOICE_TYPE';
const DATE_TIME_TYPE = 'DATE_TIME_TYPE';
const GO_NEW_PAGE = 'go_new_page';

Widget getSelectRow({
  String label,
  bool canEmpty,
  bool withDivider,
  String selectedItem,
  String selectType,
  Function onSelect,
  BuildContext context,
  List data,
  String datas,
  GlobalKey<ScaffoldState> key,
}) {
  return Column(
    children: <Widget>[
      Container(
        padding: EdgeInsets.symmetric(vertical: 20.h),
        child: Flex(
          direction: Axis.horizontal,
          children: <Widget>[
            Expanded(
              flex: 0,
              child: getLabel(label, canEmpty),
            ),
            Expanded(
              flex: 1,
              child: InkWell(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.centerRight,
                      width: MediaQuery.of(context).size.width / 3,
                      child: Text(
                        selectedItem ?? '请选择',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: selectedItem == '请选择'
                              ? Colors.black12
                              : Colors.black,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.navigate_next,
                      color: Colors.black12,
                    ),
                  ],
                ),
                onTap: () {
                  switch (selectType) {
                    case SINGLE_COLUMN_SELECT_TYPE:
                      showPickerModal(context, data, onSelect);
                      break;
                    case MULTI_COLUMN_SELECT_TYPE:
                      showPickerModalRange(context, data, onSelect);
                      break;
                    case MULTI_CHOICE_TYPE:
                      showMultiChoiceBottomSheet(context, data).then((value) {
                        if (value != null) {
                          onSelect(value);
                        }
                      });
                      break;
                    case ARRAY_COLUMN_SELECT_TYPE:
                      showPickerArray(context, datas, onSelect);
                      break;
                    case GO_NEW_PAGE:
                      onSelect();
                      break;
                    case DATE_TIME_TYPE:
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
        height: 1.h,
        color: Colors.black12,
      )
          : Container(),
    ],
  );
}