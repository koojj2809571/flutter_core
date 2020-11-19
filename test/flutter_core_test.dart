import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_core/flutter_core.dart';



void main() {
  test('test test', () async{
    Configuration()
      ..setHost('https://dog.ceo/')
      ..setConnectTimeout(15000)
      ..setReceiveTimeout(15000)
      ..printHttpLog(true)
      ..setContentType(Headers.formUrlEncodedContentType)
      ..setResponseType(ResponseType.json)
      ..setInterceptors([])
      ..setInitialHeaders({});
     dynamic value = await HttpUtil().get('api/breeds/image/random', context: null);
     print(value.toString());
  });
  // testWidgets('test myWidget have title and message',
  //     (WidgetTester tester) async {
  //   await tester.pumpWidget(TestPage(
  //     title: 'title',
  //     message: 'message',
  //     callback: (BuildContext context) {
  //       HttpUtil()
  //           .get('https://dog.ceo/api/breeds/image/random', context: context);
  //       expect(1, 1);
  //     },
  //   ));
  //   tester.pump(Duration(seconds: 1));
  //   final titleFinder = find.text('title');
  //   expect(titleFinder, findsOneWidget);
  // });
}
