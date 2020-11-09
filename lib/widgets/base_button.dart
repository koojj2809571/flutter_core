part of flutter_core;

Widget jyFlatButton({
  @required VoidCallback click,
  double width,
  double height,
  Widget child,
  Color color,
  ShapeBorder shape,
  EdgeInsetsGeometry padding,
}) {
  return Container(
    padding: padding,
    width: width,
    height: height,
    child: FlatButton(
      onPressed: click,
      child: child,
      color: color,
      shape: shape,
    ),
  );
}

Widget jyRaiseButton({
  @required VoidCallback click,
  double width,
  double height,
  Widget child,
  Color color,
  ShapeBorder shape,
  EdgeInsetsGeometry padding,
}) {
  return Container(
    padding: padding,
    width: width,
    height: height,
    child: RaisedButton(
      onPressed: click,
      child: child,
      color: color,
      shape: shape,
    ),
  );
}

Widget jyOutlineButton({
  @required VoidCallback click,
  double width,
  double height,
  Widget child,
  Color color,
  ShapeBorder shape,
  EdgeInsetsGeometry padding,
}) {
  return Container(
    padding: padding,
    width: width,
    height: height,
    child: OutlineButton(
      onPressed: click,
      child: child,
      color: color,
      shape: shape,
    ),
  );
}
