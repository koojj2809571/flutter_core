part of flutter_core;

Widget getRateRow({
  String label,
  int maxStar,
  bool canEmpty,
  bool withDivider,
  Function onRate,
  double currentRating,
  Color theme,
}) {
  return Column(
    children: <Widget>[
      Container(
        padding: EdgeInsets.only(top: 20, bottom: 20),
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
                children: <Widget>[
                  SmoothStarRating(
                    allowHalfRating: false,
                    starCount: maxStar,
                    onRated: onRate,
                    rating: currentRating,
                    isReadOnly: false,
                    color: theme,
                    borderColor: Colors.black12,
                    size: 18.h,
                  )
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
