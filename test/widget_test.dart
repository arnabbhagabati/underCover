import 'package:flutter_test/flutter_test.dart';
import 'package:undercover/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const UndercoverApp());
    expect(find.text('UNDERCOVER'), findsOneWidget);
    expect(find.text('Start Game'), findsOneWidget);
  });
}
