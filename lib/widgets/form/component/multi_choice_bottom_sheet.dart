part of flutter_core;

typedef void CancelSelectedItem(int id);

Future<T> showMultiChoiceBottomSheet<T>(
    BuildContext context,
    List<String> names, {
      List<Object> values,
      bool isShortTag: true,
      List<String> selectedData,
      List<int> selectedExtra,
      CancelSelectedItem cancelSelectedItem,
      void onSelected(List names, List values),
    }) async {
  List<TagItem> tags = [];
  selectedData = selectedData ?? [];
  selectedExtra = selectedExtra ?? [];

  for (int i = 0; i < names.length; i++) {
    bool isCreated = selectedData != null && selectedData.contains(names[i]);
    tags.add(TagItem(
      name: names[i],
      isCreated: isCreated,
      isSelected: isCreated,
      id: selectedExtra.isNotEmpty ? selectedExtra[i] : -1,
      value: (values ?? [])[i],
    ));
  }
  return await showModalBottomSheet<T>(
    context: context, //state.context,
    builder: (BuildContext context) {
      return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 50.h,
              child: Flex(
                direction: Axis.horizontal,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: InkWell(
                      child: Container(
                        padding: EdgeInsets.only(left: 20),
                        child: Text(
                          '取消',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 18.sp,
                            color: Colors.lightBlue,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context, null);
                      },
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: InkWell(
                      child: Container(
                        padding: EdgeInsets.only(right: 20),
                        child: Text(
                          '确认',
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            fontSize: 18.sp,
                            color: Colors.lightBlue,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      onTap: () {
                        List<String> results = [];
                        List<Object> values = [];
                        for (TagItem tag in tags) {
                          if (tag.isSelected) {
                            results.add(tag.name);
                            values.add(tag.value);
                          }
                        }
                        onSelected(results,values);
                        Navigator.pop(context, results);
                      },
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              height: 1.h,
              color: Colors.black12,
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 20.w,
                  vertical: 30.h,
                ),
                child: Tag(tags, cancelSelectedItem, isShortTag),
              ),
            ),
          ],
        ),
      );
    },
  );
}

class TagItem {
  String name;
  bool isSelected;
  bool isCreated;
  int id;
  var value;

  TagItem({
    this.name,
    this.isSelected,
    this.isCreated,
    this.id,
    this.value,
  });
}

class Tag extends StatefulWidget {
  final List<TagItem> data;
  final CancelSelectedItem cancelSelectedItem;
  final bool isShortTag;

  Tag(this.data, this.cancelSelectedItem,this.isShortTag);

  @override
  _TagState createState() => _TagState();
}

class _TagState extends State<Tag> {
  List<TagItem> data;

  @override
  void initState() {
    super.initState();
    data = widget.data;
  }

  List<Widget> getTag(int size, List<TagItem> data) {
    List<Widget> list = [];
    for (TagItem item in data) {
      list.add(InkWell(
        onTap: () {
          if (item.isSelected &&
              item.isCreated &&
              widget.cancelSelectedItem != null) {
            widget.cancelSelectedItem(item.id);
          }
          setState(() {
            item.isSelected = !item.isSelected;
          });
        },
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.all(5.w),
          padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
          decoration: BoxDecoration(
            color: item.isSelected ? Colors.lightBlueAccent : Colors.black12,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            item.name,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      child: ListView(
        children: getTag(data.length, data),
      ),
    );
  }
}