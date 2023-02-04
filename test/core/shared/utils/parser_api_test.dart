import 'package:flutter_test/flutter_test.dart';

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
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  // testWidgets(
  //   'parse samples',
  //   (WidgetTester tester) async {
  //     // _FirebaseAnalyticsMock firebaseAnalyticsMock = _FirebaseAnalyticsMock();
  //     WidgetsFlutterBinding.ensureInitialized();

  //     await tester.pumpWidget(const ProviderScope(child: App()));
  //     await tester.pumpAndSettle();

  //     // List<Sample> result = await SamplesApi().getSamples();
  //     List<Sample> sampleList = [];

  //     String data = await rootBundle.loadString('samples/samples.json');
  //     final jsonResult = json.decode(data);
  //     jsonResult.forEach((json) => sampleList.add(Sample.fromJson(json)));
  //     expect(sampleList.length, 606);
  //   },
  // );
}
