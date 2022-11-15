import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:samples/src/app.dart';

// class _FirebaseAnalyticsMock extends Mock implements FirebaseAnalytics {
//   @override
//   Future<void> logEvent({
//     required String name,
//     Map<String, Object?>? parameters,
//     AnalyticsCallOptions? callOptions,
//   }) async {
//     return;
//   }
// }

void main() {
  testWidgets(
    'parse samples',
    (WidgetTester tester) async {
      // _FirebaseAnalyticsMock firebaseAnalyticsMock = _FirebaseAnalyticsMock();
      WidgetsFlutterBinding.ensureInitialized();
      TestWidgetsFlutterBinding.ensureInitialized();
      await tester.pumpWidget(const App());
      await tester.pump();
      // List<Sample> result = await ParserUtil.parseSamples();
      // expect(result.length, hasLength(606));
    },
    skip: true,
  );
}
