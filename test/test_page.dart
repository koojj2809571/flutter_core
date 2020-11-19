import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_core/flutter_core.dart';

// ignore: must_be_immutable
class TestPage extends BasePage {
  final String title;
  final String message;
  Function callback;
  TestPage({
    this.message,
    this.title,
    this.callback,
  });
  @override
  TestPageState getState() => TestPageState();
}


class TestPageState extends BasePageState<TestPage> {
  @override
  Widget buildWidget(BuildContext context) {
    widget.callback(context);
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Container(
        child: Text(widget.message),
      ),
    );
  }

  @override
  void onCreate() {
    // TODO: implement onCreate
  }

  @override
  void onPause() {
    // TODO: implement onPause
  }

  @override
  void onResume() {
    // TODO: implement onResume
  }
}
