part of flutter_core;

class ToastUtils {
  static void showToast(String content,
      {Toast length = Toast.LENGTH_SHORT,
        ToastGravity gravity = ToastGravity.BOTTOM,
        Color backColor = Colors.black54,
        Color textColor = Colors.white}) {
    if (content != null) {
      if (content != null && content.isNotEmpty) {
        Fluttertoast.showToast(
            msg: content,
            toastLength: length,
            gravity: gravity,
            backgroundColor: backColor,
            textColor: textColor,
            fontSize: 13.0);
      }
    }
  }

  static showToastCenter(String content) {
    showToast(
      content,
      gravity: ToastGravity.CENTER,
    );
  }
}