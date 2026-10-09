import 'package:econopreco/app_widget.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('rendered text uses bundled Inter (read via material_ui)', (
    tester,
  ) async {
    await tester.pumpWidget(const AppWidget());
    await tester.pumpAndSettle();

    // Theme the app installs.
    final TextTheme appText = Theme.of(
      tester.element(find.text('Home')),
    ).textTheme;
    expect(appText.bodyMedium!.fontFamily, 'Inter');

    // The actual glyph style Flutter will paint.
    final RichText welcome = tester.widget(
      find.descendant(
        of: find.text('Welcome to the Home View'),
        matching: find.byType(RichText),
      ),
    );
    debugPrint('RENDERED welcome.family=${welcome.text.style?.fontFamily}');
    expect(welcome.text.style!.fontFamily, 'Inter');
  });
}
