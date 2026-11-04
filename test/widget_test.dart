import 'package:flutter_test/flutter_test.dart';
import 'package:employee_app/main.dart';

void main() {
  testWidgets('Employee Manager app launches successfully',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Employee Manager'), findsOneWidget);
  });
}
