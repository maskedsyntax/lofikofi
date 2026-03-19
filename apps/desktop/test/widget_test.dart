import 'package:flutter_test/flutter_test.dart';
import 'package:lofikofi/main.dart';

void main() {
  testWidgets('App renders', (WidgetTester tester) async {
    await tester.pumpWidget(const LofikofiApp());
    expect(find.text('Ambient'), findsOneWidget);
    expect(find.text('Focus'), findsOneWidget);
  });
}
