import 'package:flutter_test/flutter_test.dart';

import 'package:xinqingriji/main.dart';

void main() {
  testWidgets('App builds and renders', (WidgetTester tester) async {
    await tester.pumpWidget(const MoodDiaryApp());
    expect(find.text('心情日记'), findsOneWidget);
  });
}
